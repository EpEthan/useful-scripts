<#

.Synopsis
gig - Download .gitignore files from www.toptal.com/developers/gitignore

.PARAMETER List
Whether to print all the options for .gitignore files
Aliases: Lst, L

.PARAMETER ToIgnore
The environments/langs you want in the .gitignore.
For example: 'VisualStudio,Csharp,Go'

.EXAMPLE
PS> gig -l

.EXAMPLE
PS> gig VisualStudio,Csharp

#> 

# Parameters
param(
    # Parameter to list all available options
    [Alias("lst", "l")]
    [switch] $List,

    [string[]] $ToIgnore,

    [string] $SavePath=$pwd
)

Function GetIgnore 
{
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




if ($List) {
    Write-Output "fuck you. i ain't doing this shit."
}
else {
    GetIgnore -lst $ToIgnore -path $SavePath
}