function New-ApiSetMessage {
    [CmdletBinding()]
    [OutputType([xml])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Add', 'Update')]
        [string]$Operation,

        [Parameter(Mandatory = $true)]
        [System.Xml.XmlElement]$InputObject
    )
    return New-XgApiMessage -ActionType 'Set' @PSBoundParameters
}