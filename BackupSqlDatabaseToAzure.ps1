function Backup-SqlDatabaseToAzure {
  <#
  .SYNOPSIS
  Backup one or more databases from a SQL Server instance to Azure Blob Storage
  .DESCRIPTION
  The function takes a SQL Server instance as input and displays a grid of all of the databases on that instance.  The user selects the databases to be backed up and the
  function loops through the databases selected and backs them up to the Azure Blob Storage container specified.
  .EXAMPLE
  Backup-SqlDatabaseToAzure -instance "cncybook82\dev2017" -container "https://fbgazure.blob.core.windows.net/fbgazurecont" -credential "BackupToAzure";
  .PARAMETER instance
  The SQL Server instance to back up from. Just one.
  .PARAMETER container
  The Azure Blob Storage container to backup to.
  #>
  [CmdletBinding(SupportsShouldProcess=$True,ConfirmImpact='Low')]
  param
  (
    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What SQL Server instance are you backing up from?')]
    [Alias('sqlinst')]
    [ValidateLength(3,255)]
    [string]$instance,

    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What Azure Blob Storage container are you backing up to?')]
    [Alias('blob')]
    [ValidateLength(3,255)]
    [string]$container,

    [Parameter(Mandatory=$True,
    ValueFromPipeline=$True,
    ValueFromPipelineByPropertyName=$True,
      HelpMessage='What SQL Server credential are you using?')]
    [Alias('cred')]
    [ValidateLength(3,255)]
    [string]$credential
		
  )

  process {
            $date = Get-Date -Format yyyyMMdd_HHmmss;
            $databases = Get-SqlDatabase -ServerInstance $instance | Out-GridView -PassThru | Select-Object -ExpandProperty Name;

            foreach($database in $databases)
            {
                $backupfile = "$container/$database`_$date.bak";

                #Write-Output $backupfile;
                Write-Output "Backup starting for " $database;

                Backup-SqlDatabase -ServerInstance $instance `
                -Database $database `
                -BackupAction Database `
                -BackupFile $backupfile `
                -SqlCredential $credential `
                -CompressionOption On;
            }
    }
}
