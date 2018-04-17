#Login-AzureRmAccount;

$StorageAccountName = "fbgazure"; 
$StorageAccountKey = "+i+72Kn5blMqIg/ic5FJ/El1NahGiF9Frhtd98Iu8J5GKXtGrgjXNIrsEuRWgseUYCtgHtC9jt/uDLGw095ltw==";

$ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey;

$ContainerName = “fbgazurecont”;

$blobs = Get-AzureStorageBlob -Container $ContainerName -Context $ctx | Select -ExpandProperty Name ;

$blobs; 

foreach($blob in $blobs)
{
    Remove-AzureStorageBlob -Blob $Blob -Container $ContainerName -Context $ctx;
}