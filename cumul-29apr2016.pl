#!/usr/bin/perl -CASD
###############
while (<>){
	if (/spons|idgin/){next;}
	@F = split /\t/;
	$i1 = $F[1];
	$i2 = $F[3];
	$s = $F[5];
	$cumul{$i1."_".$i2}+= $s;
	$counts{$i1."_".$i2}++;
}
for $k (keys %cumul){
	$quot = $cumul{$k} / $counts{$k};
	printf("$k\t$cumul{$k} / $counts{$k} = %.3f\n",$quot);
	}
