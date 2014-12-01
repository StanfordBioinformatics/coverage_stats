#!/srv/gs1/software/python/3.2.3/bin/python3
import argparse
from string import Template
import shlex
import subprocess
import highest_version
import os.path

current_version = '0.1'
default_basepath = '/srv/gsfs0/SCGS' 
default_toolsdir = 'pipeline/coverage_stats/' + current_version
default_dbasesdir = 'pipeline/dbases'

qualities = ['Q0', 'Q10', 'Q20', 'Q30']
thresholds = '5 10 15 20' # Perl script takes exactly 4 thresholds
genelists = ['dcm','acmg','clinvar','arrhythmia-brugada','global-developmental-delay']

parser = argparse.ArgumentParser('Run additional coverage statistics for a single case.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-b', '--basepath', dest='basepath', type=str, default=default_basepath, help='path to "cases" directory')
parser.add_argument('-m', '--medgapdir', dest='medgapdir', type=str, default='latest', help='MedGap subdirectory, relative to basepath')
parser.add_argument('-q', '--qcdir', dest='qcdir', type=str, default='latest', help='QC subdirectory, relative to medgapdir')
parser.add_argument('-d', '--dbasesdir', dest='dbasesdir', type=str, default=default_dbasesdir, help='genelists subdirectory, relative to basepath')
parser.add_argument('-t', '--toolsdir', dest='toolsdir', type=str, default=default_toolsdir, help='tools subdirectory, relative to basepath')
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
	if args.medgapdir == 'latest':
		args_dict['medgapdir'] = os.path.basename(highest_version.highest_version(args_dict['basepath'] + '/cases/' + args_dict['case']+ '/medgap'))
	if args.qcdir == 'latest':
		args_dict['qcdir'] = os.path.basename(highest_version.highest_version(args_dict['basepath'] + '/cases/' + args_dict['case'] + '/' + args_dict['medgapdir'] + '/QC'))

args_dict['thresholds'] = thresholds
args_dict['coverage_dir'] = args_dict['basepath'] + '/cases/' + args_dict['case'] + '/' + args_dict['medgapdir'] + '/' + args_dict['qcdir'] + '/coverage'
args_dict['exons_bedfile'] = args_dict['basepath'] + '/' + args.dbasesdir + '/refSeq/refseq_exons.bed' 
args_dict['add_genes_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/add_genes_qsub.pl'
args_dict['compute_gene_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/compute_gene_stats.pl'
args_dict['grab_genes_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/grab_genes_stats.pl'
args_dict['query_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/query_stats.pl'
args_dict['collect_stats_script'] = args_dict['basepath'] + '/' + args.toolsdir + '/collect_stats.pl'

# Call add_genes_qsub.pl for each quality, which uses qsub to run add_exonname_coverage.pl on each chromosome
for quality in qualities:
 	args_dict['quality'] = quality
 	templ = Template('$add_genes_script $case $medgapdir $exons_bedfile refseq_exons $thresholds $quality 2g $coverage_dir $toolsdir')
 	command_string = templ.substitute(args_dict)	
 	command = shlex.split(command_string)
 	subprocess.check_call(command)

# Call compute_gene_stats.pl on each quality
for quality in qualities:
 	args_dict['quality'] = quality
 	args_dict['outfile'] = args_dict['coverage_dir'] + '/refseq_exon_stats_' + quality + '.txt'
 	templ = Template('qsub -hold_jid coverage_add_refseq_exons_$case* -A clinical-services -N compute_gene_stats_$case\_$quality """\"$compute_gene_stats_script $coverage_dir $outfile $quality\""""')
 	command_string = templ.substitute(args_dict)	
 	command = shlex.split(command_string)
 	subprocess.check_call(command)

# Call grab_genes_stats.pl on each gene list, on each quality
for genelist in genelists:
	args_dict['genelist_file'] = args_dict['basepath'] + '/' + args.dbasesdir + '/' + genelist + '/' + genelist + '-panel.txt'
	for quality in qualities:
		args_dict['quality'] = quality
		args_dict['exon_stats_file'] = args_dict['coverage_dir'] + '/refseq_exon_stats_' + quality + '.txt'
		args_dict['outfile'] = args_dict['coverage_dir'] + '/' + genelist + '_exon_stats_' + quality + '.txt'
		templ = Template('qsub -hold_jid compute_gene_stats_$case* -A clinical-services -N grab_genes_stats_$case\_'+genelist+'\_$quality """\"$grab_genes_stats_script $exon_stats_file $genelist_file $outfile\""""')
		command_string = templ.substitute(args_dict)	
		command = shlex.split(command_string)
		subprocess.check_call(command)
 	
# Call query_stats.pl on each gene list, on each quality
for genelist in genelists:
	args_dict['genelist_file'] = args_dict['basepath'] + '/' + args.dbasesdir + '/' + genelist + '/' + genelist + '-panel.txt'
	for quality in qualities:
		args_dict['quality'] = quality
		args_dict['infile'] = args_dict['coverage_dir'] + '/' + genelist + '_exon_stats_' + quality + '.txt'
		templ = Template('qsub -hold_jid grab_genes_stats_$case* -A clinical-services -N query_stats_$case\_'+genelist+'\_$quality """\"$query_stats_script $infile $quality\""""')
		command_string = templ.substitute(args_dict)	
		command = shlex.split(command_string)
		subprocess.check_call(command)

# Call collect_stats.pl on each gene list
for genelist in genelists:
	args_dict['csqualities'] = str(qualities).strip('[]').replace(' ','')
	args_dict['csthresholds'] = thresholds.replace(' ',',')
	templ = Template('qsub -hold_jid query_stats_$case* -A clinical-services -N collect_stats_$case\_'+genelist+' """\"$collect_stats_script '+genelist+' $csqualities $csthresholds $coverage_dir\""""')
	command_string = templ.substitute(args_dict)	
	command = shlex.split(command_string)
	subprocess.check_call(command)

print("All jobs submitted successfully, check status using qstat")
