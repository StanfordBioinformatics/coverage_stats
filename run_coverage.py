#!/srv/gs1/software/python/3.2.3/bin/python3
import argparse
from string import Template
import shlex
import subprocess

qualities = ['Q0', 'Q10', 'Q20', 'Q30']
thresholds = '5, 10, 15, 20' # Perl script takes exactly 4 thresholds

default_basepath = '/srv/gsfs0/SCGS' 
default_medgapdir = 'medgap-2.0'
default_qcdir = 'QC-2.0'

parser = argparse.ArgumentParser('Run additional coverage statistics for a single case.', formatter_class=argparse.ArgumentDefaultsHelpFormatter)
parser.add_argument('-b', '--basepath', dest='basepath', type=str, default=default_basepath, help='path to "case", "dbases", and "tools" directories')
parser.add_argument('-m', '--medgapdir', dest='medgapdir', type=str, default=default_medgapdir, help='name of MedGap subdirectory')
parser.add_argument('-q', '--qcdir', dest='qcdir', type=str, default=default_qcdir, help='name of QC subdirectory')
parser.add_argument('case', type=str, help='name of case subdirectory (for example, case0017)')

args = parser.parse_args()
args_dict = vars(args)

args_dict['thresholds'] = thresholds
args_dict['coverage_dir'] = args.basepath + '/cases/' + args.case + '/' + args.medgapdir + '/' + args.qcdir + '/coverage'
args_dict['exons_bedfile'] = args.basepath + '/dbases/refSeq/refseq_exons.bed' 
args_dict['add_genes_script'] = args.basepath + '/tools/coverage/add_genes_qsub.pl'

for quality in qualities:
	args_dict['quality'] = quality
	templ = Template('$add_genes_script $case $medgapdir $exons_bedfile refseq_exons $thresholds $quality 2g $coverage_dir')
	command_string = templ.substitute(args_dict)	
	args = shlex.split(command_string)
	subprocess.Popen(args)
