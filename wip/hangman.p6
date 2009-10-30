#!/usr/bin/perl6

# Simple hangman game to illustrate Perl 6.
# Very procedural.  No OOP.  Uses scalars, arrays, and hashes

# TODO: needs cleaning

use v6;

my $dictionary = shift(@*ARGS) // 'words';
my @words = read-dictionary($dictionary);
my $alphabet = "abcdefghijklmnopqrstuvwxyz";
my @hangman = <head torso left_arm right_arm left_leg right_leg>;

loop {
    my $word = @words[rand * +@words];
    my @blanks = "_" xx chars($word);

    my (@hanging,%missed,%guessed); 
    my $i = 0;
    while @hanging != @hangman {
        say "          Word: " ~ join(" ", @blanks);
        say "Letters missed: " ~ join(" ", sort keys %missed);
        say "       Hangman: " ~ join(" ", @hanging);
        if join('',@blanks) eq $word { say "\t\tYou Win!"; last; }
        say "Enter a letter ...";
        my $guess = substr(lc(get($*IN)), 0, 1);        # only take first char
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
    say "Try again? (Y/n)";
    my $answer = get($*IN);
    last if lc(substr($answer,0,1)) eq 'n';
}
say "Thanks for playing!";
exit;

sub read-dictionary ($dictionary) {
    say "Reading dictionary...";
    my $fh = open $dictionary, :r or die;
    my @words;
    for lines($fh) <-> $line {
        chomp($line);                       # remove newline
        $line = lc($line);                  # make all words lower case
        next unless chars($line) > 4;       # only take words with more than 4 characters
        push(@words,$line);
    }
    say "Done.";
    return @words;
}

sub fill-blanks(@blanks is copy,$word,$letter) {
    return unless $letter;
    @blanks = "_" xx chars($word) if !@blanks;
    my $next_pos = 0;
    loop { 
        my $pos = index($word,$letter,$next_pos);
        last unless defined $pos;
        @blanks[$pos] = $letter;
        $next_pos = $pos+1;
    }
    return @blanks;
}
