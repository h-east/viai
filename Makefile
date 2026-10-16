# Using this Makefile without an argument will compile Vim for Unix.
# "make install" is also possible.
#
# NOTE: If this doesn't work properly, first change directory to "src" and use
# the Makefile there:
#	cd src
#	make [arguments]
# Noticed on AIX systems when using this Makefile: Trying to run "cproto" or
# something else after Vim has been compiled.  Don't know why...
# Noticed on OS/390 Unix: Restarts configure.
#
# The first (default) target is "first".  This will result in running
# "make first", so that the target from "src/auto/config.mk" is picked
# up properly when config didn't run yet.  Doing "make all" before configure
# has run can result in compiling with $(CC) empty.

first:
	@if test ! -f src/auto/config.mk; then \
		cp src/config.mk.dist src/auto/config.mk; \
	fi
	@echo "Starting make in the src directory."
	@echo "If there are problems, cd to the src directory and run make there"
	cd src && $(MAKE) $@

tags notags:
	$(MAKE) -C src/ -f Make_tags.mak $@

# Some make programs use the last target for the $@ default; put the other
# targets separately to always let $@ expand to "first" by default.
all install uninstall tools config configure reconfig proto depend lint types test scripttests testtiny test_libvterm unittests testclean clean distclean:
	@if test ! -f src/auto/config.mk; then \
		cp src/config.mk.dist src/auto/config.mk; \
	fi
	@echo "Starting make in the src directory."
	@echo "If there are problems, cd to the src directory and run make there"
	cd src && $(MAKE) $@
	@# When the target is "test" also run the indent and syntax tests.
	@if test "$@" = "test" -o "$@" = "testtiny"; then \
		$(MAKE) indenttest; \
		$(MAKE) syntaxtest; \
	fi
	@# When the target is "clean" also clean for the indent and syntax tests.
	@if test "$@" = "clean" -o "$@" = "distclean" -o "$@" = "testclean"; then \
		(cd runtime/indent && $(MAKE) clean); \
		(cd runtime/syntax && $(MAKE) clean); \
	fi

# Executable used for running the indent tests.
VIM_FOR_INDENTTEST = ../../src/viai

indenttest:
	cd runtime/indent && \
		$(MAKE) clean && \
		$(MAKE) test VIMPROG="$(VIM_FOR_INDENTTEST)"

# Executable used for running the syntax tests.
VIM_FOR_SYNTAXTEST = ../../src/viai

# (For local testing only with GNU Make.)
VIM_SYNTAX_TEST_FILTER =
VIM_SYNTAX_TEST_WAIT_TIME =

syntaxtest:
	cd runtime/syntax && \
		$(MAKE) clean && \
		$(MAKE) test VIMPROG="$(VIM_FOR_SYNTAXTEST)"
