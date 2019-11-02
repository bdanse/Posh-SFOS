function Add-ApiRequestCredentials {
    [CmdletBinding()]
    [OutputType([xml])]
    param(
        [parameter(Mandatory = $true)]
        [xml]$InputObject
    )

    if (Test-ApiSession) {
        $selectedNode = $InputObject.SelectSingleNode('//Login')
        $selectedNode.Username = $Global:XgSession.Account
        $selectedNode.Password.InnerText = $Global:XgSession.Credentials.GetNetworkCredential().Password
        $selectedNode.Password.SetAttribute('passwordform', $Global:XgSession.PasswordForm)
        return $InputObject
    }
    else {
        throw "API session not found."
    }
}