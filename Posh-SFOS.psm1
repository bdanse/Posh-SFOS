Add-Type -AssemblyName System.Net.Http
Add-Type -AssemblyName System.Web

#Get public and private function definition files.
$Public = @( Get-ChildItem -Path $PSScriptRoot\Functions\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @( Get-ChildItem -Path $PSScriptRoot\Functions\Private\*.ps1 -ErrorAction SilentlyContinue)

#Dot source the files
Foreach ($import in @($Public + $Private)) {
    Try {
        . $import.fullname
    }
    Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"
    }
}

# Here I might...
# Read in or create an initial config file and variable
# Export Public functions ($Public.BaseName) for WIP modules
# Set variables visible to the module and its functions only

Export-ModuleMember -Function $Public.Basename
