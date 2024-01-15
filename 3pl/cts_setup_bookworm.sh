#!/bin/bash

myDir=$(cd $(dirname $0); pwd)
# osVersion=$(lsb_release -ircs)

# android.google.cn == android.com
# Compatibility Test Suite - Overview
# https://source.android.google.cn/docs/compatibility/cts?hl=en
# Setting up CTS
# https://source.android.google.cn/docs/compatibility/cts/setup?hl=en

RED='\e[1;31m'
GREEN='\e[1;32m'
YELLOW='\e[1;33m'
BLUE='\e[1;34m'
PINK='\e[1;35m'
RESET='\e[0m'

read -s -p "[sudo] password for $LOGNAME: " password
echo

function pause()
{
	# breakpoint for debugging
	echo -e "${YELLOW}Press any key to continue, or Ctrl+C to exit...${RESET}"
	read -n1 -s
	echo
}

function MUST_RUN_FIRST()
{
	echo -e "${BLUE}Updating lists of packages...${RESET}"
	echo $password | sudo -S apt update

	# Establishing a build environment
	# https://source.android.google.cn/docs/setup/start/initializing
	echo -e "${BLUE}Installing building prerequisites...${RESET}"
	echo $password | sudo -S apt install -y git-core gnupg flex bison build-essential zip curl zlib1g-dev libc6-dev-i386 libncurses5 x11proto-core-dev libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig wget gedit

	# Installing python3.11-full. bookworm has installed Python 3.11.2
	echo -e "${BLUE}Installing Python 3.11 and tools...${RESET}"
	echo $password | sudo -S apt install -y python3.11-full python3-pip
	
	# `ldd --version' shows bookworm has installed GLIBC 2.36

	# Installing samba
	echo -e "${BLUE}Installing Samba for file-sharing...${RESET}"
	echo $password | sudo -S apt install -y samba
	echo $password | sudo -S apt-get -f install -y

	echo -e "${GREEN}############################################${RESET}"
	echo -e "${GREEN}STEP.1 ===============================> 100%${RESET}"
	echo -e "${GREEN}############################################${RESET}"
	list
}

function install_jdk_17()
{
	# https://source.android.google.cn/docs/compatibility/cts/setup?hl=en#jdk-ubuntu
	# For Android 11, install OpenJDK11
	# bookworm has to install OpenJDK17
	echo -e "${BLUE}Installing Open JDK 17...${RESET}"
	echo $password | sudo -S apt install -y openjdk-17-jdk
	echo $password | sudo -S apt-get -f install -y

	echo -e "${GREEN}############################################${RESET}"
	echo -e "${GREEN}STEP.2 ===============================> 100%${RESET}"
	echo -e "${GREEN}############################################${RESET}"
	list
}

