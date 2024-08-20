# Configuring Workstation1 and joining it to domain controller

1. Now to connect this WS1 to the DC, we first add our this computer to the DC. Also make sure that the DNS is configured on the DC because it resets our DC's DNS config after installation of AD Forest.

```shell
Add-Computer -Domainname abc.com -Credential abc/Administrator -Force -Restart
```
