use strict;
use warnings;
use 5.010;
use utf8;
use open IO => ':encoding(utf8)';;

use Data::Dumper;
$Data::Dumper::Useqq = 1;

say "=begin table\n";
while (<>) {
    chomp;
    s/^\s+//;
    next unless length $_;
    my @row = split /\s{2,}/, $_;
    say "=headrow\n" if $. == 1;

    say "=row\n";

    for my $c (@row) {
        say "=cell $c\n";
    }

    say "=bodyrows\n" if $. == 1;
}
say "=end table";
