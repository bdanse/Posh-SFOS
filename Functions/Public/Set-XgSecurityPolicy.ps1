function Set-XgSecurityPolicy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement]$InputObject,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Update')]
        [string]$Operation = 'Update'
    )

    $xml = New-ApiSetMessage -InputObject $InputObject -Operation $Operation

    $currentSecurityPolicyGroup = Get-XgSecurityPolicyGroup | Where-Object { $_.SecurityPolicyList.SecurityPolicy -contains $InputObject.Name }
    Write-Verbose "SecurityPolicy member of Group $($currentSecurityPolicyGroup.Name)"

    $output = Write-ApiOutput -Object (New-ApiRequest -xml $xml)

    # Restore SecurityPolicyGroup if found
    if($currentSecurityPolicyGroup) {
        Set-XgSecurityPolicyGroup -Operation Update -InputObject $currentSecurityPolicyGroup
    }

    if ($output.Status.code -eq "200") {
        # Test what result is..
        $output.Status
    }
    else {
        $output.Status
    }
}