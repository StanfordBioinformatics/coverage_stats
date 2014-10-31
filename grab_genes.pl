#!/usr/bin/perl
use strict;

my $dir = shift;
my $prefix = "refseq_exons_coverage_hist_Q0_withgenes_";
my $genes = shift;
my $out = shift;

open (GENES, "<", $genes) or die "cannot open genes file!";
open (OUT, ">", $out) or die "cannot open output file!";
print OUT "Locus\tTotal_Depth\tAverage_Depth_sample\tDepth\tcovered_by10\tcovered_by20\tgene\n";

my %genes;

while (my $line=<GENES>){
        chomp $line;
	$line =~ s/^\s+//;
	$line =~ s/\s+$//;
        $genes{$line} = 1;
}
close GENES;
foreach my $gene (keys %genes){
	print "$gene\n";
}

my @files;
get_file_list(\@files, $dir, $prefix);

foreach my $file (@files){
	print "$file\n";
	open (IN, "<", $file) or die "cannot open input sample file!";
	my $line=<IN>;
	
	while (my $line=<IN>){
		chomp $line;
		my @line = split("\t", $line);
		my $gene = $line[7];
		if ($genes{$gene} eq "1"){
			#print "$gene\t$genes{$gene}\n";
			print OUT "$line\n";
			#print "$line\n";
		}
	}
	close IN;
}
close OUT;

sub get_file_list {
        my ($list, $d, $ext) = @_;
        open (LS, "ls $d/$ext*.txt |") or return 0;
        while (my $line=<LS>) {
                chomp $line;
		print "$line\n";
                push @{$list}, $1 if ($line=~m/($d\/$ext\S+)/);
        }
        close LS;
        return scalar @{$list};
}

