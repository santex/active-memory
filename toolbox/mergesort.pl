#!/usr/bin/env perl

use strict;
use warnings;

sub mergesort_string
{
	my ($aref, $begin, $end)=@_;

	my $size=$end-$begin;

	if($size<2) {return;}
	my $half=$begin+int($size/2);

	mergesort_string($aref, $begin, $half);
	mergesort_string($aref, $half, $end);

	for(my $i=$begin; $i<$half; ++$i) {
		if($$aref[$i] gt $$aref[$half]) {
			my $v=$$aref[$i];
			$$aref[$i]=$$aref[$half];

			my $i=$half;
			while($i<$end-1 && $$aref[$i+1] lt $v) {
				($$aref[$i], $$aref[$i+1])=
					($$aref[$i+1], $$aref[$i]);
				++$i;
			}
			$$aref[$i]=$v;
		}
	}
}

sub msort_string
{
	my $size=@_;
	mergesort_string(\@_, 0, $size);
}


sub mergesort_number
{
	my ($aref, $begin, $end)=@_;

	my $size=$end-$begin;

	if($size<2) {return;}
	my $half=$begin+int($size/2);

	mergesort_number($aref, $begin, $half);
	mergesort_number($aref, $half, $end);

	for(my $i=$begin; $i<$half; ++$i) {
		if($$aref[$i] > $$aref[$half]) {
			my $v=$$aref[$i];
			$$aref[$i]=$$aref[$half];

			my $i=$half;
			while($i<$end-1 && $$aref[$i+1] < $v) {
				($$aref[$i], $$aref[$i+1])=
					($$aref[$i+1], $$aref[$i]);
				++$i;
			}
			$$aref[$i]=$v;
		}
	}
}

sub msort_number
{
	my $size=@_;
	mergesort_number(\@_, 0, $size);
}


my @towns=qw(Paris London Stockholm Berlin Oslo Rome Madrid Tallinn Amsterdam Dublin);
print "towns before mergesort:";
foreach (@towns) {
	print " $_"
}
print "\n";

msort_string(@towns);
print "towns after mergesort:";
foreach (@towns) {
	print " $_"
}
print "\n";

my @numbers=qw(9 8 6 98 43 12 59 52 4 5 14 2 92 3 32 54 22 41 7 34 15 3 1 13 99 42 63 34);
print "numbers before mergesort:";
foreach (@numbers) {
	print " $_"
}
print "\n";

msort_number(@numbers);
print "numbers after mergesort:";
foreach (@numbers) {
	print " $_"
}
print "\n";

