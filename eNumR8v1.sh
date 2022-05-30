#!/bin/bash
echo "---------------------------------"
echo "|                               |"
echo "|          eNumR8 v1.0          |"
echo "|                               |"
echo "---------------------------------"
echo "by fR0z3byte"

#Define Varibles
varDate="$(date +'%m_%d_%Y_%H%M%S')"

#Get Network Address
echo "Please Enter Network Address to Scan: "

read $network

#Get Host IP Address
echo "Please Enter IP Address for Port Scan: "

read $hostIP

#Create directory in /tmp 
#You can copy or move the files to a different directory if you need
mkdir /tmp/eNumR8_${varDate} 


echo "Running Network Scan - Skipping Ping Test ..."
echo "Test Results will be available in /tmp/eNumR8_${varDate}/skip_ping_nmap_basic"
#------------------------------
#SKIP Ping Test
#------------------------------
#Network scan:
#Create directory
mkdir /tmp/eNumR8_${varDate}/skip_ping_nmap_basic
nmap -sn -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_basic/netscan.txt
sleep 3

echo "Running Basic Port Scan - Skipping Ping Test ..."
#Basic Port scan
nmap -sT -sV -n -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_basic/portscan.txt
sleep 3

echo "Running OS Scan - Skipping Ping Test ..."
#OS Scan
nmap -A -O -n -Pn $hostIP--osscan-guess > /tmp/eNumR8_${varDate}/skip_ping_nmap_basic/osscan.txt
sleep 3

echo "Running All Port Scan - Skipping Ping Test ..."
#All Port Scan
nmap -sT -n -p- -Pn $hostIP > /tmp/eNumR8_${varDate}/skip_ping_nmap_basic/allportscan.txt
sleep 3

#------------------------------
#With Ping Test
#------------------------------
#Network scan:
#Create directory
echo "Running Network Scan with Ping Test ..."
echo "Test Results will be available in /tmp/eNumR8_${varDate}/nmap_basic"
mkdir /tmp/eNumR8_${varDate}/nmap_basic
nmap -sn $hostIP > /tmp/eNumR8_${varDate}/nmap_basic/netscan.txt
sleep 3

echo "Running Port Scan with Ping Test ..."
#Basic Port scan
nmap -sT -sV -n $hostIP > /tmp/eNumR8_${varDate}/nmap_basic/portscan.txt
sleep 3

echo "Running OS Scan with Ping Test ..."
#OS Scan
nmap -A -O -n $hostIP --osscan-guess > /tmp/eNumR8_${varDate}/nmap_basic/osscan.txt
sleep 3

echo "Running All Port Scan with Ping Test ..."
#All Port Scan
nmap -sT -n -p- $hostIP > /tmp/eNumR8_${varDate}/nmap_basic/allportscan.txt
sleep 3


#nmap scripts
#DNS Discovery:
#Create directory
echo "Running nmap Scripts ..."
echo "Test Results will be available in /tmp/eNumR8_${varDate}/nmap_script"
mkdir /tmp/eNumR8_${varDate}/nmap_script
echo "DNS - nmap Scripts ..."
nmap -sS -sU -p53 -n $hostIP > /tmp/eNumR8_${varDate}/nmap_script/nse_dns.txt
sleep 3

#Anonymous FTP Discovery:
echo "FTP - nmap Scripts ..."
nmap --script ftp-anon $hostIP > /tmp/eNumR8_${varDate}/nmap_script/nse_ftp.txt
sleep 3

#Heartbleed vulnerability checker:
echo "Heartbleed - nmap Scripts ..."
nmap --script ssl-heartbleed $hostIP > /tmp/eNumR8_${varDate}/nmap_script/nse_heartbleed.txt
sleep 3

#Find the path to WebDAV:
echo "WebDAV - nmap Scripts ..."
nmap -p80 --script http-enum $hostIP > /tmp/eNumR8_${varDate}/nmap_script/nse_webdav.txt
sleep 3




#Web Directory Enumeration:
echo "Running Web Directory Enumeration ..."
echo "Test Results will be available in /tmp/eNumR8_${varDate}/web_dir_enum"
mkdir /tmp/eNumR8_${varDate}/web_dir_enum
gobuster dir --url http://$IP -w /usr/share/dirb/wordlists/common.txt > /tmp/eNumR8_${varDate}/web_dir_enum/common.txt
sleep 3

gobuster dir -u http://$IP -w /usr/share/dirbuster/wordlists/directory-list-2.3-medium.txt > /tmp/eNumR8_${varDate}/web_dir_enum/medium.txt
sleep 3


#SMB Enumeration:
echo "Running SMB Enumeration ..."
echo "Test Results will be available in /tmp/eNumR8_${varDate}/web_dir_enum"
mkdir /tmp/eNumR8_${varDate}/smb_enum
#Identify all supported version of SMB:
nmap -p445 --script smb-protocols $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_protocols.txt
sleep 3

#Find the security level of the SMB protocol:
nmap -p445 --script smb-security-mode $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_sec_mode.txt
sleep 3

#Dump all the present windows users:
nmap -p445 --script smb-enum-users.nse $hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_users.txt
sleep 3

#Test for NBT-NS and LLMNR
python3 /usr/share/responder/tools/RunFinger.py > /tmp/eNumR8_${varDate}/smb_enum/smb_responder.txt
sleep 3

#Check for smb shares
smbclient --no-pass -L //$hostIP > /tmp/eNumR8_${varDate}/smb_enum/smb_shares.txt
sleep 3