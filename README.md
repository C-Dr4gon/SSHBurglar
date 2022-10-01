# SSHBurglar
> This is a penetration testing program, written in bash script for Linux, to anonymously brute-force and access a weakly-protected Virtual Private Server, via Secure Shell (SSH) protocol. This will only work against a weakly-protected linux VPS.

> CONFIG: The brute-force attack will take a long time. If you just want to test if this program works, set your user and password as "kali".

> 1. INITIATION: Execute SSHBurglar.sh with bash to start the script.

    $ bash SSHBurglar.sh

> 2. INSTALL(): The program will automatically install relevant applications.




> 3. ANON(): The program will automatically execute Nipe to anonymise network traffic and conduct an anonymity test.



> 4. SSHCRACK(): Once anonymised, the program will ask the user for the IP address of the target VPS, and execute a brute-force attack with Hydra, via SSH. The cracked users will be displayed, and the program will ask for the preferred user and password the user wants to use.


> 5. ACCESS: The user now has access to the VPS via SSH.
