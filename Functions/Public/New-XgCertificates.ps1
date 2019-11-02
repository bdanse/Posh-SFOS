function New-XgCertificates {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [string]$Secret,

        [Parameter(Mandatory = $true)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Add', 'Update')]
        [string]$Operation = 'Add'
    )

    $InputObject = [Xml]"
    <Certificate>
        <Name>$Name</Name>
        <Action>UploadCertificate</Action>
        <CertificateFormat>pkcs12</CertificateFormat>
        <Password>$Secret</Password>
        <CertificateFile>$(Split-Path $Path -leaf)</CertificateFile>
    </Certificate>"
    $InputObject = $InputObject.DocumentElement

    $xml = New-ApiSetMessage -Operation Add -InputObject $InputObject

    $output = Write-ApiOutput -Object (New-ApiRequest -xml $xml -InFile $Path)
    if ($output.Status.code -eq "200") {
        Get-XgCertificates -FilterCriteria Equals -FilterValue $Name
    }
    else {
        $output.Status
    }
}
