#!/usr/bin/env python3
# Generate the ViAI logo and icons.
#
# The logo is a dark green block with "Vi" cut out.  A green square and a bar
# ("A" and "I") spin out of its top right corner and leave a notch.
#
# Requires pycairo and Pillow.  Run from anywhere:
#	python3 tools/viai_logo.py
#
# Writes:
#	runtime/viai_logo.svg
#	runtime/viai{16x16,32x32,48x48}.png, .xpm and _png.h
#	runtime/bitmaps/viai.ico, src/viai.ico
#	src/viai_icon.xbm, src/viai_mask.xbm

import io
import math
import os

import cairo
from PIL import Image

TOP_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RUNTIME = os.path.join(TOP_DIR, 'runtime')
SRC = os.path.join(TOP_DIR, 'src')

BLOCK_COLOR = (0x06, 0x28, 0x1a)
DOT_COLOR = (0x01, 0x98, 0x33)
LETTER_COLOR = (0xff, 0xff, 0xff)

# Design on a 296 x 296 canvas.
DESIGN = 296
# block with rounded left corners
BX0, BY0, BX1, BY1 = 7, 48, 289, 289
RADIUS = 67
# square ("A") over the "i" stem, and the bar ("I") flush with the right edge
DOT_W, DOT_TOP, DOT_BOTTOM = 36, 7, 43
GAP, BAR_W = 8, 15
# depth of the cut corner
NOTCH = 48
# letters
V_SHAPE = [(43, 90), (86, 90), (132, 209), (178, 90), (221, 90),
           (152, 255), (112, 255)]
STEM_TOP, STEM_BOTTOM = 151, 255

# From this size on the icons are beveled, "Vi" is engraved and the square
# and the bar cast a shadow.
BEVEL_MIN_SIZE = 48
BLOCK_BEVEL = 7         # width in design units
BLOCK_LIT = (0x2b, 0x7a, 0x52)
BLOCK_DARK = (0x01, 0x0a, 0x06)
LETTER_BEVEL = 3
LETTER_SHADE = (0x9f, 0xb2, 0xa8)
DOT_BEVEL = 4
DOT_LIT = (0x5f, 0xd8, 0x84)
DOT_DARK = (0x01, 0x65, 0x24)
# offset and opacity of the steps of the soft shadow
DOT_SHADOW = ((6, 0.10), (4, 0.16), (2, 0.22))

ICO_SIZES = (16, 20, 24, 32, 40, 48, 64, 128, 256)
X11_SIZES = (16, 32, 48)


def geometry(size):
    """Edges of the straight parts in design units, put on pixel boundaries
    for an icon of "size" pixels.  Every part keeps at least one pixel."""
    k = size / DESIGN

    def px(v):
        return max(1, round(v * k))

    right = px(BX1)
    bar_x0 = right - px(BAR_W)
    dot_x1 = bar_x0 - px(GAP)
    dot_x0 = dot_x1 - px(DOT_W)
    top = px(BY0)
    dot_y1 = top - px(BY0 - DOT_BOTTOM)
    dot_y0 = dot_y1 - px(DOT_BOTTOM - DOT_TOP)
    g = {'left': px(BX0), 'right': right, 'top': top, 'bottom': px(BY1),
         # rounded up, the cut looks too shallow otherwise
         'notch': top + max(1, math.ceil(NOTCH * k)),
         'bar_x0': bar_x0, 'dot_x0': dot_x0, 'dot_x1': dot_x1,
         'dot_y0': dot_y0, 'dot_y1': dot_y1,
         'stem_y0': px(STEM_TOP), 'stem_y1': px(STEM_BOTTOM)}
    return {key: val / k for key, val in g.items()}


def rgb(ctx, color):
    ctx.set_source_rgb(*(c / 255 for c in color))


