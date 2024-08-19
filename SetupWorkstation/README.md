# Setting up the Windows 11 box 

1. Downloaded the `iso` file from the microsoft.
2. Setting all the required parameters in VMware Workstation
3. Opening up the win11 iso in VMware workstation.
4. Now since both DC and workstation are ready to go, we can remotely connect them.
5. Steps to connect them remotely, make sure PS remoting is enabled on DC.
    - Starting up the `Win RM` service.
    ```shell
    Start-Service WinRM
    ```
    - Now setting ap the value for the trusted hosts.
    ```shell
    Set-Item WSMAN:\localhost\Client\TrustedHosts -value 192.168.179.138
    ```
    - Connecting to the session of DC.
    ```shell
    Enter-PSSession `id` `computer-name`
    ```
    - Successfully connected to DC.