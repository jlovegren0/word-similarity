#!/usr/bin/perl -CA
use strict;
use lib ("./");
use scorePairs;
##############
# http://stackoverflow.com/questions/33728250/inconsistent-results-parsing-unicode-strings-in-perl-unpack
#############

my $line;
my $fileName = $ARGV[0];
open INPUT, "$fileName";
while ($line = <INPUT>){
	chomp $line;
	$line =~ s/\s//g;
	$line =~ s/"//g;
	my @words = split /,/, $line;
	###
	if ($words[0]){
		for my $i (1..$#words){
		my $output = $words[0] . ": " . $words[1] . " | " . $words[$i] . "; score: " .  scorePairs::reportScore($words[1],$words[$i]) . "\n";
		print $output;
		}	
	}
}

