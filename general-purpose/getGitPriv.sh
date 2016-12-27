#!/bin/bash
TOKEN=$1;
OWNER=$2;
REPO=$3;
GITPATH=$4; #example bin/sample.txt
OUTPATH=$5
FILE="https://api.github.com/repos/$OWNER/$REPO/contents/$GITPATH";

curl -o $OUTPATH\
     --header "Authorization: token $TOKEN" \
     --header 'Accept: application/vnd.github.v3.raw' \
     --remote-name \
     --location $FILE ;
