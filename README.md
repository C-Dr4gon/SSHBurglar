# SSHRemoteControl
> This is a penetration testing program, written in bash script, to anonymously access a weakly-protected Virtual Private Server, via Secure Shell (SSH) protocol, and copy the entire file system to the local host. . This will only work in a weakly-protected linux VPS.

> The brute-force attack will take a long time. If you just want to test if this program works, set your password and user as "root".

> 1. Execute SSHRemoteControl.sh with bash

    $ bash SSHRemoteControl.sh

>  2. It will automatically install relevant applications, activate anonymity traffic mask and ask for address of the target VPS.

>  3. It will execute a brute-force attack on the VPS, and copy the entire file system of the VPS onto the local host.
