#!/usr/bin/perl
use strict;

my $in = shift;
my $genes = shift;
my $out = shift;
my $chr = shift;
my $thr1 = shift;
my $thr2 = shift;
my $thr3 = shift;
my $thr4 = shift;
my $stat = "$in\_$chr\_$thr1\_$thr2\_$thr3\_$thr4\.stat";
#my $in = "/srv/gsfs0/projects/gbsc/benchmark/giab/NA12878.clia/hugeseq-1.3/hc2/manual-QC/coverage/acmg_coverage_hist.txt";
#my $genes = "/srv/gsfs0/projects/gbsc/Clinical_Service/dbases/ACMG/ACMG_genes.bed";
#my $out = "/srv/gsfs0/projects/gbsc/benchmark/giab/NA12878.clia/hugeseq-1.3/hc2/manual-QC/coverage/acmg_coverage_hist_genes.txt";

open (IN, "<", $in) or die "cannot open input sample file!";
open (OUT, ">", $out) or die "cannot open output file!";
open (STAT, ">", $stat) or die "cannot open output file!";
#open (OUT, ">", "test.txt") or die "cannot open output file!";
open (GENE, "<", $genes) or die "cannot open input gene list!";

my %genes;

my $l = <GENE>;
while (my $l = <GENE>){
	chomp $l;
	my @rec = split("\t", $l);
	#print "@rec\n";
	push(@{$genes{$rec[0]}}, "$rec[1]\t$rec[2]\t$rec[3]");  
}
#print "@{$genes{'chr1'}}\n";

my $line=<IN>;
chomp $line;
print OUT "$line\tcovered_by$thr1\tcovered_by$thr2\tcovered_by$thr3\tcovered_by$thr4\tgene\ttranscript\n";
#print STAT "gene\ttotal_bases\tcovered_by10\tpercent_covered_by10\tnot_covered_by10\tpercent_not_covered_by10\tcovered_by20\tpercent_covered_by20\tnot_covered_by20\tpercent_not_covered_by20\n";
print STAT "gene\ttotal_bases\tcovered_by$thr1\tnot_covered_by$thr1\tcovered_by$thr2\tnot_covered_by$thr2\tcovered_by$thr3\tnot_covered_by$thr3\tcovered_by$thr4\tnot_covered_by$thr4\n";


#my $chr="chr1";
my @intervals;
foreach my $rec (@{$genes{$chr}}){
	my @rec = split("\t", $rec);
	my $beg = $rec[0];
	my $end = $rec[1];
	my $gene = $rec[2];
	push(@intervals, $beg);	
	push(@intervals, $end);	
	push(@intervals, $gene);	
}
#print "@intervals\n";
#die;

my @lines;
while (my $line=<IN>){
	if ($line=~m/$chr\:\d+/){
		chomp $line;
		while ($line=~m/$chr\:\d+/){
			push(@lines, $line);
			$line=<IN>;
			chomp $line;
		}
		goto END;
	}	
}
END:

