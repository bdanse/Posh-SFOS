# Overview
A Powershell module to manage pfx certificate on a Sophos XG firewall and assign certificates to HTTPBased policy.

# Disclaimer
This project is to be considered a proof-of-concept and not a supported product.

# Usage

## Connect with non-encrypted password

``` powershell
Import-Module .\Posh-SFOS.psm1 -verbose -force
$Uri = 'https://[IP]:4444/webconsole/APIController'
$Credentials = Get-Credential

Connect-XgAppliance -uri $uri -Credentials $Credentials -PlainPass

Name      Uri                                         Account Message
----      ---                                         ------- -------
Sophos XG https://[IP]:4444/webconsole/APIController  admin   Authentication Successful

```

## Automated Certificate renewal

Request a Let's encrypt certificate using posh-acme with Azure DNS plugin. Import and assign resulting certificatre to Sophos XG firewall.
For other DNS providers check [here](https://github.com/rmbolger/Posh-ACME/wiki/List-of-Supported-DNS-Providers)
``` powershell 

Install-Module Az
Install-Module Posh-Acme

$az = Get-AzContext 
$fqdn = 'www.contoso.com'

$azDnsParams = @{
    AzSubscriptionId = $az.Subscription.Id
    AzTenantId = $az.Tenant.Id
    AZAppUsername = $appUser.Guid
    AZAppPasswordInsecure = 'password'
}

$PACert = New-PACertificate $fqdn -DnsPlugin Azure -PluginArgs $azDnsParams -AcceptTOS -Contact 'webmaster@contoso.com'

$prefix = [datetime]::Now.ToString('yyyyMMddHHmm')
$splat = @{
  Name   = "$prefix-$fqdn"
  Secret = 'poshacme'
  Path   = $PACert.PfxFullChain
}

$XgCert = New-XgCertificates @splat
$XgSp = Get-XgSecurityPolicy -FilterValue 'WAF-www.contoso.com'
$XgSp.HTTPBasedPolicy.Certificate = $xgcert.Name
Set-XgSecurityPolicy -InputObject $XgSp
```

# Cmdlets

## Connect-XgAppliance

``` powershell
NAME
    Connect-XgAppliance

SYNOPSIS


SYNTAX
    Connect-XgAppliance [-Uri] <String> [-Credentials] <PSCredential> [-PlainPass] [-SkipCertificateCheck] [<CommonParameters>]


DESCRIPTION
    The Connect-XgAppliance validates credentials and create a sort of cached session.
    Default URI would look like https://[IP]:4444/webconsole/APIController

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

``` powershell
NAME
    Get-XgUsers

SYNTAX
    Get-XgUsers [[-FilterCriteria] {Equals | NotEquals | Like}] [[-FilterValue] <string>]  [<CommonParameters>]

DESCRIPTION
    The Get-XgContext retrieves all/single or set Users based on filter.

```

## Get-XgCertificates

``` powershell
NAME
    Get-XgCertificates

SYNTAX
    Get-XgCertificates [[-FilterCriteria] {Equals | NotEquals | Like}] [[-FilterValue] <string>]  [<CommonParameters>]


```

## New-XgCertificates

``` powershell
NAME
    New-XgCertificates

SYNTAX
    New-XgCertificates [-Name] <string> [-Secret] <string> [-Path] <string> [[-Operation] {Add | Update}]  [<CommonParameters>]
```

## Remove-XgCertificates

``` powershell
NAME
    Remove-XgCertificates

SYNTAX
    Remove-XgCertificates [-Name] <string>  [<CommonParameters>]
```



## Get-XgSecurityPolicy

```powershell
NAME
    Get-XgSecurityPolicy

SYNTAX
    Get-XgSecurityPolicy [[-FilterCriteria] {Equals | NotEquals | Like}] [[-FilterValue] <string>]  [<CommonParameters>]
```


## Set-XgSecurityPolicy

``` powershell
NAME
    Set-XgSecurityPolicy

SYNTAX
    Set-XgSecurityPolicy [-InputObject] <XmlElement> [[-Operation] {Update}]  [<CommonParameters>]
```