CHAPTERS = src/preface.pod \
		  src/multi-dispatch.pod \
		  src/classes-and-objects.pod \
		  src/regexes.pod \
		  src/grammars.pod

default: build/book.pdf

build/mmd-table.pdf: src/mmd-table.svg
	inkscape --export-pdf=build/mmd-table.pdf -D src/mmd-table.svg

build/book.pdf:	build/book.tex build/mmd-table.pdf
	cd build && pdflatex book.tex

build/book.tex: $(CHAPTERS)
	perl bin/book-to-latex $(CHAPTERS) > build/book.tex

clean: 
	rm -rf build/*

.PHONY: clean

# for stupid vim users:
# vim: set noexpandtab
