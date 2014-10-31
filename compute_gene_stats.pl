#!/usr/bin/perl
use strict;

my $dir = shift;
my $out = shift;
my $ext = "stat";
my $Q = shift;

open (OUT, ">", $out) or die "cannot open output file!";

my @files;
get_file_list(\@files, $dir, $ext, $Q);

my %map;
foreach my $file (@files){
	print "$file\n";

	#my $chr = $1 if ($file =~ m/\S+\/refseq_exons_coverage_hist_$Q\.txt\_(chr[\dXYM]{1,2})\_\d+\_\d+\.stat/);	
	my $chr = $1 if ($file =~ m/\S+\/refseq_exons_coverage_hist_$Q\.txt\_(chr[\dXYM]{1,2})\_\d+\_\d+\_\d+\_\d+\.stat/);	
	open (IN, "<", $file) or die "cannot open input sample file!";
	my $line=<IN>;
	
	while (my $line=<IN>){
		chomp $line;
		my @line = split("\t", $line);
		my $gene = $line[0];
		if ($map{$gene}[1] > 0){
			$map{$gene}[0] = $chr;
			$map{$gene}[1] = $map{$gene}[1] + $line[1];
			$map{$gene}[2] = $map{$gene}[2] + $line[2];
			$map{$gene}[3] = $map{$gene}[3] + $line[4];
			$map{$gene}[4] = $map{$gene}[4] + $line[6];
			$map{$gene}[5] = $map{$gene}[5] + $line[8];
			$map{$gene}[6] = $map{$gene}[6] + 1; #exons;
		} else {
			$map{$gene}[0] = $chr;
			$map{$gene}[1] = $line[1];
			$map{$gene}[2] = $line[2];
			$map{$gene}[3] = $line[4];
			$map{$gene}[4] = $line[6];
			$map{$gene}[5] = $line[8];
			$map{$gene}[6] = 1;
		}
		if ($map{$gene}[0] eq ""){
			print "$line\n";
			die;
		}
	}
	close IN;
}

print OUT "gene\tchr\texons\ttotal_bases\tbases_not_covered_by5 (min Q: $Q)\tbases_not_covered_by10 (min Q: $Q)\tbases_not_covered_by15 (min Q: $Q)\tbases_not_covered_by20 (min Q: $Q)\tpercent_bases_not_covered_by5 (min Q: $Q)\tpercent_bases_not_covered_by10 (min Q: $Q)\tpercent_bases_not_covered_by15 (min Q: $Q)\tpercent_bases_not_covered_by20 (min Q: $Q)\n";
foreach my $gene (sort keys %map){
	print "$gene\n";
	my $chr = $map{$gene}[0];
	my $N = $map{$gene}[1];
	my $C1 = $map{$gene}[2];
	my $C2 = $map{$gene}[3];
	my $C3 = $map{$gene}[4];
	my $C4 = $map{$gene}[5];
	my $NC1 = $N-$C1;
	my $NC2 = $N-$C2;
	my $NC3 = $N-$C3;
	my $NC4 = $N-$C4;
	my $TRNSCRPT = $map{$gene}[6];
	my $PC1 = 100*($C1/$N);
	my $PC2 = 100*($C2/$N);
	my $PC3 = 100*($C3/$N);
	my $PC4 = 100*($C4/$N);
	my $PNC1 = 100-$PC1;
	my $PNC2 = 100-$PC2;
	my $PNC3 = 100-$PC3;
	my $PNC4 = 100-$PC4;
	print OUT "$gene\t$chr\t$TRNSCRPT\t$N\t$NC1\t$NC2\t$NC3\t$NC4\t";
	#printf OUT "%.2f\t%.2f\t%.2f\t%.2f\n", $PC1, $PC2, $PNC1, $PNC2;
	printf OUT "%.3f\t%.3f\t%.3f\t%.3f\n", $PNC1, $PNC2, $PNC3, $PNC4;
}
close OUT;

sub get_file_list {
        my ($list, $d, $ext, $Q) = @_;
        open (LS, "ls $d/refseq_exons_coverage_hist_$Q\.txt\_chr*.$ext |") or return 0;
        while (my $line=<LS>) {
                chomp $line;
                push @{$list}, $1 if ($line=~m/($d\/\S+\.$ext)/);
        }
        close LS;
        return scalar @{$list};
}

