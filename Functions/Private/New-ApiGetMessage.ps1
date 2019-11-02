function New-ApiGetMessage {
    [CmdletBinding()]
    [OutputType([xml])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('User', 'Certificate', 'SecurityPolicy', 'SecurityPolicyGroup')]
        [string]$Entity,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Equals', 'NotEquals', 'Like')]
        [string]$FilterCriteria,

        [Parameter(Mandatory = $false)]
        [string]$FilterValue
    )
    return New-XgApiMessage -ActionType 'Get' @PSBoundParameters
}