function install_android_sdk()
{
	# https://developer.android.google.cn/tools
	echo -e "${BLUE}Installing Android SDK...${RESET}"
	echo $password | sudo -S apt install -y wget
	wget -c https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O ~/Downloads/commandlinetools-linux-9477386_latest.zip
	unzip -o ~/Downloads/commandlinetools-linux-9477386_latest.zip -d ~
	mkdir -p ~/android-sdk/cmdline-tools/latest
	cp -rf ~/cmdline-tools/* ~/android-sdk/cmdline-tools/latest/
	rm -rf ~/cmdline-tools
	~/android-sdk/cmdline-tools/latest/bin/sdkmanager "build-tools;34.0.0" "platform-tools" "tools"
	# Pressing y to accept the license

	echo -e "${GREEN}############################################${RESET}"
	echo -e "${GREEN}STEP.3 ===============================> 100%${RESET}"
	echo -e "${GREEN}############################################${RESET}"
	list
}

function install_51-android_rules()
{
	# Official method
	# https://developer.android.google.cn/studio/run/device
	echo $password | sudo -S usermod -aG plugdev $LOGNAME
	sudo apt install -y android-sdk-platform-tools-common

	# Another method still maintained in github
	# https://github.com/M0Rf30/android-udev-rules
	[ -e ~/android-udev-rules ] && rm -rf ~/android-udev-rules
	if [ -e ~/Downloads/android-udev-rules-20240114.zip ]; then
		unzip -o ~/Downloads/android-udev-rules-20240114.zip -d ~
		mv ~/android-udev-rules-20231124 ~/android-udev-rules
	else
		git clone https://github.com/M0Rf30/android-udev-rules.git
		if [ -e "$myDir"/android-udev-rules ]; then
			[ "$myDir" != "$HOME" ] && mv -f "$myDir"/android-udev-rules ~
		else
			echo -e "${RED}[Error] Since github might not be accessed via Mainland's internet sometimes,"
			echo -e "copy android-udev-rules-20240114.zip to ~/Downloads manually,"
			echo -e "and then re-try this step.${RESET}"
			exit 1
		fi
	fi
	cd ~/android-udev-rules
	echo $password | sudo -S ln -sf "$PWD"/51-android.rules /etc/udev/rules.d/51-android.rules
	sudo chmod a+r /etc/udev/rules.d/51-android.rules
	sudo cp -f android-udev.conf /usr/lib/sysusers.d/
	sudo systemd-sysusers
	sudo gpasswd -a $LOGNAME adbusers
	sudo udevadm control --reload-rules
	sudo systemctl restart systemd-udevd.service
	~/android-sdk/platform-tools/adb start-server
	~/android-sdk/platform-tools/adb kill-server
	~/android-sdk/platform-tools/adb devices

	echo -e "${GREEN}############################################${RESET}"
	echo -e "${GREEN}STEP.4 ===============================> 100%${RESET}"
	echo -e "${GREEN}############################################${RESET}"
	list

	# Legacy method which last updated 2 years ago
	# http://snowdream.github.io/51-android/
	# https://github.com/snowdream/51-android
}

function import_GTS_key()
{
	mkdir -p ~/CTS_tool/GTS_key
	mkdir -p ~/CTS_tool/CTSV
	chmod -R 755 ~/CTS_tool
	echo -e "${YELLOW}Copy gts-public.json to '~/CTS_tool/GTS_key/',"
	echo -e "and then press any key to continue...${RESET}"
	read -n1 -s
	echo
	if [ ! -e ~/CTS_tool/GTS_key/gts-public.json ]; then
		echo -e "${RED}[Error] gts-public.json is not found!${RESET}"
		list
	fi
	echo $password | sudo -S chown $LOGNAME:$LOGNAME ~/CTS_tool/GTS_key/gts-public.json
	chmod 755 ~/CTS_tool/GTS_key/gts-public.json
	mkdir -p ~/3pl_report/aosp
	mkdir -p ~/3pl_report/cts
	mkdir -p ~/3pl_report/gts
	mkdir -p ~/3pl_report/sts
	mkdir -p ~/3pl_report/vts
	chmod -R 755 ~/3pl_report
	echo $password | sudo -S chown -R $LOGNAME:$LOGNAME ~/3pl_report

	echo -e "${GREEN}############################################${RESET}"
	echo -e "${GREEN}STEP.5 ===============================> 100%${RESET}"
	echo -e "${GREEN}############################################${RESET}"
	list
}

function modify_bashrc()
{
	echo -e "${YELLOW}Above steps must be successful without any error!"
	echo -e "If you want to run this step again,"
	echo -e "restore bashrc & PATH to the original ones first.${RESET}"
	pause
	[ ! -e ~/.bashrc_backup ] && cp ~/.bashrc ~/.bashrc_backup
	[ ! -e ~/.PATH_backup ] && echo $PATH > ~/.PATH_backup
	echo >> ~/.bashrc
	echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bashrc
	echo "export ANDROID_HOME=$HOME/android-sdk" >> ~/.bashrc
	echo "export PATH=$PATH:$HOME/android-sdk/cmdline-tools/latest/bin:$HOME/android-sdk/tools:$HOME/android-sdk/tools/bin:$HOME/android-sdk/platform-tools:$HOME/android-sdk/build-tools/34.0.0" >> ~/.bashrc
	echo "export APE_API_KEY=$HOME/CTS_tool/GTS_key/gts-public.json" >> ~/.bashrc
	echo -e "${YELLOW}#### ATTENTION PLEASE !!!!\nAfter you exit this script, run 'source ~/.bashrc' in the terminal manually.${RESET}"
	exit
}

function restore_bashrc()
{
	[ ! -e ~/.bashrc_backup ] && echo -e "${RED}[Error] .bashrc_backup is not found!${RESET}"
	[ ! -e ~/.PATH_backup ] && echo -e "${RED}[Error] .PATH_backup is not found!${RESET}" && list
	cp -f ~/.bashrc_backup ~/.bashrc
	export PATH=$(cat ~/.PATH_backup)
	source ~/.bashrc
	echo -e "${YELLOW}#### ATTENTION PLEASE !!!!\nAfter you exit this script, restart terminal and then run the script.${RESET}"
	exit
}

function install_chrome_anydesk()
{
	echo -e "${BLUE}Installing Google Chrome...${RESET}"
	wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O ~/google-chrome-stable_current_amd64.deb
	echo $password | sudo -S dpkg -i ~/google-chrome-stable_current_amd64.deb
	sudo apt-get -f install -y
	rm -f ~/google-chrome-stable_current_amd64.deb

	echo -e "${BLUE}Installing Anydesk...${RESET}"
	wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -
	echo "deb http://deb.anydesk.com/ all main" > ~/anydesk-stable.list
	sudo mv ~/anydesk-stable.list /etc/apt/sources.list.d/anydesk-stable.list
	echo $password | sudo -S apt update
	sudo apt install -y anydesk
	sudo apt-get -f install -y

	echo -e "${GREEN}############################################${RESET}"
	echo -e "${GREEN}STEP.8 ===============================> 100%${RESET}"
	echo -e "${GREEN}############################################${RESET}"
	list

	# https://blog.csdn.net/micheal890915/article/details/103719744
	# wget -c https://storage.googleapis.com/android-mtt.appspot.com/prod/mtt -O ~/Downloads/mtt
}

function list()
{
	echo "============================================"
	echo "1. MUST RUN FIRST"
	echo "2. Install OpenJDK-17"
	echo "3. Install Android SDK"
	echo "4. Install 51-android.rules"
	echo "5. Import GTS key and create some folders"
	echo "6. Modify bashrc & PATH"
	echo "7. Restore bashrc & PATH (if re-run step 6)"
	echo "8. Install Chrome & Anydesk"
	echo "9. Exit"
	echo "============================================"
	read -p "Please key in a number: " option
	echo
	case $option in
		1)
			MUST_RUN_FIRST
			;;
		2)
			install_jdk_17
			;;
		3)
			install_android_sdk
			;;
		4)
			install_51-android_rules
			;;
		5)
			import_GTS_key
			;;
		6)
			modify_bashrc
			;;
		7)
			restore_bashrc
			;;
		8)
			install_chrome_anydesk
			;;
		9)
			exit
			;;
		*)
			echo -e "${RED}[Error] incorrect number, please try again!${RESET}"
			list
			;;
	esac
}

list
