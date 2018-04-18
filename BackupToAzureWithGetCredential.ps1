$credential = 'TestPsCred3';
$date = Get-Date -Format yyyyMMdd_HHmmss;
$instance = "cncybook82\dev2017";
$backuppath = "https://fbgazure.blob.core.windows.net/fbgazurecont";
$rgname = 'fbgazurerg';
$storagename = 'fbgazure';
$keynum = 'key1'

Set-Location SQLSERVER:\SQL\cncybook82\dev2017;

$credcheck = Invoke-Sqlcmd -ServerInstance $instance -Database 'master' -Query "SELECT name FROM sys.credentials WHERE name = '$credential';" |Select-Object -ExpandProperty Name;

if(!$credcheck)
{
    $key = Get-AzureRmStorageAccountKey -ResourceGroupName $rgname -Name $storagename | Where-Object {$_.KeyName -eq $keynum} | Select-Object -ExpandProperty Value;

    $secretstring = ConvertTo-SecureString $key -AsPlainText -Force;

    $credential = New-SqlCredential -Name $credential -Identity $storagename -Secret $secretstring;
}

$databases = Get-SqlDatabase -ServerInstance $instance | Out-GridView -PassThru | Select-Object -ExpandProperty Name;

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