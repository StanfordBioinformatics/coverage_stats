#!/srv/gs1/software/python/3.2.3/bin/python3
import argparse
from string import Template
import shlex
import subprocess
import highest_version
import os.path

current_version = '0.3.1'
dbases_version = '0.2'
default_basepath = '/srv/gsfs0/SCGS' 
default_toolsdir = 'pipeline/coverage_stats/' + current_version
default_dbasesdir = 'pipeline/dbases/' + dbases_version
default_qsub = '/srv/gs1/software/oge2011.11p1/bin/linux-x64/qsub'

qualities = ['Q0', 'Q10', 'Q20', 'Q30']
thresholds = '5 10 15 20' # Perl script takes exactly 4 thresholds
genelists = ['dcm','acmg','clinvar','arrhythmia-brugada','global-developmental-delay','jf-cancer']

def add_gene_names(args_dict):
    """Call add_genes_qsub.pl for each quality, which uses qsub to run add_exonname_coverage.pl on each chromosome."""
    for quality in qualities:
        args_dict['quality'] = quality
        templ = Template('$add_genes_script $case $medgapdir $exons_bedfile refseq_exons $thresholds $quality 2g $coverage_dir $basepath/$toolsdir $output_dir')
        command_string = templ.substitute(args_dict)	
        command = shlex.split(command_string)
        subprocess.check_call(command)

def compute_gene_stats(args_dict):
    """Call compute_gene_stats.pl on each quality."""
    qsub = args_dict['qsub']
    for quality in qualities:
        args_dict['quality'] = quality
        args_dict['outfile'] = args_dict['output_dir'] + '/refseq_exon_stats_' + quality + '.txt'
        templ = Template(qsub + ' -hold_jid coverage_add_refseq_exons_$case* -A clinical-services -N compute_gene_stats_$case\_$quality """\"$compute_gene_stats_script $output_dir $outfile $quality\""""')
        command_string = templ.substitute(args_dict)	
        command = shlex.split(command_string)
        subprocess.check_call(command)

def grab_gene_stats(args_dict):
    """Call grab_genes_stats.pl on each gene list, on each quality."""
    qsub = args_dict['qsub']
    for genelist in genelists:
        args_dict['genelist_file'] = args_dict['basepath'] + '/' + args_dict['dbasesdir'] + '/' + genelist + '-panel.txt'
        for quality in qualities:
            args_dict['quality'] = quality
            args_dict['exon_stats_file'] = args_dict['output_dir'] + '/refseq_exon_stats_' + quality + '.txt'
            args_dict['outfile'] = args_dict['output_dir'] + '/' + genelist + '_exon_stats_' + quality + '.txt'
            args_dict['outfile_unmatched'] = args_dict['output_dir'] + '/' + genelist + '_exon_stats_' + quality + '\_unmatched.txt'
            templ = Template(qsub + ' -hold_jid compute_gene_stats_$case* -A clinical-services -N grab_genes_stats_$case\_'+genelist+'\_$quality """\"$grab_genes_stats_script $exon_stats_file $genelist_file $outfile $outfile_unmatched\""""')
            command_string = templ.substitute(args_dict)	
            command = shlex.split(command_string)
            subprocess.check_call(command)

def query_stats(args_dict):
    """Call query_stats.pl on each gene list, on each quality."""
    qsub = args_dict['qsub']
    for genelist in genelists:
        args_dict['genelist_file'] = args_dict['basepath'] + '/' + args_dict['dbasesdir'] + '/' + genelist + '-panel.txt'
        for quality in qualities:
            args_dict['quality'] = quality
            args_dict['infile'] = args_dict['output_dir'] + '/' + genelist + '_exon_stats_' + quality + '.txt'
            templ = Template(qsub + ' -hold_jid grab_genes_stats_$case* -A clinical-services -N query_stats_$case\_'+genelist+'\_$quality """\"$query_stats_script $infile $quality\""""')
            command_string = templ.substitute(args_dict)	
            command = shlex.split(command_string)
            subprocess.check_call(command)

def collect_stats(args_dict):
    """Call collect_stats.pl on each gene list."""
    qsub = args_dict['qsub']
    for genelist in genelists:
        args_dict['csqualities'] = str(qualities).strip('[]').replace(' ','')
        args_dict['csthresholds'] = thresholds.replace(' ',',')
        templ = Template(qsub + ' -hold_jid query_stats_$case* -A clinical-services -N collect_stats_$case\_'+genelist+' """\"$collect_stats_script '+genelist+' $csqualities $csthresholds $output_dir\""""')
        command_string = templ.substitute(args_dict)	
        command = shlex.split(command_string)
        subprocess.check_call(command)

