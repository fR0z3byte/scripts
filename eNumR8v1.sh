#!/bin/bash
BANNER='\033[0;32m'
NOTIF='\033[1;35m'
NC='\033[0m'

echo -e "${BANNER}---------------------------------"
echo -e "${BANNER}|                               |"
echo -e "${BANNER}|          eNumR8 v1.0          |"
echo -e "${BANNER}|                               |"
echo -e "${BANNER}---------------------------------"
echo -e "${BANNER}by fR0z3byte"

#Define Varibles
varDate="$(date +'%m_%d_%Y_%H%M%S')"

#Get Network Address
echo -e "${NC}Please Enter Network Address to Scan: \c"

read network

#Get Host IP Address
echo -e "${NC}Please Enter IP Address for Port Scan: \c"

read hostIP

#Create directory in /tmp 
#You can copy or move the files to a different directory if you need
mkdir /tmp/eNumR8_${varDate} 


echo -e "${NOTIF}Running Network Scan - Skipping Ping Test ..."
echo -e "${NC}Test Results will be available in /tmp/eNumR8_${varDate}/skip_ping_nmap_scan"
#------------------------------
#SKIP Ping Test
#------------------------------
#Network scan:
#Create directory
mkdir /tmp/eNumR8_${varDate}/skip_ping_nmap_scan
nmap -sn -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/netscan.txt &
sleep 10

echo -e "${NOTIF}Running Basic Port Scan - Skipping Ping Test ..."
#Basic Port scan
nmap -sT -sV -n -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/portscan.txt &
sleep 10

echo -e "${NOTIF}Running OS Scan - Skipping Ping Test ..."
#OS Scan
nmap -A -O -n -Pn $hostIP --osscan-guess > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/osscan.txt &
sleep 10

echo -e "${NOTIF}Running All Port Scan - Skipping Ping Test ..."
#All Port Scan
nmap -sT -n -p- -Pn $hostIP -T4 > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/allportscan.txt &
sleep 10

#nmap scripts
#DNS Discovery:
#Create directory
echo -e "${NOTIF}Running nmap Scripts ..."

echo -e "${NOTIF}Running DNS - nmap Scripts ..."
nmap -sS -sU -p53 -n -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/nse_dns.txt &
sleep 10

#Anonymous FTP Discovery:
echo -e "${NOTIF}Running FTP - nmap Scripts ..."
nmap --script ftp-anon -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/nse_ftp.txt &
sleep 10

#Heartbleed vulnerability checker:
echo -e "${NOTIF}Running Heartbleed - nmap Scripts ..."
nmap --script ssl-heartbleed -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/nse_heartbleed.txt &
sleep 10

#SNMP Discovery:
echo -e "${NOTIF}Running SNMP - nmap Scripts ..."
nmap -sU -p 161 --script snmp-* -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/nse_snmp.txt &
sleep 10

#Find the path to WebDAV:
echo -e "${NOTIF}Running WebDAV - nmap Scripts ..."
nmap -p80 --script http-enum -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_scan/nse_webdav.txt &
sleep 10



#------------------------------
#With Ping Test
#------------------------------
#Network scan:
#Create directory
echo -e "${NOTIF}Running Network Scan with Ping Test ..."
echo -e "${NC}Test Results will be available in /tmp/eNumR8_${varDate}/nmap_scan"
mkdir /tmp/eNumR8_${varDate}/nmap_scan
nmap -sn $hostIP > /tmp/eNumR8_${varDate}/nmap_scan/netscan.txt &
sleep 10

echo -e "${NOTIF}Running Port Scan with Ping Test ..."
#Basic Port scan
nmap -sT -sV -n $hostIP > /tmp/eNumR8_${varDate}/nmap_scan/portscan.txt &
sleep 10

echo -e "${NOTIF}Running OS Scan with Ping Test ..."
#OS Scan
nmap -A -O -n $hostIP --osscan-guess > /tmp/eNumR8_${varDate}/nmap_scan/osscan.txt &
sleep 10

