function Get-XgContext {
    <#
    .Description
    The Get-XgContext function displays the account and uri of which the credentials are cached.
    #>
    param()

    if (Test-ApiSession) {
        return $Global:XgSession | Select-Object Name, Uri, Account, Message
    }
}
