#!/usr/bin/perl
use strict;

my $sample = shift;
my $pipeline = shift;
my $BED = shift;	# /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/refSeq/refseq_exons.bed, /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/refSeq/refseq_genes_pad10.bed 
my $TYPE = shift; # refseq_exons, refseq_genes_pad10
my $thr1 = shift;
my $thr2 = shift;
my $thr3 = shift;
my $thr4 = shift;
my $Q = shift;		#Q0, Q10, Q20, Q30
my $mem = shift;
my $MDIR = shift;

print "$sample\n";
print "$pipeline\n";
print "$MDIR\n";

my $command;
my $chr;
for (my $i=1; $i<=22; $i++){
	$chr = "chr$i";
	$command = "qsub \-b y \-N coverage_add_$TYPE\_$sample\_$chr -A clinical-services -l h_vmem=$mem \"/srv/gsfs0/SCGS/tools/coverage/add_exonname_coverage.pl $MDIR/$TYPE\_coverage_hist_$Q.txt $BED $MDIR/$TYPE\_coverage_hist_$Q\_withgenes_$chr.txt $chr $thr1 $thr2 $thr3 $thr4\"";
	print "$command\n";
	system($command);
}
$chr = "chrX";
$command = "qsub \-b y \-N coverage_add_$TYPE\_$sample\_$chr -A clinical-services -l h_vmem=$mem \"/srv/gsfs0/SCGS/tools/coverage/add_exonname_coverage.pl $MDIR/$TYPE\_coverage_hist_$Q.txt $BED $MDIR/$TYPE\_coverage_hist_$Q\_withgenes_$chr.txt $chr $thr1 $thr2 $thr3 $thr4\"";
print "$command\n";
system($command);

$chr = "chrY";
$command = "qsub \-b y \-N coverage_add_$TYPE\_$sample\_$chr -A clinical-services -l h_vmem=$mem \"/srv/gsfs0/SCGS/tools/coverage/add_exonname_coverage.pl $MDIR/$TYPE\_coverage_hist_$Q.txt $BED $MDIR/$TYPE\_coverage_hist_$Q\_withgenes_$chr.txt $chr $thr1 $thr2 $thr3 $thr4\"";
print "$command\n";
system($command);

