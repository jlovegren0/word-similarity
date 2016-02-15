#!/usr/bin/perl -CA
##############
# http://stackoverflow.com/questions/33728250/inconsistent-results-parsing-unicode-strings-in-perl-unpack
#############

require Algorithm::NeedlemanWunsch;
use utf8;

use warnings;

# similarity matrix (one for match, negative one for non-match)
# this should be altered

# for pairs of letteres where a score is declared
# if a pair is not declared here, it defaults to
# the values given in &score_sub
my %similarities = (
	"dg" => .5,
	"gd" => .5,
	"tk" => .5,
	"kt" => .5,
	"uo" => .5,
	"ou" => .5,
	);


# default scoring for gaps and matches
# not covered by %similarities
#
sub score_sub {
	if (!@_) {
		return -1; # gap penalty
	}
	my $index = $_[0] . $_[1];
	if (!$similarities{$index}){ 
		return ($_[0] eq $_[1]) ? 1 : -1;
		}
	else {
		return $similarities{$index};
	}
}

my @aString = ();
my @bString = ();
my $matches = 0;

# callback function when a match occurs
# two arguments are match position in
# first and second strings, respectively
sub on_align {
	push @aString, $a[$_[0]];
	push @bString, $b[$_[1]];
	$matches++;
}

# callback functions when a letter 
# in a or b is matched with a gap
sub on_shift_a {
	push @aString,$a[$_[0]];
	push @bString,35;
	$matches++;
	 }
sub on_shift_b {
	push @aString,35;
	push @bString,$b[$_[0]];
	$matches++;
	}

sub printArray {
	@arr = @{$_[0]};
	for $j (reverse @arr){
		if ($j == 768 || $j == 769 || $j == 770 || $j == 780){ print " ", pack ("U*", 9676,$j); }
		else { print " ", pack ("U*", $j); }
	}
}

my $matcher = Algorithm::NeedlemanWunsch->new(\&score_sub);

$args = \@ARGV;

@a = unpack("U*",$args->[0]);
@b = unpack("U*",$args->[1]);
# uncomment these to show unicode addresses
#print join "|",@a,"\n";
#print join "|",@b,"\n";


my $score = $matcher->align(\@a,\@b,{align=>\&on_align,shift_a=>\&on_shift_a,shift_b=>\&on_shift_b});

binmode(STDOUT,":utf8");
print " score: $score\n";
&printArray(\@aString);
print "\n";
print " |" x $matches;
print "\n";
&printArray(\@bString);
print "\n";
