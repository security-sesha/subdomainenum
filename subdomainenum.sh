#!/bin/bash
# Steps:
# 1. This script first look for the subdomains with assetfinder tool developed by tomnomnom.
# 2. it look for the IPs with Dig command.
# 3. with host command it extracts the domains.
# 4. extract the hostnames in Dig output near to the CNAME field.
# 5. CURL command will help which sites are up or not. If it's amazon or azure or any other hosting sites. Then subdomain takeover is possible.

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

printf "$green\n*********** Finding IPs with dig command ************$white"
dig $(<subdomains.txt) > digfull.txt ; cat digfull.txt |grep -i cname > cname.txt # use tee if you want output on to the screen

grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' digfull.txt | sort -n | uniq > ips.txt # use tee if you want output on to the screen

printf "\nIPs saved to: ips.txt file"

#host command

printf "$red\n\n***********  Finding IPs with host command for subdomain takeover  ************\n$white"
while read in; do host "$in";done < subdomains.txt > hostcmdips.txt
printf "$green\nhost command output in the file: hostcmdips.txt\n$white"

cat cname.txt

printf "$red***********\nChecking the CNAME values for any subdomain take over chances.....\n************\n$white"
 

printf "$green***********\nExtracting Domain names from the CNAME file.....\n************\n$white"

sed 's/|/ /' cname.txt| awk '{print $1,$5}' | tr ' ' '\n' | sed 's/.$//' > cnamedomains.txt

printf "$blue\nAdding https to the domain names\n$white"
sed -i -e 's/^/https:\/\//' cnamedomains.txt

printf "$red***********\nChecking for https dead URLs.....\n************\n$white"
touch output.txt
rm output.txt
for URL in `cat cnamedomains.txt`; do printf "$URL\n" >> output.txt ; curl -m 10 -s -I $1 "$URL" >> output.txt ; done
printf "\nDone"

 
printf "$blue\nAdding http to the domain names\n$white"
sed -i -e 's/^/http:\/\//' cnamedomains.txt-e
printf "$red***********\nChecking for https dead URLs.....\n************$white"

for URL in `cat cnamedomains.txt-e`; do printf "$URL\n" >> output.txt  ; curl -m 10 -s -I $1 "$URL" >> output.txt ; done
printf "\nDone"

printf "$red\n***********\n\nLook for 404 Page Not found files\n************$white"
cat output.txt | grep "HTTP/1.1 404" -B2
 

printf "$green\n\n\nNow check the cname.txt file to see the exact domain and validate the False positives !!!!!!!"
