#!/bin/bash

#Author : Jishnu P
#Date : 17-07-2016

#Getting Universal IP as a command line argument

echo -e "\nNOTE: THIS SCRIPT IS FOR UBUNTU POWERED SYSTEMS. \n\nSTEP-1: SCANNING OPERATING SYSTEM."

# To find whether the OS is ubuntu or not. If the OS is not Ubuntu then the following command returns nothing else returns 'Ubuntu'
# It works for all Linux distributions. 

os=`cat /etc/*-release | grep -w 'NAME' | grep -o -P '(?<=NAME=").*(?=")'`

if [ -z $os ];	#If os variable is empty
then
	echo -e "\nWARNING !!!\n\nOS DETECTED BUT IT'S NOT UBUNTU, HENCE EXITING.\n"
	exit 1  #OS detected is not Ubuntu hence exiting the code.
else 
	echo -e "\nSUCCESS!!! OS DETECTED: $os"
fi


#Changing the root user's password to password
echo -e "\nSTEP-2: Changing the root user's password to password"
echo 'root:password' | sudo chpasswd

#Setting up the repository for google chrome
echo -e "\nSTEP-3: Setting up the repository for google chrome"
sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
sudo add-apt-repository ppa:chromium-daily/stable


#Getting all the dependencies and updates once again after repo addition

#Getting all the dependencies and updates
echo -e "\nSTEP-4: Getting all the dependencies and updates"

sudo apt-get update 

sudo dpkg --configure -a

#Installing required software packages
echo -e "\nSTEP-5: Installing required software packages"
echo "INSTALLING : jq"
sudo apt-get -y install jq 
echo "INSTALLING : LIBAPPINDICATOR1"
sudo apt-get -y install libappindicator1 
echo "INSTALLING : LIBINDICATOR7"
sudo apt-get -y install libindicator7 
echo "INSTALLING : LXDE"
sudo apt-get -y install lxde 
echo "INSTALLING : UBUNTU"
sudo apt-get -y install ubuntu-gnome-desktop 
echo "INSTALLING : TIGHT_VNC_SERVER"
sudo apt-get -y install tightvncserver 
echo "INSTALLING : XRDP"
sudo apt-get -y install xrdp
echo "INSTALLING : FLASH"
sudo apt-get -y install flashplugin-installer 
echo "INSTALLING : CHROMIUM BROWSER"
sudo apt-get -y install chromium-browser 
echo "INSTALLING : FIREFOX BROWSER"
sudo apt-get -y install firefox 
echo "INSTALLING : GOOGLE_CHROME_STABLE"
sudo apt-get -y install google-chrome-stable 
echo "INSTALLING : FORCEFULLY"
sudo apt-get install -f

#Configuring lxde
echo -e "\nSTEP-6: Configuring lxde"
sudo echo lxsession -s LXDE -e LXDE > ~/.xsession 

sudo ~/.xsession /root/.xsession

#Configuring various browsers settings
echo -e "\nSTEP-6: Configuring various browsers settings"
sudo echo "CHROMIUM_FLAGS=\" --user-data-dir --no-sandbox\"" > sudo /etc/chromium-browser/default
sudo echo "chromium-browser --no-sandbox https://www.gmail.com/&" >> ~/a  
sudo echo "google-chrome --no-sandbox https://www.gmail.com/&" >> ~/c  
sudo echo "firefox --no-sandbox https://www.gmail.com/&" >> ~/d
chmod +x ~/a ~/c ~/d
sudo cp ~/a /root
sudo cp ~/c /root
sudo cp ~/d /root


echo -e "\nSTEP-8: Setting up various autostart script files"

#Creating various autostart files for starting various applications like terminal and google chrome
sudo touch /etc/xdg/autostart/google-chrome-autostart.desktop /etc/xdg/autostart/terminal-autostart.desktop /etc/xdg/autostart/setting-session-port.desktop ~/rdp-session-setup.sh

