# Generate install and migartion scripts:
$INPUTDir = "C:\temp\lCCHP\TestedMigrationScripts\"
$dbname = "LCCHPTestImport"

#$OUTPUT = "D:\DBSpace\DB\MigrationScripts\Tested\ImportDB.ps1"
$OUTPUT = "C:\temp\lCCHP\TestedMigrationScripts\ImportDB.ps1"

$OUTPUTDir = $INPUTDir + "OUTPUT"

# Create the output directory if it doesn't exist
If (!($OUTPUTDir)) { New-Item -ItemType Directory -Force -Path $OUTPUTDir }

# Delete the import script if it already exists
IF (Test-Path $OUTPUT)
{ Remove-Item -Path $OUTPUT
}

# Create script to run each .sql file
foreach ($file in (Get-ChildItem $INPUTDir -File -filter *.sql)) 
{ $CMD = "SQLCMD.EXE -E -i "+$file.FullName +" -o "+$OUTPUTDIR+"\"+$file.Basename+".txt -d $dbname"
    Write-Host $CMD
    Add-Content -Path $OUTPUT -Value $CMD

};