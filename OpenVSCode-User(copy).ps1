
$folderFile = "path"

# Read the folder path
if (-Not (Test-Path $folderFile)) {
    Write-Host "Folder file not found: $folderFile"
    exit
}

$Folder = Get-Content $folderFile | Select-Object -First 1


# Full path to VSCode executable
$VSCodePath = "path"

# Launch VSCode in the specified folder
Start-Process $VSCodePath -ArgumentList $Folder