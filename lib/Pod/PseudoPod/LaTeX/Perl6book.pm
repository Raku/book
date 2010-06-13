package Pod::PseudoPod::LaTeX::Perl6book;

use Pod::PseudoPod 0.16;

use base 'Pod::PseudoPod::LaTeX';
use 5.008006;

use strict;
use warnings;

# Originally, it had a "section*" -- why, for god's sake?
# If someone wants to exclude certain sections from the TOC, there are better way
# than hard-coding something like that.
BEGIN {
    for my $level ( 1 .. 5 ) {
        my $prefix = '\\' . ( 'sub' x ( $level - 1 ) ) . 'section{';
        my $start_sub = sub {
            my $self = shift;
            $self->{scratch} .= $prefix;
        };

        my $end_sub = sub {
            my $self = shift;
            $self->{scratch} .= "}\n\n";
            $self->emit();
        };

        no strict 'refs';
        *{ 'start_head' . $level } = $start_sub;
        *{ 'end_head' . $level }   = $end_sub;
    } ## end for my $level ( 1 .. 5 )
} ## end BEGIN

# Overload because of custom formatting for programlisting sections
sub start_Verbatim {
    my $self  = shift;
    my $flags = shift;

    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';

    my $verb_options =
        'commandchars=\\\\\{\},frame=lines,xleftmargin=1ex,fillcolor=\color{lightgray},showspaces=false,fontsize=\\small,gobble=4';
    if ( $target eq 'screen' ) {
        $verb_options .= ',labelposition=topline,label=' . $self->{labels}{screen};
    }
    if ( $target eq 'programlisting' ) {
        $verb_options .= ',numbers=left,tabsize=4,numberblanklines=false';
    }
    $self->{scratch} .= "\\begin{Verbatim}[$verb_options]\n";
    $self->{flags}{in_verbatim}++;
} ## end sub start_Verbatim

# This sub is overloaded because one line has been removed
# We do want ligatures to look good, gotta find out why it got removed in the first place
sub encode_text {
    my ( $self, $text ) = @_;

    return $self->encode_verbatim_text($text) if $self->{flags}{in_verbatim};
    return $text                              if $self->{flags}{in_xref};
    return $text                              if $self->{flags}{in_figure};

    # Escape LaTeX-specific characters
    $text =~ s/\\/\\backslash/g;                                     # backslashes are special
    $text =~ s/([#\$&%_{}])/\\$1/g;
    $text =~ s/(\^)/\\char94{}/g;                                    # carets are special
    $text =~ s/</\\textless{}/g;
    $text =~ s/>/\\textgreater{}/g;

    $text =~ s/(\\backslash)/\$$1\$/g;                               # add unescaped dollars

    # use the right beginning quotes
    $text =~ s/(^|\s)"/$1``/g;

    # and the right ending quotes
    $text =~ s/"(\W|$)/''$1/g;

    # fix the ellipses
    $text =~ s/\.{3}\s*/\\ldots /g;

    # fix emdashes
    $text =~ s/\s--\s/---/g;

    # fix tildes
    $text =~ s/~/\$\\sim\$/g;

    # suggest hyphenation points for module names
    $text =~ s/::/::\\-/g;

    return $text;
} ## end sub encode_text

1;
