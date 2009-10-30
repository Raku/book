#!/usr/bin/perl6

# RPN calulator from the bottom of http://use.perl.org/~pmichaud/journal/38580

# Excellent example, not sure where/if it fits

use v6;

my %op_dispatch_table = {
    '+'    => { .push(.pop + .pop)  },
    '-'    => { .push(.pop R- .pop) },
    '*'    => { .push(.pop * .pop)  },
    '/'    => { .push(.pop R/ .pop) },
    'sqrt' => { .push(.pop.sqrt)    },
};

sub evaluate (%odt, $expr) {
    my @stack;
    my @tokens = $expr.split(/\s+/);
    for @tokens {
        when /\d+/     { @stack.push($_); }
        when ?%odt{$_} { %odt{$_}(@stack); }
        default        { die "Unrecognized token '$_'; aborting"; }
    }
    @stack.pop;
}

say "Result: { evaluate(%op_dispatch_table, @*ARGS[0]) }";
