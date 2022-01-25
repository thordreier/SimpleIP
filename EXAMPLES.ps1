######## IPv4



#### Convert-IPv4Address

# Convert IP address between different formats
# - Quad dot (without mask) eg. "192.168.1.2"
# - Integer (uint32)        eg. 3232235778
# - Binary (32 long string) eg. "11000000101010000000000100000010"
Convert-IPv4Address -IP 192.168.1.2 -Binary               # Returns 11000000101010000000000100000010
Convert-IPv4Address -IP 11000000101010000000000100000010  # Returns 192.168.1.2
3232235778 | Convert-IPv4Address -QuadDot                 # Returns 192.168.1.2
Convert-IPv4Address 192.168.1.2 -Integer                  # Returns 3232235778



#### Convert-IPv4Mask

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



#### Get-IPv4Address

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
# MaskQuadDot : 255.255.255.128
# MaskLength  : 25



#### Get-IPv4Mask

# Get subnet mask in different formats from IP address (this funtion is just a wrapper for Get-IPv4Address)
Get-IPv4Mask 9.8.7.6/22                     # Returns 255.255.252.0
Get-IPv4Mask 9.8.7.6/22 -LengthWithSlash    # Returns /22
Get-IPv4Mask 9.8.7.6/255.255.252.0 -Length  # Returns 22



#### Get-IPv4Subnet

# Get subnet in different formats from IP address (this funtion is just a wrapper for Get-IPv4Address)
Get-IPv4Subnet 127.0.0.1/8                                # Returns 127.0.0.0/8
Get-IPv4Subnet -IP 10.20.30.40/28 -WithMask               # Returns 10.20.30.32 255.255.255.240
Get-IPv4Subnet -IP '10.20.30.40 255.255.255.240' -IPOnly  # Returns 10.20.30.32



#### Test-ValidIPv4

# Test if input is a valid IPv4 address
Test-ValidIPv4 -IP 127.0.0.1     # Returns True
Test-ValidIPv4 -IP 127.0.0.256   # Returns False
Test-ValidIPv4 -IP 127.0.0.1/32  # Returns False

# Test if input is a valid IPv4 address - subnet mask is allowed, but not required
Test-ValidIPv4 -AllowMask -IP 127.0.0.1/32                 # Returns True
Test-ValidIPv4 -AllowMask -IP "127.0.0.1 255.255.255.255"  # Returns True
Test-ValidIPv4 -AllowMask -IP "127.0.0.1"                  # Returns True

# Test if input is a valid IPv4 address - subnet mask is required
Test-ValidIPv4 -RequireMask -IP 127.0.0.1/32  # Returns True
Test-ValidIPv4 -RequireMask -IP 127.0.0.1     # Returns False

# Test if input is a valid subnet mask (in quad dot format)
Test-ValidIPv4 -Mask -IP 255.255.0.0  # Returns True
Test-ValidIPv4 -Mask -IP 255.0.255.0  # Returns False
Test-ValidIPv4 -Mask -IP 32           # Returns False

# Test if input is a valid subnet mask (quad dot) or mask length
Test-ValidIPv4 -Mask -AllowLength -IP 255.0.255.0  # Returns False
Test-ValidIPv4 -Mask -AllowLength -IP 255.255.0.0  # Returns True
Test-ValidIPv4 -Mask -AllowLength -IP 32           # Returns True
Test-ValidIPv4 -Mask -AllowLength -IP /32          # Returns True




######## IPv6



#### Convert-IPv6Address

# Compact IPv6 address
Convert-IPv6Address 00ab:00:0:000:00:fff::1     # Returns ab::fff:0:1
Convert-IPv6Address 00ab:00:0:000:00:fff::1/64  # Returns ab::fff:0:1/64

# Get different info about an IPv6 address
Convert-IPv6Address -IP a:b:c::/64 -Info  # Returns object...:
# IP                     : a:b:c::/64
# IPCompact              : a:b:c::
# IPExpanded             : 000a:000b:000c:0000:0000:0000:0000:0000
# IPIntArray             : {10, 11, 12, 0...}
# IPHexArray             : {a, b, c, 0...}
# IPHexArrayExpanded     : {000a, 000b, 000c, 0000...}
# IPBinary               : 00000000000010100000000000001011000000000000110000000000000000000000000000000000000000000000000000000000000000000000000000000000
# Cidr                   : a:b:c::/64
# Prefix                 : 64
# PrefixIntArray         : {65535, 65535, 65535, 65535...}
# PrefixHexArray         : {ffff, ffff, ffff, ffff...}
# PrefixHexArrayExpanded : {ffff, ffff, ffff, ffff...}
# PrefixBinary           : 11111111111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000



#### Get-IPv6Address

# Get subnet
Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet          # Returns 7:6:5::/64

# Get subnet without prefix
Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet -IPOnly  # Returns 7:6:5::

# Get IP without prefix
Get-IPv6Address -IP 007:6:5::77:88/64 -IPOnly          # Returns 7:6:5::77:88

# Get different info for 7:6:5::77:88/64
Get-IPv6Address -IP 007:6:5::77:88/64 -Info  # Returns object...:
# IP           : 7:6:5::77:88/64
# Subnet       : 7:6:5::/64
# FirstIP4Real : 7:6:5::/64
# FirstIP      : 7:6:5::1/64
# LastIP       : 7:6:5::ffff:ffff:ffff:fffe/64
# LastIP4Real  : 7:6:5::ffff:ffff:ffff:ffff/64



#### Get-IPv6Subnet

# Get subnet in different formats from IP address (this funtion is just a wrapper for Get-IPv6Address)
Get-IPv6Subnet -IP 0007:006:05::077:0088/64          # Returns 7:6:5::/64
Get-IPv6Subnet -IP 0007:006:05::077:0088/64 -IPOnly  # Returns 7:6:5::