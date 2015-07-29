# Generate install and migartion scripts:
$INPUTDir = $PSScriptRoot
$dbname = "LCCHPImport"

#$OUTPUT = "D:\DBSpace\DB\MigrationScripts\Tested\ImportDB.ps1"
$OUTPUT = $INPUTDir + "\ImportDB.ps1"

$OUTPUTDir = $INPUTDir + "\OUTPUT"

write-host "InputDirectory: $InputDir"
write-host "DBName: $dbname"
write-host "OUTPUT: $OUTPUT"
write-host "OutputDir: $OUTPUTDir"

# Create the output directory if it doesn't exist
If (!($OUTPUTDir)) { New-Item -ItemType Directory -Force -Path $OUTPUTDir }

# Delete the import script if it already exists
IF (Test-Path $OUTPUT)
{ Remove-Item -Path $OUTPUT
}

# Create script to run each .sql file
foreach ($file in (Get-ChildItem $INPUTDir -File -filter *.sql)) 
{ $CMD = "SQLCMD.EXE -S .\SQL2012 -E -i "+$file.FullName +" -o "+$OUTPUTDIR+"\"+$file.Basename+".txt -d $dbname"
    Write-Host $CMD
    Add-Content -Path $OUTPUT -Value $CMD

};