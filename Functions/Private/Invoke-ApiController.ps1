function Invoke-ApiController {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [System.Net.Http.MultipartFormDataContent]$Content,

        [parameter(Mandatory = $false)]
        [string]$Uri,

        [switch]$SkipCertificateCheck
    )

    $httpClientHandler = New-Object System.Net.Http.HttpClientHandler

    if($SkipCertificateCheck.IsPresent) {
        $httpClientHandler.ServerCertificateCustomValidationCallback = [System.Net.Http.HttpClientHandler]::DangerousAcceptAnyServerCertificateValidator
    }
    $httpClient = New-Object System.Net.Http.Httpclient $httpClientHandler

    if (-not $PSBoundParameters.Uri) {
        $Uri = $Global:XgSession.Uri
    }

    Write-Verbose $Uri
    Write-Verbose $content.ReadAsStringAsync().Result

    try {

        $response = $httpClient.PostAsync($Uri, $content).Result

        if (!$response.IsSuccessStatusCode) {
            $responseBody = $response.Content.ReadAsStringAsync().Result
            $errorMessage = "Status code {0}. Reason {1}. Server reported the following message: {2}." -f $response.StatusCode, $response.ReasonPhrase, $responseBody

            throw [System.Net.Http.HttpRequestException] $errorMessage
        }

        return $response.Content.ReadAsStringAsync().Result
    }
    catch [Exception] {
        $PSCmdlet.ThrowTerminatingError($_)
    }
    finally {
        if ($null -ne $httpClient) {
            $httpClient.Dispose()
        }

        if ($null -ne $response) {
            $response.Dispose()
        }
    }
}