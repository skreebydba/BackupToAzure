#Connect-AzureRmAccount;
Set-Location SQLSERVER:\SQL\cncybook82\dev2017;

$rgname = 'fbgazurerg';
$storagename = 'fbgazure';
$credname = 'TestPsCred3';
$keynum = 'key1'

$key = Get-AzureRmStorageAccountKey -ResourceGroupName $rgname -Name $storagename | Where-Object {$_.KeyName -eq $keynum} | Select-Object -ExpandProperty Value;


$secretstring = ConvertTo-SecureString $key -AsPlainText -Force;

New-SqlCredential -Name $credname -Identity $storagename -Secret $secretstring;