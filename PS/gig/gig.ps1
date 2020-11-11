<#

.SYNOPSIS
gig - Download .gitignore files from www.toptal.com/developers/gitignore

.DESCRIPTION
Download .gitignore file templates based on the given arguments, to a desired path.
If -List is passed, the list of available template options will be printed.

.PARAMETER List
Whether to print all the options for .gitignore files
Aliases: Lst, L

.PARAMETER ToIgnore
The environments/langs you want in the .gitignore.
For example: 'VisualStudio,Csharp,Go'

.PARAMETER SavePath
Where the .gitignore file should be saved.
Default value: $pwd

.INPUTS
You can pipe a path to the gig.ps1, to choose the path of the 
resulting .gitignore file.

.OUTPUTS
If you pass -List to gig.ps1, the program will output the list of 
available .gitignore template options.

.NOTES
  Version:        1.0
  Author:         Eitan Epstein
  Creation Date:  11/11/2020


.EXAMPLE
PS> gig -l

.EXAMPLE
PS> gig VisualStudio,Csharp


.LINK
https://github.com/EpEthan/useful-scripts/tree/main/PS/gig
More commands on GitHub: https://github.com/EpEthan/useful-scripts

#> 

#---------------------------------------------------------[Initialisations]--------------------------------------------------------

# Parameters
param(
    [Alias("lst", "l")]
    [switch] $List,
    
    [string[]] $ToIgnore,
    
    [Parameter(ValueFromPipeline = $true)]
    [string] $SavePath = $pwd
)


#----------------------------------------------------------[Declarations]----------------------------------------------------------

#Script Version
$sScriptVersion = "1.0"

#-----------------------------------------------------------[Functions]------------------------------------------------------------
Function Get-Ignore {
    param(
        [Parameter(Mandatory = $true)]
        [string[]]$lst,

        [string]$path
    )

    if ($lst.Count -eq 0 -or 
        $lst[0] -eq "") {
        Write-Error -Message "Variable ToIgnore was left empty." -ErrorAction Stop
    }
    
    # get list
    $params = ($lst | ForEach-Object { [uri]::EscapeDataString($_) }) -join ","

    # get .gitignore from web
    Invoke-WebRequest -Uri "https://www.toptal.com/developers/gitignore/api/$params" | 
    Select-Object -ExpandProperty content | 
    Out-File -FilePath $(Join-Path -path $path -ChildPath ".gitignore") -Encoding ascii
}



#-----------------------------------------------------------[Execution]------------------------------------------------------------


if ($List) {
    Write-Output "fuck you. i ain't doing this shit."
}
else {
    Get-Ignore -lst $ToIgnore -path $SavePath
}