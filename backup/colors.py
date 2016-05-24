#colors
HEADER = '\033[95m'
OKBLUE = '\033[94m'
OKGREEN = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
ENDC = '\033[0m'

def disable(self):
	self.HEADER = ''
	self.OKBLUE = ''
	self.OKGREEN = ''
	self.WARNING = ''
	self.FAIL = ''
	self.ENDC = ''

def printOkBlue(string):
	print(OKBLUE + string + ENDC)

def printOkGreen(string):
	print(OKGREEN + string + ENDC)

def printWarning(string):
	print(WARNING + string + ENDC)

def printFail(string):
	print(FAIL + string + ENDC)