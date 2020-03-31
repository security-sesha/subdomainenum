#!/bin/bash
# This script enumerate the directories on the server
# Steps:
# 1. This script first look for the subdomains with assetfinder tool developed by tomnomnom.
# 2. It looks for the http(s) with httprobe tool
# 3. It start looking for files/directories on the portal
# 

red=$'\e[1;31m'
green=$'\e[1;32m'
blue=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
white=$'\e[0m'

printf "$green\n*********** Enter the Domain below (xyz.com)  ************\n$white"
read domain

printf "$green\n***********  Finding subdomains  ************\n$white"
assetfinder -subs-only $domain > subdomains.txt
printf "$white\nSubdomains saved to file: subdomains.txt\n$white"

printf "$green\n*********** Finding http or https responses with httprobe ************\n$white"

cat subdomains.txt | httprobe | tee hosts

# run gobuster on the hosts. 

printf "$red\n\n*********** Using Meg tool to look for details  ************\n$white"

meg -d 1000 / 

printf "Done"