function New-ApiRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [xml]$xml,

        [Parameter(Mandatory = $false)]
        [string]$InFile,

        [switch]$Connect
    )

    $xml = Add-ApiRequestCredentials -InputObject $xml

    $content = [System.Net.Http.MultipartFormDataContent]::new()
    $content.Add((New-ApiStringContent -Request $xml))

    if ($PSBoundParameters.InFile) {
        $content.Add((New-ApiFileContent -InFile $InFile))
    }

    $ht = @{
        Uri     = $Uri
        Content = $content
    }

    $result = Invoke-ApiController @ht -SkipCertificateCheck:$($Global:XgSession.SkipCertificateCheck)
    return $result
}