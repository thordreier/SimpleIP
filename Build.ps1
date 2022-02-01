<#PSScriptInfo
	.VERSION 0.3
	.GUID e0a6966d-65c7-4ed7-8f6c-417fb2d43c5f
	.AUTHOR Thor Dreier
	.COMPANYNAME Thor Dreier
	.COPYRIGHT This is free and unencumbered software released into the public domain
	.TAGS
	.LICENSEURI https://unlicense.org/
	.PROJECTURI https://github.com/thordreier/PowerShellModuleTools
	.ICONURI
	.EXTERNALMODULEDEPENDENCIES
	.REQUIREDSCRIPTS
	.EXTERNALSCRIPTDEPENDENCIES
	.RELEASENOTES
#>

<#
        .SYNOPSIS
            Build module

        .DESCRIPTION
            Build module - combine files to psm1, create psd1, zip it, ...

        .PARAMETER Path
            Path

        .EXAMPLE
            Invoke-ModuleBuild
    #>
param (
        [Parameter()]
        [String]
        $Path,

        [Parameter(ParameterSetName = 'JsonFile')]
        [String]
        $JsonFile = 'Build.json',

        [Parameter(ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline = $true)]
        [PSCustomObject]
        $InputObject,

        [Parameter(ParameterSetName = 'Module', Mandatory = $true)]
        [Switch]
        $Module,

        [Parameter(ParameterSetName = 'ScriptFromTemplate', Mandatory = $true)]
        [Switch]
        $ScriptFromTemplate,

        [Parameter(ParameterSetName = 'ScriptFromFunction', Mandatory = $true)]
        [Switch]
        $ScriptFromFunction,

        [Parameter()]
        [String]
        $SourceRoot = '.',

        [Parameter()]
        [String]
        $BuildRoot = 'Build',

        [Parameter()]
        [String]
        $ManifestFile = 'Manifest.psd1',

        [Parameter()]
        [String[]]
        $FunctionExportFile = @('FunctionExport\*.ps1'),

        [Parameter()]
        [String[]]
        $FunctionPrivateFile = @('FunctionPrivate\*.ps1'),

        [Parameter()]
        [String[]]
        $ClassFile = @('Class\*.ps1'),

        [Parameter()]
        [String[]]
        $AliasFile = @('Alias\*.ps1'),

        [Parameter()]
        [String[]]
        $ExtraPSFile = @('Include\*.ps1'),

        [Parameter()]
        [String]
        $IncludeFileDir = 'IncludeFile',

        [Parameter()]
        [Version]
        $Version,

        [Parameter()]
        [switch]
        $VersionAppendDate,

        [Parameter()]
        [Switch]
        $NoTrim,

        [Parameter()]
        [ScriptBlock[]]
        $BeforeZip = @(),

        [Parameter()]
        [ScriptBlock[]]
        $AfterZip = @(),

        [Parameter(ParameterSetName = 'Module')]
        [Parameter(ParameterSetName = 'ScriptFromTemplate', Mandatory = $true)]
        [Parameter(ParameterSetName = 'ScriptFromFunction', Mandatory = $true)]
        [String]
        $TargetName,

        [Parameter(ParameterSetName = 'Module')]
        [Parameter(ParameterSetName = 'ScriptFromTemplate')]
        [Parameter(ParameterSetName = 'ScriptFromFunction')]
        [Guid]
        $Guid,

        [Parameter(ParameterSetName = 'Module')]
        [Hashtable]
        $ManifestParameters = @{},

        [Parameter(ParameterSetName = 'ScriptFromTemplate', Mandatory = $true)]
        [String]
        $Template,

        [Parameter(ParameterSetName = 'ScriptFromFunction', Mandatory = $true)]
        [String]
        $Function,

        [Parameter(ParameterSetName = 'ScriptFromFunction')]
        [String[]]
        $HelperFunction = @(),

        [Parameter()]
        [Switch]
        $InstallModule,

        [Parameter()]
        [string]
        $InstallModulePath = 'CurrentUser'
    )


