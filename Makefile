CHAPTERS =src/basics.pod \
          src/preface.pod \
		  src/multi-dispatch.pod \
		  src/classes-and-objects.pod \
		  src/regexes.pod \
		  src/grammars.pod

# If you're on a Mac, and installed Inkscape via MacPorts, you might want to
# manually uncomment the next line, and remove the one after it.
#INKSCAPE = /Applications/Inkscape.app/Contents/Resources/bin/inkscape
INKSCAPE = inkscape

default: build/book.pdf

build/mmd-table.pdf: src/mmd-table.svg
	$(INKSCAPE) --export-pdf=build/mmd-table.pdf -D src/mmd-table.svg

build/book.pdf:	build/book.tex build/mmd-table.pdf
	cd build && pdflatex book.tex && pdflatex book.tex

build/book.tex: $(CHAPTERS)
	perl bin/book-to-latex $(CHAPTERS) > build/book.tex

clean: 
	rm -rf build/*

.PHONY: clean

# vim: set noexpandtab
