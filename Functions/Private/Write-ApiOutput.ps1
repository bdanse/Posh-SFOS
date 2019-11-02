function Write-ApiOutput {
    [CmdletBinding()]
    param(
        [string]$Object,
        [switch]$Connect
    )

    $start = $Object.IndexOf("<?xml")
    $end = $Object.LastIndexOf("</Response>")
    $ObjectParsed = $Object.Substring($start, $end - $start + 11)

    Write-Verbose $ObjectParsed

    $xml = [xml]$ObjectParsed
    if ($xml.Response.ChildNodes.Count -eq 1 -and $xml.Response.FirstChild.Name -eq "Login") {
        $errorMessage = $xml.Response.Login.Status
        throw [System.Net.Http.HttpRequestException] $errorMessage
    }

    if (-not $Connect.IsPresent) {
        $result = $xml.SelectNodes("/Response/*[@transactionid]")
    }
    else {
        $result = $xml.SelectSingleNode("//Login")
    }

    return $result
}
