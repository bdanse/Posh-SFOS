function New-ApiRemoveMessage {
    [CmdletBinding()]
    [OutputType([xml])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('User', 'Certificate', 'SecurityPolicy', 'SecurityPolicyGroup')]
        [string]$Entity,

        [Parameter(Mandatory, $true)]
        [string]$RemoveEntity
    )
    return New-XgApiMessage -ActionType 'Remove' @PSBoundParameters
}