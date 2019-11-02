# Overview
A Powershell module to manage pfx certificate on a Sophos XG firewall and assign certificates to HTTPBased policy.

# Disclaimer
This project is to be considered a proof-of-concept and not a supported product.




# Cmdlets

## Connect-XgAppliance

``` powershell
NAME
    Connect-XgAppliance

SYNOPSIS


SYNTAX
    Connect-XgAppliance [-Uri] <String> [-Credentials] <PSCredential> [-PlainPass] [<CommonParameters>]


DESCRIPTION
    The Connect-XgAppliance validates credentials and create a sort of cached session.

```

## Get-XgContext

``` powershell
NAME
    Get-XgContext

SYNOPSIS


SYNTAX
    Get-XgContext [<CommonParameters>]


DESCRIPTION
    The Get-XgContext displays current session.

```
## Get-XgUsers

This cmdlet can be used to retrieve the encryped password of a user. Which can be reused in the Connect-XgAppliance cmdlet

```
NAME
    Get-XgUsers

SYNTAX
    Get-XgUsers [[-FilterCriteria] {Equals | NotEquals | Like}] [[-FilterValue] <string>]  [<CommonParameters>]

DESCRIPTION
    The Get-XgContext retrieves all/single or set Users based on filter.

```

Get-XgCertificates
New-XgCertificates
Remove-XgCertificates

Get-XgSecurityPolicy
Get-XgSecurityPolicyGroup

Set-XgSecurityPolicy
Set-XgSecurityPolicyGroup