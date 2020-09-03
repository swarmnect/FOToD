#!/bin/bash

# Copyright EMRAH KAR 01/09/2020

# define functions first



# Check for any errors, quit if any
check_errors() {
  if ! [ $? = 0 ]
  then
    echo "An error occured! Aborting...."
    exit 1
  fi
}

#***********************END OF FUNCTION DEFINITIONS******************************
start_time="$(date -u +%s)"

set -x

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "This will install webccam on Pi and set it up for you."
echo "See README in 4guav gitlab repo for documentation."


read -p "To begin with the installation type in the EXACT IP address of the AWS instance for the ssh tunnel: " awsip

echo "You entered:"
echo $awsip

read -p "If this is correct, enter "yes": " out

if ! [ "$out" = "yes" ]
then
  echo "You did not type in 'yes'. Exiting... Nothing has been done."
  exit 1
fi

echo "Starting..."


time sudo apt-get -y update # 1 min   #Update the list of packages in the software center                                   
time sudo apt-get -y upgrade # 3.5 min

time sudo apt-get install git -y; 
time sudo apt-get install screen -y; 
time sudo apt-get install autossh -y; 

cd /home/pi

git clone https://github.com/silvanmelchior/RPi_Cam_Web_Interface.git

cd RPi_Cam_Web_Interface

sudo chmod 777 install.sh; 

# sudo ~/RPi_Cam_Web_Interface/install.sh


echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Now download the autostart scripts for ssh to AWS"
if [ ! -d "/home/pi/startupscripts" ] 
then
    echo "Directory /home/pi/startupscripts does not exist yet. Making it." 
    sudo -u pi mkdir /home/pi/startupscripts
    echo "Made /home/pi/startupscripts" 
fi
cd /home/pi/startupscripts
wget https://github.com/swarmnect/FOToD/raw/master/WebCam/autostart_sshtoAWSforWebCam.sh -O /home/pi/startupscripts/autostart_sshtoAWSforWebCam.sh 
wget https://github.com/swarmnect/FOToD/raw/master/WebCam/start_sshtoAWSforWebCam.sh -O /home/pi/startupscripts/start_sshtoAWSforWebCam.sh 
echo "Did download the autostart scripts for sshtoAWS"

sudo chmod 777 *.sh

echo "Editing sshtoAWS.sh to put IP address in that you entered above."

# awsip was entered above
sed -i "s/AWSIPADDRESS/$awsip/g" /home/pi/startupscripts/start_sshtoAWSforWebCam.sh


echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "adding autostart_sshtoAWS.sh to /etc/rc.local"
# Add these lines to /etc/rc.local
#sudo -H -u pi /bin/bash -c '/home/pi/startupscripts/autostart_mavlinkrouter.sh'
#sudo -H -u pi /bin/bash -c '/home/pi/startupscripts/autostart_sshtoAWS.sh'

# If line already was added delete it.
sudo sed -i -n '/autostart_sshtoAWSforWebCam.sh/!p' /etc/rc.local

a="
sudo -H -u pi /bin/bash -c '/home/pi/startupscripts/autostart_sshtoAWSforWebCam.sh'
exit 0
"
# delete exit on last line of /etc/rc.local
sudo sed -i '/exit 0/d'  /etc/rc.local
# append a to end
sudo sh -c "echo '$a'>>/etc/rc.local"
sudo chown root:root /etc/rc.local
sudo chmod 755 /etc/rc.local
echo "added autostart_sshtoAWSforWebCam.sh to /etc/rc.local"

# Now clean up extra spaced lines:
tmpfile=$(mktemp)
sudo awk '!NF {if (++n <= 1) print; next}; {n=0;print}' /etc/rc.local > "$tmpfile" && sudo mv "$tmpfile" /etc/rc.local
sudo chmod 777 /etc/rc.local


echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"


end_time="$(date -u +%s)"

elapsed="$(($end_time-$start_time))"
echo "Total of $elapsed seconds elapsed for the entire process"


echo "Installation is complete. You will want to restart your Pi to make this work."
echo "No further action should be required. Closing..."