def block_path(ctx, g, dx=0, dy=0):
    r = RADIUS
    x0, y0, x1, y1 = g['left'] + dx, g['top'] + dy, g['right'] + dx, \
        g['bottom'] + dy
    ctx.move_to(x0 + r, y0)
    ctx.line_to(g['dot_x0'] + dx, y0)
    ctx.line_to(g['dot_x0'] + dx, g['notch'] + dy)
    ctx.line_to(x1, g['notch'] + dy)
    ctx.line_to(x1, y1)
    ctx.line_to(x0 + r, y1)
    ctx.arc(x0 + r, y1 - r, r, math.pi / 2, math.pi)
    ctx.line_to(x0, y0 + r)
    ctx.arc(x0 + r, y0 + r, r, math.pi, 3 * math.pi / 2)
    ctx.close_path()


def letters_path(ctx, g, dx=0, dy=0):
    ctx.move_to(V_SHAPE[0][0] + dx, V_SHAPE[0][1] + dy)
    for x, y in V_SHAPE[1:]:
        ctx.line_to(x + dx, y + dy)
    ctx.close_path()
    ctx.rectangle(g['dot_x0'] + dx, g['stem_y0'] + dy,
                  g['dot_x1'] - g['dot_x0'], g['stem_y1'] - g['stem_y0'])


def dots_path(ctx, g, dx=0, dy=0):
    h = g['dot_y1'] - g['dot_y0']
    ctx.rectangle(g['dot_x0'] + dx, g['dot_y0'] + dy,
                  g['dot_x1'] - g['dot_x0'], h)
    ctx.rectangle(g['bar_x0'] + dx, g['dot_y0'] + dy,
                  g['right'] - g['bar_x0'], h)


def fill(ctx, path, g, color, b=0, lit=None, dark=None):
    """Fill the shape of "path".  With a bevel width "b", the band of that
    width along the top and left edges gets "lit" and the band along the
    bottom and right edges gets "dark"."""
    if b == 0:
        path(ctx, g)
        rgb(ctx, color)
        ctx.fill()
        return
    ctx.save()
    for clip_dx, c in ((None, lit), (b, dark), (-b, color)):
        if clip_dx is not None:
            path(ctx, g, clip_dx, clip_dx)
            ctx.clip()
        path(ctx, g)
        rgb(ctx, c)
        ctx.fill()
    ctx.restore()


def draw(ctx, size):
    g = geometry(size)
    beveled = size >= BEVEL_MIN_SIZE
    k = size / DESIGN

    def bevel(units):
        # whole pixels, so that the bands stay sharp
        return max(1, round(units * k)) / k if beveled else 0

    if beveled:
        for offset, alpha in DOT_SHADOW:
            d = bevel(offset)
            dots_path(ctx, g, d * 0.6, d)
            ctx.set_source_rgba(0, 0, 0, alpha)
            ctx.fill()

    fill(ctx, block_path, g, BLOCK_COLOR, bevel(BLOCK_BEVEL), BLOCK_LIT,
         BLOCK_DARK)
    # engraved: only the top and left edges are shaded
    fill(ctx, letters_path, g, LETTER_COLOR, bevel(LETTER_BEVEL),
         LETTER_SHADE, LETTER_COLOR)
    fill(ctx, dots_path, g, DOT_COLOR, bevel(DOT_BEVEL), DOT_LIT, DOT_DARK)


def render(size):
    surf = cairo.ImageSurface(cairo.FORMAT_ARGB32, size, size)
    ctx = cairo.Context(surf)
    ctx.scale(size / DESIGN, size / DESIGN)
    draw(ctx, size)
    buf = io.BytesIO()
    surf.write_to_png(buf)
    buf.seek(0)
    return Image.open(buf).convert('RGBA')


def write_svg(path):
    surf = cairo.SVGSurface(path, DESIGN, DESIGN)
    # at the design size every edge is on a whole unit, nothing is moved
    draw(cairo.Context(surf), DESIGN)
    surf.finish()


