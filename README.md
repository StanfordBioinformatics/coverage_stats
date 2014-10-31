vizzle
======

A collection of tools to create plots and figures. Initially targeting QC metrics, but can be expanded to other types of data.

coverage
========
COMPUTING THE COVERAGE STATS FOR MIN 10 and MIN 20 with Q0,Q10,Q20,Q30

After you have the coverage data from Kwality:

## 1-

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/add_genes_qsub.pl case0019 medgap-2.0 /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/refSeq/refseq_exons.bed refseq_exons 5 10 15 20 Q0 2g /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/add_genes_qsub.pl case0019 medgap-2.0 /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/refSeq/refseq_exons.bed refseq_exons 5 10 15 20 Q10 2g /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/add_genes_qsub.pl case0019 medgap-2.0 /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/refSeq/refseq_exons.bed refseq_exons 5 10 15 20 Q20 2g /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/add_genes_qsub.pl case0019 medgap-2.0 /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/refSeq/refseq_exons.bed refseq_exons 5 10 15 20 Q30 2g /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage

## 2-

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/compute_gene_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/ /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q0.txt Q0
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/compute_gene_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/ /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q10.txt Q10
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/compute_gene_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/ /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q20.txt Q20
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/compute_gene_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/ /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q30.txt Q30

## 3-

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q0.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/dcm/dcm-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q0.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q10.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/dcm/dcm-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q10.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q20.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/dcm/dcm-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q20.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q30.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/dcm/dcm-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q30.txt

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q0.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/acmg/acmg-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q0.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q10.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/acmg/acmg-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q10.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q20.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/acmg/acmg-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q20.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q30.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/acmg/acmg-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q30.txt

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q0.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/clinvar/clinvar-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q0.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q10.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/clinvar/clinvar-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q10.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q20.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/clinvar/clinvar-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q20.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q30.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/clinvar/clinvar-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q30.txt

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q0.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/arrhythmia-brugada/arrhythmia-brugada-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q0.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q10.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/arrhythmia-brugada/arrhythmia-brugada-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q10.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q20.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/arrhythmia-brugada/arrhythmia-brugada-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q20.txt
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/grab_genes_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/refseq_exon_stats_Q30.txt /srv/gsfs0/projects/gbsc/Clinical_Service/dbases/arrhythmia-brugada/arrhythmia-brugada-panel.txt /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q30.txt

## 4-

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q0.txt Q0

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q10.txt Q10
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q20.txt Q20
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/acmg_exon_stats_Q30.txt Q30

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q0.txt Q0
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q10.txt Q10
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q20.txt Q20
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/dcm_exon_stats_Q30.txt Q30

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q0.txt Q0
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q10.txt Q10
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q20.txt Q20
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/clinvar_exon_stats_Q30.txt Q30

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q0.txt Q0
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q10.txt Q10
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q20.txt Q20
/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/query_stats.pl /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/arrhythmia-brugada_exon_stats_Q30.txt Q30

## 5- 

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/collect_stats.pl dcm Q0,Q10,Q20,Q30 5,10,15,20 /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/collect_stats.pl acmg Q0,Q10,Q20,Q30 5,10,15,20 /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/collect_stats.pl clinvar Q0,Q10,Q20,Q30 5,10,15,20 /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/

/srv/gsfs0/projects/gbsc/Clinical_Service/tools/coverage/collect_stats.pl arrhythmia-brugada Q0,Q10,Q20,Q30 5,10,15,20 /srv/gsfs0/projects/gbsc/Clinical_Service/cases/case0019/medgap-2.0/QC-0.1/coverage/
