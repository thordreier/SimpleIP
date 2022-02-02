# SimpleIP

Text in this document is automatically created - don't change it manually

## Index

[Convert-IPv4Address](#Convert-IPv4Address)<br>
[Convert-IPv4Mask](#Convert-IPv4Mask)<br>
[Convert-IPv6Address](#Convert-IPv6Address)<br>
[Get-IPv4Address](#Get-IPv4Address)<br>
[Get-IPv4Mask](#Get-IPv4Mask)<br>
[Get-IPv4Subnet](#Get-IPv4Subnet)<br>
[Get-IPv6Address](#Get-IPv6Address)<br>
[Get-IPv6Subnet](#Get-IPv6Subnet)<br>
[Test-IPv4Address](#Test-IPv4Address)<br>
[Test-IPv4AddressInSameNet](#Test-IPv4AddressInSameNet)<br>
[Test-IPv4AddressInSubnet](#Test-IPv4AddressInSubnet)<br>
[Test-IPv4AddressIsPrivate](#Test-IPv4AddressIsPrivate)<br>
[Test-IPv4Subnet](#Test-IPv4Subnet)<br>
[Test-IPv6Address](#Test-IPv6Address)<br>
[Test-IPv6AddressInSameNet](#Test-IPv6AddressInSameNet)<br>
[Test-IPv6AddressInSubnet](#Test-IPv6AddressInSubnet)<br>
[Test-IPv6Subnet](#Test-IPv6Subnet)<br>

## Functions

<a name="Convert-IPv4Address"></a>
### Convert-IPv4Address

```

NAME
    Convert-IPv4Address
    
SYNOPSIS
    Convert IP address between different formats
    
    
SYNTAX
    Convert-IPv4Address [-IP] <String> [-QuadDot] [<CommonParameters>]
    
    Convert-IPv4Address [-IP] <String> -Integer [<CommonParameters>]
    
    Convert-IPv4Address [-IP] <String> -Binary [<CommonParameters>]
    
    
DESCRIPTION
    Convert IP address between different formats
    - Quad dot (without mask) eg. "192.168.1.2"
    - Integer (uint32)        eg. 3232235778
    - Binary (32 long string) eg. "11000000101010000000000100000010"
    

PARAMETERS
    -IP <String>
        Input IP is either:
        - Quad dot (without mask) eg. "192.168.1.2"
        - Integer (uint32)        eg. 3232235778
        - Binary (32 long string) eg. "11000000101010000000000100000010"
        
    -QuadDot [<SwitchParameter>]
        Output in quad dot format, eg. "192.168.1.2"
        This is default output
        
    -Integer [<SwitchParameter>]
        Output integer (uint32), eg 3232235778
        
    -Binary [<SwitchParameter>]
        Output in binary (32 long string), eg. "11000000101010000000000100000010"
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Convert-IPv4Address -IP 192.168.1.2 -Integer
    
    3232235778
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Convert-IPv4Address -IP 192.168.1.2 -Binary
    
    11000000101010000000000100000010
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Convert-IPv4Address -IP 11000000101010000000000100000010 -QuadDot
    
    192.168.1.2
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>3232235778 | Convert-IPv4Address
    
    192.168.1.2
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Convert-IPv4Address 192.168.1.2 -Integer
    
    3232235778
    
    
    
    
REMARKS
    To see the examples, type: "get-help Convert-IPv4Address -examples".
    For more information, type: "get-help Convert-IPv4Address -detailed".
    For technical information, type: "get-help Convert-IPv4Address -full".

```

<a name="Convert-IPv4Mask"></a>
### Convert-IPv4Mask

```
NAME
    Convert-IPv4Mask
    
SYNOPSIS
    Convert IP subnet mask between different formats
    
    
SYNTAX
    Convert-IPv4Mask [-Mask] <String> [<CommonParameters>]
    
    Convert-IPv4Mask [-Mask] <String> -QuadDot [<CommonParameters>]
    
    Convert-IPv4Mask [-Mask] <String> -Length [<CommonParameters>]
    
    Convert-IPv4Mask [-Mask] <String> -LengthWithSlash [<CommonParameters>]
    
    Convert-IPv4Mask [-Mask] <String> -Integer [<CommonParameters>]
    
    Convert-IPv4Mask [-Mask] <String> -Binary [<CommonParameters>]
    
    
DESCRIPTION
    Convert IP subnet mask between different formats
    - Quad dot                eg. "255.255.128.0"
    - Mask length (0-32)      eg. "17"
    - Mask length with slash  eg. "/17"
    - Integer (uint32)        eg. "4294934528"
    - Binary (32 long string) eg. "11111111111111111000000000000000"
    
    If input is in quad dot format ("255.0.0.0"), output defaults to mask length with a leading slash ("/8")
    - else output defaults to quad dot format
    Output can be forced to be in specific format with switches
    

PARAMETERS
    -Mask <String>
        Input subnet mask is either:
        - Quad dot                eg. "255.255.128.0"
        - Mask length (0-32)      eg. "17"
        - Mask length with slash  eg. "/17"
        - Integer (uint32)        eg. "4294934528"
        - Binary (32 long string) eg. "11111111111111111000000000000000"
        
    -QuadDot [<SwitchParameter>]
        Output in quad dot format, eg. "255.255.128.0"
        
    -Length [<SwitchParameter>]
        Output is in mask length, eg "17"
        
    -LengthWithSlash [<SwitchParameter>]
        Output is in mask length with leading slash, eg "/17"
        
    -Integer [<SwitchParameter>]
        Output integer (uint32), eg 4294934528
        
    -Binary [<SwitchParameter>]
        Output in binary (32 long string), eg. "11111111111111111000000000000000"
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Convert-IPv4Mask -Mask 255.255.128.0
    
    /17
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Convert-IPv4Mask -Mask /17 -Length
    
    17
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Convert-IPv4Mask -Mask /17
    
    255.255.128.0
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Convert-IPv4Mask -Mask 17
    
    255.255.128.0
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Convert-IPv4Mask -Mask 17 -Binary
    
    11111111111111111000000000000000
    
    
    
    
REMARKS
    To see the examples, type: "get-help Convert-IPv4Mask -examples".
    For more information, type: "get-help Convert-IPv4Mask -detailed".
    For technical information, type: "get-help Convert-IPv4Mask -full".

```

<a name="Convert-IPv6Address"></a>
### Convert-IPv6Address

```
NAME
    Convert-IPv6Address
    
SYNOPSIS
    Convert IPv6 address between formats
    
    
SYNTAX
    Convert-IPv6Address [-IP] <Object> [-Prefix <Nullable`1>] [<CommonParameters>]
    
    Convert-IPv6Address [-IP] <Object> [-Prefix <Nullable`1>] -Info [<CommonParameters>]
    
    
DESCRIPTION
    Convert IPv6 address between formats
    Also compress/compact IPv6 address.
    (IPv6 addresses can be hard to compare ("0::1" -eq "::1"),
    but they are run throug this command, they can be compared)
    Output defaults to compacted IPv6 address (eg. "::1")
    

PARAMETERS
    -IP <Object>
        Input IP is either
        - Standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")
        - [uint16[]] array with  8 elements
        - Binary (string containinging 128 "0" or "1" - spaces are allowed)
        
    -Prefix <Nullable`1>
        If prefix is not set in IP address, it must be set with this parameter
        
    -Info [<SwitchParameter>]
        Output object with IP and prefix in different formats
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Convert-IPv6Address 00ab:00:0:000:00:fff::1
    
    ab::fff:0:1
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Convert-IPv6Address 00ab:00:0:000:00:fff::1/64
    
    ab::fff:0:1/64
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Convert-IPv6Address -IP a:b:c::/64 -Info
    
    IP                      : a:b:c::/64
    IPCompact               : a:b:c::
    IPExpanded              : 000a:000b:000c:0000:0000:0000:0000:0000
    IPIntArray              : {10, 11, 12, 0...}
    IPHexArray              : {a, b, c, 0...}
    IPHexArrayExpanded      : {000a, 000b, 000c, 0000...}
    IPBinary                : 0000000000001010 0000000000001011 0000000000001100 0000000000000000 0000000000000000 0000000000000000 0000000000000000 0000000000000000
    Cidr                    : a:b:c::/64
    CidrExpanded            : 000a:000b:000c:0000:0000:0000:0000:0000/64
    Prefix                  : 64
    PrefixIntArray          : {65535, 65535, 65535, 65535...}
    PrefixHexArray          : {ffff, ffff, ffff, ffff...}
    PrefixHexArrayExpanded  : {ffff, ffff, ffff, ffff...}
    PrefixHexString         : ffff:ffff:ffff:ffff:0:0:0:0
    PrefixHexStringExpanded : ffff:ffff:ffff:ffff:0000:0000:0000:0000
    PrefixBinary            : 1111111111111111 1111111111111111 1111111111111111 1111111111111111 0000000000000000 0000000000000000 0000000000000000 0000000000000000
    
    
    
    
REMARKS
    To see the examples, type: "get-help Convert-IPv6Address -examples".
    For more information, type: "get-help Convert-IPv6Address -detailed".
    For technical information, type: "get-help Convert-IPv6Address -full".

```

<a name="Get-IPv4Address"></a>
### Get-IPv4Address

```
NAME
    Get-IPv4Address
    
SYNOPSIS
    Get IP subnet, mask, broadcast for an IP address
    
    
SYNTAX
    Get-IPv4Address [-IP] <String> [-Mask <String>] [-SameIP] [-Pool] -IPOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] [-SameIP] [-Pool] -WithMask [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] [-SameIP] [-Pool] [-WithMaskLength] [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Subnet [-Pool] -IPOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Subnet [-Pool] -WithMask [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Subnet [-Pool] [-WithMaskLength] [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Broadcast [-Pool] -IPOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Broadcast [-Pool] -WithMask [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Broadcast [-Pool] [-WithMaskLength] [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -First [-Pool] -IPOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -First [-Pool] -WithMask [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -First [-Pool] [-WithMaskLength] [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Last [-Pool] -IPOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Last [-Pool] -WithMask [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -Last [-Pool] [-WithMaskLength] [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -All [-Pool] -IPOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -All [-Pool] -WithMask [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] -All [-Pool] [-WithMaskLength] [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] [-Pool] -MaskQuadDotOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] [-Pool] -MaskLengthOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] [-Pool] -MaskLengthWithSlashOnly [<CommonParameters>]
    
    Get-IPv4Address [-IP] <String> [-Mask <String>] [-Pool] -Info [<CommonParameters>]
    
    
DESCRIPTION
    Get IP subnet, mask, broadcast for an IP address
    

PARAMETERS
    -IP <String>
        Input IP in quad dot format with subnet mask, either:
        - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.1/8"
        If input is IP without subnet mask (eg. "127.0.0.1") then -Mask parameter must be set
        
    -Mask <String>
        If input IP is in format without subnet mask, this parameter must be set to either
        - Quad dot format,        eg. "255.255.255.0"
        - Mask length (0-32),     eg. "24"
        - Mask length with slash, eg. "/24"
        
    -SameIP [<SwitchParameter>]
        Return same IP as input IP (why? maybe in a different format back)
        If input is "10.11.12.13/24", then "10.11.12.13/24" is returned
        
    -Subnet [<SwitchParameter>]
        Return subnet
        If input is "10.11.12.13/24", then "10.11.12.0/24" is returned
        
    -Broadcast [<SwitchParameter>]
        Return broadcast
        If input is "10.11.12.13/24", then "10.11.12.255/24" is returned
        
    -First [<SwitchParameter>]
        Return first usable IP in subnet
        If input is "10.11.12.13/24", then "10.11.12.1/24" is returned
        
    -Last [<SwitchParameter>]
        Return last usable IP in subnet
        If input is "10.11.12.13/24", then "10.11.12.254/24" is returned
        
    -All [<SwitchParameter>]
        Return all usable IPs in subnet
        If input is "10.11.12.13/24", then an array with IP addresses from "10.11.12.1/24" to "10.11.12.254/24" is returned
        
    -Pool [<SwitchParameter>]
        Treat subnet and broadcast adddresses as usable
        First IP will be same as subnet and last IP will be the same as broadcast
        
    -WithMaskLength [<SwitchParameter>]
        Return in "127.0.0.1/8" format
        This is default output
        
    -WithMask [<SwitchParameter>]
        Return in "127.0.0.1 255.0.0.0" format
        
    -IPOnly [<SwitchParameter>]
        Return in "127.0.0.1" format
        
    -MaskQuadDotOnly [<SwitchParameter>]
        Only return subnet mask in "255.0.0.0" format
        
    -MaskLengthOnly [<SwitchParameter>]
        Only return subnet mask in "8" format
        
    -MaskLengthWithSlashOnly [<SwitchParameter>]
        Only return subnet mask in "/8" format
        
    -Info [<SwitchParameter>]
        Return object with different info
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-IPv4Address -IP 127.0.0.1/8 -Subnet
    
    127.0.0.0/24
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-IPv4Address -IP 127.0.0.1/8 -Subnet -WithMask
    
    127.0.0.0 255.0.0.0
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-IPv4Address -IP 127.0.0.1/8 -Broadcast -WithMask
    
    127.255.255.255 255.0.0.0
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Get-IPv4Address -IP 127.0.0.1/8 -Broadcast -IPOnly
    
    127.255.255.255
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Get-IPv4Address -IP 10.100.200.201 -Mask /30 -All -WithMask
    
    10.100.200.201 255.255.255.252
    10.100.200.202 255.255.255.252
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS C:\>Get-IPv4Address -IP 192.168.0.150/255.255.255.128 -Info
    
    IP          : 192.168.0.150
    Subnet      : 192.168.0.128
    FirstIP     : 192.168.0.129
    LastIP      : 192.168.0.254
    Broadcast   : 192.168.0.255
    Integer     : @{IP=3232235670; Subnet=3232235648; FirstIP=3232235...
    Binary      : @{IP=11000000101010000000000010010110; Subnet=11000...
    MaskQuadDot : 255.255.255.128
    MaskLength  : 25
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-IPv4Address -examples".
    For more information, type: "get-help Get-IPv4Address -detailed".
    For technical information, type: "get-help Get-IPv4Address -full".

```

<a name="Get-IPv4Mask"></a>
### Get-IPv4Mask

```
NAME
    Get-IPv4Mask
    
SYNOPSIS
    Get IP subnet mask for an IP address
    
    
SYNTAX
    Get-IPv4Mask [-IP] <String> [-QuadDot] [<CommonParameters>]
    
    Get-IPv4Mask [-IP] <String> -Length [<CommonParameters>]
    
    Get-IPv4Mask [-IP] <String> -LengthWithSlash [<CommonParameters>]
    
    
DESCRIPTION
    Get IP subnet mask for an IP address
    

PARAMETERS
    -IP <String>
        Input IP in quad dot format with subnet mask, either:
        - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.1/8"
        
    -QuadDot [<SwitchParameter>]
        Return subnet mask in "255.0.0.0" format
        
    -Length [<SwitchParameter>]
        Return subnet mask in "8" format
        
    -LengthWithSlash [<SwitchParameter>]
        Return subnet mask in "/8" format
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-IPv4Mask 9.8.7.6/22
    
    255.255.252.0
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-IPv4Mask 9.8.7.6/22 -LengthWithSlash
    
    /22
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-IPv4Mask 9.8.7.6/255.255.252.0 -Length
    
    22
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-IPv4Mask -examples".
    For more information, type: "get-help Get-IPv4Mask -detailed".
    For technical information, type: "get-help Get-IPv4Mask -full".

```

<a name="Get-IPv4Subnet"></a>
### Get-IPv4Subnet

```
NAME
    Get-IPv4Subnet
    
SYNOPSIS
    Get IP subnet for an IP address
    
    
SYNTAX
    Get-IPv4Subnet [-IP] <String> [-Mask <String>] [-WithMaskLength] [<CommonParameters>]
    
    Get-IPv4Subnet [-IP] <String> [-Mask <String>] -WithMask [<CommonParameters>]
    
    Get-IPv4Subnet [-IP] <String> [-Mask <String>] -IPOnly [<CommonParameters>]
    
    
DESCRIPTION
    Get IP subnet for an IP address
    

PARAMETERS
    -IP <String>
        Input IP in quad dot format with subnet mask, either:
        - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.1/8"
        If input is IP without subnet mask (eg. "127.0.0.1") then -Mask parameter must be set
        
    -Mask <String>
        If input IP is in format without subnet mask, this parameter must be set to either
        - Quad dot format,        eg. "255.255.255.0"
        - Mask length (0-32),     eg. "24"
        - Mask length with slash, eg. "/24"
        
    -WithMaskLength [<SwitchParameter>]
        Return in "127.0.0.0/8" format
        This is default output
        
    -WithMask [<SwitchParameter>]
        Return in "127.0.0.0 255.0.0.0" format
        
    -IPOnly [<SwitchParameter>]
        Return in "127.0.0.1" format
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-IPv4Subnet 127.0.0.1/8
    
    127.0.0.0/8
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-IPv4Subnet -IP 10.20.30.40/28 -WithMask
    
    10.20.30.32 255.255.255.240
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-IPv4Subnet -IP '10.20.30.40 255.255.255.240' -IPOnly
    
    10.20.30.32
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-IPv4Subnet -examples".
    For more information, type: "get-help Get-IPv4Subnet -detailed".
    For technical information, type: "get-help Get-IPv4Subnet -full".

```

<a name="Get-IPv6Address"></a>
### Get-IPv6Address

```
NAME
    Get-IPv6Address
    
SYNOPSIS
    Get subnet, prefix, ... for an IPv6 address
    
    
SYNTAX
    Get-IPv6Address [-IP] <String> [-Prefix <Nullable`1>] [-SameIP] -IPOnly [<CommonParameters>]
    
    Get-IPv6Address [-IP] <String> [-Prefix <Nullable`1>] [-SameIP] -Subnet [-WithPrefix] [<CommonParameters>]
    
    Get-IPv6Address [-IP] <String> [-Prefix <Nullable`1>] -Subnet -IPOnly [<CommonParameters>]
    
    Get-IPv6Address [-IP] <String> [-Prefix <Nullable`1>] [-WithPrefix] [<CommonParameters>]
    
    Get-IPv6Address [-IP] <String> [-Prefix <Nullable`1>] -PrefixOnly [<CommonParameters>]
    
    Get-IPv6Address [-IP] <String> [-Prefix <Nullable`1>] -PrefixWithSlashOnly [<CommonParameters>]
    
    Get-IPv6Address [-IP] <String> [-Prefix <Nullable`1>] -Info [<CommonParameters>]
    
    
DESCRIPTION
    Get subnet, prefix, ... for an IPv6 address
    

PARAMETERS
    -IP <String>
        Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")
        
    -Prefix <Nullable`1>
        If prefix is not set in IP address, it must be set with this parameter
        
    -SameIP [<SwitchParameter>]
        Return same IP as input IP (why? maybe in a different format back)
        If input is "7:6:5::77:88/56", then "7:6:5::77:88/56" is returned
        
    -Subnet [<SwitchParameter>]
        Return subnet
        If input is "7:6:5::77:88/56", then "7:6:5::/56" is returned
        
    -WithPrefix [<SwitchParameter>]
        Return in "7:6:5::/64" format
        This is default output
        
    -IPOnly [<SwitchParameter>]
        Return in "7:6:5::" format
        
    -PrefixOnly [<SwitchParameter>]
        Only return prefix in "64" format
        
    -PrefixWithSlashOnly [<SwitchParameter>]
        Only return prefix in "/64" format
        
    -Info [<SwitchParameter>]
        Return object with different info
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet
    
    7:6:5::/64
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-IPv6Address -IP 007:6:5::77:88/64 -Subnet -IPOnly
    
    7:6:5::
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Get-IPv6Address -IP 007:6:5::77:88/64 -IPOnly
    
    7:6:5::77:88
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Get-IPv6Address -IP 007:6:5::77:88/64 -Info
    
    IP            : 7:6:5::77:88/64
    Subnet        : 7:6:5::/64
    FirstIP       : 7:6:5::/64
    SecondIP      : 7:6:5::1/64
    PenultimateIP : 7:6:5::ffff:ffff:ffff:fffe/64
    LastIP        : 7:6:5::ffff:ffff:ffff:ffff/64
    Prefix        : 64
    Objects       : @{IP=; Subnet=; FirstIP=; SecondIP=; PenultimateIP=; LastIP=}
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-IPv6Address -examples".
    For more information, type: "get-help Get-IPv6Address -detailed".
    For technical information, type: "get-help Get-IPv6Address -full".

```

<a name="Get-IPv6Subnet"></a>
### Get-IPv6Subnet

```
NAME
    Get-IPv6Subnet
    
SYNOPSIS
    Get IP subnet for an IPv6 address
    
    
SYNTAX
    Get-IPv6Subnet [-IP] <String> [-Prefix <Nullable`1>] [-WithPrefix] [<CommonParameters>]
    
    Get-IPv6Subnet [-IP] <String> [-Prefix <Nullable`1>] -IPOnly [<CommonParameters>]
    
    
DESCRIPTION
    Get IP subnet for an IPv6 address
    

PARAMETERS
    -IP <String>
        Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")
        
    -Prefix <Nullable`1>
        If prefix is not set in IP address, it must be set with this parameter
        
    -WithPrefix [<SwitchParameter>]
        Return in "7:6:5::/64" format
        This is default output
        
    -IPOnly [<SwitchParameter>]
        Return in "7:6:5::" format
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Get-IPv6Subnet -IP 7:6:5::77:88/64
    
    7:6:5::/64
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Get-IPv6Subnet -IP 7:6:5::77:88/64 -IPOnly
    
    7:6:5::
    
    
    
    
REMARKS
    To see the examples, type: "get-help Get-IPv6Subnet -examples".
    For more information, type: "get-help Get-IPv6Subnet -detailed".
    For technical information, type: "get-help Get-IPv6Subnet -full".

```

<a name="Test-IPv4Address"></a>
### Test-IPv4Address

```
NAME
    Test-IPv4Address
    
SYNOPSIS
    Test if a string contains a valid IP address (IPv4)
    
    
SYNTAX
    Test-IPv4Address [-IP] <String> [-IPOnly] [<CommonParameters>]
    
    Test-IPv4Address [-IP] <String> -Mask [-AllowLength] [<CommonParameters>]
    
    Test-IPv4Address [-IP] <String> -AllowMask [<CommonParameters>]
    
    Test-IPv4Address [-IP] <String> -RequireMask [<CommonParameters>]
    
    
DESCRIPTION
    Test if a string contains a valid IP address (IPv4)
    Uses regex to test
    Returns [bool]
    

PARAMETERS
    -IP <String>
        IP address (or subnet mask) to test is valid or not
        
    -IPOnly [<SwitchParameter>]
        Only return True if input is valid IPv4 in quad dot format (without subnet mask)
        Eg. "127.0.0.1"
        This is default
        
    -Mask [<SwitchParameter>]
        Only return True if input is valid IPv4 subnet mask in quad dot format
        Eg. "255.255.255.0"
        
    -AllowLength [<SwitchParameter>]
        Used along with -Mask
        Only return true if input is subnet mask in:
        - Quad dot format,        eg. "255.255.255.0"
        - Mask length (0-32),     eg. "24"
        - Mask length with slash, eg. "/24"
        
    -AllowMask [<SwitchParameter>]
        Return true if input is either
        - IP in quad dot,        eg. "127.0.0.1"
        - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.1/8"
        
    -RequireMask [<SwitchParameter>]
        Return true if input is IP with mask, either
        - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.1/8"
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv4Address -IP 127.0.0.1
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv4Address -IP 127.0.0.256
    
    False
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Test-IPv4Address -IP 127.0.0.1/32
    
    False
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Test-IPv4Address -AllowMask -IP 127.0.0.1/32
    
    True
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Test-IPv4Address -AllowMask -IP "127.0.0.1 255.255.255.255"
    
    True
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS C:\>Test-IPv4Address -AllowMask -IP "127.0.0.1"
    
    True
    
    
    
    
    -------------------------- EXAMPLE 7 --------------------------
    
    PS C:\>Test-IPv4Address -RequireMask -IP 127.0.0.1/32
    
    True
    
    
    
    
    -------------------------- EXAMPLE 8 --------------------------
    
    PS C:\>Test-IPv4Address -RequireMask -IP 127.0.0.1
    
    False
    
    
    
    
    -------------------------- EXAMPLE 9 --------------------------
    
    PS C:\>Test-IPv4Address -Mask -IP 255.255.0.0
    
    True
    
    
    
    
    -------------------------- EXAMPLE 10 --------------------------
    
    PS C:\>Test-IPv4Address -Mask -IP 255.0.255.0
    
    False
    
    
    
    
    -------------------------- EXAMPLE 11 --------------------------
    
    PS C:\>Test-IPv4Address -Mask -IP 32
    
    False
    
    
    
    
    -------------------------- EXAMPLE 12 --------------------------
    
    PS C:\>Test-IPv4Address -Mask -AllowLength -IP 255.0.255.0
    
    False
    
    
    
    
    -------------------------- EXAMPLE 13 --------------------------
    
    PS C:\>Test-IPv4Address -Mask -AllowLength -IP 255.255.0.0
    
    True
    
    
    
    
    -------------------------- EXAMPLE 14 --------------------------
    
    PS C:\>Test-IPv4Address -Mask -AllowLength -IP 32
    
    True
    
    
    
    
    -------------------------- EXAMPLE 15 --------------------------
    
    PS C:\>Test-IPv4Address -Mask -AllowLength -IP /32
    
    True
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv4Address -examples".
    For more information, type: "get-help Test-IPv4Address -detailed".
    For technical information, type: "get-help Test-IPv4Address -full".

```

<a name="Test-IPv4AddressInSameNet"></a>
### Test-IPv4AddressInSameNet

```
NAME
    Test-IPv4AddressInSameNet
    
SYNOPSIS
    Test if two IP addresses are in the same subnet
    
    
SYNTAX
    Test-IPv4AddressInSameNet [-IP] <String> [-IP2] <String> [-Mask <String>] [-AllowMaskMismatch] [<CommonParameters>]
    
    
DESCRIPTION
    Test if two IP addresses are in the same subnet
    

PARAMETERS
    -IP <String>
        Input IP in quad dot format with subnet mask, either:
        - IP + mask in quad dot, eg. "127.0.0.1 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.1/8"
        If input is IP without subnet mask (eg. "127.0.0.1") then -Mask parameter must be set
        
    -IP2 <String>
        Same format as -IP
        
    -Mask <String>
        If input IP is in format without subnet mask, this parameter must be set to either
        - Quad dot format,        eg. "255.255.255.0"
        - Mask length (0-32),     eg. "24"
        - Mask length with slash, eg. "/24"
        
    -AllowMaskMismatch [<SwitchParameter>]
        Return true if hosts with the two IP addresses can communicate with each other directly
        (not routed), even if there's a mismatch in subnet mask between the two.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv4AddressInSameNet -IP 10.30.50.60 -IP2 10.30.50.61/24
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/255.255.255.0
    
    True
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/29
    
    False
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Test-IPv4AddressInSameNet -IP 10.30.50.60/24 -IP2 10.30.50.61/29 -AllowMaskMismatch
    
    True
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv4AddressInSameNet -examples".
    For more information, type: "get-help Test-IPv4AddressInSameNet -detailed".
    For technical information, type: "get-help Test-IPv4AddressInSameNet -full".

```

<a name="Test-IPv4AddressInSubnet"></a>
### Test-IPv4AddressInSubnet

```
NAME
    Test-IPv4AddressInSubnet
    
SYNOPSIS
    Test if IP address is in a subnet
    
    
SYNTAX
    Test-IPv4AddressInSubnet [-Subnet] <String> [-IP] <String> [-Mask <String>] [-AllowMaskMismatch] [<CommonParameters>]
    
    
DESCRIPTION
    Test if IP address is in a subnet
    

PARAMETERS
    -Subnet <String>
        Input IP in quad dot format with subnet mask, either:
        - IP + mask in quad dot, eg. "127.0.0.0 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.0/8"
        If input is IP without subnet mask (eg. "127.0.0.0") then -Mask parameter must be set
        
    -IP <String>
        Same format as -Subnet
        
    -Mask <String>
        If subnet is in format without subnet mask, this parameter must be set to either
        - Quad dot format,        eg. "255.255.255.0"
        - Mask length (0-32),     eg. "24"
        - Mask length with slash, eg. "/24"
        
    -AllowMaskMismatch [<SwitchParameter>]
        Return true if IP is in subnet, even if the subnet mask is wrong.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/24
    
    True
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/29
    
    False
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/29 -AllowMaskMismatch
    
    True
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.50.70/23 -AllowMaskMismatch
    
    True
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS C:\>Test-IPv4AddressInSubnet -Subnet 10.30.50.0/24 -IP 10.30.51.70/23 -AllowMaskMismatch
    
    False
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv4AddressInSubnet -examples".
    For more information, type: "get-help Test-IPv4AddressInSubnet -detailed".
    For technical information, type: "get-help Test-IPv4AddressInSubnet -full".

```

<a name="Test-IPv4AddressIsPrivate"></a>
### Test-IPv4AddressIsPrivate

```
NAME
    Test-IPv4AddressIsPrivate
    
SYNOPSIS
    Test if IP address is in a private segment
    
    
SYNTAX
    Test-IPv4AddressIsPrivate [-IP] <String> [<CommonParameters>]
    
    Test-IPv4AddressIsPrivate [-IP] <String> -Rfc1918 [<CommonParameters>]
    
    Test-IPv4AddressIsPrivate [-IP] <String> -Rfc6598 [<CommonParameters>]
    
    
DESCRIPTION
    Test if IP address is in a private segment
    

PARAMETERS
    -IP <String>
        Input IP in quad dot format with or without subnet mask
        
    -Rfc1918 [<SwitchParameter>]
        
    -Rfc6598 [<SwitchParameter>]
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>xxx
    
    
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv4AddressIsPrivate -examples".
    For more information, type: "get-help Test-IPv4AddressIsPrivate -detailed".
    For technical information, type: "get-help Test-IPv4AddressIsPrivate -full".

```

<a name="Test-IPv4Subnet"></a>
### Test-IPv4Subnet

```
NAME
    Test-IPv4Subnet
    
SYNOPSIS
    Test if IP address is a valid subnet address
    
    
SYNTAX
    Test-IPv4Subnet [-Subnet] <String> [-Mask <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Test if IP address is a valid subnet address
    

PARAMETERS
    -Subnet <String>
        Input IP in quad dot format with subnet mask, either:
        - IP + mask in quad dot, eg. "127.0.0.0 255.0.0.0"
        - IP + mask length,      eg. "127.0.0.0/8"
        If input is IP without subnet mask (eg. "127.0.0.0") then -Mask parameter must be set
        
    -Mask <String>
        If input IP is in format without subnet mask, this parameter must be set to either
        - Quad dot format,        eg. "255.255.255.0"
        - Mask length (0-32),     eg. "24"
        - Mask length with slash, eg. "/24"
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv4Subnet -Subnet 10.20.30.0/24
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv4Subnet -Subnet 10.20.30.0/255.255.0.0
    
    False
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv4Subnet -examples".
    For more information, type: "get-help Test-IPv4Subnet -detailed".
    For technical information, type: "get-help Test-IPv4Subnet -full".

```

<a name="Test-IPv6Address"></a>
### Test-IPv6Address

```
NAME
    Test-IPv6Address
    
SYNOPSIS
    Test if a string contains a valid IP address (IPv6)
    
    
SYNTAX
    Test-IPv6Address [-IP] <String> [-IPOnly] [<CommonParameters>]
    
    Test-IPv6Address [-IP] <String> -AllowPrefix [<CommonParameters>]
    
    Test-IPv6Address [-IP] <String> -RequirePrefix [<CommonParameters>]
    
    
DESCRIPTION
    Test if a string contains a valid IP address (IPv6)
    Returns [bool]
    

PARAMETERS
    -IP <String>
        IP address to test is valid or not
        
    -IPOnly [<SwitchParameter>]
        Only return True if input is valid IPv6 address (without prefix)
        Eg. "a:b::c"
        This is default
        
    -AllowPrefix [<SwitchParameter>]
        Return true if input valid IPv6 address with or without prefix
        Eg. "a:b::c" or "a:b::c/64"
        
    -RequirePrefix [<SwitchParameter>]
        Return true if input valid IPv6 address with prefix
        Eg. "a:b::c/64"
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv6Address -IP a:b::c
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv6Address -IP a:b::c/64
    
    False
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Test-IPv6Address -IP a:b::x
    
    False
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Test-IPv6Address -IP a:b::c/64
    
    False
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Test-IPv6Address -AllowPrefix -IP a:b::c/64
    
    True
    
    
    
    
    -------------------------- EXAMPLE 6 --------------------------
    
    PS C:\>Test-IPv6Address -AllowPrefix -IP a:b::c
    
    True
    
    
    
    
    -------------------------- EXAMPLE 7 --------------------------
    
    PS C:\>Test-IPv6Address -AllowPrefix -IP a:b::x/64
    
    False
    
    
    
    
    -------------------------- EXAMPLE 8 --------------------------
    
    PS C:\>Test-IPv6Address -RequirePrefix -IP a:b::c/64
    
    True
    
    
    
    
    -------------------------- EXAMPLE 9 --------------------------
    
    PS C:\>Test-IPv6Address -RequirePrefix -IP a:b::c
    
    False
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv6Address -examples".
    For more information, type: "get-help Test-IPv6Address -detailed".
    For technical information, type: "get-help Test-IPv6Address -full".

```

<a name="Test-IPv6AddressInSameNet"></a>
### Test-IPv6AddressInSameNet

```
NAME
    Test-IPv6AddressInSameNet
    
SYNOPSIS
    Test if two IP addresses are in the same subnet (IPv6)
    
    
SYNTAX
    Test-IPv6AddressInSameNet [-IP] <String> [-IP2] <String> [-Prefix <Nullable`1>] [-AllowPrefixMismatch] [<CommonParameters>]
    
    
DESCRIPTION
    Test if two IP addresses are in the same subnet (IPv6)
    

PARAMETERS
    -IP <String>
        Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")
        
    -IP2 <String>
        Same format as -IP
        
    -Prefix <Nullable`1>
        If prefix is not set in IP address, it must be set with this parameter
        
    -AllowPrefixMismatch [<SwitchParameter>]
        Return true if hosts with the two IP addresses can communicate with each other directly
        (not routed), even if there's a mismatch in prefix between the two.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/31
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv6AddressInSameNet -IP a:2::/32 -IP2 a:3::/32
    
    False
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/30
    
    False
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/32 -AllowPrefixMismatch
    
    False
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Test-IPv6AddressInSameNet -IP a:2::/31 -IP2 a:3::/30 -AllowPrefixMismatch
    
    True
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv6AddressInSameNet -examples".
    For more information, type: "get-help Test-IPv6AddressInSameNet -detailed".
    For technical information, type: "get-help Test-IPv6AddressInSameNet -full".

```

<a name="Test-IPv6AddressInSubnet"></a>
### Test-IPv6AddressInSubnet

```
NAME
    Test-IPv6AddressInSubnet
    
SYNOPSIS
    Test if two IP addresses are in the same subnet (IPv6)
    
    
SYNTAX
    Test-IPv6AddressInSubnet [-Subnet] <String> [-IP] <String> [-Prefix <Nullable`1>] [-AllowPrefixMismatch] [<CommonParameters>]
    
    
DESCRIPTION
    Test if two IP addresses are in the same subnet (IPv6)
    

PARAMETERS
    -Subnet <String>
        Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")
        
    -IP <String>
        Same format as -Subnet
        
    -Prefix <Nullable`1>
        If prefix is not set in subnet address, it must be set with this parameter
        
    -AllowPrefixMismatch [<SwitchParameter>]
        Return true if hosts with the two IP addresses can communicate with each other directly
        (not routed), even if there's a mismatch in prefix between the two.
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/31
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv6AddressInSubnet -Subnet a:2::/32 -IP a:3::/32
    
    False
    
    
    
    
    -------------------------- EXAMPLE 3 --------------------------
    
    PS C:\>Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/30
    
    False
    
    
    
    
    -------------------------- EXAMPLE 4 --------------------------
    
    PS C:\>Test-IPv6AddressInSubnet -Subnet a:2::/32 -IP a:3::/31 -AllowPrefixMismatch
    
    False
    
    
    
    
    -------------------------- EXAMPLE 5 --------------------------
    
    PS C:\>Test-IPv6AddressInSubnet -Subnet a:2::/31 -IP a:3::/32 -AllowPrefixMismatch
    
    True
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv6AddressInSubnet -examples".
    For more information, type: "get-help Test-IPv6AddressInSubnet -detailed".
    For technical information, type: "get-help Test-IPv6AddressInSubnet -full".

```

<a name="Test-IPv6Subnet"></a>
### Test-IPv6Subnet

```
NAME
    Test-IPv6Subnet
    
SYNOPSIS
    Test if IP address is a valid subnet address (IPv6)
    
    
SYNTAX
    Test-IPv6Subnet [-Subnet] <String> [-Prefix <String>] [<CommonParameters>]
    
    
DESCRIPTION
    Test if IP address is a valid subnet address (IPv6)
    

PARAMETERS
    -Subnet <String>
        Input IP is standard IPv6 format with out prefix (eg. "a:b:00c::" or "a:b:00c::0/64")
        
    -Prefix <String>
        If prefix is not set in subnet address, it must be set with this parameter
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
    -------------------------- EXAMPLE 1 --------------------------
    
    PS C:\>Test-IPv6Subnet -Subnet a:0:0:b::/64
    
    True
    
    
    
    
    -------------------------- EXAMPLE 2 --------------------------
    
    PS C:\>Test-IPv6Subnet -Subnet a:0:0:0:b::/64
    
    False
    
    
    
    
REMARKS
    To see the examples, type: "get-help Test-IPv6Subnet -examples".
    For more information, type: "get-help Test-IPv6Subnet -detailed".
    For technical information, type: "get-help Test-IPv6Subnet -full".

```



