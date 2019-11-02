function Remove-XgCertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $xml = New-XgApiMessage -ActionType Remove -Entity Certificate -RemoveEntity $Name
    $output = Write-ApiOutput -Object (New-ApiRequest -xml $xml -InFile $Path)
    return $output.Status
}