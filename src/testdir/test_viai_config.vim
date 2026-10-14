" Tests for ViAI's own user configuration and viminfo file.

" Run ViAI with "lines" as a script, reading the user vimrc, and return the
" errors it reported.
func s:RunWithVimrc(lines)
  let vimcmd = substitute(GetVimCommand(), '-u NONE', '', '')
  call writefile(a:lines + ['call writefile(v:errors, "Xresult")', 'qall'],
        \ 'Xscript', 'D')
  call system($'{vimcmd} -S Xscript')
  let result = readfile('Xresult')
  call delete('Xresult')
  return result
endfunc

func Test_viai_config_not_used()
  CheckUnix
  unlet! $XDG_CONFIG_HOME
  call writefile(['let g:rc = ".vimrc"'], expand('~/.vimrc'), 'D')

  let lines =<< trim END
    call assert_equal('.vimrc', g:rc)
    call assert_match('XfakeHOME/\.vimrc$', $MYVIMRC)
    call assert_match('XfakeHOME/\.vim/$', $MYVIMDIR)
    call assert_match('XfakeHOME/\.vim/view$', &viewdir)
    call assert_match('\$HOME/\.vimrc', execute('version'))
  END
  call assert_equal([], s:RunWithVimrc(lines))
endfunc

func Test_viai_config_viairc()
  CheckUnix
  unlet! $XDG_CONFIG_HOME
  call writefile(['let g:rc = ".vimrc"'], expand('~/.vimrc'), 'D')
  call writefile(['let g:rc = ".viairc"'], expand('~/.viairc'), 'D')

  let lines =<< trim END
    call assert_equal('.viairc', g:rc)
    call assert_match('XfakeHOME/\.viairc$', $MYVIMRC)
    call assert_match('XfakeHOME/\.viai/$', $MYVIMDIR)
    call assert_match('^[^,]*XfakeHOME/\.viai,', &runtimepath)
    call assert_match('^[^,]*XfakeHOME/\.viai,', &packpath)
    call assert_match('XfakeHOME/\.viai/view$', &viewdir)
    call assert_match('\$HOME/\.viairc', execute('version'))
  END
  call assert_equal([], s:RunWithVimrc(lines))
endfunc

func Test_viai_config_viai_dir()
  CheckUnix
  unlet! $XDG_CONFIG_HOME
  call writefile(['let g:rc = ".vimrc"'], expand('~/.vimrc'), 'D')
  call mkdir(expand('~/.viai'), 'pD')
  call writefile(['let g:rc = ".viai/vimrc"'], expand('~/.viai/vimrc'))

  let lines =<< trim END
    call assert_equal('.viai/vimrc', g:rc)
    call assert_match('XfakeHOME/\.viai/vimrc$', $MYVIMRC)
    call assert_match('XfakeHOME/\.viai/$', $MYVIMDIR)
  END
  call assert_equal([], s:RunWithVimrc(lines))

  " An empty ~/.viai also selects ViAI's configuration, then ~/.vimrc is not
  " used.
  call delete(expand('~/.viai/vimrc'))
  let lines =<< trim END
    call assert_false(exists('g:rc'))
    call assert_match('XfakeHOME/\.viai/$', $MYVIMDIR)
  END
  call assert_equal([], s:RunWithVimrc(lines))
endfunc

