#!/bin/bash

###############################
### SSHThief FUNCTIONS
###############################

# INSTALL(): automatically installs relevant applications on user host and creates relevant directories
# ANON(): executes Nipe anonymiser and conducts and anonymity check
# CRACK(): collects user input for VPS address and executes a hydra brute-force attack
# SCP(): access VPS, and secure copy (scp) all the directories and files from the VPS onto the local host

# 1. once executed, automatically install relevant applications
# 2. automatically activate nipe and conduct an anonymity check
# 3. once the check is passed, capture credentials for VPS as input and remotely access VPS
# 4. arrive at menu with alphabetical options
# 5. use alpbetical options to remotely conduct whois query or nmap scan
# 6. return to menu after a whois query or nmapscan for convenience
# 6. generate output reports and have the option to export them to local computer

 
 
 
 
 
### LOCALINSTALL FUNCTION

# let the user know that remote control is starting
echo " "
echo "VPS REMOTE CONTROL is starting..."
echo " "

# define localinstall function
function localinstall()
{
	# let the user know applications are being installed and that some time will be spent waiting
	echo " "
	echo "Installing applications on your local computer..."
	echo " "
	
	# update and install latest APT packages
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get dist-upgrade
	
	# navigate to home directory and create a directory for this script, to contain the output files later on
	cd ~
	mkdir VRC
	cd ~/VRC	
	
	# install figlet for aesthetic purposes
	# make a directory for downloading figlet font
	mkdir figresources
	cd ~/VRC/figresources
	# install cybermedium figlet font; credits: http://www.figlet.org/fontdb_example.cgi?font=cybermedium.flf
	sudo apt-get install figlet
	wget http://www.jave.de/figlet/fonts/details/cybermedium.flf
	
	# install relevant applications for the whois query and nmap scans
	sudo apt-get install whois
	sudo apt-get install nmap
	
	# make a directory to download whois and nmap outputs later
	cd ~/VRC
	mkdir whois-reports
	mkdir nmap-reports
	
	# install xsltproc for converting nmap output to html
	sudo apt-get install -y xsltproc

	# install relevant applications for the vps access
	sudo apt-get install ssh
	sudo apt-get install sshpass
	
	# install relevant applications for anonymity check
	cd ~/VRC
	sudo apt-get install tor
	git clone https://github.com/htrgouvea/nipe.git 
	cd ~/VRC/nipe 
	sudo cpan install Try:Tiny Config::Simple JSON
	sudo perl nipe.pl install
	
	# let the user know applications are installed
	echo " "
	echo "Applications installed and up to date."
	echo "	"
}

# call the localinstall function
localinstall





### ANONCHECK-VPSACCESS FUNCTION

# define anoncheck function
function anoncheck()
{
	# let the user know anonymity check is starting
	echo " "
	echo "Conducting Anonymity Check..."
	echo " "
	
	# navigate to nipe folder
	cd ~/VRC/nipe
	# execute nipe 
	sudo perl nipe.pl start
	#c heck status of nipe
	sudo perl nipe.pl status
	
	# if nipestatus shows "activated", user is anonymous
	nipestatus=$(sudo perl nipe.pl status | grep activated | awk '{print $3}' | awk -F. '{print $1}')
	if [ "$nipestatus" == "activated" ]
	then
		# tell user that he is anonymous
		echo " "
		echo "ANONYMITY CHECK: You are currently anonymous."
		echo " "
		# after anonymity check, call the vpsaccess function
		vpsaccess
	else
		# tell user that he is not anonymous, and exit script
		echo " "
		echo "ANONYMITY CHECK: You are currently not anonymous."
		echo " "
		echo "Error in activating nipe. Exiting now..."
		echo " "
		exit
	fi	
}

# define vpsaccess function that is called within anoncheck function
function vpsaccess()
{
	# capture credentials of VPS 
	echo "Enter IP Address of VPS"
	read vpsip
	echo " "
	echo "Enter Username of VPS"
	read vpsuser
	echo " "
	echo "Enter Password of VPS"
	read vpspass
}

# call the anoncheck function, which also contains the vpsaccess function within
anoncheck





### REMOTEINSTALL FUNCTION

