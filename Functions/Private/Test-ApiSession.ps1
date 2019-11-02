function Test-ApiSession {
    [CmdletBinding()]
    [OutputType([bool])]
    param()

    if ($Global:XgSession) {
        return $true
    }
    else {
        return $false
    }
}