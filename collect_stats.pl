#!/usr/bin/perl
use strict;

my $panel = shift;
my $Qs = shift;
my $thrs = shift;
my $dir = shift;

my %map1;
my @thr = split(",", $thrs);
my @Q = split(",", $Qs);
foreach my $Q (@Q){
	open (IN, "<", "$dir/$panel\_exon_stats\_$Q\.txt") or die "cannot open input stat $Q file!";
	my $line = <IN>;
	while (my $line = <IN> ){
		chomp $line;
		my @line = split("\t", $line);
		$map1{$line[0]}{$Q} = $line;
	}
	close IN;
}

#my $temp = $map{"ACTC1"}{"Q0"};
#print "$temp\n";
#my $temp = $map{"ACTC1"}{"Q10"};
#print "$temp\n";
#my $temp = $map{"ACTC1"}{"Q20"};
#print "$temp\n";
#my $temp = $map{"ACTC1"}{"Q30"};
#print "$temp\n";


my %map2;
foreach my $gene (keys %map1){
	foreach my $Q (@Q){
		my $count = 0;
		my @rec = split("\t", $map1{$gene}{$Q});
		#print "@rec\n";
		foreach my $thr (@thr){
			$map2{$gene}{$Q}{$thr}[0] = $rec[0]; 
			$map2{$gene}{$Q}{$thr}[1] = $rec[1]; 
			$map2{$gene}{$Q}{$thr}[2] = $rec[2]; 
			$map2{$gene}{$Q}{$thr}[3] = $rec[3];
			$map2{$gene}{$Q}{$thr}[4] = $rec[4+$count];
			$map2{$gene}{$Q}{$thr}[5] = $rec[8+$count];
			#print "$rec[4+$count]\t$rec[8+$count]\n";
			$count = $count+1;
		}
		#die;
	}
}
#die;

my $lent=@thr;
for (my $i=0; $i<$lent; $i++){
	open(OUT, ">", "$dir/$panel\_coverage_stats_min$thr[$i].txt");
	print OUT "gene\tchr\ttranscripts\tlength\tnot_coverged_by$thr[$i]_minQ0_reads\tnot_coverged_by$thr[$i]_minQ10_reads\tnot_coverged_by$thr[$i]_minQ20_reads\tnot_coverged_by$thr[$i]_minQ30_reads\tpercent_not_coverged_by$thr[$i]_minQ0_reads\tpercent_not_coverged_by$thr[$i]_minQ10_reads\tpercent_not_coverged_by$thr[$i]_minQ20_reads\tpercent_not_coverged_by$thr[$i]_minQ30_reads\n";
	foreach my $gene (sort keys %map2){
		printf OUT "%s\t%s\t%s\t%s", $map2{$gene}{$Q[0]}{$thr[$i]}[0], $map2{$gene}{$Q[0]}{$thr[$i]}[1],  $map2{$gene}{$Q[0]}{$thr[$i]}[2], $map2{$gene}{$Q[0]}{$thr[$i]}[3];	
		foreach my $Q (@Q){
			printf OUT "\t%d", $map2{$gene}{$Q}{$thr[$i]}[4];	
		}
		
		foreach my $Q (@Q){
			printf OUT "\t%.3f", $map2{$gene}{$Q}{$thr[$i]}[5];	
		}
		print OUT "\n";
	}
	close OUT
}	
