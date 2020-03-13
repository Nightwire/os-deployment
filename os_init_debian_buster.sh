####### Update the OS
#Get updates
apt update

#Install updates
apt upgrade -y

#Remove obsolete packages
apt autoremove -y

####### MOTD
#Install Neofetch
apt install -y neofetch

#Delete existing motd
rm -f /etc/profile.d/motd.sh

#Download our banner
wget -O "/etc/profile.d/motd.sh" "https://raw.githubusercontent.com/Nightwire/os-deployment/master/motd_banner.sh"

#Add neofetch
echo "neofetch" >> /etc/profile.d/motd.sh

#Assign Permissions
chmod +x /etc/profile.d/motd.sh

####### Shell
#Install ZSH
apt install -y zsh

####### Domain Join
#Install Packages
apt install -y sssd-tools sssd libnss-sss libpam-sss adcli realmd packagekit -y

#Create Dyndns Config
cat > /etc/sssd/conf.d/dyndns.conf << ENDOFFILE
dyndns_update = true
dyndns_refresh_interval = 43200
dyndns_update_ptr = true
dyndns_ttl = 3600
ENDOFFILE

#Add Sudoers
echo "%s-glb-la-$(hostname | tr [A-Z] [a-z]) ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/ad-base-localadmin
echo '%domänen-admins ALL=(ALL:ALL) ALL' > /etc/sudoers.d/ad-base-domainadmin

#Tell Sudo to include subdir
echo "includedir /etc/sudoers.d" >> /etc/sudoers;

#Restart SSSD
systemctl restart sssd

#Join the domain
realm join --user=rbea AD.NIGHTWIRE.DE
