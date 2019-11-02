function New-ApiStringContent {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [System.Xml.XmlDocument]$Request
    )

    $stringHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
    $stringHeader.Name = "reqxml"

    $stringContent = [System.Net.Http.StringContent]::new($Request.OuterXml)
    $stringContent.Headers.ContentDisposition = $stringHeader
    $stringContent.Headers.ContentType = 'application/xml'
    $stringContent.Headers.ContentType.CharSet = 'utf-8'

    return $stringContent
}