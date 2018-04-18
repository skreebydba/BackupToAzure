#Login-AzureRmAccount;

$StorageAccountName = "fbgazure"; 
$StorageAccountKey = "+i+72Kn5blMqIg/ic5FJ/El1NahGiF9Frhtd98Iu8J5GKXtGrgjXNIrsEuRWgseUYCtgHtC9jt/uDLGw095ltw==";

$ctx = New-AzureStorageContext -StorageAccountName $StorageAccountName -StorageAccountKey $StorageAccountKey;

$ContainerName = “fbgazurecont”;

$blobs = Get-AzureStorageBlob -Container $ContainerName -Context $ctx | Select -Property Name, LastModified ;

$blobs; 

$now = (Get-Date).AddMinutes(-15);


foreach($blob in $blobs)
{
    if($blob.LastModified -lt $now)
    {
        Remove-AzureStorageBlob -Blob $Blob.Name -Container $ContainerName -Context $ctx;
    }

    
}