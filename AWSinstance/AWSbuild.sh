#!/bin/bash

# Copyright EMRAH KAR 01/09/2020

# define functions first


function installstuff {
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Installing a whole bunch of packages..."

    start_time_installstuff="$(date -u +%s)"

    time sudo apt-get -y update # 1 min   #Update the list of packages in the software center                                   
    time sudo apt-get -y upgrade # 3.5 min
    time sudo apt-get -y install screen # 0.5 min
    time sudo apt-get -y install tcptrack # 0 min
    time sudo apt-get -y install python  # 6 sec
    time sudo apt-get -y install python-wxgtk2.8 # 4 min 
    time sudo apt-get -y install python-matplotlib # 
    time sudo apt-get -y install python-opencv # 2 min
    time sudo apt-get -y install python-pip # 3 min
    time sudo apt-get -y install python-numpy  # 0 min
    time sudo apt-get -y install python-dev # 0 min
    time sudo apt-get -y install libxml2-dev # 1 min
    time sudo apt-get -y install libxslt-dev # 0.5 min
    time sudo apt-get -y install python-lxml # 0.75 min
    time sudo apt-get -y install python-setuptools # 0 min
    
    # Python 3 now                                                                                                                              
    time sudo apt-get -y install python3  # 6 sec                                                                                               
    time sudo apt-get -y install python3-matplotlib #                                                                                           
    time sudo apt-get -y install python3-opencv # 2 min                                                                                         
    time sudo apt-get -y install python3-pip # 3 min                                                                                            
    time sudo apt-get -y install python3-numpy  # 0 min                                                                                         
    time sudo apt-get -y install python3-dev # 0 min                                                                                            
    time sudo apt-get -y install python3-lxml # 0.75 min                                                                                        
    time sudo apt-get -y install python3-setuptools # 0 min                                                                                     
    time sudo apt-get -y install python3-genshi # 0 min                                                                                     
    time sudo apt-get -y install python3-lxml-dbg # 0 min                                                                                     
    time sudo apt-get -y install python-lxml-doc # 0 min                                                                                     
    # Done Python 3    

    time sudo apt-get -y install git # 1 min
    time sudo apt-get -y install dh-autoreconf # 1 min
    time sudo apt-get -y install systemd # 0 min
    time sudo apt-get -y install wget # 0 min
    time sudo apt-get -y install emacs # 4.5 min  (seems you have to run this twice)                                             
    time sudo apt-get -y install emacs # 0 min (seems you have to run this twice)                                             
    time sudo apt-get -y install nload # 0.5 min (network monitor, launch with nload -m)                                         
    time sudo apt-get -y install build-essential # 0 min
    time sudo apt-get -y install autossh # 0.5 min

    echo "Done installing a whole bunch of packages..."

    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "pip installing future, pymavlink, mavproxy..."
    time sudo pip install future # 1 min
    time sudo pip install pymavlink # 5.5 min
    time sudo pip install mavproxy # 4 min
    echo "Done pip installing future, pymavlink, mavproxy..."


    echo "pip3 installing future, pymavlink, mavproxy..."
    time sudo pip3 install future # 1 min                                                                                                       
    time sudo pip3 install pymavlink # 5.5 min                                                                                                  
    time sudo pip3 install mavproxy # 4 min                                                                                                     
    echo "Done pip3 installing future, pymavlink, mavproxy..."


    end_time_installstuff="$(date -u +%s)"
    elapsed_installstuff="$(($end_time_installstuff-$start_time_installstuff))"
    echo "Total of $elapsed_installstuff seconds elapsed for installing packages"
    # 38 mins
    
    
}

