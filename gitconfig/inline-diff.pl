#!/usr/bin/perl

# (C) Jeff King,  Nov 18, 2010
# via http://git.661346.n2.nabble.com/Understanding-and-improving-word-diff-tt5717239.html#a5750571

use strict;
my $COLOR = qr/\x1b\[[0-9;]*m/;
my $RESET = "\x1b[0m";
my $RED = "\x1b[1;31m";
my $GREEN = "\x1b[1;34m";
my $REVERSE = "\x1b[7m";
my $UNREVERSE = "\x1b[27m";

my @window;

while (<>) {
 chomp;
 my $plain = $_;
 $plain =~ s/$COLOR//g;

 push @window, [$_, $plain];

 if ($window[0] && $window[0]->[1] =~ /^(\@| )/ &&
 $window[1] && $window[1]->[1] =~ /^-/ &&
 $window[2] && $window[2]->[1] =~ /^\+/ &&
 $window[3] && $window[3]->[1] !~ /^\+/) {
 show_line(shift @window);
 show_pair(shift @window, shift @window);
 }

 if (@window >= 4) {
 show_line(shift @window);
 }
}

if (@window == 3 &&
 $window[0] && $window[0]->[1] =~ /^(\@| )/ &&
 $window[1] && $window[1]->[1] =~ /^-/ &&
 $window[2] && $window[2]->[1] =~ /^\+/) {
 show_line(shift @window);
 show_pair(shift @window, shift @window);
}
while (@window) {
 show_line(shift @window);
}

exit 0;

sub show_line {
 my $line = shift;
 print $line->[0], "\n";
}

sub show_pair {
 my ($from, $to) = @_;
 my @from = split //, $from->[1];
 my @to = split //, $to->[1];

 my $prefix = 1;
 while ($from[$prefix] eq $to[$prefix]) {
 $prefix++;
 }
 my $suffix = 0;
 while ($from[$#from-$suffix] eq $to[$#to-$suffix]) {
 $suffix++;
 }

 print $RED, highlight($from->[1], $prefix, $suffix), $RESET, "\n";
 print $GREEN, highlight($to->[1], $prefix, $suffix), $RESET, "\n";
}

sub highlight {
 my ($line, $prefix, $suffix) = @_;
 my $end = length($line) - $suffix;
 return $line unless $end > $prefix;
 return join('',
   substr($line, 0, $prefix),
   $REVERSE,
   substr($line, $prefix, $end - $prefix),
   $UNREVERSE,
   substr($line, $end)
 );
}

