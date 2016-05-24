#!/usr/local/bin/python3

'''
required PyYAML package
'''

import sys,os,calcHash,subprocess,pprint,yaml
from calcHash import getmd5Hash
from colors import *

# Prints JSON in a pretty way
def printJSON(data):
	pprint.pprint(data)
	print("\r\n")

# prints a box around a one line string
def printBox(string):
	bar = ""
	for char in string:
		bar += "-"
	bar = "----" + bar
	print(bar)
	print("| " + string + " |")
	print(bar + "\r\n")

# Backuper class is created for a single application
# and backups its data depending on the hashfile and hashes
class Backuper:

	# Returns the JSON interpretation of the yaml file as a String
	def _readConfig(self, filePath):
		print("Reading config file " + filePath +":")
		print("------------------------------------------")
		with open(filePath,'r') as file:
			return yaml.load(file) # interprets the yaml file

	# Contructs the Object.
	def __init__(self, configPath):
		self.configPath = configPath
		cfg = self._readConfig(configPath) #JSON interpretation of yaml config
		printJSON(cfg)

		self.pathsUpdated = []
		self.hashfilePath = cfg['hashfilePath']
		self.operations = cfg['ops']
		self.excludes = []
		if 'target' in cfg:
			if 'data' in cfg['target']:
				self.filesToBackup = cfg['target']['data']
			if 'exclude' in cfg['target']:
				self.excludes = cfg['target']['exclude']

		#check if the hashfile path exists
		if (not os.path.exists(self.hashfilePath)):
			#check if the directories of the hashfiles exist. if not create directories
			dirsOnly = self.hashfilePath[:self.hashfilePath.rfind('/')]
			if(not os.path.exists(dirsOnly)):
				os.makedirs(dirsOnly)
				printBox("Hashfile path does not exist. Creating folders.")


	def _getOldHashes(self):
		hashes = []
		with open(self.hashfilePath,'r') as file:
			hashes = file.read().splitlines()
		return hashes

	def _saveNewHashes(self,hashes):
		if (os.path.isfile(self.hashfilePath)):
			os.remove(self.hashfilePath)
		for path in range(len(self.filesToBackup)):
			with open(self.hashfilePath,'a') as file:
				file.write(hashes[path] + "\n")
				print("Saving Hash: "+hashes[path])
		print("Hashes saved")

	def _getNewHashes(self):
		newHashes = []
		for path in self.filesToBackup:
			newHashes.append(getmd5Hash(path,self.excludes))
		print("New Hashes generated")
		return newHashes

	def _compareHashes(self,oldHashes, newHashes):
		pathsUpdated = []
		for path in range(len(self.filesToBackup)):
			print(oldHashes[path] + " =? " + newHashes[path])
			if(oldHashes[path] == newHashes[path]):
				printOkGreen(self.filesToBackup[path] + ": Aktuell")
			else:
				printWarning(self.filesToBackup[path] + ": Updated")
				pathsUpdated.append(path)
		return pathsUpdated

	def _executeOperations(self,ops):
		printBox("Nothing to Backup")
		if(self.pathsUpdated != []):
			printBox("Starting to Backup")
			print("executing ops\r\n")
			for key in ops:
				print(key + " Operations")
				print("=============================================")
				for op in ops[key]:
					printBox(op)
					subprocess.call([op], shell=True)
					print("\r\n")
				print("\r\n")
			print("\r\n")

	#checks if the apps have been updated and if they have to get backuped
	def checkIfUpdated(self):
		printOkGreen(self.configPath + ":")
		print("--------------------------")
		# check if backup is needed
		if (os.path.isfile(self.hashfilePath)):
			printOkBlue("Hash exists")
			oldHashes = self._getOldHashes()
			print("Comparing with new hashes")
			newHashes = self._getNewHashes()
			self._saveNewHashes(newHashes)
			self.pathsUpdated = self._compareHashes(oldHashes,newHashes)
			#subprocess.check_call(["../Slack/postToSlack.sh","Backuper: " + self.configPath,"Es gab seit dem letzten Backup Änderungen an " + path])

		else:
			 printWarning("no hash file found")
			 print("Generating new Hash. Backup needed...")
			 hashes = self._getNewHashes()
			 self._saveNewHashes(hashes)
			 self.pathsUpdated = self.filesToBackup
			 #subprocess.check_call(["../Slack/postToSlack.sh","Backuper: " + self.configPath,"Bisher wurde kein Backup erstellt"])
		for path in self.pathsUpdated:
		   print(path + " has to be backuped")
		print("\r\n")

	def backup(self):
		self.checkIfUpdated()
		self._executeOperations(self.operations)

	# Returns configs. called like Backuper.getConfigFiles (kind of static method)
	def getConfigFiles():
		print("Getting Config Files:")
		print("---------------------")
		dir = os.listdir('.') # Config files in same dir as script
		confFiles = []
		for file in dir:
			found = file.find(".yaml") # every yaml file is interpreted as config
			if found > 0 :
				confFiles.append(file)
				print(file)
		print("---------------------\r\n")
		return confFiles


# Main Programm
appsToBackup = Backuper.getConfigFiles()
Backupers = []
for appConf in appsToBackup:
	Backupers.append(Backuper(appConf))

for Backuper in Backupers:
	Backuper.backup()