def summarize_stats(args_dict):
    """Extract top-level summary stats for clinical report."""
    infile = open(os.path.join(args_dict['coverage_dir'],'genome_coverage_hist_Q0.txt.sample_summary'))
    infile.readline()
    fields = infile.readline().split('\t')
    genome_Q0_mean_depth = fields[2]
    genome_Q0_coverage = fields[6]
    print(fields[2] + ', ' + fields[6])
    infile = open(os.path.join(args_dict['coverage_dir'],'genome_coverage_hist_Q20.txt.sample_summary'))
    infile.readline()
    fields = infile.readline().split('\t')
    genome_Q20_mean_depth = fields[2]
    genome_Q20_coverage = fields[6]
    print(fields[2] + ', ' + fields[6])
    infile = open(os.path.join(args_dict['coverage_dir'],'refseq_exons_coverage_hist_Q0.txt.sample_summary'))
    infile.readline()
    fields = infile.readline().split('\t')
    exome_Q0_mean_depth = fields[2]
    exome_Q0_coverage = fields[6]
    print(fields[2] + ', ' + fields[6])
    infile = open(os.path.join(args_dict['coverage_dir'],'refseq_exons_coverage_hist_Q20.txt.sample_summary'))
    infile.readline()
    fields = infile.readline().split('\t')
    exome_Q20_mean_depth = fields[2]
    exome_Q20_coverage = fields[6]
    print(fields[2] + ', ' + fields[6])
    outfile = open(os.path.join(args_dict['output_dir'], 'sample_summary.txt'), 'w')
    outfile.write('Mean depth of coverage (genome, Q0): ' + genome_Q0_mean_depth + '\n')
    outfile.write('Mean depth of coverage (genome, Q20): ' + genome_Q20_mean_depth + '\n')
    outfile.write('Mean depth of coverage (exome, Q0): ' + exome_Q0_mean_depth + '\n')
    outfile.write('Mean depth of coverage (exome, Q20): ' + exome_Q20_mean_depth + '\n')
    outfile.write('% of base pairs covered at min depth 10 (genome, Q0): ' + genome_Q0_coverage)
    outfile.write('% of base pairs covered at min depth 10 (genome, Q20): ' + genome_Q20_coverage)
    outfile.write('% of base pairs covered at min depth 10 (exome, Q0): ' + exome_Q0_coverage)
    outfile.write('% of base pairs covered at min depth 10 (exome, Q20): ' + exome_Q20_coverage)
    outfile.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser('Run additional coverage statistics for a single case.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-b', '--basepath', dest='basepath', type=str, default=default_basepath, help='path to "cases" directory')
    parser.add_argument('-m', '--medgapdir', dest='medgapdir', type=str, default='latest', help='MedGap subdirectory, relative to basepath')
    parser.add_argument('-q', '--qcdir', dest='qcdir', type=str, default='latest', help='QC subdirectory, relative to medgapdir')
    parser.add_argument('-d', '--dbasesdir', dest='dbasesdir', type=str, default=default_dbasesdir, help='genelists subdirectory, relative to basepath')
    parser.add_argument('-t', '--toolsdir', dest='toolsdir', type=str, default=default_toolsdir, help='tools subdirectory, relative to basepath')
    parser.add_argument('-qs', '--qsub', dest='qsub', type=str, default=default_qsub, help='full path to qsub executable, absolute')
    parser.add_argument('--case', dest = 'case', type=str, help='name of case subdirectory (for example, case0017)')
    parser.add_argument('--fullqcdir', dest='fullqcdir', type=str, help='Full path to QC directory. If provided, overrides basepath, medgapdir, qcdir, and case.')

    args = parser.parse_args()
    args_dict = vars(args)

    if args.fullqcdir != None:
        # Calculate other paths from full path
        rest, args_dict['qcdir'] = os.path.split(args.fullqcdir)
        rest, args_dict['medgapdir'] = os.path.split(rest)
        rest, args_dict['case'] = os.path.split(rest)
        rest, cases = os.path.split(rest)
        assert cases == 'cases'
        args_dict['basepath'] = rest
    else:
        assert args.case != None
        if args.medgapdir == 'latest':
            args_dict['medgapdir'] = os.path.basename(highest_version.highest_version(args_dict['basepath'] + '/cases/' + args_dict['case']+ '/medgap'))
        if args.qcdir == 'latest':
            args_dict['qcdir'] = os.path.basename(highest_version.highest_version(args_dict['basepath'] + '/cases/' + args_dict['case'] + '/' + args_dict['medgapdir'] + '/QC'))

    args_dict['thresholds'] = thresholds
    args_dict['coverage_dir'] = args_dict['basepath'] + '/cases/' + args_dict['case'] + '/' + args_dict['medgapdir'] + '/' + args_dict['qcdir'] + '/coverage'
    args_dict['exons_bedfile'] = args_dict['basepath'] + '/' + args.dbasesdir + '/refseq_exons.bed' 
    args_dict['add_genes_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/add_genes_qsub.pl'
    args_dict['compute_gene_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/compute_gene_stats.pl'
    args_dict['grab_genes_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/grab_genes_stats.pl'
    args_dict['query_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/query_stats.pl'
    args_dict['collect_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/collect_stats.pl'
    args_dict['output_dir'] = os.path.join(args_dict['coverage_dir'],'coverage_stats-'+str(current_version))
    args_dict['qsub'] = args.qsub

    # Create output dir if it's not there already
    if not os.path.isdir(args_dict['output_dir']):
        os.makedirs(args_dict['output_dir'], exist_ok=True)

    add_gene_names(args_dict)
    compute_gene_stats(args_dict)
    grab_gene_stats(args_dict)
    query_stats(args_dict)
    collect_stats(args_dict)
    summarize_stats(args_dict)

    print("All jobs submitted successfully, check status using qstat")
