PERL = perl

ifeq "$(PAPER)" ""
	PAPER = $(shell paperconf)
endif

ifneq "$(TEST)" ""
	BOOK = build/test.$(PAPER)
	CHAPTERS = $(wildcard test/*.pod)
else
	BOOK = build/UsingPerl6.$(PAPER)
	CHAPTERS = \
    src/preface.pod \
    src/basics.pod \
    src/operators.pod \
    src/subs-n-sigs.pod \
    src/classes-and-objects.pod \
    src/multi-dispatch.pod \
    src/roles.pod \
    src/subtypes.pod \
    src/regexes.pod \
    src/grammars.pod \
    src/builtins.pod

endif

default: prepare pdf clean

prepare: clean
	mkdir build

html: prepare $(CHAPTERS) bin/book-to-html
	$(PERL) bin/book-to-html $(CHAPTERS) > $(BOOK).html

pdf: tex lib/Makefile
	cd build && make -I ../lib -f ../lib/Makefile

tex: prepare $(CHAPTERS) lib/Perl6BookLatex.pm lib/book.sty bin/book-to-latex
	$(PERL) -Ilib bin/book-to-latex --paper $(PAPER) $(CHAPTERS) > $(BOOK).tex

release: pdf
	cp $(BOOK).pdf build/book-$$(date +"%Y-%m").$(PAPER).pdf

clean:
	rm -rf build/

.PHONY: clean

# vim: set noexpandtab
