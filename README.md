coverage_stats
==============
Computes additional coverage statistics downstream of GATK's DepthOfCoverage.

    usage: Run additional coverage statistics for a single case.
           [-h] [-b BASEPATH] [-m MEDGAPDIR] [-q QCDIR] [-d DBASESDIR]
           [-t TOOLSDIR] [--case CASE] [--fullqcdir FULLQCDIR]
    
    optional arguments:
      -h, --help            show this help message and exit
      -b BASEPATH, --basepath BASEPATH
                            path to "cases" directory (default: /srv/gsfs0/SCGS)
      -m MEDGAPDIR, --medgapdir MEDGAPDIR
                            MedGap subdirectory, relative to basepath (default:
                            latest)
      -q QCDIR, --qcdir QCDIR
                            QC subdirectory, relative to medgapdir (default:
                            latest)
      -d DBASESDIR, --dbasesdir DBASESDIR
                            genelists subdirectory, relative to basepath (default:
                            pipeline/dbases/0.2)
      -t TOOLSDIR, --toolsdir TOOLSDIR
                            tools subdirectory, relative to basepath (default:
                            pipeline/coverage_stats/0.2)
      --case CASE           name of case subdirectory (for example, case0017)
                            (default: None)
      --fullqcdir FULLQCDIR
                            Full path to QC directory. If provided, overrides
                            basepath, medgapdir, qcdir, and case. (default: None)

For example:

	./coverage_stats.py case0011

Notes:

Stderr and stdout files from qsub are placed in user's home directory. This matches the behavior of the original scripts.

Overview of scripts:

add_genes_qsub.pl, calls add_exonname_coverage.pl on each chromosome
Input: $TYPE_coverage_hist_$Q.txt
Output: $TYPE_coverage_hist_$Q_withgenes_$chr.txt, $TYPE_coverage_hist_$Q.txt_$chromosome_$thresholds.stat

compute_gene_stats.pl
Input: coverage directory path
Output: refseq_exon_stats_$Q.txt

grab_genes_stats.pl
Input: refseq_exon_stats_$Q.txt, gene list
Output: $panel_exon_stats_$Q.txt

query_stats.pl
input: $panel_exon_stats_$Q.txt
output: $panel_exon_stats_$Q.txt.query.out

collect_stats.pl
Input: $panel_exon_stats_$Q.txt
Output: $panel_coverage_stats_min$thr[$i].txt
