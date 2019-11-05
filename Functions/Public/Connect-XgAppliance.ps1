function Connect-XgAppliance {
    <#
    .Description
    The Connect-XgAppliance function tests the used credentials and create a session context.
    Default URI would look like https://[IP]:4444/webconsole/APIController
    #>
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$Uri,

        [parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credentials,

        [Parameter(Mandatory = $false)]
        [switch]$PlainPass,

        [switch]$SkipCertificateCheck
    )

    $FilterValue = $Credentials.UserName

    $xml = New-XgApiMessage -ActionType Get -Entity User -FilterValue $FilterValue

    $selectedNode = $xml.SelectSingleNode('//Login')
    $selectedNode.Username = $Credentials.UserName
    $selectedNode.Password.InnerText = $Credentials.GetNetworkCredential().Password

    switch ($PlainPass.IsPresent) {
        true { $passwordFrom = 'plain' }
        false { $passwordFrom = 'encrypt' }
    }

    $selectedNode.Password.SetAttribute('passwordform', $passwordFrom)

    $content = [System.Net.Http.MultipartFormDataContent]::new()
    $content.Add((New-ApiStringContent -Request $xml))

    $ht = @{
        Uri     = $Uri
        Content = $content
        SkipCertificateCheck = $SkipCertificateCheck.IsPresent
    }

    $response = Invoke-ApiController @ht
    $result = ([xml]$response).SelectSingleNode("//Login")

    $SessionName = 'XgSession'
    if ($result.status -eq 'Authentication Successful') {

        $session = [PSCustomObject]@{
            Name         = "Sophos XG"
            Uri          = $Uri
            Account      = $Credentials.UserName
            Credentials  = $Credentials
            PasswordForm = $passwordFrom
            Message      = $result.status
            SkipCertificateCheck = $SkipCertificateCheck.IsPresent
        }
        New-Variable -Name $SessionName -Visibility Private -Scope Global -Value $session -Force
        return Get-XgContext
    }

}