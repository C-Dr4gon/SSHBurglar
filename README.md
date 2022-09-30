# SSHBurglar
> This is a penetration testing program, written in bash script for Linux, to anonymously brute-force and access a weakly-protected Virtual Private Server, via Secure Shell (SSH) protocol. This will only work against a weakly-protected linux VPS.

> CONFIG: The brute-force attack will take a long time. If you just want to test if this program works, set your user and password as "kali".

> 1. Execute SSHRemoteControl.sh with bash

    $ bash SSHRemoteControl.sh

>  2. It will automatically install relevant applications:
<img width="539" alt="start" src="https://user-images.githubusercontent.com/103941010/193277722-77ae9669-8893-4694-8128-36b33c78f866.png">


>  3. It will execute a brute-force attack on the VPS, and copy the entire file system of the VPS onto the local host.
