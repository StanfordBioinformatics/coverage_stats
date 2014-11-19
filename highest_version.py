#!/srv/gs1/software/python/3.2.3/bin/python3.2 
import argparse
import glob
import string
import re

def highest_version(prefix):
	dirs = glob.glob(prefix+'*')
	versions_to_dirs = {}
	for dir in dirs:
		suffix = dir.replace(prefix.strip(),'',1)
		suffix = suffix.strip(string.punctuation)
		version = re.split('['+string.punctuation+']', suffix)
		version = tuple(version)
		for digit in version:
			assert digit.isnumeric()
		versions_to_dirs[version] = dir
	versions = list(versions_to_dirs.keys())
	versions.sort()
	highest_version = versions[-1]
	return versions_to_dirs[highest_version]

if __name__ == "__main__":
	parser=argparse.ArgumentParser(description='Get highest version number of directory starting with input prefix, relative to current working directory.')
	parser.add_argument('prefix', type=str, help='directory prefix')
	args = parser.parse_args()
	prefix = args.prefix
	print(highest_version(prefix))
