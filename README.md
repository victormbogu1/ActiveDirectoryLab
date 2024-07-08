# Creating Active Directory Home Lab With Bulk User Creation
## Description
This project demonstrates the creation of an Active Directory home lab environment using VirtualBox. I set up a Microsoft Server to run Active Directory and configured a Domain Controller to manage a domain. Using a PowerShell script, I generated over 1000 users in Active Directory and logged into these accounts on a client machine connected to the domain for internet access. This lab replicates a business environment setup. The tools required include Microsoft Server 2019 ISO, Windows 10 Enterprise ISO, VirtualBox, and a PowerShell script. Note the installation of the VirtualBox and client machine won't be desplayed here but i'll leave the download link below.
## Languages and Utilities Used
  + Active Directory
  + PowerShell
  + CMD
## Environments Used
  + VirtualBox
  + Microsoft Server 2019
  + Windows 10 Enterprise
## Links
  + [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  + [Windows 10 ISO](https://www.microsoft.com/de-de/evalcenter/download-windows-10-enterprise/)
  + [Windows Sever 2019](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)
## Program walk-through



[![Untitled-Diagram-drawio-2.png](https://i.postimg.cc/zf2gBJMS/Untitled-Diagram-drawio-2.png)](https://postimg.cc/xkHCpS9c)



A brief explaination of the above diagram
The IP address 172.16.0.1 falls within the range of private IP addresses, specifically within the range 172.16.0.0 to 172.31.255.255. This range is reserved for private use and is not routable on the public internet. Instead, it is typically used within local networks (such as home, office, or enterprise networks) for internal communication as stated previouly this project lab replicates a business environment setup.

A DHCP (Dynamic Host Configuration Protocol) scope is a range of IP addresses that a DHCP server can assign to clients on a network. When a client device (such as a computer, smartphone, or tablet) connects to the network, the DHCP server assigns it an IP address from this range.

The DHCP scope 172.16.0.100-200 in the diagram means the following:
IP Address Range: The DHCP server can assign IP addresses ranging from 172.16.0.100 to 172.16.0.200
Total Addresses Available: There are 101 possible IP addresses within this range (including both endpoints: 172.16.0.100 and 172.16.0.200)
Network Usage: Devices on the network that request an IP address via DHCP will receive one from this pool of addresses. This range is used to dynamically allocate IP addresses to devices on the network
For example, if a new device joins the network and requests an IP address from the DHCP server, the server might assign it 172.16.0.101, and another device might receive 172.16.0.102, and so on, up to 172.16.0.200.

After installing VirtualBox and the extension pack, Windows 10 enterprise was downloaded to serve as the client-server. For the Virtual Machine hosting the Domain Controller, two network adapters are required: a NAT adapter using the host IP address from the home router, and an Internal Network Adapter (intnet) to enable communication between the Domain Controller and other Virtual Machines acting as client machines. Refer to the initial diagram for setup details.

                                            Adapter One (NAT)

[![Screenshot-2024-07-03-211159.png](https://i.postimg.cc/05LNkk0v/Screenshot-2024-07-03-211159.png)](https://postimg.cc/c6BWTNzk)

                                            Adapter Two (Internal Network)

[![Screenshot-2024-07-03-211303.png](https://i.postimg.cc/vmBy7ktX/Screenshot-2024-07-03-211303.png)](https://postimg.cc/v4pCbPj6)


As shown below, the Domain Controller (DC) is running on two renamed networks. Now that I have identified which network adapter is external and which is internal. Renaming the adapters helps me easily identify them, which is crucial for setting up the DC and DHCP. I configure the internal network adapter and assign it the IP address 172.16.0.1, as shown in the diagram above. Since the Domain Controller (DC) serves as the gateway, no default gateway is needed. I set the DNS server IP to the same address since Active Directory will install DNS, using a loopback address for self-ping

[![Screenshot-2024-07-03-233953.png](https://i.postimg.cc/3xrQ7VV7/Screenshot-2024-07-03-233953.png)](https://postimg.cc/8jY0mKTn)



After configuring the network, I installed Active Directory Domain Services

[![Screenshot-2024-07-06-145429.png](https://i.postimg.cc/vTdf6rw7/Screenshot-2024-07-06-145429.png)](https://postimg.cc/dk4LbT1D)


After installing Active Directory Domain Services, the next step is to promote the server to a domain controller, as it doesn't do this automatically

[![Screenshot-2024-07-06-145647.png](https://i.postimg.cc/nc2BC9R7/Screenshot-2024-07-06-145647.png)](https://postimg.cc/zVLVQv1X)

Instead of using the built-in Administrator account, I will create a dedicated domain admin account

[![Screenshot-2024-07-06-145924.png](https://i.postimg.cc/hvrzzNrg/Screenshot-2024-07-06-145924.png)](https://postimg.cc/n9XcNRgw)

I created a domain-specific admin account, but it initially lacks admin privileges. To resolve this, I promote the new account to Administrator in Active Directory. Afterward, I log out of the built-in Administrator account and log in using the newly created domain admin account

[![Screenshot-2024-07-06-162115.png](https://i.postimg.cc/5yxjVnMr/Screenshot-2024-07-06-162115.png)](https://postimg.cc/YGstNN0N)

Next I need to install and configure RAS/NAT to allow my Windows 10 client computer to access the internet through the internal network via the Domain Controller.

[![Screenshot-2024-07-06-150208.png](https://i.postimg.cc/sDxD4Bf5/Screenshot-2024-07-06-150208.png)](https://postimg.cc/Tp86R3DP)


Now that the role features are installed, I need to configure Routing and Remote Access

[![Screenshot-2024-07-06-150548.png](https://i.postimg.cc/dthwTznB/Screenshot-2024-07-06-150548.png)](https://postimg.cc/VdP3xZxr)

Now that Remote Access is installed and configured, it’s time to install a DHCP Server. This will enable our Windows 10 clients to be assigned IP addresses and allow them to browse the internet

[![Screenshot-2024-07-06-150915.png](https://i.postimg.cc/fLWhWFJY/Screenshot-2024-07-06-150915.png)](https://postimg.cc/zLQQ0xwf)

To configure the DHCP and set up a scope, these steps:
Create a DHCP Scope: The purpose of DHCP is to automatically assign IP addresses to computers on the network. I will create a scope that assigns IP addresses in the range of 172.16.0.100-200, allowing DHCP to distribute up to 100 IP addresses.

Set Lease Duration: I will set the lease duration to 8 days. This duration is important because, once an IP address is assigned, it cannot be used by other devices until the lease expires. For example, in a café offering WiFi where the average stay is 3 hours, an 8-day lease would be inefficient. Instead, a lease duration of under 4 hours would be more appropriate, along with a larger IP range. However, since this is a virtual machine setup, the lease duration is less critical.

[![Screenshot-2024-07-06-151240.png](https://i.postimg.cc/3J0Qw2Jf/Screenshot-2024-07-06-151240.png)](https://postimg.cc/crWb9g3f)

To download my PowerShell script from the internet, I need web browsing enabled, which requires disabling security features on the Domain Controller. While I'd never consider this in a real production environment due to the associated security risks, it's not a concern in this lab setting. I could still browse the internet without disabling these features, but it would generate frequent warnings for every webpage visited, which is quite annoying. To view the full code, please refer to the top of this repository. The script is located under CREATE_USERS.ps1 and I gave brief explaination of this script

[![Screenshot-2024-07-04-205249.png](https://i.postimg.cc/QtdRZTyb/Screenshot-2024-07-04-205249.png)](https://postimg.cc/sBbnpvyQ)


Now that Active Directory and my Domain Controller are configured, including the downloaded user account information, I will use a PowerShell script to create over 1000 user accounts to domain system. During this process, I'll need to set the execution policy to "Unrestricted" to allow adding this many users into the domain system.

[![Screenshot-2024-07-06-155414.png](https://i.postimg.cc/SsXbz9fK/Screenshot-2024-07-06-155414.png)](https://postimg.cc/mzG5vtqx)


Below are the details for the 1000 user accounts derived from the PowerShell script and it's path is located on the desktop


[![Screenshot-2024-07-04-210110.png](https://i.postimg.cc/VLzKNVPk/Screenshot-2024-07-04-210110.png)](https://postimg.cc/vDSrqXmJ)


The PowerShell script has run successfully, and the output confirming the creation of user accounts looks impressive

[![Screenshot-2024-07-04-212914.png](https://i.postimg.cc/LsbrRXFF/Screenshot-2024-07-04-212914.png)](https://postimg.cc/v15PtGm0)

I verify whether the user accounts are within the AD domain.

[![Screenshot-2024-07-06-153217.png](https://i.postimg.cc/9FwzjR3C/Screenshot-2024-07-06-153217.png)](https://postimg.cc/RN9v70VD)


Now, it's time to utilize the new Virtual Machine named Clientvic, which serves as the client server to be joined to the domain.

[![Screenshot-2024-07-06-152741.png](https://i.postimg.cc/90pbm8ww/Screenshot-2024-07-06-152741.png)](https://postimg.cc/bSZkLRTq)

Note It uses the internal network

[![Screenshot-2024-07-04-213334.png](https://i.postimg.cc/mr85jrgF/Screenshot-2024-07-04-213334.png)](https://postimg.cc/3y01JYpK)

I noticed that the Clientvicm virtual machine had no network access, likely due to skipping the previous network configuration in RAS or DHCP. However, I identified the issue I forgot to configure the server option in DHCP by associating the IP address 172.16.0.1 which allows the router to assign IP addresses to client machines. As you can see below, there is no associated gateway, preventing network access. To resolve this, I need to revisit the DHCP configuration

[![Screenshot-2024-07-06-152035.png](https://i.postimg.cc/GtcP5FgL/Screenshot-2024-07-06-152035.png)](https://postimg.cc/ph6n9Ft4)

The internal IP of the client machine has been linked with the router to enable network access. This setup helps manage IP addresses efficiently within a local network, ensuring that each device gets a unique IP address without manual configuration

[![Screenshot-2024-07-06-152254.png](https://i.postimg.cc/QdRQ3GYn/Screenshot-2024-07-06-152254.png)](https://postimg.cc/rDN01bkS)

Confirmed that the client can access the network, as shown below with a configured default gateway 

[![Screenshot-2024-07-06-152447.png](https://i.postimg.cc/KjqTpdgf/Screenshot-2024-07-06-152447.png)](https://postimg.cc/JHXtGYxH)

For a final test to ensure the work environment and the bulk users I created are functioning properly, I return to my server VM and check the DHCP to review the number of leased addresses. It's evident that my Clientvic Virtual Machine has been assigned the IP address 172.16.0.100. In a real company environment, this folder would typically show hundreds, if not thousands, of leased addresses, depending on the lease duration set—mine is currently configured for 8 days in this environment

[![Screenshot-2024-07-06-152948.png](https://i.postimg.cc/DZ7bv2r5/Screenshot-2024-07-06-152948.png)](https://postimg.cc/DWYz53Yb)


Here's an alternative method to check the number of computers or devices currently connected to the domain. It's clear that my CLIENT1 computer is correctly identified in Active Directory. In a real-world scenario, this folder would likely contain thousands of devices

[![Screenshot-2024-07-06-153037.png](https://i.postimg.cc/hPNzJ88X/Screenshot-2024-07-06-153037.png)](https://postimg.cc/crM42nbW)

I confirmed that the user account "abargo" created in the AD domain can log in as shown below, and the user can access their machine as a client

[![Screenshot-2024-07-06-153344.png](https://i.postimg.cc/4d3N2nbC/Screenshot-2024-07-06-153344.png)](https://postimg.cc/QBR3H8yS)

Verify the username to confirm if it belongs to one of the users created in the domain

[![Screenshot-2024-07-06-230945.png](https://i.postimg.cc/s2zxF7Zq/Screenshot-2024-07-06-230945.png)](https://postimg.cc/3kLYmy1F)
