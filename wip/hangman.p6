#!/usr/bin/perl6

# Simple hangman game to illustrate Perl 6.
# Very procedural.  No OOP.  Uses scalars, arrays, and hashes

# TODO: needs cleaning

use v6;

my $dictionary = shift(@*ARGS) // 'words';
my @words = read-dictionary($dictionary);
my $alphabet = join '', 'a'..'z';
my @hangman = <head torso left_arm right_arm left_leg right_leg>;

loop {
    my $word = @words.pick();
    my @blanks = "_" xx chars($word);

    my (@hanging,%missed,%guessed);
    my $i = 0;
    while @hanging != @hangman {
        say "          Word: " ~ join(" ", @blanks);
        say "Letters missed: " ~ join(" ", sort keys %missed);
        say "       Hangman: " ~ join(" ", @hanging);
        if join('',@blanks) eq $word { say "\t\tYou Win!"; last; }
        my $guess = lc prompt('Enter a letter: ');
        if not defined(index($alphabet,$guess)) {
            say "That's not a letter!";
            next;
        }
        if %guessed{$guess} {
            say "You already guessed that letter!";
            next;
        }
        %guessed{$guess}++;
        if defined(index($word,$guess)) {
            say "yes";
            @blanks = fill-blanks(@blanks,$word,$guess);
        }
        else {
            say "no";
            push(@hanging, @hangman[$i++]);
            %missed{$guess}++;
        }
    }
    say "\t\tYou lose!\nThe word was ''$word''" if @hanging == @hangman;

    my $answer = prompt('Try again? (Y/n) ');
    last if lc(substr($answer,0,1)) eq 'n';
}
say "Thanks for playing!";
exit;

sub read-dictionary ($dictionary) {
    say "Reading dictionary...";
    my $fh = open $dictionary, :r or die;
    my @words = gather for lines($fh) -> $line {
        # take only words of at least 5 charaters
        if chars($line) > 4 {
            # ... and conver to lower case
            take lc $line;
        }
    }
    say "Done.";
    return @words;
}

sub fill-blanks(@blanks, $word,$letter) {
    gather for @blanks Z $word.split('') -> $b, $w {
        take $w eq $letter ?? $w !! $b;
    }
}