function Invoke-ModuleBuild
{
    <#
        .SYNOPSIS
            Build module

        .DESCRIPTION
            Build module - combine files to psm1, create psd1, zip it, ...

        .PARAMETER Path
            Path

        .EXAMPLE
            Invoke-ModuleBuild
    #>
    [CmdletBinding(DefaultParameterSetName = 'JsonFile')]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssignments',         'type', Justification='Variable IS used, ScriptAnalyzer is wrong')]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssignments',         'h',    Justification='Variable IS used, ScriptAnalyzer is wrong')]
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSPossibleIncorrectUsageOfAssignmentOperator', '',     Justification='I like assigning values to variables in if statements')]
    param (
        [Parameter()]
        [String]
        $Path,

        [Parameter(ParameterSetName = 'JsonFile')]
        [String]
        $JsonFile = 'Build.json',

        [Parameter(ParameterSetName = 'InputObject', Mandatory = $true, ValueFromPipeline = $true)]
        [PSCustomObject]
        $InputObject,

        [Parameter(ParameterSetName = 'Module', Mandatory = $true)]
        [Switch]
        $Module,

        [Parameter(ParameterSetName = 'ScriptFromTemplate', Mandatory = $true)]
        [Switch]
        $ScriptFromTemplate,

        [Parameter(ParameterSetName = 'ScriptFromFunction', Mandatory = $true)]
        [Switch]
        $ScriptFromFunction,

        [Parameter()]
        [String]
        $SourceRoot = '.',

        [Parameter()]
        [String]
        $BuildRoot = 'Build',

        [Parameter()]
        [String]
        $ManifestFile = 'Manifest.psd1',

        [Parameter()]
        [String[]]
        $FunctionExportFile = @('FunctionExport\*.ps1'),

        [Parameter()]
        [String[]]
        $FunctionPrivateFile = @('FunctionPrivate\*.ps1'),

        [Parameter()]
        [String[]]
        $ClassFile = @('Class\*.ps1'),

        [Parameter()]
        [String[]]
        $AliasFile = @('Alias\*.ps1'),

        [Parameter()]
        [String[]]
        $ExtraPSFile = @('Include\*.ps1'),

        [Parameter()]
        [String]
        $IncludeFileDir = 'IncludeFile',

        [Parameter()]
        [Version]
        $Version,

        [Parameter()]
        [switch]
        $VersionAppendDate,

        [Parameter()]
        [Switch]
        $NoTrim,

        [Parameter()]
        [ScriptBlock[]]
        $BeforeZip = @(),

        [Parameter()]
        [ScriptBlock[]]
        $AfterZip = @(),

        [Parameter(ParameterSetName = 'Module')]
        [Parameter(ParameterSetName = 'ScriptFromTemplate', Mandatory = $true)]
        [Parameter(ParameterSetName = 'ScriptFromFunction', Mandatory = $true)]
        [String]
        $TargetName,

        [Parameter(ParameterSetName = 'Module')]
        [Parameter(ParameterSetName = 'ScriptFromTemplate')]
        [Parameter(ParameterSetName = 'ScriptFromFunction')]
        [Guid]
        $Guid,

        [Parameter(ParameterSetName = 'Module')]
        [Hashtable]
        $ManifestParameters = @{},

        [Parameter(ParameterSetName = 'ScriptFromTemplate', Mandatory = $true)]
        [String]
        $Template,

        [Parameter(ParameterSetName = 'ScriptFromFunction', Mandatory = $true)]
        [String]
        $Function,

        [Parameter(ParameterSetName = 'ScriptFromFunction')]
        [String[]]
        $HelperFunction = @(),

        [Parameter()]
        [Switch]
        $InstallModule,

        [Parameter()]
        [string]
        $InstallModulePath = 'CurrentUser'
    )

    begin
    {
        Write-Verbose -Message 'Begin'
        $originalErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = 'Stop'

        # Error in this is terminating
        $null = Add-Type -AssemblyName 'System.IO.Compression.FileSystem'

        # Error in this is terminating
        if ($Path)
        {
            Write-Verbose -Message "cd $Path"
            Push-Location -Path $Path -StackName Invoke-ModuleBuild
            $null = $PSBoundParameters.Remove('Path')
        }

        # Get System.IO.FileInfo object from strings
        # Paths is relative to $SourceRoot (unless it's a full path)
        # Don't want to show errors if directory doesn't exist
        function GetFileInfo ([String[]] $Path)
        {
            foreach ($p in $Path)
            {
                if (-not [System.IO.Path]::IsPathRooted($p))
                {
                    $p = Join-Path -Path $SourceRoot -ChildPath $p
                }
                Get-Item -Path $p -ErrorAction SilentlyContinue | Where-Object -FilterScript {$_ -is [System.IO.FileInfo]}
            }
        }

        # Map info from GetFileInfo() in to hashtable
        # Key is BaseName (filename without extension). Fail if multiple files with same basename is found
        function GetFileInfoMap ([String[]] $Path)
        {
            $h = @{}
            foreach ($p in (GetFileInfo @PSBoundParameters))
            {
                $null = $h.Add($p.BaseName, $p)
            }
            $h
        }

        # Create new directory - rename existing if that exist
        function CreateDirectory ($Path)
        {
            if (Test-Path -Path $Path)
            {
                Move-Item -Path $Path -Destination ($Path + ('_old_{0}' -f (Get-Date -Format yyyyMMddTHHmmssffff)))
            }
            New-Item -ItemType Directory -Path $Path
        }

        # Create file with content
        # Return System.IO.FileInfo
        function CreateFile ([String] $Dir, [String] $Name, [String] $Content, [Switch] $NoTrim)
        {
            if ($Dir)
            {
                $Name = Join-Path -Path $Dir -ChildPath $Name
            }
            if (-not $NoTrim)
            {
                # Trim trailing spaces
                $Content = $Content -replace '( |\t)+((\r)?\n|$)','$2'
            }
            Set-Content -Path $Name -Value $Content
            Get-Item -Path $Name
        }

        # Easy join multiple parts of a path
        function JoinPath ([array] $Path)
        {
            if ($Path.Length -gt 1)
            {
                Join-Path -Path $Path[0] -ChildPath (JoinPath -Path ($Path | Select-Object -Skip 1))
            }
            else
            {
                $Path
            }
        }
    }

    process
    {
        Write-Verbose -Message "Process (ParameterSetName: $($PSCmdlet.ParameterSetName))"
        Write-Verbose -Message ("PSBoundParameters: " + (ConvertTo-Json -Depth 1 -InputObject $PSBoundParameters))
        try
        {
            if ($PSCmdlet.ParameterSetName -eq 'JsonFile')
            {
                # Convert JSON to object
                # Raise error if -JsonFile was specified and if the file does not exist
                # Show warning an continue with empty object if JSON file isn't found but -JsonFile wasn't specified
                $throw = $PSBoundParameters.Remove('JsonFile')
                try
                {
                    $json = Get-Content -Path $JsonFile -Raw
                    Write-Verbose -Message "Input JSON: $json"
                    if (-not ($objects = $json | ConvertFrom-Json))
                    {
                        Write-Error -Message 'No objects found in JSON'
                    }

                }
                catch
                {
                    if ($throw)
                    {
                        Write-Error -Exception $_.Exception
                    }
                    else
                    {
                        Write-Warning -Message "Problems with <$JsonFile>: $_"
                        $objects = New-Object -TypeName PSCustomObject
                    }
                }

                # Call recursive (with -InputObject implicit)
                Write-Verbose -Message ("Call recursive: " + (ConvertTo-Json -Depth 1 -InputObject $PSBoundParameters))
                $objects | & $PSCmdlet.MyInvocation.MyCommand.Name @PSBoundParameters
            }
            elseif ($PSCmdlet.ParameterSetName -eq 'InputObject')
            {
                # Merge data from InputObject and parameters (PSBoundParameters)
                # parameters normally override info from InputObject (BeforeZip/AfterZip get merged)
                # Call recursive
                # PSBoundParameters needs to be cloned, else it's the same each time process is run
                Write-Verbose -Message ("Input object: " + (ConvertTo-Json -Depth 1 -InputObject $InputObject))
                $params = ([Hashtable] $PSBoundParameters).Clone()
                $null = $params.Remove('InputObject')
                $type = 'Module'

                # If we don't cast it as [PSCustomObject] then piping hashtables will show error (A parameter cannot be found that matches parameter name 'SyncRoot')
                ([PSCustomObject] $InputObject).PSObject.Properties  | ForEach-Object -Process {
                    Write-Verbose -Message "Processing object property $($_.Name)"
                    if ($_.Name -eq 'Type')
                    {
                        # Module, ScriptFromTemplate or ScriptFromFunction - Module is default
                        $type = $_.Value
                    }
                    elseif (@('BeforeZip', 'AfterZip').Contains($_.Name))
                    {
                        # Commands defined in JSON comes first in array
                        if (-not $params[$_.Name])
                        {
                            # Empty array not $null
                            $params[$_.Name] = @()
                        }
                        # If BeforeZip/AfterZip comes from commandline it's ScriptBlock, if it comes from JSON it's a string
                        $params[$_.Name] = @($_.Value | ForEach-Object -Process {[ScriptBlock]::Create($_)}) + $params[$_.Name]
                    }
                    elseif (@('ManifestParameters').Contains($_.Name))
                    {
                        # Convert object to hashtable - only one level
                        # ConvertFrom-Json never return Hashtable, only PSCustomObject
                        # For now it's only ManifestParameters that get's converted
                        $params.Add($_.Name, ($_.Value.PSObject.Properties | ForEach-Object -Begin {$h=@{}} -Process {$h[$_.Name]=$_.Value} -End {$h}))
                    }
                    else
                    {
                        # parameters override info from InputObject
                        try
                        {
                            $params.Add($_.Name, $_.Value)
                        }
                        catch
                        {
                            Write-Verbose -Message "<$($_.Name)> is defined both as parameter and in object"
                        }
                    }
                }

                # Module, ScriptFromTemplate or ScriptFromFunction is a switch
                $params[$type] = $true

                # Call recursive
                Write-Verbose -Message ("Call recursive: " + (ConvertTo-Json -Depth 1 -InputObject $params))
                & $PSCmdlet.MyInvocation.MyCommand.Name @params
            }
            elseif ($PSCmdlet.ParameterSetName -eq 'ScriptFromFunction')
            {
                $templateContent  = (.{
                    "<#PSScriptInfo"
                    "`t.VERSION {{var:Version}}"
                    "`t.GUID {{var:Guid}}"
                    "`t.AUTHOR {{manifest:Author}}"
                    "`t.COMPANYNAME {{manifest:CompanyName}}"
                    "`t.COPYRIGHT {{manifest:Copyright}}"
                    "`t.TAGS {{manifest:PrivateData.PSData.Tags}}"
                    "`t.LICENSEURI {{manifest:PrivateData.PSData.LicenseUri}}"
                    "`t.PROJECTURI {{manifest:PrivateData.PSData.ProjectUri}}"
                    "`t.ICONURI {{manifest:PrivateData.PSData.IconUri}}"
                    "`t.EXTERNALMODULEDEPENDENCIES {{manifest:PrivateData.PSData.ExternalModuleDependencies}}"
                    "`t.REQUIREDSCRIPTS "
                    "`t.EXTERNALSCRIPTDEPENDENCIES "
                    "`t.RELEASENOTES {{manifest:PrivateData.PSData.ReleaseNotes}}"
                    "#>"
                    ""
                    "{{function:$($Function):help}}"
                    "{{function:$($Function):param}}"
                    ""
                    ""
                    $HelperFunction | ForEach-Object -Process {"{{function:$($_)}}"}
                    "{{function:$($Function)}}"
                    ""
                    "$($Function) @PSBoundParameters"

                }) -join "`r`n"

                $tmp = New-TemporaryFile
                Set-Content -Path $tmp -Value $templateContent

                # Remove/add parameters
                @('ScriptFromFunction', 'Function', 'HelperFunction') | ForEach-Object -Process {
                    $null = $PSBoundParameters.Remove($_)
                }
                $PSBoundParameters['ScriptFromTemplate'] = $true
                $PSBoundParameters['Template'] = $tmp

                # Call recursive
                Write-Verbose -Message ("Call recursive: " + (ConvertTo-Json -Depth 1 -InputObject $PSBoundParameters))
                & $PSCmdlet.MyInvocation.MyCommand.Name @PSBoundParameters
            }
            else
            {
                # Every external value in here comes as parameter ($PSBoundParameters). JSON has been converted to a paramter
                Write-Verbose -Message ("Input params: " + (ConvertTo-Json -Depth 1 -InputObject $PSBoundParameters))

                # We assume that a function/class can be found in a file with the same name! This COULD be changed in future version
                # Hashtable: key is BaseName, value is System.IO.FileInfo
                $functionsExport  = GetFileInfoMap -Path  $FunctionExportFile
                $functions        = GetFileInfoMap -Path ($FunctionPrivateFile + $FunctionExportFile)
                $classes          = GetFileInfoMap -Path  $ClassFile
                $aliases          = GetFileInfoMap -Path  $AliasFile

                # (Array of) System.IO.FileInfo
                $psFiles          = GetFileInfo    -Path ($ClassFile + $FunctionPrivateFile + $FunctionExportFile + $AliasFile + $ExtraPSFile)
                $manifestFileInfo = GetFileInfo    -Path $ManifestFile

                # Manifest files are just PowerShell code containing one hashtable and can therefore be parsed by just running the content (is this secure!?)
                $manifest         = & ([ScriptBlock]::Create(('' + ($manifestFileInfo | Get-Content -Raw))))

                # TODO: Shoud we create a class instead of using PSCustomObject
                # This object is sent to BeforeZip/AfterZip
                $variables = [PSCustomObject] @{
                    Type            = $PSCmdlet.ParameterSetName
                    TargetName      = $null
                    TargetDirectory = $null
                    Guid            = $null
                    Version         = $null
                    FunctionsExport = $null # Module
                    Functions       = $null # Module
                    Classes         = $null # Module
                    Aliases         = $null # Module
                    Psm1            = $null # Module
                    Psd1            = $null # Module
                    Ps1             = $null # ScriptFromTemplate or ScriptFromFunction
                    TargetZip       = $null
                }

                # TargetName
                if (-not ($variables.TargetName = $TargetName))
                {
                    if ($variables.Type -eq 'Module')
                    {
                        if ($manifest.RootModule)
                        {
                            $variables.TargetName = $manifest.RootModule -replace '\.psm1$'
                        }
                        else
                        {
                            $variables.TargetName = (Get-Location | Get-Item).Name
                        }
                    }
                    else
                    {
                        Write-Error -Message 'TargetName not defined'
                    }
                }

                # TargetDirectory
                $variables.TargetDirectory = CreateDirectory -Path (Join-Path -Path $BuildRoot -ChildPath $variables.TargetName)

                # Guid
                if ($Guid)
                {
                    $variables.Guid = $Guid
                }
                elseif ($manifest.Guid -and $variables.Type -eq 'Module')
                {
                    $variables.Guid = $manifest.Guid
                }
                else
                {
                    $variables.Guid = [Guid]::NewGuid()
                }

                # Version
                if ($Version)
                {
                    $variables.Version = [version] $Version
                }
                elseif ($manifest.ModuleVersion)
                {
                    $variables.Version = [version] $manifest.ModuleVersion
                }
                else
                {
                    $variables.Version = [version] '0.1'
                }
                if ($VersionAppendDate)
                {
                    $variables.Version = [version]::new($variables.Version.Major, $variables.Version.Minor, (Get-Date -Format yyyyMMdd), (Get-Date -Format HHmmss))
                }

                if ($PSCmdlet.ParameterSetName -eq 'Module')
                {
                    $variables.FunctionsExport = [String[]] @($functionsExport.Keys)
                    $variables.Functions       = [String[]] @($functions.Keys)
                    $variables.Classes         = [String[]] @($classes.Keys)
                    $variables.Aliases         = [String[]] @($aliases.Keys)

                    # All ps1 files concenated and som Exporte-ModuleMember in the bottom
                    # Order of ps1 files is seen when $psFiles is defined
                    $psm1Content  = (.{
                        $psFiles                   | ForEach-Object -Process {Get-Content -Raw -Path $_}
                        $variables.FunctionsExport | ForEach-Object -Process {"Export-ModuleMember -Function $_"}
                        $variables.Aliases         | ForEach-Object -Process {"Export-ModuleMember -Alias    $_"}
                    }) -join "`r`n"

                    # Create module file
                    $variables.Psm1 = CreateFile -Dir $variables.TargetDirectory -Name "$($variables.TargetName).psm1" -Content $psm1Content -NoTrim:$NoTrim

                    # Include extra files
                    if (Test-Path -Path $IncludeFileDir)
                    {
                        Copy-Item -Recurse -Path (JoinPath $IncludeFileDir,'*') -Destination $variables.TargetDirectory
                    }

                    $psd1Tmp = Join-Path -Path $variables.TargetDirectory -ChildPath tmp.psd1
                    if ($manifestFileInfo)
                    {
                        Copy-Item -Path $manifestFileInfo -Destination $psd1Tmp
                    }
                    else
                    {
                        New-ModuleManifest -Path $psd1Tmp
                    }

                    # Update ReleaseNotes with git info
                    if (-not $ManifestParameters['ReleaseNotes'])
                    {
                        try
                        {
                            if ($gitCommit = git rev-parse HEAD)
                            {
                                if ($gitStatus = git status -s)
                                {
                                    Write-Warning -Message ($ManifestParameters['ReleaseNotes'] = "git commit $gitCommit (with uncommitted changes)")
                                }
                                else
                                {
                                    $ManifestParameters['ReleaseNotes'] = "git commit $gitCommit"
                                }
                            }
                            else
                            {
                                throw
                            }
                        }
                        catch
                        {
                            Write-Verbose -Message 'Not adding git commit id to release note, maybe git is not installed'
                        }
                    }

                    # ManifestParameters come as hashtable from parameter. Add other values
                    # - but not if they are $null/$false and not if parameter already come from command line (-Path is an exception)
                    $ManifestParameters['Path'] = $psd1Tmp
                    @{
                        ModuleVersion     = $variables.Version
                        AliasesToExport   = $variables.Aliases
                        FunctionsToExport = $variables.FunctionsExport
                        Guid              = $variables.Guid
                        RootModule        = $variables.Psm1.Name
                    }.GetEnumerator() | ForEach-Object -Process {
                        if ($_.Value -and -not $ManifestParameters.ContainsKey($_.Key))
                        {
                            $ManifestParameters.Add($_.Key, $_.Value)
                        }
                    }
                    Update-ModuleManifest @ManifestParameters

                    # Manifest
                    $psd1Content = Get-Content -Path $psd1Tmp -Raw
					Remove-Item -Path $psd1Tmp
                    if (-not $NoTrim)
                    {
                        # Update-ModuleManifest produces nice comments for each setting, but top comments about who ran the command and such will be stripped
                        $psd1Content = $psd1Content -replace '^(#.*(\r?\n)+)*',''
                    }
                    $variables.Psd1 = CreateFile -Dir $variables.TargetDirectory -Name "$($variables.TargetName).psd1" -Content $psd1Content -NoTrim:$NoTrim
                }
                elseif ($PSCmdlet.ParameterSetName -eq 'ScriptFromTemplate')
                {
                    # Replace all {{xxx}}, {{xxx:yyy}}, ... - run though ScriptBlock that will return replaced text
                    $ps1Content = ([Regex] '\{\{((:?([\w\\\*\.-]+))+)\}\}').Replace((Get-Content -Path $Template -Raw), {
                        # TODO: Decide if we should throw on errors or just show warnings?
                        # Not using param() but $args instead. If using param() we don't have access to $PSBoundParameters for main function

                        # $m is like $Matches, $v is an array: '{{xxx:yyy:zzz}}' will be @('xxx','yyy','zzz')
                        $m = $args[0]
                        $fullReplace = $m.Groups[0]
                        Write-Verbose -Message "Replacing $fullReplace"
                        $v = @($m.Groups[3].Captures.Value)

                        if ($v[0] -eq 'function')
                        {
                            # {{function:xxx}} / {{function:xxx:param}} / {{function:xxx:help}}
                            # We still assume one function == one file
                            if ($functions.Contains($v[1]))
                            {
                                $f = $functions[$v[1]] | Get-Content -Raw
                                if (-not $v[2])
                                {
                                    # no third block, just return function (content of file)
                                    $f
                                }
                                else
                                {
                                    # TODO: this isn't bulletproof
                                    $astTokens = $astErr = $null
                                    $ast = [System.Management.Automation.Language.Parser]::ParseInput($f, [ref] $astTokens, [ref] $astErr)
                                    if ($astErr)
                                    {
                                        Write-Warning -Message "Error parsing AST. Not replacing $fullReplace."
                                    }
                                    else
                                    {
                                        try
                                        {
                                            if ($v[2] -eq 'param')
                                            {
                                                # params() block from function
                                                # TODO make it work with function F ($xx) type of parameter
                                                $ast.EndBlock.Statements[0].Body.ParamBlock.Extent.Text
                                            }
                                            elseif ($v[2] -eq 'help')
                                            {
                                                # TODO: This only works with <# #> in beginning - not in end of function or with # on each line
                                                # and we just take the first comment - not follow rules in (eg. max one line break, parameter help can come from comment above parameter, ...)
                                                # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help
                                                $astTokens.Where({$_.Kind -eq 'Comment'}).Item(0).Text
                                            }
                                            else
                                            {
                                                Write-Warning -Message "$($v[2]) is an unkown third option to function"
                                            }
                                        }
                                        catch
                                        {
                                            Write-Warning -Message "Not able to get $($v[2]) from function $($v[1])"
                                        }
                                    }
                                }
                            }
                            else
                            {
                                Write-Warning -Message "No file found with function name $($v[1])"
                            }
                        }
                        elseif ($v[0] -eq 'var')
                        {
                            # {{var:xxx}}
                            if ($variables.($v[1]))
                            {
                                $variables.($v[1])
                            }
                            else
                            {
                                Get-Variable -Name $v[1] -ValueOnly
                            }
                        }
                        elseif ($v[0] -eq 'manifest' -or $v[0] -eq 'param')
                        {
                            # {{manifest:xxx.yyy.zzz}} / {{param:xxx.yyy.zzz}}
                            if ($v[0] -eq 'manifest')
                            {
                                $value = $manifest
                            }
                            elseif ($v[0] -eq 'param')
                            {
                                $value = $PSBoundParameters
                            }
                            foreach ($key in ($v[1] -split '\.'))
                            {
                                $value = $value[$key]
                            }
                            $value
                        }
                        elseif ($v[0] -eq 'file')
                        {
                            # {{file:dir\file.txt}}
                            (GetFileInfo -Path $v[1] | Get-Content -Raw) -join "`r`n"
                        }
                    })

                    # Module file
                    $variables.Ps1 = CreateFile -Dir $variables.TargetDirectory -Name "$($variables.TargetName).ps1" -Content $ps1Content -NoTrim:$NoTrim
                }
                else
                {
                    throw "Unknown ParameterSetName: $($PSCmdlet.ParameterSetName) - this should never happen - will come up as missed in Invoke-Pester -CodeCoverage"
                }

                # User defined ScriptBlock's. The second ForEach-Object is just to get $variables become $_ inside the ScriptBlock
                $BeforeZip | ForEach-Object -Process {$variables | ForEach-Object -Process $_}

                # Rename existing zip if that exist
                $targetZip = "$($variables.TargetDirectory)-$($variables.Version).zip"
                if (Test-Path -Path $targetZip)
                {
                    Move-Item -Path $targetZip -Destination ($targetZip -replace '.zip$',('_old_{0}.zip' -f (Get-Date -Format yyyyMMddTHHmmssffff)))
                }

                # Zip
                [System.IO.Compression.ZipFile]::CreateFromDirectory($variables.TargetDirectory, $targetZip)
                $variables.TargetZip = Get-Item -Path $targetZip

                # User defined ScriptBlock's. The second ForEach-Object is just to get $variables become $_ inside the ScriptBlock
                $AfterZip | ForEach-Object -Process {$variables | ForEach-Object -Process $_}

                function JoinPath ([array] $Path)
                {
                    if ($Path.Length -gt 1)
                    {
                        Join-Path -Path $Path[0] -ChildPath (JoinPath -Path ($Path | Select-Object -Skip 1))
                    }
                    else
                    {
                        $Path
                    }
                }

                # Install module
                if ($PSCmdlet.ParameterSetName -eq 'Module')
                {
                    if ($InstallModule)
                    {
                        $importModule = $false
                        if (@('AllUsers','CurrentUser') -contains $InstallModulePath)
                        {
                            $importModule = $true
                            $InstallModulePath = JoinPath @(
                                &{if ($InstallModulePath -eq 'AllUsers') {$env:ProgramFiles} else {[Environment]::GetFolderPath('MyDocuments')}}
                                &{if ($PSVersionTable.ContainsKey('PSEdition') -and $PSVersionTable.PSEdition -eq 'Core') {'PowerShell'} else {'WindowsPowerShell'}}
                                'Modules'
                                $variables.TargetName
                                $variables.Version
                            )
                        }
                        Write-Verbose -Message "Installing module in $InstallModulePath"
                        $moduleInstallDir = CreateDirectory -Path $InstallModulePath
                        [System.IO.Compression.ZipFile]::ExtractToDirectory($variables.TargetZip.FullName, $moduleInstallDir.FullName)
                        if ($importModule)
                        {
                            Write-Verbose -Message "Importing module $($variables.TargetName) version $($variables.Version)"
                            Remove-Module -Name $variables.TargetName -ErrorAction SilentlyContinue -Force
                            Import-Module -Name $variables.TargetName -RequiredVersion $variables.Version
                        }
                    }
                }
            }
        }
        catch
        {
            # If error was encountered inside this function then stop doing more
            # But still respect the ErrorAction that comes when calling this function
            # And also return the line number where the original error occured in verbose output
            Write-Verbose -Message "Detailed error info: $_`r`n$($_.InvocationInfo.PositionMessage)"
            Write-Error -ErrorAction $originalErrorActionPreference -Exception $_.Exception
        }
    }

    end
    {
        if ($Path)
        {
            Pop-Location -StackName Invoke-ModuleBuild -ErrorAction SilentlyContinue
        }

        Write-Verbose -Message 'End'
    }
}


Invoke-ModuleBuild @PSBoundParameters


