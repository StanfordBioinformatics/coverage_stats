#!/usr/bin/perl
use strict;

#my $dir = shift;
my $in = shift; #"refseq_exon_stats.txt";
my $genes = shift;
my $out = shift;
my $out_unmatched = shift;

open (GENES, "<", $genes) or die "cannot open genes file!";
open (OUT, ">", $out) or die "cannot open output file!";
#open (OUT_UNMATCHED, ">", $out_unmatched) or die "cannot open output file!";
open (IN, "<", $in) or die "cannot open input sample file!";
#print OUT "Locus\tTotal_Depth\tAverage_Depth_sample\tDepth\tcovered_by10\tcovered_by20\tgene\n";

my %genes;

while (my $line=<GENES>){
        chomp $line;
	print "$line\n";	
	$line =~ s/^\s+//;	# Remove white space at beginning and end of line
	$line =~ s/\s+$//;
        $genes{$line} = 1;	# Add a new key:value pair gene_name:1
}
close GENES;
foreach my $gene (keys %genes){
	print "$gene\n";
}
#my @files;
#get_file_list(\@files, $dir, $prefix);

my %genes_found = %genes;

#foreach my $file (@files){
#	print "$file\n";
	my $line=<IN>;
	chomp $line;
	print OUT "$line\n";
	while (my $line=<IN>){
		chomp $line;
		my @line = split("\t", $line);
		my $gene = $line[0];
		if ($genes{$gene} eq "1"){
			#print "$gene\t$genes{$gene}\n";
			print OUT "$line\n";
			#print "$line\n";
			$genes_found{$gene} = 0;	# Every time we match a gene, mark its corresponding entry in genes_found with a 0
		}
	}
	close IN;
#}

close OUT;

# At this point, genes_found should have a value of 0 for genes that were matched and 1 for genes that weren't matched
my $unmatched_count = 0;

#print OUT_UNMATCHED "Genes from gene list with no matches:\n";
#foreach my $gene (keys %genes_found) {
#	if ($genes_found{$gene} eq "1") {
#		print OUT_UNMATCHED "$gene\n";
#		$unmatched_count++;
#	}	
#}
#if ($unmatched_count == 0) {
#	print OUT_UNMATCHED "No unmatched genes.\n";
#}

close OUT_UNMATCHED;
