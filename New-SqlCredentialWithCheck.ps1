function New-SqlCredentialWithCheck {
  <#
  .SYNOPSIS
  Check for the existence of a SQL credential on the instance specified
  .DESCRIPTION
  Check for the existence of a SQL credential on the instance specified. If the credential does not exist, create it.
  Get the storage requested storage key from the Azure Storage Account.
  .EXAMPLE
  New-SqlCredentialWithCheck -Server 'Server1' -Instance 'Dev' -Credential 'Cred1' -ResourceGroup 'Rg1' -StorageAccount 'Sa1' -KeyNumber 'Key1'; 
  .EXAMPLE
  New-SqlCredentialWithCheck -Server 'Server1' -Credential 'Cred1' -ResourceGroup 'Rg1' -StorageAccount 'Sa1' -KeyNumber 'Key1'; 
  .PARAMETER Server
  The SQL Server server.
  .PARAMETER Instance
  The SQL Server instance.
  .PARAMETER Credential
  The SQL Server credential.
  .PARAMETER ResourceGroup
  The Azure resource group.
  .PARAMETER StorageAccount
  The Azure storage account.
  .PARAMETER KeyNumber
  The Azure storage key required.
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What server is your SQL Server instance running on?')]
    [Alias('srv')]
    [ValidateLength(3,30)]
    [string]$Server,
    [Parameter(Mandatory=$False,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What is your SQL Server instance name?')]
    [Alias('inst')]
    [string]$Instance,
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What server is your SQL Server instance running on?')]
    [Alias('cred')]
    [ValidateLength(3,30)]
    [string]$Credential,
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What SQL credential do you want to use?')]
    [Alias('rg')]
    [ValidateLength(3,30)]
    [string]$ResourceGroup,
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What Azure resource group contains the Storage Account you are creating the credential for?')]
    [Alias('sa')]
    [ValidateLength(3,30)]
    [string]$StorageAccount,
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='Which storage key do you want to use?')]
    [Alias('key#')]
    [ValidateLength(3,30)]
    [string]$KeyNum
  )

process 
    {
        if(!$instance)
        {
            $instance = 'default';
            $serverinstance = $server;
        }
        else
        {
            $serverinstance = "$server\$instance";
        }
    
        Set-Location "SQLSERVER:\SQL\$server\$instance";


        $credcheck = Invoke-Sqlcmd -ServerInstance $serverinstance -Database 'master' -Query "SELECT name FROM sys.credentials WHERE name = '$credential';" |Select-Object -ExpandProperty Name;

        if(!$credcheck)
        {
            $key = Get-AzureRmStorageAccountKey -ResourceGroupName $rgname -Name $storagename | Where-Object {$_.KeyName -eq $keynum} | Select-Object -ExpandProperty Value;

            $secretstring = ConvertTo-SecureString $key -AsPlainText -Force;

            $credential = New-SqlCredential -Name $credential -Identity $storagename -Secret $secretstring;

            return ($credential.Replace('[','')).Replace(']','');
        }
        else
        {
            return $Credential;
        }
    }
}
  