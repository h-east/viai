<p align="center">
  <img src="runtime/viai_logo.svg" alt="ViAI" width="200">
</p>

# ViAI - Vim Advanced Integrated

ViAI is a text editor based on [Vim](https://github.com/vim/vim), developed
with the help of AI tools.

## What is ViAI?

ViAI started from Vim 9.2.1186 and keeps importing the patches of Vim, so it
has all the features of Vim: multi-level undo, syntax highlighting, command
line history, on-line help, spell checking, Vim9 script, a GUI, and much more.
Plugins written for Vim should work in ViAI as well.

The name stands for "Vim Advanced Integrated".  It happens to be the same
words as the "AI synthesis" (Advanced Integrated) of the KORG M1 synthesizer,
released in 1988, the year in which Bram Moolenaar started writing Vim.

## Use of AI tools

The maintainer reviews every change made with AI tools before committing
it, and is responsible for all changes in ViAI, however they were written.

## Differences from Vim

* The programs are named `viai`, `gviai`, `viaidiff`, etc., and the runtime
  files are installed in their own directory, so that ViAI can be installed
  next to Vim.  `ex`, `view`, `xxd` and `vimtutor` are not installed.
* ViAI has its own version number, starting at 1.0.  `v:version` and
  `has('patch-...')` still report the Vim version.  Use `has('viai')` to check
  for ViAI.
* ViAI uses your Vim configuration, unless its own configuration exists:
  `~/.viairc`, `~/.viai/` or `$XDG_CONFIG_HOME/viai/` (`$HOME/_viairc` or
  `$HOME/viaifiles/` on MS-Windows).
* The viminfo file is `~/.viaiinfo`.  The first time, the history and marks
  of `~/.viminfo` are taken over.

See `:help viai` ([`runtime/doc/viai.txt`](./runtime/doc/viai.txt)) for all
the differences.

## Building and installing

ViAI is built like Vim.  All the stuff for compiling is in the
[`src`](./src/) directory, see [`src/INSTALL`](./src/INSTALL) for Unix and
[`src/INSTALLpc.txt`](./src/INSTALLpc.txt) for MS-Windows.  On Unix:

```
./configure
make
make install
```

## Documentation

Use `:help` in ViAI, or read
[`runtime/doc/help.txt`](./runtime/doc/help.txt).

## Contributing

Bug reports and feature requests are welcome.  Please open an issue in this
repository.  Pull requests from others are generally not accepted, see the
[CONTRIBUTING.md](./CONTRIBUTING.md) file.

## License

Changes made in ViAI after the initial import are licensed under the Apache
License 2.0, see [`LICENSE-APACHE`](./LICENSE-APACHE).

Code imported from Vim is licensed under the Vim license, see
[`LICENSE`](./LICENSE).  This applies to the initial import commit and to
every commit whose subject starts with `vim-patch:`.

Vim is Charityware: its users are encouraged to make a donation to help
children in Uganda.  See [`runtime/doc/uganda.txt`](./runtime/doc/uganda.txt)
(`:help uganda`).

## Credits

Most of Vim was created by Bram Moolenaar.  Many thanks to him and to everyone
who has contributed to Vim.

ViAI is maintained by Hirohito Higashi ([@h-east](https://github.com/h-east)).