# define remoteinstall function
function remoteinstall()
{
	# let user know he is connected to the VPS
	echo " "
	echo "Connected to VPS."
	echo " "
	# let the user know applications are being installed and that some time will be spent waiting
	echo " "
	echo "Installing applications on VPS..."
	echo " "
	
	# update and install latest APT packages
	sudo apt-get update
	sudo apt-get upgrade
	sudo apt-get dist-upgrade
	
	# navigate to home directory and create a directory for this script, to contain the output files later on
	cd ~
	mkdir VRC
	cd ~/VRC	
	
	# install figlet for aesthetic purposes
	# make a directory for downloading figlet font
	mkdir figresources
	cd ~/VRC/figresources
	
	# install cybermedium figlet font; credits: http://www.figlet.org/fontdb_example.cgi?font=cybermedium.flf
	sudo apt-get install figlet
	wget http://www.jave.de/figlet/fonts/details/cybermedium.flf
	
	# install relevant applications for the whois query and nmap scans
	sudo apt-get install whois
	sudo apt-get install nmap
	
	# make a directory to download whois and nmap outputs later
	cd ~/VRC
	mkdir whois-reports
	mkdir nmap-reports
	
	# install xsltproc for converting nmap output to html
	sudo apt-get install -y xsltproc

	# install relevant applications for the vps access
	sudo apt-get install ssh
	sudo apt-get install sshpass
	
	# let the user know applications are installed
	echo " "
	echo "Applications installed and up to date."
	echo "	"
}

# call the remoteinstall function over ssh to install the applications on the accessed VPS
# declare then call the function within the remote ssh command
# credit: Ushakov Vasilii, last post on https://stackoverflow.com/questions/22107610/shell-script-run-function-from-script-over-ssh
# let the user know that he is connecting to the VPS
echo " "
echo "Connecting to $vpsip..."
echo " "
sshpass -p "$vpspass" ssh "$vpsuser"@"$vpsip" "$(declare -f remoteinstall);remoteinstall" 2> /dev/null





### MENU FUNCTION

# define menu function 
function menu()
{
	# read options for remote control
	read -p "Select an option (A/B/C):
	
	A) Whois Query
	B) Nmap Scan
	C) Export Reports (Exit)
		
	" Options
}

# do a while true loop to return to the menu after an option, until exit
# got this from CFC/ThinkCyber coursebook, Linux Fundamentals, page 49
while true 
do
# display figlet for aesthetics
figlet -c -f ~/VRC/figresources/cybermedium.flf -t "VPS REMOTE CONTROL"
# call menu function
menu

# define remote control options
case $Options in
		
# A. WHOIS QUERY
# conduct a whois query and output to the whois-reports directory 
A) sshpass -p "$vpspass" ssh "$vpsuser"@"$vpsip" "whois $vpsip > ~/VRC/whois-reports/whois-report.txt"
# let user know that the whois query is done
echo " "
echo "Whois query is done."
echo " "
echo "Your report is ready for export."
echo " "
;;
		
# B. NMAP SCAN
# conduct an nmap scan and output to the nmap-reports directory
B) sshpass -p "$vpspass" ssh "$vpsuser"@"$vpsip" "sudo nmap -oX ~/VRC/nmap-reports/nmap-report.xml $vpsip"
# convert to html for readability
sshpass -p "$vpspass" ssh "$vpsuser"@"$vpsip" "xsltproc ~/VRC/nmap-reports/nmap-report.xml -o ~/VRC/nmap-reports/nmap-report.html"
# let user know that the nmap scan is done
echo " "
echo "Nmap scan is done."
echo " "
echo "Your report is ready for export."
echo " "
;;		

# C. EXPORT 
# remotely copy all generated reports onto local computer before exiting
# let user know the above
C) echo " "
echo "Exporting all generated reports from VPS onto local computer..."
echo " "
sshpass -p "$vpspass" scp "$vpsuser"@"$vpsip":~/VRC/whois-reports/whois-report.txt ~/VRC/whois-reports 2> /dev/null
sshpass -p "$vpspass" scp "$vpsuser"@"$vpsip":~/VRC/nmap-reports/nmap-report.html ~/VRC/nmap-reports 2> /dev/null
# let user know that the exporting is done"
echo " "
echo "The latest whois report has been exported to the directory: ~/VRC/whois-reports."
echo " "
echo "The latest nmap report has been exported to the directory: ~/VRC/nmap-reports."
echo " "
exit
;;

esac

done
