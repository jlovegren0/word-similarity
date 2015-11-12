#!/usr/bin/perl
##############

require Algorithm::NeedlemanWunsch;
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

my $pushAligns = [[],[]];
my $shifts = [[],[]];
my $aString = "";
my $bString = "";
my $matches = 0;

# callback function when a match occurs
# two arguments are match position in
# first and second strings, respectively
sub on_align {
	$aString .= ($a[$_[0]] . " ");
	$bString .= ($b[$_[1]] . " ");
	$matches++;
}

# callback functions when a letter 
# in a or b is matched with a gap
sub on_shift_a {
	$aString .= ($a[$_[0]] . " ");
	$bString .= "# ";
	$matches++;
	 }
sub on_shift_b {
	$aString .= "# ";
	$bString .= ($b[$_[0]] . " ");
	$matches++;
	}


my $matcher = Algorithm::NeedlemanWunsch->new(\&score_sub);

$args = \@ARGV;
@a = split //, $args->[0];
@b = split //, $args->[1];


my $score = $matcher->align(\@a,\@b,{align=>\&on_align,shift_a=>\&on_shift_a,shift_b=>\&on_shift_b});

print " score: $score\n";
print scalar reverse $aString;
print "\n";
print " |" x $matches;
print "\n";
print scalar reverse $bString;
print "\n";