def write_png_h(png_path, name, path):
    data = open(png_path, 'rb').read()
    lines = [f'/* PNG icon data, converted from {os.path.basename(png_path)}'
             ' */', f'static const unsigned char {name}[] = {{']
    for i in range(0, len(data), 12):
        chunk = ', '.join(f'0x{b:02x}' for b in data[i:i + 12])
        lines.append('    ' + chunk + (',' if i + 12 < len(data) else ''))
    lines += ['};', f'static const unsigned int {name}_len = sizeof({name});']
    with open(path, 'w') as f:
        f.write('\n'.join(lines) + '\n')


XPM_CHARS = ('.#+@$%&*=-;>,\')!~{]^/(_:<[}|1234567890'
             'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`')


def write_xpm(im, name, path):
    # XPM has no partial transparency: pixels less than half opaque are
    # transparent
    w, h = im.size
    px = im.load()
    rows = [[None if px[x, y][3] < 128 else px[x, y][:3] for x in range(w)]
            for y in range(h)]
    colors = sorted({c for row in rows for c in row if c is not None})
    cpp = 1 if len(colors) < len(XPM_CHARS) else 2

    def code(i):
        if cpp == 1:
            return XPM_CHARS[i]
        return XPM_CHARS[i // len(XPM_CHARS)] + XPM_CHARS[i % len(XPM_CHARS)]

    codes = {c: code(i) for i, c in enumerate(colors)}
    none = ' ' * cpp
    lines = ['/* XPM */', f'static char * {name}[] = {{',
             f'"{w} {h} {len(colors) + 1} {cpp}",', f'"{none}\tc None",']
    lines += [f'"{codes[c]}\tc #{c[0]:02X}{c[1]:02X}{c[2]:02X}",'
              for c in colors]
    body = ['"' + ''.join(none if c is None else codes[c] for c in row) + '"'
            for row in rows]
    lines += [b + ',' for b in body[:-1]] + [body[-1] + '};']
    with open(path, 'w') as f:
        f.write('\n'.join(lines) + '\n')


def write_xbm(bits, name, w, h, path):
    data = []
    for y in range(h):
        for x0 in range(0, w, 8):
            data.append(sum(1 << i for i in range(8) if bits(x0 + i, y)))
    lines = [f'#define {name}_width {w}', f'#define {name}_height {h}',
             f'static unsigned char {name}_bits[] = {{']
    for i in range(0, len(data), 12):
        chunk = ', '.join(f'0x{b:02x}' for b in data[i:i + 12])
        lines.append('   ' + chunk + (',' if i + 12 < len(data) else '};'))
    with open(path, 'w') as f:
        f.write('\n'.join(lines) + '\n')


def main():
    write_svg(os.path.join(RUNTIME, 'viai_logo.svg'))

    images = {s: render(s) for s in set(ICO_SIZES) | set(X11_SIZES)}

    for s in X11_SIZES:
        name = f'viai{s}x{s}'
        png = os.path.join(RUNTIME, name + '.png')
        images[s].save(png, optimize=True)
        write_png_h(png, name + '_png', os.path.join(RUNTIME, name +
                                                     '_png.h'))
        write_xpm(images[s], name, os.path.join(RUNTIME, name + '.xpm'))

    ico = [images[s] for s in sorted(ICO_SIZES, reverse=True)]
    for path in (os.path.join(RUNTIME, 'bitmaps', 'viai.ico'),
                 os.path.join(SRC, 'viai.ico')):
        ico[0].save(path, sizes=[im.size for im in ico],
                    append_images=ico[1:])

    # 32 x 32 bitmaps for X11 without XPM: the icon is set for the dark
    # parts, the mask for the opaque parts
    px = images[32].load()

    def opaque(x, y):
        return px[x, y][3] >= 128

    def dark(x, y):
        return opaque(x, y) and sum(px[x, y][:3]) < 3 * 128

    write_xbm(dark, 'viai_icon', 32, 32, os.path.join(SRC, 'viai_icon.xbm'))
    write_xbm(opaque, 'viai_mask_icon', 32, 32,
              os.path.join(SRC, 'viai_mask.xbm'))


if __name__ == '__main__':
    main()
