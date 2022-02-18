# SimpleIP

PowerShell module: Get info about IP addresses (eg. network address).

## Usage

### Examples

```powershell
#******************************************************************************#
#                                     IPv4                                     #
#******************************************************************************#


############################# Convert-IPv4Address ##############################

# Convert IP address between different formats
# - Quad dot (without mask) eg. "192.168.1.2"
# - Integer (uint32)        eg. 3232235778
# - Binary (32 long string) eg. "11000000101010000000000100000010"
Convert-IPv4Address -IP 192.168.1.2 -Binary               # Returns 11000000101010000000000100000010
Convert-IPv4Address -IP 11000000101010000000000100000010  # Returns 192.168.1.2
3232235778 | Convert-IPv4Address -QuadDot                 # Returns 192.168.1.2
Convert-IPv4Address 192.168.1.2 -Integer                  # Returns 3232235778



############################### Convert-IPv4Mask ###############################

# Convert IP subnet mask between different formats
# - Quad dot                eg. "255.255.128.0"
# - Mask length (0-32)      eg. "17"
# - Mask length with slash  eg. "/17"
# - Integer (uint32)        eg. "4294934528"
# - Binary (32 long string) eg. "11111111111111111000000000000000"
Convert-IPv4Mask -Mask 255.255.128.0  # Returns /17
Convert-IPv4Mask -Mask /17 -Length    # Returns 17
Convert-IPv4Mask -Mask /17            # Returns 255.255.128.0
Convert-IPv4Mask -Mask 17             # Returns 255.255.128.0
Convert-IPv4Mask -Mask 17 -Binary     # Returns 11111111111111111000000000000000



############################### Get-IPv4Address ################################

# Get subnet address in CIDR format for an IP address
Get-IPv4Address -IP 127.0.0.1/8 -Subnet               # Returns 127.0.0.0/24

# Get subnet address with mask in quad dot format
Get-IPv4Address -IP 127.0.0.1/8 -Subnet -WithMask     # Returns 127.0.0.0 255.0.0.0

# Get broadcast address with mask in quad dot format
Get-IPv4Address -IP 127.0.0.1/8 -Broadcast -WithMask  # Returns 127.255.255.255 255.0.0.0

# Get broadcast address without mask
Get-IPv4Address -IP 127.0.0.1/8 -Broadcast -IPOnly    # Returns 127.255.255.255

# Get all available addresses in same net as 10.100.200.201/30 is in
Get-IPv4Address -IP 10.100.200.201 -Mask /30 -All -WithMask  # Returns array...:
# 10.100.200.201 255.255.255.252
# 10.100.200.202 255.255.255.252

# Get different info for 192.168.0.150/25
Get-IPv4Address -IP 192.168.0.150/255.255.255.128 -Info  # Returns object...:
# IP          : 192.168.0.150
# Subnet      : 192.168.0.128
# FirstIP     : 192.168.0.129
# LastIP      : 192.168.0.254
# Broadcast   : 192.168.0.255
# Integer     : @{IP=3232235670; Subnet=3232235648; FirstIP=3232235...
# Binary      : @{IP=11000000101010000000000010010110; Subnet=11000...
# MaskQuadDot : 255.255.255.128
# MaskLength  : 25



################################# Get-IPv4Mask #################################

# Get subnet mask in different formats from IP address (this funtion is just a wrapper for Get-IPv4Address)
Get-IPv4Mask 9.8.7.6/22                     # Returns 255.255.252.0
Get-IPv4Mask 9.8.7.6/22 -LengthWithSlash    # Returns /22
Get-IPv4Mask 9.8.7.6/255.255.252.0 -Length  # Returns 22



################################ Get-IPv4Subnet ################################

# Get subnet in different formats from IP address (this funtion is just a wrapper for Get-IPv4Address)
Get-IPv4Subnet 127.0.0.1/8                                # Returns 127.0.0.0/8
Get-IPv4Subnet -IP 10.20.30.40/28 -WithMask               # Returns 10.20.30.32 255.255.255.240
Get-IPv4Subnet -IP '10.20.30.40 255.255.255.240' -IPOnly  # Returns 10.20.30.32



############################### Test-IPv4Address ###############################

# Test if input is a valid IPv4 address (without subnet mask)
Test-IPv4Address -IP 127.0.0.1                           # Returns True
Test-IPv4Address -IP 127.0.0.256                         # Returns False
Test-IPv4Address -IP 127.0.0.1/32                        # Returns False

# Test if input is a valid IPv4 address - subnet mask is allowed, but not required
Test-IPv4Address -AllowMask -IP 127.0.0.1/32             # Returns True
Test-IPv4Address -AllowMask "127.0.0.1 255.255.255.255"  # Returns True
Test-IPv4Address -AllowMask -IP "127.0.0.1"              # Returns True

# Test if input is a valid IPv4 address - subnet mask is required
Test-IPv4Address -RequireMask -IP 127.0.0.1/32           # Returns True
Test-IPv4Address -RequireMask -IP 127.0.0.1              # Returns False

# Test if input is a valid subnet mask (in quad dot format)
Test-IPv4Address -Mask -IP 255.255.0.0                   # Returns True
Test-IPv4Address -Mask -IP 255.0.255.0                   # Returns False
Test-IPv4Address -Mask -IP 32                            # Returns False

# Test if input is a valid subnet mask (quad dot) or mask length
Test-IPv4Address -Mask -AllowLength -IP 255.0.255.0      # Returns False
Test-IPv4Address -Mask -AllowLength -IP 255.255.0.0      # Returns True
Test-IPv4Address -Mask -AllowLength -IP 32               # Returns True
Test-IPv4Address -Mask -AllowLength -IP /32              # Returns True



########################## Test-IPv4AddressInSameNet ###########################

# Test if two IP addresses is in the same subnet
Test-IPv4AddressInSameNet -IP 10.30.50.60 -IP2 10.30.50.61/24                # Returns True
Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/255.255.255.0  # Returns True
Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/29             # Returns False

# Allow mismatch in subnet mask, as long as hosts with the two IP addresses
# would be able to communicate directly (not routed)
Test-IPv4AddressInSameNet 10.30.50.60/24 10.30.50.61/29 -AllowMaskMismatch   # Returns True



########################### Test-IPv4AddressInSubnet ###########################

# Test if IP address is in a subnet
Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70  # Returns True
Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/24  # Returns True
Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/29  # Returns False

# Ignore mask on IP
Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/29 -AllowMaskMismatch  # Returns True
Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/23 -AllowMaskMismatch  # Returns True
Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.51.70/23 -AllowMaskMismatch  # Returns False



############################### Test-IPv4Subnet ################################

# Test if input is a subnet
Test-IPv4Subnet -Subnet 10.20.30.0/24           # Returns True
Test-IPv4Subnet -Subnet 10.20.30.0/255.255.0.0  # Returns False



#******************************************************************************#
#                                     IPv6                                     #
#******************************************************************************#


############################# Convert-IPv6Address ##############################

# Compact IPv6 address
Convert-IPv6Address 00ab:00:0:000:00:fff::1     # Returns ab::fff:0:1
Convert-IPv6Address 00ab:00:0:000:00:fff::1/64  # Returns ab::fff:0:1/64

# Get different info about an IPv6 address
Convert-IPv6Address -IP a:b:c::/64 -Info  # Returns object...:
# IP                      : a:b:c::/64
# IPCompact               : a:b:c::
# IPExpanded              : 000a:000b:000c:0000:0000:0000:0000:0000
# IPIntArray              : {10, 11, 12, 0...}
# IPHexArray              : {a, b, c, 0...}
# IPHexArrayExpanded      : {000a, 000b, 000c, 0000...}
# IPBinary                : 0000000000001010 0000000000001011 0000000000001100 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000
# Cidr                    : a:b:c::/64
# CidrExpanded            : 000a:000b:000c:0000:0000:0000:0000:0000/64
# Prefix                  : 64
# PrefixIntArray          : {65535, 65535, 65535, 65535...}
# PrefixHexArray          : {ffff, ffff, ffff, ffff...}
# PrefixHexArrayExpanded  : {ffff, ffff, ffff, ffff...}
# PrefixHexString         : ffff:ffff:ffff:ffff:0:0:0:0
# PrefixHexStringExpanded : ffff:ffff:ffff:ffff:0000:0000:0000:0000
# PrefixBinary            : 1111111111111111 1111111111111111 1111111111111111 1111111111111111 0000000000000000 0000000000000000 0000000000000000 0000000000000000



############################### Get-IPv6Address ################################

# Get subnet
Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet          # Returns 7:6:5::/64

# Get subnet without prefix
Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet -IPOnly  # Returns 7:6:5::

# Get IP without prefix
Get-IPv6Address -IP 007:6:5::77:88/64 -IPOnly          # Returns 7:6:5::77:88

# Get different info for 7:6:5::77:88/64
Get-IPv6Address -IP 007:6:5::77:88/64 -Info  # Returns object...:
# IP            : 7:6:5::77:88/64
# Subnet        : 7:6:5::/64
# FirstIP       : 7:6:5::/64
# SecondIP      : 7:6:5::1/64
# PenultimateIP : 7:6:5::ffff:ffff:ffff:fffe/64
# LastIP        : 7:6:5::ffff:ffff:ffff:ffff/64
# Prefix        : 64
# Objects       : @{IP=; Subnet=; FirstIP=; SecondIP=; PenultimateIP=; LastIP=}


################################ Get-IPv6Subnet ################################

# Get subnet in different formats from IP address (this funtion is just a wrapper for Get-IPv6Address)
Get-IPv6Subnet -IP 0007:006:05::077:0088/64          # Returns 7:6:5::/64
Get-IPv6Subnet -IP 0007:006:05::077:0088/64 -IPOnly  # Returns 7:6:5::



############################### Test-IPv6Address ###############################

# Test if input is a valid IPv6 address (without prefix)
Test-IPv6Address -IP a:b::c                    # Returns True
Test-IPv6Address -IP a:b::c/64                 # Returns False
Test-IPv6Address -IP a:b::x                    # Returns False
Test-IPv6Address -IP a:b::c/64                 # Returns False

# Test if input is a valid IPv6 address - prefix is allowed, but not required
Test-IPv6Address -AllowPrefix -IP a:b::c/64    # Returns True
Test-IPv6Address -AllowPrefix -IP a:b::c       # Returns True
Test-IPv6Address -AllowPrefix -IP a:b::x/64    # Returns False

# Test if input is a valid IPv6 address - prefix is required
Test-IPv6Address -RequirePrefix -IP a:b::c/64  # Returns True
Test-IPv6Address -RequirePrefix -IP a:b::c     # Returns False



########################## Test-IPv4AddressInSameNet ###########################

# Test if two IP addresses is in the same subnet
Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/31  # Returns True
Test-IPv6AddressInSameNet -IP a:2::/32 -IP2 a:3::/32  # Returns False
Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/30  # Returns False

# Allow mismatch in prefix, as long as hosts with the two IP addresses
# would be able to communicate directly (not routed)
Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/32 -AllowPrefixMismatch  # Returns False
Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/30 -AllowPrefixMismatch  # Returns True



########################### Test-IPv6AddressInSubnet ###########################

# Test if IP address is in a subnet
Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/31  # Returns True
Test-IPv6AddressInSubnet -Subnet a:2::/32 -IP a:3::/32  # Returns False
Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/30  # Returns False

# Ignore mask on IP
Test-IPv6AddressInSubnet -Subnet a:2::/32 -IP a:3::/31 -AllowPrefixMismatch  # Returns False
Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/32 -AllowPrefixMismatch  # Returns True



############################### Test-IPv6Subnet ################################

# Test if input is a subnet
Test-IPv6Subnet -Subnet a:0:0:b::/64    # Returns True
Test-IPv6Subnet -Subnet a:0:0:0:b::/64  # Returns False

```

Examples are also found in [EXAMPLES.ps1](EXAMPLES.ps1).

### Functions

See [FUNCTIONS.md](FUNCTIONS.md) for documentation of functions in this module.

## Install

### Install module from PowerShell Gallery

```powershell
Install-Module SimpleIP
```

### Install module from source

```powershell
git clone https://github.com/thordreier/SimpleIP.git
cd SimpleIP
git pull
.\Build.ps1 -InstallModule
```
