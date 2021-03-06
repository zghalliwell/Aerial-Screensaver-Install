#!/bin/bash

###############################################################################################################
# This script will install a homebrew binary, then use that binary to install the Aerial screensaver.          
# After that it will create a launch daemon and use the homebrew binary to update the screensaver once per week
# All you need to do once it's done is go into the screensaver settings and select Aerial as your screensaver! 
#                                                                                                             
# This all worked as of 1/8/19, always test before using in production.                       
###############################################################################################################

#Install Brew Binary
#It will ask you if you want to proceed and enter your password
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "Brew installed!"

#Use Brew Cask binary to install Aerial Screensaver
brew cask install aerial
echo "Aerial Screensaver Installed!"

#Next we'll create a launch daemon that will have Brew update the Aerial screen saver once per week

#Create the plist
sudo defaults write /Library/LaunchDaemons/com.halliwell.upgradeAerial.plist Label -string "com.halliwell.UpgradeAerial"

#Add program argument to have it run the update script
sudo defaults write /Library/LaunchDaemons/com.halliwell.upgradeAerial.plist ProgramArguments -array bash -string "brew cask upgrade"

#Set the run inverval to run every 7 days
sudo defaults write /Library/LaunchDaemons/com.halliwell.upgradeAerial.plist StartInterval -integer 604800

#Set run at load
sudo defaults write /Library/LaunchDaemons/com.halliwell.upgradeAerial.plist RunAtLoad -boolean yes

#Set ownership
sudo chown root:wheel /Library/LaunchDaemons/com.halliwell.upgradeAerial.plist
sudo chmod 644 /Library/LaunchDaemons/com.halliwell.upgradeAerial.plist

#Load the daemon 
launchctl load /Library/LaunchDaemons/com.halliwell.upgradeAerial.plist

echo "Launch daemon created, Aerial will check for updates once every week."