#Changing the permissions of each autostart file so that execution can take place without any problem.
sudo chmod 777 /etc/xdg/autostart/google-chrome-autostart.desktop /etc/xdg/autostart/terminal-autostart.desktop /etc/xdg/autostart/setting-session-port.desktop ~/rdp-session-setup.sh

#Creating the autostart file for google chrome startup on rdp log in.

sudo echo -e "#!/bin/bash\nsudo echo -e '[globals]\nbitmap_cache=yes\nbitmap_compression=yes\nport=3389\ncrypt_level=low\nchannel_code=1\nmax_bpp=24\n\n[xrdp1]\n\nname=Jishnu Customized\nlib=libvnc.so\nusername=ask\npassword=ask\nip=127.0.0.1\nport=5910' | sudo cat > /etc/xrdp/xrdp.ini" | sudo cat > ~/rdp-session-setup.sh

#Cpying the script from current's user home directory to root user's home directory.
sudo cp ~/rdp-session-setup.sh /root/rdp-session-setup.sh


#Creating the autostart file for google-chrome startup on rdp log in.
sudo echo -e "[Desktop Entry]\nType=Application\nName=Google Chrome\nGenericName=Google chrome autostart configuration\nComment=This will open google chrome when gnome starts up\nExec=sudo sensible-browser https://www.gmail.com/\nTerminal=true\nType=Application\nX-GNOME-Autostart-enabled=true" | cat > /etc/xdg/autostart/google-chrome-autostart.desktop

#Creating the autostart file for terminal startup on rdp log in.
sudo echo -e "[Desktop Entry]\nType=Application\nName=Terminal\nGenericName=Terminal autostart configuration\nComment=This will open default terminal program when gnome starts up\nExec=x-terminal-emulator\nTerminal=true\nType=Application\nX-GNOME-Autostart-enabled=true" | cat > /etc/xdg/autostart/terminal-autostart.desktop

#Creating the autostart file for session port set up on rdp log in.
sudo echo -e "[Desktop Entry]\nType=Application\nName=Terminal\nGenericName=Terminal autostart configuration\nComment=This will open default terminal program when gnome starts up\nExec=/root/rdp-session-setup.sh\n" | cat > /etc/xdg/autostart/setting-session-port.desktop

echo -e "\nSTEP-9: Customizing rdp log in screen"

#Changing the permissions for xrdp log in file  
sudo chmod 777 /etc/xrdp/xrdp.ini

#Customizing rdp log in screen 
sudo echo -e "[globals]\nbitmap_cache=yes\nbitmap_compression=yes\nport=3389\ncrypt_level=low\nchannel_code=1\nmax_bpp=24\n\n[xrdp1]\n\nname=Jishnu Customized\nlib=libvnc.so\nusername=ask\npassword=ask\nip=127.0.0.1\nport=-1" | cat > /etc/xrdp/xrdp.ini

echo -e "\nSTEP-10: Restarting the xrdp server so that changes get saved\n"

#Restarting the xrdp server
echo sudo /etc/init.d/xrdp restart

#Getting the IP location
echo -e "\nSTEP-11: Getting the IP information"
ip_address=`curl -s https://4.ifcfg.me/`
ip=`curl -s ipinfo.io/$ip_address | jq -r '.ip'`
city=`curl -s ipinfo.io/$ip_address | jq -r '.city'`
region=`curl -s ipinfo.io/$ip_address | jq -r '.region'`
country=`curl -s ipinfo.io/$ip_address | jq -r '.country'`
postal_code=`curl -s ipinfo.io/$ip_address | jq -r '.postal'`

#Printing out the system details

echo -e "\n"
echo -e "===================================================="
echo -e " \tSYSTEM DETAILS"
echo -e "===================================================="
echo -e "\tOperating System: $os"
echo -e "===================================================="
echo -e "\tIP-Address : $ip"
echo -e "===================================================="
echo -e "\tIP-City : $city"
echo -e "===================================================="
echo -e "\tIP-Region : $region"
echo -e "===================================================="
echo -e "\tIP-Country : $country"
echo -e "===================================================="
echo -e "\tIP-Postal : $postal_code"
echo -e "===================================================="