#!/usr/bin/perl
use strict;

my $in = shift;
my $genes = shift;
my $out = shift;
#my $in = "/srv/gsfs0/projects/gbsc/benchmark/giab/NA12878.clia/hugeseq-1.3/hc2/manual-QC/coverage/acmg_coverage_hist.txt";
#my $genes = "/srv/gsfs0/projects/gbsc/Clinical_Service/dbases/ACMG/ACMG_genes.bed";
#my $out = "/srv/gsfs0/projects/gbsc/benchmark/giab/NA12878.clia/hugeseq-1.3/hc2/manual-QC/coverage/acmg_coverage_hist_genes.txt";

open (IN, "<", $in) or die "cannot open input sample file!";
open (OUT, ">", $out) or die "cannot open output file!";
open (GENE, "<", $genes) or die "cannot open input gene list!";

my %genes;

my $l = <GENE>;
while (my $l = <GENE>){
	chomp $l;
	my @rec = split("\t", $l);
	#print "@rec\n";
	push(@{$genes{$rec[0]}}, "$rec[1]\t$rec[2]\t$rec[3]");  
}
print "@{$genes{'chr1'}}\n";
die;

my $line=<IN>;
chomp $line;
print OUT "$line\tgene\n";
while (my $line=<IN>){
	chomp $line;
	my @line = split("\t", $line);
	my $chr = $1 if ($line[0] =~ m/(chr[\dXYM]{1,2}):\d+/); 	
	my $loc = $1 if ($line[0] =~ m/chr[\dXYM]{1,2}:(\d+)/); 
	#print ">$chr\t$loc\n";	
	foreach my $rec (@{$genes{$chr}}){
		#print ">>$rec\n";
		my @rec = split("\t", $rec);
		my $beg = $rec[0];
		my $end = $rec[1];
		my $gene = $rec[2];
		#print ">>>($beg)\t($end)\t($gene)\n";
		#print ">>>($loc)\t($chr)\n";
		if ($loc >= $beg && $loc <= $end){
			print OUT "$chr\t$loc\t$line[1]\t$line[2]\t$line[3]\t$gene\n";
			#print "$chr\t$loc\t$line[1]\t$line[2]\t$line[3]\t$gene\n";
			last;
		}
	}
}
close IN;
close OUT;