my @olines;
my $search = 0;
my $gene_found = 0;
my $trans_no = 0;
my $gene_beg = -1;
my $gene_end = -1;
my $total_gene_bases = 0;
my $bases_covered_thr1 = 0;
my $bases_covered_thr2 = 0;
my $bases_covered_thr3 = 0;
my $bases_covered_thr4 = 0;
my $gene_name;
my $gene_name_old = $gene_name;
foreach my $line (@lines){
	#$loc = $loc + 1;
	my @l = split("\t", $line);
	my $loc = $1 if ($l[0] =~ m/chr[\dXYM]{1,2}:(\d+)/); 
	#print ">$loc\t$gene_end\n";
	#die;
	if ($gene_found>0){
		if ($loc <= $gene_end){
			my $gt_thr1 = 0;
			my $gt_thr2 = 0;
			my $gt_thr3 = 0;
			my $gt_thr4 = 0;
			#print OUT ">>>$loc\t$search\t$gene_name\n";
			if ($l[3] >= $thr4){
				$gt_thr4 = 1;
				#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t1\t$gene_name\n");
				$bases_covered_thr4 = $bases_covered_thr4+1;
			}
			if ($l[3] >= $thr3){
				$gt_thr3 = 1;
				#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t0\t$gene_name\n");
				$bases_covered_thr3 = $bases_covered_thr3+1;
			}
			if ($l[3] >= $thr2){
				$gt_thr2 = 1;
				#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t0\t$gene_name\n");
				$bases_covered_thr2 = $bases_covered_thr2+1;
			}
			if ($l[3] >= $thr1){
				$gt_thr1 = 1;
				#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t0\t$gene_name\n");
				$bases_covered_thr1 = $bases_covered_thr1+1;
			}
			push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t$gt_thr1\t$gt_thr2\t$gt_thr3\t$gt_thr4\t$gene_name\t$trans_no\n");

			$total_gene_bases = $total_gene_bases+1;
		} else {
			foreach my $l (@olines){
				print OUT "$l";
			}
			my $bases_not_covered_thr1 = $total_gene_bases - $bases_covered_thr1;
			my $bases_not_covered_thr2 = $total_gene_bases - $bases_covered_thr2;
			my $bases_not_covered_thr3 = $total_gene_bases - $bases_covered_thr3;
			my $bases_not_covered_thr4 = $total_gene_bases - $bases_covered_thr4;
			my $thr1_covered = $bases_covered_thr1/$total_gene_bases;
			my $thr2_covered = $bases_covered_thr2/$total_gene_bases;
			my $thr3_covered = $bases_covered_thr3/$total_gene_bases;
			my $thr4_covered = $bases_covered_thr4/$total_gene_bases;
			my $thr1_not_covered = 1-$thr1_covered;
			my $thr2_not_covered = 1-$thr2_covered;
			my $thr3_not_covered = 1-$thr3_covered;
			my $thr4_not_covered = 1-$thr4_covered;
			print STAT "$gene_name\t$total_gene_bases\t";
			#printf STAT "%d\t%.2f\t%d\t%.2f\t%d\t%.2f\t%d\t%.2f\n", $bases_covered_thr1, $thr1_covered, $bases_not_covered_thr1, $thr1_not_covered, $bases_covered_thr2, $thr2_covered, $bases_not_covered_thr2, $thr2_not_covered;
			#printf STAT "%d\t%d\t%d\t%d\n", $bases_covered_thr1, $bases_not_covered_thr1, $bases_covered_thr2, $bases_not_covered_thr2;
			printf STAT "%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n", $bases_covered_thr1, $bases_not_covered_thr1, $bases_covered_thr2, $bases_not_covered_thr2, $bases_covered_thr3, $bases_not_covered_thr3, $bases_covered_thr4, $bases_not_covered_thr4;
			$gene_found=0;
			$search=0;
			$gene_beg = -1;
			$gene_end = -1;
			$gene_name = "";
			$total_gene_bases = 0;
			$bases_covered_thr1 = 0;
			$bases_covered_thr2 = 0;
			$bases_covered_thr3 = 0;
			$bases_covered_thr4 = 0;
			@olines=();
			#die;
		}
	} else {
		foreach my $rec (@intervals){
			#print "$loc\t$rec\t$search\n";
			#if ($loc >= $rec && $search==1 && $rec !~ m/[A-Z]/i){
			#	$gene_beg = $rec;
			#	print "1:$gene_name\t$gene_beg\t$gene_end\n";
			#	next;
			#} elsif ($loc <= $rec && $search==1 && $rec !~ m/[A-Z]/i){
			if ($loc <= $rec && $search==1 && $rec !~ m/[A-Z]/i){
				$gene_end = $rec;
				next;	
			} elsif ($loc > $rec && $search==1 && $rec !~ m/[A-Z]/i){
				$search=0;
				next;	
			} elsif ($search == 1 && $rec =~ m/[A-Z]/i){ 
				$bases_covered_thr1 = 0;
				$bases_covered_thr2 = 0;
				$bases_covered_thr3 = 0;
				$bases_covered_thr4 = 0;
				my $gt_thr1 = 0;
				my $gt_thr2 = 0;
				my $gt_thr3 = 0;
				my $gt_thr4 = 0;
				#if ($l[3] >= $thr1 && $l[3]>=$thr2){
				if ($l[3] >= $thr4){
					$gt_thr4 = 1;
					#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t1\t$rec\n");
					$bases_covered_thr4 = 1;
				}
				if ($l[3] >= $thr3){
					$gt_thr3 = 1;
					#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t1\t$rec\n");
					$bases_covered_thr3 = 1;
				}
				if ($l[3] >= $thr2){
					$gt_thr2 = 1;
					#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t1\t$rec\n");
					$bases_covered_thr2 = 1;
				}
				if ($l[3] >= $thr1){
					$gt_thr1 = 1;
					#push(@olines,  "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t1\t0\t$rec\n");
					$bases_covered_thr1 = 1;
					#$bases_covered_thr2 = 1;
				}
				# else {
				$gene_name = $rec;
				if ($gene_name eq $gene_name_old){
					$trans_no = $trans_no + 1;
				} else {
					$trans_no = 1;
					$gene_name_old = $gene_name;
				}
				push(@olines, "$chr\t$loc\t$l[1]\t$l[2]\t$l[3]\t$gt_thr1\t$gt_thr2\t$gt_thr3\t$gt_thr4\t$rec\t$trans_no\n");
				$total_gene_bases = 1;
				$gene_found = 1;
				#die;
				goto GENEFOUND;
			} elsif ($loc >= $rec && $search==0 && $rec !~ m/[A-Z]/i){
				$gene_beg = $rec;
				$search = 1;
				#print "5:$rec\t$gene_name\t$gene_beg\t$gene_end\n";
			}
		}
	}
	GENEFOUND:
	#print "@olines\n";
}
#print OUT "$chr\t$loc\t$line[1]\t$line[2]\t$line[3]\t$gene\n";
close IN;
close OUT;
close STAT;
