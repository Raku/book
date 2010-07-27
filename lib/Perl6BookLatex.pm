# --------------------------------------------------------------------
use strict;
use warnings;
use feature ':5.10';

package Perl6BookLatex;
use Pod::PseudoPod::LaTeX 1.101650;
use base 'Pod::PseudoPod::LaTeX';

# --------------------------------------------------------------------

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
    }
}

# --------------------------------------------------------------------
sub start_B {
    my $self = shift;
    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';
    $self->{scratch} .= '\\textbf{';
}

sub end_B {
    my $self = shift;
    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';
    $self->{scratch} .= '}';
}

sub start_C {
    my $self = shift;
    $self->{scratch} .= "\\VerbatimQuotes\\texttt{";
}

sub end_C {
    my $self = shift;
    $self->{scratch} .= "}\\EnableQuotes{}";
}

# --------------------------------------------------------------------
sub start_U {
    my $self = shift;
    $self->{scratch} .= '\\url{';
}

sub end_U {
    my $self = shift;
    $self->{scratch} .= '}';
}

# --------------------------------------------------------------------
sub encode_verbatim_text {
    my ($self, $text) = @_;

    $text =~ s/([{}])/\\$1/g;
    $text =~ s/\\(?![{}])/\\textbackslash{}/g;
    
    return $text;
}

    # Overload because of custom formatting for programlisting sections.
sub start_Verbatim {
    my $self  = shift;
    my $flags = shift;

    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';

    if ( $target eq 'screen' ) {
        my $verb_options = 'label=' . $self->{labels}{screen};
        $self->{scratch} .= "\\begin{Verbatim}[$verb_options]\n";
    }
   # elsif ( $target eq 'programlisting' ) {
   #     $self->{scratch} .= "\\begin{perlcode}\n";
   # }
    else {
        $self->{scratch} .= "\\begin{Verbatim}[numbers=left]\n";
    }

    $self->{flags}{in_verbatim}++;
}

sub end_Verbatim {
    my $self = shift;

    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';

   # if ( $target eq 'programlisting' ) {
   #     $self->{scratch} .= "\n\\end{perlcode}\n";
   # }
   # else {
        $self->{scratch} .= "\n\\end{Verbatim}\n";
   # }

    $self->{flags}{in_verbatim}--;
    $self->emit();
}

# --------------------------------------------------------------------
# This sub is overloaded because one line has been removed. We do want
# ligatures to look good, gotta find out why it got removed in the
# first place.

sub encode_text {
    my ( $self, $text ) = @_;

    return $self->encode_verbatim_text($text)
      if $self->{flags}{in_verbatim};
    return $text
      if $self->{flags}{in_xref} || $self->{flags}{in_figure};

    # Escape LaTeX-specific characters.

    # Backslashes are special.
    $text =~ s/\\/\\backslash/g;

    # Tildes
    $text =~ s/ ~~ /\\ \\textasciitilde\\textasciitilde\\ /g;
    $text =~ s/~/\\textasciitilde/g;
    $text =~ s/([#\$&%_{}])/\\$1/g;

    # Carets are special.
    $text =~ s/(\^)/\\char94{}/g;

    # Add unescaped dollars.
    $text =~ s/(\\backslash)/\$$1\$/g;

    # FIXME: Can't just replace them, since they look awful inside ttseries 
    # $text =~ s/\.{3}\s*/\\ldots /g;

    # Suggest hyphenation points for module names.
    $text =~ s/::/::\\-/g;

    # Non-breakable spaces.
    $text =~ s/Perl 6/Perl~6/g;
    $text =~ s/Perl 5/Perl~5/g;

    return $text;
}

# --------------------------------------------------------------------
1;
