# Installing and Setting up the DC

1. Use `sconfig` to :
    - Change the hostname
    - Change the IP address from dynamic to Static
    - Change the DNS server to our own IP Address.
    - Enable PS Remoting on the server so that we can connect it with our workstation.

2. Enable the `PS remoting` on the DC.

```shell
Enable-PSRemoting
```

3. Install AD features in DC.

```shell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
```

4. Importing the deployment module that is used to install AD Forest. 

```shell
import-Module ADDSDeployment
```

5. Creating a new Active Directory forest.

```shell
install-ADDSForest
```

6. After the domain is created, it resets our DNS server so we have to reconfigure it.
```shell
Get-NetIPAddress # to check the ip configuration
Get-DNSClientServerAddress # to check the DNS server address and InterfaceIndex of adapter.
```

7. Setting and configuring our DNS server
```shell
Set-DNSClientServerAddress -InterfaceIndex 5 -ServerAddress 192.168.179.155 # use ur own parameters.
```

