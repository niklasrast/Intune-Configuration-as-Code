<#

.COPYRIGHT
Copyright (c) Niklas Rast.
Version 14-07-2023

.DOCUMENTATION
<<<FOLLOWING SOON>>>
#>

####################################################
# Script Parameters
Param (
  [Parameter (Mandatory= $true)]
  [String] $clientId,
  [Parameter (Mandatory= $true)]
  [String] $clientSecret,
  [Parameter (Mandatory= $true)]
  [String] $tenantId
)

####################################################
# Settings
$ErrorActionPreference = "SilentlyContinue"

####################################################
# MS Graph Module Install, Update & Connect
if (Get-Module -ListAvailable -Name Microsoft.Graph) {
  Import-Module -Name Microsoft.Graph
  Write-Host "Imported Microsoft.Graph Module" -ForegroundColor Green
} 
else {
  Install-Module -Name Microsoft.Graph
  Import-Module -Name Microsoft.Graph
  Write-Host "Installed and Imported Microsoft.Graph Module" -ForegroundColor Green
}

$latestMSGraphModule = Find-Module -Name Microsoft.Graph -AllVersions -AllowPrerelease | select-Object -First 1
$currentMSGraphModule = Get-InstalledModule | Where-Object {$_.Name -eq "Microsoft.Graph"}

If ($latestMSGraphModule.version -gt $currentMSGraphModule.version) {
    try {Update-Module -Name Microsoft.Graph -RequiredVersion $latestMSGraphModule.version -AllowPrerelease
         Write-host "Microsoft Graph PowerShell updated" $latestMSGraphModule.Version -ForegroundColor Green}
    catch {Write-Host "Unable to update Microsoft Graph" -ForegroundColor Red}
} else {
    write-host "Latest version already installed" -ForegroundColor yellow
}

$clientSecretPassword = ConvertTo-SecureString -String $clientSecret -AsPlainText -Force
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $clientSecretPassword
Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential