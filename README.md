coverage_stats
==============
Computes additional coverage statistics downstream of GATK's DepthOfCoverage.

	usage: Run additional coverage statistics for a single case.
		[-h] [-b BASEPATH] [-m MEDGAPDIR] [-q QCDIR] [-d DBASESDIR]
		[-t TOOLSDIR]
		case

	positional arguments:
	  case              name of case subdirectory (for example, case0011)

	optional arguments:
	  -h, --help        show this help message and exit
	  -b BASEPATH, --basepath BASEPATH
                	  path to "cases", "dbases", and "tools" directories
                        (default: /srv/gsfs0/SCGS)
  	  -m MEDGAPDIR, --medgapdir MEDGAPDIR
    	                name of MedGap subdirectory, relative to basepath
      	                (default: latest)
  	  -q QCDIR, --qcdir QCDIR
    	                name of QC subdirectory, relative to medgapdir
      	                (default: latest)
  	  -d DBASESDIR, --dbasesdir DBASESDIR
    	                name of genelists subdirectory, relative to basepath
      	                (default: dbases)
  	  -t TOOLSDIR, --toolsdir TOOLSDIR
    	                name of tools subdirectory, relative to basepath
      	                (default: tools/coverage/dev)

For example:

	./coverage_stats.py case0011

Notes:

Stderr and stdout files from qsub are placed in user's home directory. This matches the behavior of the original scripts.
