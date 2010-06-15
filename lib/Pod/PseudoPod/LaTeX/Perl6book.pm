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

sub start_B {
    my $self = shift;    
    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';
    if ( $target eq 'programlisting' ) {
        return;
    }    
    $self->{scratch} .= '\\textbf{';    
}

sub start_U {
    my $self = shift;
    $self->{scratch} .= '\\url{';    
}

sub end_U {
    my $self = shift;
    $self->{scratch} .= '}';
}

sub end_B {
    my $self = shift;
    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';
    if ( $target eq 'programlisting' ) {
        return;
    }
    $self->{scratch} .= '}';
}

sub encode_verbatim_text {
    my ($self, $text) = @_;

    # No encoding needed!    
    return $text;
}


# Overload because of custom formatting for programlisting sections
sub start_Verbatim {
    my $self  = shift;
    my $flags = shift;

    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';

    if ( $target eq 'screen' ) {
        my $verb_options = 'label=' . $self->{labels}{screen};
        $self->{scratch} .= "\\begin{Verbatim}[$verb_options]\n";
    } elsif ( $target eq 'programlisting' ) {
        $self->{scratch} .= "\\begin{perlcode}\n";
    } else {
        $self->{scratch} .= "\\begin{Verbatim}\n";        
    }
    
    $self->{flags}{in_verbatim}++;
} ## end sub start_Verbatim

sub end_Verbatim
{
    my $self = shift;

    my $target = eval { $self->{curr_open}[-1][-1]{target} } || '';

    if ( $target eq 'programlisting' ) {
        $self->{scratch} .= "\n\\end{perlcode}\n";
    } else {
        $self->{scratch} .= "\n\\end{Verbatim}\n";
    }
   
    $self->{flags}{in_verbatim}--;
    $self->emit();
}



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

    # Quotes are gone now too -- csquotes is the right package for that
    
    # fix the ellipses
    $text =~ s/\.{3}\s*/\\ldots /g;

    # Better be fixed in text directly!
    # $text =~ s/\s--\s/---/g;

    # Probably not needed, since tildes should look nice when we've got the right font
    # $text =~ s/~/\$\\sim\$/g;

    # suggest hyphenation points for module names
    $text =~ s/::/::\\-/g;

    # Non-breakable spaces
    $text =~ s/Perl 6/Perl~6/g;
    $text =~ s/Perl 5/Perl~5/g;
    
    return $text;
} ## end sub encode_text

1;