function downloadandbuildmavlinkrouter {

    start_time_downloadandbuildmavlinkrouter="$(date -u +%s)"
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Downloading git clone of mavlink-router..."
    #Download the git clone:                                                                                        

    git clone https://github.com/intel/mavlink-router.git
    cd mavlink-router
    sudo git submodule update --init --recursive

    echo "Done downloading git clone of mavlink-router..."

    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo "Start making / compiling / building mavlink-router..."

    sudo ./autogen.sh && sudo ./configure CFLAGS='-g -O2' --sysconfdir=/etc --localstatedir=/var --libdir=/usr/lib64 --prefix=/usr --disable-systemd # needed for AWS linux                                                       

    #Make it                                                                                                        

    sudo make

    echo "Done making / compiling / building mavlink-router..."

    end_time_downloadandbuildmavlinkrouter="$(date -u +%s)"
    elapsed_downloadandbuildmavlinkrouter="$(($end_time_downloadandbuildmavlinkrouter-$start_time_downloadandbuildmavlinkrouter))"
    echo "Total of $elapsed_downloadandbuildmavlinkrouter seconds elapsed for downloading and building mavlink router"
    # 13 min

}

# Check for any errors, quit if any
check_errors() {
  if ! [ $? = 0 ]
  then
    echo "An error occured! Aborting...."
    exit 1
  fi
}

#***********************END OF FUNCTION DEFINITIONS******************************

set -x

echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "This will install mavlink router and set it up for you."
echo "See README in 4guav gitlab repo for documentation."

read -p "To continue, enter "yes": " out

if ! [ "$out" = "yes" ]
then
  echo "You did not type in 'yes'. Exiting... Nothing has been done."
  exit 1
fi

echo "Starting..."

date


start_time="$(date -u +%s)"


installstuff

downloadandbuildmavlinkrouter
                                                            


echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Start configuring mavlink-router..."
echo "It will connect to flight controller on /dev/AMA0"
echo "It will serve up a mavlink stream on localhost port 5678 TCP"


#Configure it                                                                                                   

if [ ! -d "/etc/mavlink-router" ] 
then
    echo "Directory /etc/mavlink-router does not exist yet. Making it." 
    sudo mkdir /etc/mavlink-router
    echo "Made /etc/mavlink-router" 
fi

cd /etc/mavlink-router
# wget main.conf #  for mavlink-router configuration
wget https://github.com/swarmnect/FOToD/raw/master/AWSinstance/main.conf -O /etc/mavlink-router/main.conf
sudo chmod 777 main.conf
echo "Done configuring mavlink-router..."


echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "Now download the autostart scripts for mavlink-router"
if [ ! -d "/home/ubuntu/startupscripts" ] 
then
    echo "Directory /home/ubuntu/startupscripts does not exist yet. Making it." 
    sudo -u ubuntu mkdir /home/ubuntu/startupscripts
    echo "Made /home/ubuntu/startupscripts" 
fi
cd /home/ubuntu/startupscripts
wget https://github.com/swarmnect/FOToD/raw/master/AWSinstance/autostart_mavlinkrouter.sh -O /home/ubuntu/startupscripts/autostart_mavlinkrouter.sh
wget https://github.com/swarmnect/FOToD/raw/master/AWSinstance/start_mavlinkrouter.sh  -O /home/ubuntu/startupscripts/start_mavlinkrouter.sh
sudo chmod 777 /home/ubuntu/startupscripts/start_mavlinkrouter.sh
sudo chmod 777 /home/ubuntu/startupscripts/autostart_mavlinkrouter.sh

echo "Did download the autostart scripts for mavlink-router"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

echo "Downloading /etc/rc.local"
# Need this command to run on boot to start mavlink router each time it boots:
# sudo -H -u ubuntu /bin/bash -c '/home/ubuntu/startupscripts/autostart_mavlinkrouter.sh'
wget https://github.com/swarmnect/FOToD/raw/master/AWSinstance/rc.local -O /etc/rc.local
sudo chmod 777 /etc/rc.local
echo "Downloaded /etc/rc.local"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

# Must change /etc/ssh/sshd_config to allow port forwarding and also for time out as explained in wiki
# Just download a whole new one.
sudo wget https://github.com/swarmnect/FOToD/raw/master/AWSinstance/sshd_config -O /etc/ssh/sshd_config
sudo chmod 777 /etc/ssh/sshd_config

date

end_time="$(date -u +%s)"

elapsed="$(($end_time-$start_time))"
echo "Total of $elapsed seconds elapsed for the entire process"


echo "Installation is complete. You will want to restart AWS instance."
echo "No further action should be required. Closing..."