func Test_viai_config_xdg()
  CheckUnix
  call writefile(['let g:rc = ".vimrc"'], expand('~/.vimrc'), 'D')
  call mkdir(expand('~/.config/viai'), 'pD')
  call writefile(['let g:rc = ".config/viai/vimrc"'],
        \ expand('~/.config/viai/vimrc'))
  call mkdir(expand('~/xdg/viai'), 'pD')
  call writefile(['let g:rc = "xdg/viai/vimrc"'], expand('~/xdg/viai/vimrc'))

  unlet! $XDG_CONFIG_HOME
  let lines =<< trim END
    call assert_equal('.config/viai/vimrc', g:rc)
    call assert_match('XfakeHOME/\.config/viai/$', $MYVIMDIR)
    call assert_match('^[^,]*XfakeHOME/\.config/viai,', &runtimepath)
    call assert_match('XfakeHOME/\.config/viai/view$', &viewdir)
  END
  call assert_equal([], s:RunWithVimrc(lines))

  let $XDG_CONFIG_HOME = expand('~/xdg')
  let lines =<< trim END
    call assert_equal('xdg/viai/vimrc', g:rc)
    call assert_match('XfakeHOME/xdg/viai/$', $MYVIMDIR)
    call assert_match('^[^,]*XfakeHOME/xdg/viai,', &runtimepath)
    call assert_match('XfakeHOME/xdg/viai/view$', &viewdir)
  END
  call assert_equal([], s:RunWithVimrc(lines))
  unlet $XDG_CONFIG_HOME
endfunc

func Test_viai_config_mswin()
  CheckMSWindows
  call writefile(['let g:rc = "_vimrc"'], expand('~/_vimrc'), 'D')
  call writefile(['let g:rc = "_viairc"'], expand('~/_viairc'), 'D')

  let lines =<< trim END
    call assert_equal('_viairc', g:rc)
    call assert_match('XfakeHOME[/\\]_viairc$', $MYVIMRC)
    call assert_match('^[^,]*XfakeHOME[/\\]viaifiles,', &runtimepath)
    call assert_match('XfakeHOME[/\\]viaifiles[/\\]view$', &viewdir)
  END
  call assert_equal([], s:RunWithVimrc(lines))

  call delete(expand('~/_viairc'))
  call mkdir(expand('~/viaifiles'), 'pD')
  call writefile(['let g:rc = "viaifiles/vimrc"'],
        \ expand('~/viaifiles/vimrc'))
  let lines =<< trim END
    call assert_equal('viaifiles/vimrc', g:rc)
    call assert_match('XfakeHOME[/\\]viaifiles[/\\]vimrc$', $MYVIMRC)
  END
  call assert_equal([], s:RunWithVimrc(lines))
endfunc

func Test_viai_config_viminfo()
  unlet! $XDG_CONFIG_HOME
  let prefix = has('win32') ? '_' : '.'
  call writefile(['set nocompatible'], expand($'~/{prefix}vimrc'), 'D')
  let vim_viminfo = expand($'~/{prefix}viminfo')
  let viai_viminfo = expand($'~/{prefix}viaiinfo')
  call writefile(['# Command Line History (newest to oldest):',
        \ ':let g:from_vim = 1'], vim_viminfo, 'D')
  " Other tests may have written ViAI's viminfo file.
  call delete(viai_viminfo)
  defer delete(viai_viminfo)

  " Without ViAI's viminfo file, Vim's viminfo file is read and merged into
  " the new ViAI's viminfo file.  Vim's viminfo file is not changed.
  let lines =<< trim END
    call assert_equal('let g:from_vim = 1', histget(':', -1))
    call histadd(':', 'let g:from_viai = 1')
  END
  call assert_equal([], s:RunWithVimrc(lines))
  call assert_true(filereadable(viai_viminfo))
  let viai_text = readfile(viai_viminfo)->join("\n")
  call assert_match('let g:from_vim = 1', viai_text)
  call assert_match('let g:from_viai = 1', viai_text)
  call assert_notmatch('from_viai', readfile(vim_viminfo)->join("\n"))

  " With ViAI's viminfo file, Vim's viminfo file is no longer read.
  call writefile(['# Command Line History (newest to oldest):',
        \ ':let g:from_vim_later = 1'], vim_viminfo)
  let lines =<< trim END
    call assert_equal('let g:from_viai = 1', histget(':', -1))
    call assert_notmatch('from_vim_later', execute('history :'))
  END
  call assert_equal([], s:RunWithVimrc(lines))
endfunc

" vim: shiftwidth=2 sts=2 expandtab
