ifeq "$(PAPER)" ""
	PAPER = a4
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
	  src/multi-dispatch.pod \
	  src/classes-and-objects.pod \
	  src/regexes.pod \
	  src/grammars.pod \

endif

	# If you're on a Mac, and installed Inkscape via MacPorts, you
	# might want to manually uncomment the next line, and remove
	# the one after it.
#INKSCAPE = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
INKSCAPE = inkscape

default: print

html: $(CHAPTERS) bin/book-to-html
	perl bin/book-to-html $(CHAPTERS) > $(BOOK).html

print: $(BOOK).pdf

release: print
	cp $(BOOK).pdf build/book-$$(date +"%Y-%m").$(PAPER).pdf

build/Makefile: lib/Makefile
	cp $< $@

$(BOOK).pdf: $(BOOK).tex build/Makefile build/mmd-table.pdf
	cd build && make $*

$(BOOK).tex: $(CHAPTERS) lib/Perl6BookLatex.pm lib/book.sty bin/book-to-latex
	perl -Ilib bin/book-to-latex --paper $(PAPER) $(CHAPTERS) > $(BOOK).tex

build/mmd-table.pdf: src/mmd-table.svg
	$(INKSCAPE) --export-pdf=build/mmd-table.pdf -D src/mmd-table.svg

clean: 
	rm -rf build/*

.PHONY: clean

# vim: set noexpandtab
