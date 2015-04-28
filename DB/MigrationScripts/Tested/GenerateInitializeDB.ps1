# Generate install and migartion scripts:
$ListofFiles = Get-ChildItem D:\DBSpace\DB\MigrationScripts\Tested -File | % { $_.Fullname }

$OUTPUT = "D:\DBSpace\DB\MigrationScripts\Tested\ImportDB.ps1"

foreach ($file in $ListofFiles) 
{ $outputFile = $file -replace ".sql", ".txt"
  $outputFile = $outputFile -replace "Tested", "Tested\Output"

Write-Host "SQLCMD.EXE -E -i " $file " -o "$outputFile


};