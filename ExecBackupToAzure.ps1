$credential = "BackupToAzure";
$instance = "cncybook82\dev2017";
$backuppath = "https://fbgazure.blob.core.windows.net/fbgazurecont";

Backup-SqlDatabaseToAzure -instance $instance -container $backuppath -credential $credential;

#Get-SqlDatabase -ServerInstance $instance | Select-Object -ExpandProperty Name | Where-Object {$_.Name -ne "tempdb"};

 