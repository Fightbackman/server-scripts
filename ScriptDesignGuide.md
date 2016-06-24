# Script Design Guide

## Introduction
This guide aims to give you a simple view of how to write scripts for this Repository.

## Validation/Checking
We prefer if you use the [Shellcheck-Linter](https://github.com/koalaman/shellcheck)
to fit in a mostly compatible way to bash and sh.
You'll find a installation guide for your editor in their repository.

## Script REAMDE.md

If you plan to write a more complex script you'll be free to create a folder for that script and document the functionalities of it with a own README.md.
But PLEASE do this only if it is necessary. A folder for every script makes the whole thing very confusing and bloats the repository up.
## Interpreter
All of our scripts are written to run inside of the bash. So please use the shebang
```
!#/bin/bash
```
## script functionalities
### setup/install scripts
### management/everyday scripts
## variables
### passed variables
#### input validation
### internal variables
## functions
## error handling
## exit codes
## all the other things
### author/credits
