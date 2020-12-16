 Param(
   [string]$computerName,
    [string]$path,
    [string]$filename
) #end param
try{
$session = new-pssession $computerName
}
catch{
    write-host "Failed to Connect"
    $session = $null
}
if ($session -ne $null){
Invoke-command -session $session -ScriptBlock {get-childitem -path $using:path -filter $using:filename -Recurse -Force | Select FullName | foreach-object {get-filehash $_.fullname | select *} }
remove-pssession $session
}
else {
    write-host "No Remote Session"
    break
}
