$date = Get-Date -Format yyyyMMdd_HHmmss;
$credential = "BackupToAzure";
$instance = "cncybook82\dev2017";
$backuppath = "https://fbgazure.blob.core.windows.net/fbgazurecont";

$databases = (Get-SqlDatabase -ServerInstance $instance | Out-GridView -PassThru | Select-Object -Property Name).Name;

foreach($database in $databases)
{
    $backupfile = "$backuppath/$database`_$date.bak";

    #Write-Output $backupfile;
    Write-Output "Backup starting for " $database;

    Backup-SqlDatabase -ServerInstance $instance `
    -Database $database `
    -BackupAction Database `
    -BackupFile $backupfile `
    -SqlCredential $credential `
    -CompressionOption On;
}

