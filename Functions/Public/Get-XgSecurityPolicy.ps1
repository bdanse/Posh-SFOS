function Get-XgSecurityPolicy {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet('Equals', 'NotEquals', 'Like')]
        [string]$FilterCriteria,

        [Parameter(Mandatory = $false)]
        [string]$FilterValue
    )

    $xml = New-XgApiMessage -ActionType Get -Entity SecurityPolicy @PSBoundParameters
    $output = Write-ApiOutput -Object (New-ApiRequest -xml $xml)
    return $output
}
