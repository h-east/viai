#! /bin/sh
# installml.sh --- install or uninstall manpage links for Vim
#
# arguments:
# 1  what: "install" or "uninstall"
# 2  also do GUI pages: "yes" or ""
# 3  target directory		     e.g., "/usr/local/man/it/man1"
# 4  vim exe name		     e.g., "vim"
# 5  vimdiff exe name		     e.g., "vimdiff"
# 6  evim exe name		     e.g., "evim"
# 7  rvim exe name		     e.g., "rvim"
# 8  gvim exe name		     e.g., "gvim"
# 9  rgvim exe name		     e.g., "rgvim"
# 10 gvimdiff exe name		     e.g., "gvimdiff"

errstatus=0

what=$1
gui=$2
destdir=$3
vimname=$4
vimdiffname=$5
evimname=$6
rvimname=$7
gvimname=$8
rgvimname=$9
# old shells don't understand ${10}
shift
gvimdiffname=$9

if test $what = "install" -a \( -f $destdir/$vimname.1 -o -f $destdir/$vimdiffname.1 -o -f $destdir/$evimname.1 \); then
   if test ! -d $destdir; then
      echo creating $destdir
      /bin/sh install-sh -c -d $destdir
   fi

   # rvim
   if test ! -f $destdir/$rvimname.1 -a -f $destdir/$vimname.1; then
      echo creating link $destdir/$rvimname.1
      cd $destdir; ln -s $vimname.1 $rvimname.1
   fi

   # GUI targets are optional
   if test "$gui" = "yes"; then
      # gvim
      if test ! -f $destdir/$gvimname.1 -a -f $destdir/$vimname.1; then
	 echo creating link $destdir/$gvimname.1
	 cd $destdir; ln -s $vimname.1 $gvimname.1
      fi

      # rgvim
      if test ! -f $destdir/$rgvimname.1 -a -f $destdir/$vimname.1; then
	 echo creating link $destdir/$rgvimname.1
	 cd $destdir; ln -s $vimname.1 $rgvimname.1
      fi

      # gvimdiff
      if test ! -f $destdir/$gvimdiffname.1 -a -f $destdir/$vimdiffname.1; then
	 echo creating link $destdir/$gvimdiffname.1
	 cd $destdir; ln -s $vimdiffname.1 $gvimdiffname.1
      fi
   fi
fi

if test $what = "uninstall"; then
   echo Checking for Vim manual page links in $destdir...

   if test -L $destdir/$rvimname.1; then
      echo deleting $destdir/$rvimname.1
      rm -f $destdir/$rvimname.1
   fi

   # GUI targets are optional
   if test "$gui" = "yes"; then
      if test -L $destdir/$gvimname.1; then
	 echo deleting $destdir/$gvimname.1
	 rm -f $destdir/$gvimname.1
      fi
      if test -L $destdir/$rgvimname.1; then
	 echo deleting $destdir/$rgvimname.1
	 rm -f $destdir/$rgvimname.1
      fi
      if test -L $destdir/$gvimdiffname.1; then
	 echo deleting $destdir/$gvimdiffname.1
	 rm -f $destdir/$gvimdiffname.1
      fi
   fi
fi

exit $errstatus

# vim: set sw=3 :
