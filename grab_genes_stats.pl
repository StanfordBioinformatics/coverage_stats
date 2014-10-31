#!/usr/bin/perl
use strict;

#my $dir = shift;
my $in = shift; #"refseq_exon_stats.txt";
my $genes = shift;
my $out = shift;

open (GENES, "<", $genes) or die "cannot open genes file!";
open (OUT, ">", $out) or die "cannot open output file!";
open (IN, "<", $in) or die "cannot open input sample file!";
#print OUT "Locus\tTotal_Depth\tAverage_Depth_sample\tDepth\tcovered_by10\tcovered_by20\tgene\n";

my %genes;

while (my $line=<GENES>){
        chomp $line;
	print "$line\n";
	$line =~ s/^\s+//;
	$line =~ s/\s+$//;
        $genes{$line} = 1;
}
close GENES;
foreach my $gene (keys %genes){
	print "$gene\n";
}
#my @files;
#get_file_list(\@files, $dir, $prefix);

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
		}
	}
	close IN;
#}
close OUT;
