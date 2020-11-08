#-----------------Global variables--------------------------
Write-Host "Getting things ready...";
$ErrorActionPreference = "silentlyContinue";
$DownloadDir = Get-ChildItem -Path C:\Users -Filter "Downloads" -Recurse | Where-Object {$_.PSIsContainer} | Select-Object -ExpandProperty Fullname;

$ccleaner = "\ccsetup573.exe";
$destination = $DownloadDir[0]+$ccleaner;
$source = "https://download.ccleaner.com/ccsetup573.exe";
$ccleanerSource = "C:\Program Files\CCleaner\CCleaner64.exe";
$prgrmsToClose = "chrome", "msedge"
$prgrmsToName = "Chrome", "Microsoft Edge"

$AppsList = "king.com.CandyCrushSaga", "2FE3CB00.PICSART-PHOTOSTUDIO", "ThumbmunkeysLtd.PhototasticCollage", "king.com.CandyCrushFriends", "king.com.CandyCrushSodaSaga", "5CB722CC.SeekersNotesMysteriesofDarkwood", "PLRWorldwideSales.Gardenscapes-NewAcres", "828B5831.TheSecretSociety-HiddenMystery", "GAMELOFTSA.Asphalt8Airborne", "king.com.CandyCrushJellySaga"


<#---------------------------------------------------------
For virus scaning
-----------------------------------------------------------#>

Write-Host '----------Starting Michael EZ Script-----------'
Write-Host ''
Write-Host 'Created by: Michael Carr'
Write-Host 'Version 2.11072020'
Write-Host ''
Write-Host '-----------------------------------------------'
Write-Host ''

Write-Host 'Updating Windows Defender...'
Write-Host 'Please wait'
Update-MpSignature
Write-Host 'Done'
Start-Sleep -s 5
Write-Host 'Running Windows Defender...'
Start-MpScan -ScanType QuickScan
Write-Host 'Done'
Start-Sleep -s 5

<#---------------------------------------------------------
For any bloatware. some will need to be checked and added as new versions come out
-----------------------------------------------------------#>
        
Write-Host 'Finding bloatware...'

ForEach ($App in $AppsList)
{
    $PackageFullName = (Get-AppxPackage $App).PackageFullName
    
    if ($PackageFullName)
    {
        Write-Host "Removing App: $App"
        remove-AppxPackage -package $PackageFullName
    }
    else
    {
        Write-Host "Unable to find App: $App"
    }
}

<#---------------------------------------------------------
For CCleaner uninstall/install
-----------------------------------------------------------#>

Write-Host 'Checking CCleaner...'
$software = "CCleaner";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null;

    
If(-Not $installed) {
	Write-Host "'$software' NOT is installed.";
    Write-Host "'$software' is installing.";
} 

else {
        Write-Host "'$software' is installed. Uninstalling please wait"
            Write-Host "Please press YES if dialog box comes up"
            Start-Sleep -s 5
    if (Get-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Where-Object DisplayName -eq CCleaner -OutVariable Results) {
        & "$($Results.InstallLocation)\uninst.exe" /S
    } 
    Write-Host "Finishing up...";
    Start-Sleep -s 5;
    Write-Host "Done.";
    Write-Host "'$software' is reinstalling.";
    
    
}

Write-Host "Please press YES if dialog box comes up";
Start-Sleep -s 5;  

If ((Test-Path $destination) -eq $false) {
    New-Item -ItemType File -Path $destination -Force;
} 
Invoke-WebRequest $source -OutFile $destination;

Start-Process -FilePath $destination -ArgumentList "/S"
Write-Host "Finishing up...";
Start-Sleep -s 10;

<#---------------------------------------------------------
Closing programs
-----------------------------------------------------------#>

$i = 0
ForEach ($app in $prgrmsToClose){
    Write-Host "Closing "$prgrmsToName[$i]
    Get-Process | Where-Object { $_.Name -eq $app } | stop-process -Force
    Write-Host "Done"
    $i++
}

<#---------------------------------------------------------
Running CCleaner
-----------------------------------------------------------#>

Start-Sleep -s 5;
Write-Host "Running CCleaner..."
Write-Host "Please Wait"
Start-Process -FilePath $ccleanerSource -ArgumentList "/AUTO"
Write-Host "Opening CCleaner to manually run registry cleaner"
Start-Sleep -s 10
Start-Process -FilePath $ccleanerSource -ArgumentList "/REGISTRY"