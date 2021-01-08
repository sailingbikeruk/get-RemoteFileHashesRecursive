Param(
    [string]$computerName,
    [string]$path,
    [string]$filename
) #end param

$computerName = ""
$path = "C:\"
$filename = "*.txt"
$hashes = @()

$path = ".\"
$filename = "*"

if ($path -eq "" -or $Filename -eq "") {
    write-host "The script requires a path and filename please start the script with the following syntax" -ForegroundColor red
    write-host "./Get-FileHashesRecursive -computername <fqdn of remote host> -path <root of path to recurse through> -filename <file name or pattern>" -ForegroundColor Red
    break
}
if ($computername -eq "") {
    Write-Host "No remote host was entered, running script on local machine" -ForegroundColor Yellow
    try { 
        $hashes += get-childitem -path $path -filter $filename -Recurse -Force | Select FullName | foreach-object { get-filehash $_.fullname | select * }
    }
    catch{

    }
}
else {
    try {
        $session = new-pssession $computerName
    }
    catch {
        write-host "Failed to Connect to $ComputerName" -ForegroundColor Red
        write-host "the error was $_"
        $session = $null
        break
    }
    if ($session -ne $null) {
        Invoke-command -session $session -ScriptBlock { get-childitem -path $using:path -filter $using:filename -Recurse -Force | Select FullName | foreach-object { get-filehash $_.fullname | select * } }
        remove-pssession $session
    }
    else {
        write-host "No Remote Session" -ForegroundColor Red
        break
    }
}

$hashes
