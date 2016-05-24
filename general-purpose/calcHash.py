#!/usr/local/bin/python3
import sys, hashlib, os, time

#file hashen
def md5(fname):
	hash_md5 = hashlib.md5()
	with open(fname, "rb") as f:
		for chunk in iter(lambda: f.read(4096), b""):
			hash_md5.update(chunk)
	return hash_md5.hexdigest()

def toExclude(filepath, excludes):
	for exclude in excludes:
		if(exclude in filepath):
			return True
	return False

# ordner hashen
def md5Dir(dname,excludes):
	hash_md5 = hashlib.md5()
	for root, dirs, files in os.walk(dname):
		for names in files:
			filepath = os.path.join(root,names)
			if (toExclude(filepath,excludes)):
				continue
			#print(filepath)
			with open(filepath, "rb") as f:
				for chunk in iter(lambda: f.read(4096), b""):
					hash_md5.update(chunk)
	return hash_md5.hexdigest()

# Unterscheiden zwischen Ordner und File
def getmd5Hash(arg,exclude):
	if (os.path.isfile(arg)):
		return md5(arg)
	return md5Dir(arg,exclude)
