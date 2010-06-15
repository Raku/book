CHAPTERS =src/preface.pod \
	  src/basics.pod \
          src/operators.pod \
	  src/subs-n-sigs.pod \
	  src/multi-dispatch.pod \
	  src/classes-and-objects.pod \
	  src/regexes.pod \
	  src/grammars.pod

ifeq "$(SIZE)" ""
SIZE=a4
endif

BOOK = book.$(SIZE)
ENGINE = xelatex

# If you're on a Mac, and installed Inkscape via MacPorts, you might want to
# manually uncomment the next line, and remove the one after it.
#INKSCAPE = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
INKSCAPE = inkscape

default: pdf

release: pdf
	cp build/$(BOOK).pdf build/book-$$(date +"%Y-%m").$(SIZE).pdf

build/mmd-table.pdf: src/mmd-table.svg
	$(INKSCAPE) --export-pdf=build/mmd-table.pdf -D src/mmd-table.svg

html: $(CHAPTERS) bin/book-to-html
	perl bin/book-to-html $(CHAPTERS) > build/book.html

pdf: tex build/mmd-table.pdf
	cd build && $(ENGINE) -shell-escape $(BOOK).tex && makeindex $(BOOK).idx && $(ENGINE) -shell-escape $(BOOK).tex

sty:
	cp lib/minted.sty build/

tex: $(CHAPTERS) src/latex.style bin/book-to-latex sty
	perl bin/book-to-latex \
           --size $(SIZE) \
           $(CHAPTERS) > build/$(BOOK).tex

clean: 
	rm -rf build/*

.PHONY: clean sty

# vim: set noexpandtab
