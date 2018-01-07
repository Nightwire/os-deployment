#/bin/sh -c "cd /opt/os-deployment;git reset --hard; git pull; chmod +x osdeployment.ps1; pwsh osdeployment.ps1"
[string]$localOS = ""

#Get OS Version
switch($PSVersionTable.Platform){
    "Unix" {
        . "lsb_release" @("-d") | ForEach-Object { $localOS = ($_.Replace(" ","").Replace("`t","").Split(":")[1]) }
    }

    default {
        $localOS = "Windows"
    }
}

#Ubuntu 16.04: Ubuntu16.04.3LTS
Write-Host("Executing Nightwire OS Deployment on $localOS")

if($localOS -eq "Ubuntu16.04.3LTS"){
    $url = "https://raw.githubusercontent.com/Nightwire/os-deployment/master/motd.sh"
    $output = "/etc/profile.d/motd.sh"

    Invoke-WebRequest -Uri $url -OutFile $output
}

Send-MailMessage -From ([Environment]::MachineName + "@nightwire.de") -To "infrastructure-news@mailin.nightwire.de" -Subject ([Environment]::MachineName + " successfully deployed") -SmtpServer "smtp.ad.nightwire.de"
