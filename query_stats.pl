#!/usr/bin/perl

my $stats = shift;
my $Q = shift;		# Q0, Q10, Q20, Q30

my $out="$stats.query.out";

open (IN, "<", $stats) or die "cannot open input file!";
open (OUT, ">", $out) or die "cannot open output file!";

my @N = 0;
my @C = 0;
my $idx=-1;

<IN>;
while (my $line=<IN>) {
	chomp $line;
	my @line = split("\t", $line);
	if ($line[1] eq "chrX"){
		$idx = 0;	# chrX
	} elsif ($line[1] eq "chrY"){
		$idx = 1;	# chrY
	} else {
		$idx = 2;
	}
	$N[$idx] = $N[$idx] + $line[3];
	$C[$idx][0] = $C[$idx][0] + $line[4];	# min x5
	$C[$idx][1] = $C[$idx][1] + $line[5];	# min x10
	$C[$idx][2] = $C[$idx][2] + $line[6];	# min x15
	$C[$idx][3] = $C[$idx][3] + $line[7];	# min x20

	#print "$line\n";
	#print "@line\n";
	#print "$N[$idx]\n";
	#print "$C[$idx][0]\t$C[$idx][1]\t$C[$idx][2]\t$C[$idx][3]\n";
}

my $ratio = 0;
if ($N[2]>0){
	$ratio = 100*($N[2]-$C[2][0])/$N[2];
}
print OUT "Percent autosomal genes covered by min X5 reads with min $Q base quality:\t";
printf OUT "%.4f\n", $ratio;


$ratio = 0;
if ($N[0]>0){
	$ratio = 100*($N[0]-$C[0][0])/$N[0];
}
print OUT "Percent X-linked genes covered by min X5 reads with min $Q base quality:\t";
printf OUT "%.4f\n\n", $ratio;

$ratio = 0;
if ($N[2]>0){
	$ratio = 100*($N[2]-$C[2][1])/$N[2];
}
print OUT "Percent autosomal genes covered by min X10 reads with min $Q base quality:\t";
printf OUT "%.4f\n", $ratio;

my $ratio = 0;
if ($N[0]>0){
	$ratio = 100*($N[0]-$C[0][1])/$N[0];
}
print OUT "Percent X-linked genes covered by min X10 reads with min $Q base quality:\t";
printf OUT "%.4f\n\n", $ratio;

$ratio = 0;
if ($N[2]>0){
	$ratio = 100*($N[2]-$C[2][2])/$N[2];
}
print OUT "Percent autosomal genes covered by min X15 reads with min $Q base quality:\t";
printf OUT "%.4f\n", $ratio;

$ratio = 0;
if ($N[0]>0){
	$ratio = 100*($N[0]-$C[0][2])/$N[0];
}
print OUT "Percent X-linked genes covered by min X15 reads with min $Q base quality:\t";
printf OUT "%.4f\n\n", $ratio;

$ratio = 0;
if ($N[2]>0){
	$ratio = 100*($N[2]-$C[2][3])/$N[2];
}
print OUT "Percent autosomal genes covered by min X20 reads with min $Q base quality:\t";
printf OUT "%.4f\n", $ratio;
$ratio = 0;
if ($N[0]>0){
	$ratio = 100*($N[0]-$C[0][3])/$N[0];
}
print OUT "Percent X-linked genes covered by min X20 reads with min $Q base quality:\t";
printf OUT "%.4f\n\n", $ratio;

close IN;
close OUT;