echo -e "${NOTIF}Running All Port Scan with Ping Test ..."
#All Port Scan
nmap -sT -n -p- $hostIP -T4 > /tmp/eNumR8_${varDate}/nmap_scan/allportscan.txt &
sleep 10

echo -e "${NOTIF}Running nmap Scripts ..."

echo -e "${NOTIF}Running DNS - nmap Scripts ..."
nmap -sS -sU -p53 -n $hostIP > /tmp/eNumR8_${varDate}/nmap_scan/nse_dns.txt &
sleep 10

#Anonymous FTP Discovery:
echo -e "${NOTIF}Running FTP - nmap Scripts ..."
nmap --script ftp-anon $hostIP > /tmp/eNumR8_${varDate}/nmap_scan/nse_ftp.txt &
sleep 10

#Heartbleed vulnerability checker:
echo -e "${NOTIF}Running Heartbleed - nmap Scripts ..."
nmap --script ssl-heartbleed $hostIP > /tmp/eNumR8_${varDate}/nmap_scan/nse_heartbleed.txt &
sleep 10

#SNMP Discovery:
echo -e "${NOTIF}Running SNMP - nmap Scripts ..."
nmap -sU -p 161 --script snmp-* $hostIP > /tmp/eNumR8_${varDate}/nmap_scan/nse_snmp.txt &
sleep 10

#Find the path to WebDAV:
echo -e "${NOTIF}Running WebDAV - nmap Scripts ..."
nmap -p80 --script http-enum $hostIP > /tmp/eNumR8_${varDate}/nmap_scan/nse_webdav.txt &
sleep 10





#Web Directory Enumeration:
echo -e "${NOTIF}Running Web Directory Enumeration ..."
echo -e "${NC}Test Results will be available in /tmp/eNumR8_${varDate}/web_dir_enum"
mkdir /tmp/eNumR8_${varDate}/web_dir_enum
gobuster dir --url http://$hostIP -w /usr/share/dirb/wordlists/common.txt -x php,txt,html,py,css -q > /tmp/eNumR8_${varDate}/web_dir_enum/common.txt &
sleep 60

gobuster dir -u http://$hostIP -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt -x php,txt,html,py,css -q > /tmp/eNumR8_${varDate}/web_dir_enum/medium.txt &
sleep 60


#SMB Enumeration:
echo -e "${NOTIF}Running SMB Enumeration ..."
echo -e "${NC}Test Results will be available in /tmp/eNumR8_${varDate}/web_dir_enum"
mkdir /tmp/eNumR8_${varDate}/smb_enum
#Identify all supported version of SMB:
nmap -p445 --script smb-protocols $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_protocols.txt &
sleep 10

#Find the security level of the SMB protocol:
nmap -p445 --script smb-security-mode $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_sec_mode.txt &
sleep 10

#Dump all the present windows users:
nmap -p445 --script smb-enum-users.nse $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_users.txt &
sleep 10

#Check for SMB Vulnerabilities:
nmap --script smb-vuln* -p 445 $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_vuln.txt &

#Test for NBT-NS and LLMNR
python3 /usr/share/responder/tools/RunFinger.py -i $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_responder.txt &
sleep 10

#Check for smb shares
smbclient --no-pass -L //$hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_shares.txt &
sleep 10

#Wordpress Enumeration
mkdir /tmp/eNumR8_${varDate}/wordpress_enum
nmap --script http-wordpress-enum $hostIP > /tmp/eNumR8_${varDate}/wordpress_enum/wordpress_enum.txt &
nmap --script http-wordpress-brute $hostIP > /tmp/eNumR8_${varDate}/wordpress_enum/wordpress_brute.txt &
nmap --script http-wordpress-enum $hostIP > /tmp/eNumR8_${varDate}/wordpress_enum/wordpress_users.txt &

echo -e "${BANNER}Enumeration Completed!! Please wait for the other results to complete."

exit 1
