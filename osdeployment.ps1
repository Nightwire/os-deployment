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
    DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical sudo apt-get -q -y -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" dist-upgrade
}
