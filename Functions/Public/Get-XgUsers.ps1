function Get-XgUsers {
    <#
    .Description
    The Get-XgContext retrieves all/single or set Users based on filter.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet('Equals', 'NotEquals', 'Like')]
        [string]$FilterCriteria,

        [Parameter(Mandatory = $false)]
        [string]$FilterValue
    )

    $xml = New-XgApiMessage -ActionType Get -Entity User @PSBoundParameters
    $output = Write-ApiOutput -Object (New-ApiRequest -xml $xml)
    return $output
}