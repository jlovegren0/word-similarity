#!/usr/bin/perl -CASD
use strict;
use lib ("./");
use List::Util qw(first max maxstr min minstr reduce shuffle sum);
use scorePairs;
##############
# http://stackoverflow.com/questions/33728250/inconsistent-results-parsing-unicode-strings-in-perl-unpack
#############

sub fixDigraphs {
	my $in = $_[0];
	my $a = join "!", unpack("U*",$in);
	$a =~ s/116!115!104/679/g;
	$a =~ s/115!104/643/g;
	$a =~ s/116!115/678/g;
	$a =~ s/110!121/626/g;
	$a =~ s/112!102/80/g;
	$a =~ s/103!104/611/g;
	$a =~ s/100!122/499/g;
	$a =~ s/107!112/75/g;
	$a =~ s/103!98/71/g;
	$a =~ s/109!(768|769|770|780)!331/625!\1/g;
	my $out = pack("U*",split /!/,$a);
	return $out;
}

my $line;
my ($fileName,$startLine,$endLine,$idLine) = @ARGV;

open INPUT, "$fileName";
my @theIDs;
LINELOOP: while ($line = <INPUT>){
	chomp $line;
	$line =~ s/\s//g;
	$line =~ s/"//g;
	if ($line=~m/^(,|\s)*$/){next LINELOOP;}
	my @words = split /,/, $line;
	###
	if ($. == $idLine){
		for my $i (1..$#words){ push @theIDs, $words[$i]; }
		}
	elsif ($. >= $startLine && $. <= $endLine){
		my $last = $#words;
		my $penult = $last - 1;
		my ($jib, $jab);
		for my $outerIndex (1..$penult){
			for my $innerIndex ($outerIndex+1..$last){
				$jib = &fixDigraphs($words[$innerIndex]);
				$jab = &fixDigraphs($words[$outerIndex]);
				my $l1 = scorePairs::wordLength($jib);
				my $l2 = scorePairs::wordLength($jab);
				my $l3 = max($l1,$l2);
				my $score = scorePairs::reportScore($jib,$jab) / $l3;
				my $msg = $words[0] . "\t" . $theIDs[$outerIndex-1] .
					"\t" . $words[$outerIndex] . "\t" . $theIDs[$innerIndex-1] .
					"\t" . $words[$innerIndex];
				printf("$msg\t%.2f\n",$score);
			}	
		}
##		my $subtotal = 0;
##		my $verbose = '(';
##		my $jib;
##		my $jab;
##		for my $i (1..$penult){
##		$jib = &fixDigraphs($words[$i]);
##		$jab = &fixDigraphs($words[$last]);
##		my $incr = scorePairs::reportScore($jib,$jab);
##		$subtotal += $incr;
##		$verbose .= " $incr ";
##		if ($i < $penult){$verbose .= "+";}
##		}	
##		my $wordlen = scorePairs::wordLength($jab);
##		if ($penult==0){next;}
##		$verbose .= " ) / $penult";
##		printf("Average score for $jab ($wordlen) $jib is %.2f  $verbose\n",$subtotal/$penult);
	}
}

