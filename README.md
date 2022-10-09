# SSHBurglar

This is a penetration testing program, written in bash script for Linux, to anonymously brute-force and access a weakly-protected Virtual Private Server, via Secure Shell (SSH) protocol. This will only work against a weakly-protected linux VPS.

The brute-force attack will take a long time. If you just want to test if this program works, set your user and password as "kali" for the target host

## MODULES

INSTALL(): automatically installs relevant applications on user host and creates relevant directories

CONSOLE(): collects user input for the target IP address to breach

ANON(): executes nipe anonymiser and conducts an anonymity check

SSHBREACH(): collects user input for VPS address, executes a hydra brute-force attack and accesses the vps

## EXECUTION

Execute SSHBurglar.sh with bash to start the script.

    $ bash SSHBurglar.sh

## INSTALL()

The user will be asked to either install relevant applications or skip to the console. if applications are already installed previously.

![image](https://user-images.githubusercontent.com/103941010/194731113-ea328add-8707-431a-8587-d70516485acd.png)

## CONSOLE()

After installation or skipping installation, the user will arrive at a console for the user to key in the target IP address.

![image](https://user-images.githubusercontent.com/103941010/194731135-a5677388-f2ca-4395-8192-476dec7e5435.png)

![image](https://user-images.githubusercontent.com/103941010/194731197-b0cb4180-d78f-4245-8f2c-ae8ff0d476f5.png)

## ANON(): The program will automatically execute Nipe to anonymise network traffic and conduct an anonymity test.

If the anonymiser succeeds, the user will be connecting to the VPS via a TOR-routed IP

![image](https://user-images.githubusercontent.com/103941010/194731208-4e5fe4c9-7d99-44d9-9e5d-1e43fa3e4601.png)

If the anonymiser fails to work (likely due to your network), then the program will exit.

![image](https://user-images.githubusercontent.com/103941010/194731160-b3a471f2-12b9-4a7c-82e6-733f479cf4d6.png)

## SSH_BREACH(): After passing the anonymity test, the program will execute a brute-force attack with Hydra, via the SSH protocol on the VPS.

If the attack succeeds, the cracked users will be displayed, and the program will ask for the preferred user and password the user wants to use.

![image](https://user-images.githubusercontent.com/103941010/194731274-a5e22581-5120-4be1-803b-e3b04e1b49df.png)

After the user selects the preferred credentials, the user will access the server, anonymously.

![image](https://user-images.githubusercontent.com/103941010/194731310-0c04231b-e4c1-4000-98c4-deb7ed756f1c.png)

