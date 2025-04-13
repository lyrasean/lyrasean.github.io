#  禁用睡眠和休眠
`systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target`

#  设置 Linux 构建环境
https://source.android.google.cn/docs/setup/start/initializing?hl=zh-cn#setting-up-a-linux-build-environment  
`sudo apt-get install git-core gnupg flex bison build-essential zip curl \`  
`zlib1g-dev libc6-dev-i386 libncurses5 lib32ncurses5-dev x11proto-core-dev \`  
`libx11-dev lib32z1-dev libgl1-mesa-dev libxml2-utils xsltproc unzip fontconfig`

#  Desktop machine setup
https://source.android.google.cn/docs/compatibility/cts/setup?hl=en#desktop-machine
## Install the ffmpeg version 5.1.3 (or later) package on the host machine.
`sudo apt-get install ffmpeg`

## Install the proper version of Java Development Kit (JDK).
`sudo apt-get install openjdk-17-jdk`

## Python
`sudo apt-get install python3-full python3-pip pipx`

## 安装 Miniconda 管理 Python 虚拟环境
`mkdir -p ~/miniconda3`  
`wget -c https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \`  
`-O ~/miniconda3/miniconda.sh`  
`bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3`  
`sudo ln -s ~/miniconda3/bin/conda /bin/conda`  
`conda config --set auto_activate_base false`

## 安装 Android SDK
https://developer.android.google.cn/studio  
`wget -c https://googledownloads.cn/android/repository/commandlinetools-linux-11076708_latest.zip -O ~/Downloads/commandlinetools-linux-11076708_latest.zip`  
`unzip -o ~/Downloads/commandlinetools-linux-11076708_latest.zip -d ~`  
`mkdir -p ~/android-sdk/cmdline-tools/latest`  
`cp -rf ~/cmdline-tools/* ~/android-sdk/cmdline-tools/latest/`  
`rm -rf ~/cmdline-tools`  
`~/android-sdk/cmdline-tools/latest/bin/sdkmanager "build-tools;34.0.0" "platform-tools" "tools"`

## Device detection
https://developer.android.google.cn/studio/run/device#setting-up  
`sudo usermod -aG plugdev $LOGNAME`  
`sudo apt-get install android-sdk-platform-tools-common`

## 修改 .bashrc
`cp ~/.bashrc ~/.bashrc_backup`  
`echo $PATH > ~/.PATH_backup`  
`echo "export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64" >> ~/.bashrc`  
`echo "export ANDROID_HOME=$HOME/android-sdk" >> ~/.bashrc`  
`echo "export PATH=$PATH:$HOME/android-sdk/cmdline-tools/latest/bin:$HOME/android-sdk/tools:$HOME/android-sdk/tools/bin:$HOME/android-sdk/platform-tools:$HOME/android-sdk/build-tools/34.0.0" >> ~/.bashrc`

## 安装 Google Chrome 浏览器
`wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O ~/google-chrome-stable_current_amd64.deb`  
`sudo dpkg -i ~/google-chrome-stable_current_amd64.deb`  
`sudo apt-get -f install -y`  
`rm -f ~/google-chrome-stable_current_amd64.deb`

## 安装 Anydesk 远程桌面
`wget -qO - https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo apt-key add -`  
`echo "deb http://deb.anydesk.com/ all main" > ~/anydesk-stable.list`  
`sudo mv ~/anydesk-stable.list /etc/apt/sources.list.d/anydesk-stable.list`  
`sudo apt-get update`  
`sudo apt-get install -y anydesk`

## 安装 SSH/SFTP
`sudo apt-get install ssh`  
Files (nautilus) 可以用 sftp://ip 连接远程主机管理文件  
samba 限制太多，远程修改后的文件权限也比较混乱

## 创建 CameraITS 测试环境
`conda create -n its14 python=3.9`  
`conda activate its14`  
`conda install opencv`	# will install ffmpeg/numpy meanwhile  
`conda install matplotlib`	# will install pillow meanwhile  
`conda install scipy pyserial pyyaml`  
`pip install mobly colour-science`

## 安装中文输入法
`sudo apt-get install locales xfonts-intl-chinese fonts-wqy-microhei`  
`sudo apt-get remove ibus`  
`sudo apt-get automove`  
`sudo apt-get install fcitx fcitx-googlepinyin`  
`sudo dpkg-reconfigure locales`  
`sudo reboot`  
在 fcitx configuration 中添加 googlepinyin
