function New-XgApiMessage {
    [CmdletBinding(DefaultParameterSetName = 'Get')]
    [OutputType([xml])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateSet('Get', 'Set', 'Remove')]
        [string]$ActionType,

        [Parameter(Mandatory, ParameterSetName = 'Set')]
        [ValidateSet('Add', 'Update')]
        [string]$Operation,

        [Parameter(Mandatory, ParameterSetName = 'Set')]
        [System.Xml.XmlElement]$InputObject,

        [Parameter(Mandatory, ParameterSetName = 'Get')]
        [Parameter(Mandatory, ParameterSetName = 'Remove')]
        [ValidateSet('User', 'Certificate', 'SecurityPolicy', 'SecurityPolicyGroup')]
        [string]$Entity,

        [Parameter(Mandatory = $false, ParameterSetName = 'Get')]
        [ValidateSet('Equals', 'NotEquals', 'Like')]
        [string]$FilterCriteria,

        [Parameter(Mandatory = $false, ParameterSetName = 'Get')]
        [string]$FilterValue,

        [Parameter(Mandatory, ParameterSetName = 'Remove')]
        [string]$RemoveEntity
    )

    #$ActionType = $PSCmdlet.ParameterSetName

    [xml]$ApiMessage = New-Object System.Xml.XmlDocument
    $dec = $ApiMessage.CreateXmlDeclaration("1.0", "UTF-8", $null)
    $null = $ApiMessage.AppendChild($dec)

    $RequestNode = $ApiMessage.CreateNode("element", "Request", $null)

    $LoginNode = $ApiMessage.CreateNode("element", "Login", $null)
    $UserNameElement = $ApiMessage.CreateElement("UserName")
    $UserNameElement.InnerText = 'admin'
    $null = $LoginNode.AppendChild($UserNameElement)

    $PasswordElement = $ApiMessage.CreateElement("Password")
    $PasswordElement.SetAttribute('passwordform', '')
    $null = $LoginNode.AppendChild($PasswordElement)

    $ActionNode = $ApiMessage.CreateNode("element", $ActionType, $null)

    if ($ActionType -eq "Set") {
        $ActionNode.SetAttribute('operation', $Operation.ToLower())
        $ImportedElement = $ApiMessage.ImportNode($InputObject, $true)
        $null = $ActionNode.AppendChild($ImportedElement)
    }

    if ($ActionType -ne "Set") {
        $EntityElement = $ApiMessage.CreateNode("element", $Entity, $null)
        if ($ActionType -eq "Remove") {
            $NameElement = $ApiMessage.CreateElement("Name")
            $NameElement.InnerText = $RemoveEntity
            $null = $EntityElement.AppendChild($NameElement)
        }
        if($ActionType -eq "Get" -and $PSBoundParameters.FilterValue) {

            switch ($PSBoundParameters.FilterCriteria) {
                Equals { $Criteria = '=' }
                NotEquals { $Criteria = '!=' }
                Like { $Criteria = 'like' }
                Default { $Criteria = '=' }
            }

            $filterNode = $ApiMessage.CreateNode("element", "Filter", $null)
            $filterElement = $ApiMessage.CreateElement("key")
            $filterElement.SetAttribute("name", "Name")
            $filterElement.SetAttribute("criteria", $Criteria)
            $filterElement.InnerText = $FilterValue
            $null = $filterNode.AppendChild($filterElement)
            $null = $EntityElement.AppendChild($filterNode)
        }

        $null = $ActionNode.AppendChild($EntityElement)
    }

    $null = $RequestNode.AppendChild($LoginNode)
    $null = $RequestNode.AppendChild($ActionNode)
    $null = $ApiMessage.AppendChild($RequestNode)

    return $ApiMessage
}