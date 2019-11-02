function New-ApiFileContent {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [string]$InFile
    )

    if (-not (Test-Path $InFile)) {
        $errorMessage = ("File {0} missing or unable to read." -f $InFile)
        $exception = New-Object System.Exception $errorMessage
        $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, 'MultipartFormDataUpload', ([System.Management.Automation.ErrorCategory]::InvalidArgument), $InFile
        $PSCmdlet.ThrowTerminatingError($errorRecord)
    }

    $fileStream = [System.IO.FileStream]::new($inFile, [System.IO.FileMode]::Open)
    $fileHeader = [System.Net.Http.Headers.ContentDispositionHeaderValue]::new("form-data")
    $fileHeader.Name = "file"
    $fileHeader.FileName = (Split-Path $InFile -leaf)

    $fileContent = [System.Net.Http.StreamContent]::new($fileStream)
    $fileContent.Headers.ContentDisposition = $fileHeader
    $fileContent.Headers.ContentType = [System.Web.MimeMapping]::GetMimeMapping($inFile)

    return $fileContent
}
