***NOTE***:

This repository is retained only for archival purposes. The project is
currently considered dead and only really useful for updating the
documentation on https://docs.raku.org. 

If you are looking for up-to-date Raku books, please check
<https://perl6book.com/> for an overview.

Reference documentation can be found at <https://doc.raku.org/>.

----------------------------------------------------------------------

We are writing a book about Raku.

It will be some kind of example-driven introduction to Raku, and at
the same time showing off the reasons why we love that language.

We plan to have monthly releases, see docs/release-guide.pod

"We" are Carl Mäsak, Jonathan Worthington, Patrick Michaud, Moritz
Lenz, Jonathan Scott Duff (Scott) and anybody who's willing to work on
it.  If you're not on that list yet, you're still very welcome to join
us.

You can find us on #perl6book on irc.freenode.net.  Logs of the IRC
discussions: <http://irclog.perlgeek.de/perl6book/> (If you do not
have an IRC client, you can use a web-based client at
<http://webchat.freenode.net/?randomnick=1&channels=perl6book&prompt=1>
)

To build the PDF version of this book, you need to have the following
software installed (for HTML output only, the first section of the prereqs
is enough; 'make html' will be your friend):

* GNU make
* perl 5.10
* the Perl modules:
  Pod::PseudoPod::LaTeX version 1.101050 or newer
  Template version 2.22 or newer
* inkscape (for svg -> pdf conversion)
* A number of LaTeX packages (see lib/*.sty). Ubuntu 10.04
  supplies most of what is needed with its texlive-latex-base,
  texlive-latex-extra, texlive-xetex, texlive-fonts-extra,
  texlive-latex-recommended and texlive-font-utils packages.
* Adobe's fonts and B&H Luxi Sans. To get those, install
  ttf-xfree86-nonfree (and uninstall t1-xfree86-nonfree) and
  Acrobat Reader then copy *.otf from
  /opt/Adobe/Reader9/Resource/Font/ to ~/.fonts/
* Run 'sudo fc-cache -f -v' to rebuild the cache in case the fonts
  are not found.

The book is produced from src/*.pod chapters ultimately rendered into
dist/*.pdf using bin/* and lib/* files.

Just type 'make' on your command line, and the book should be built in
dist/UsingRaku.a4.pdf, with an A4 paper size; to get U.S. letter
size, type 'make PAPER=letter'. To get any PAPER width and height type
'make PAPER=6.125in,9.25in'; accepted length units are pt, in, cm and mm.

PDF versions of this book can be found at 
http://puffin.ch/perl/6/ and http://github.com/raku/book/downloads

All material in this repository is licensed under a CC-by-nc-sa
license: <http://creativecommons.org/licenses/by-nc-sa/2.5/>
(attribution, noncommercial, share-alike), unless explicitly stated
otherwise.

(Maybe we'll open up towards removing the noncommercial part at some
point).
