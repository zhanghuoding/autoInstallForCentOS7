#!/bin/bash


#===============================================================
#author	:王勃博
#time		:2017-10-07
#modify	:2019-01-07
#site		:Yunnan University
#e-mail	:wangbobochn@gmail.com
#===============================================================



#When you run this script,you should add the first parameter with your user name.
#The second parameter will control the time of install loop.So,the second parameter must be a digital.
#If you want to run this script,you should clear that whether you want to output redirection.
#You should add the third parameter "-y" to achieve output redirection or "-n" to disabled redirection.

#inorder to reuse this shell file,there are some variable


#this script need three parameters
if test $# -lt 3
then
	echo "Sorry! You have to set one parameters for excute at least."
	echo "You can set one or two parameters and try again."
	exit
fi



getPermission=""
packageManager=""
installCommandHead=""
installCommandHead_skipbroken=""
installCommandHead_skipbroken_nogpgcheck=""
packageManagerLocalInstallCommand=""
packageManagerLocalInstallCommand_skipbroken=""
packageManagerLocalInstallCommand_skipbroken_nogpgcheck=""
outputRedirectionFile=""
outputRedirectionCommand=""
outputRedirectionFlag=""
userName=""
binaryPackageManager=""
binaryPackageImport=""
changeOwn=""
systemTime=""
currentPath=""
loopTimne=""

getPermission="sudo "
userName=$1
loopTime=$2
#ensure the second parameter is a digital.
expr $loopTime "+" 10
if [[ $? != 0 ]]
then
	echo "Sorry! Please enter a digital with the second parameter!"
	exit
fi
outputRedirectionFlag=$3
readonly outputRedirectionFlag

currentPath=$( pwd )
currentPath=${currentPath}/Resource
readonly currentPath

if [[ x$outputRedirectionFlag == x"-y" ]]
then
	outputRedirectionFile="$currentPath/outputInfo.log"
	outputRedirectionCommand=" "$outputRedirectionFile" "	#" >> "$outputRedirectionFile" "
#	outputRedirectionCommand=" 2>> "$outputRedirectionFile" "
	if [[ -e "$outputRedirectionFile" ]]
	then
		$getPermission rm -r $outputRedirectionFile
	fi
	touch $outputRedirectionFile
fi

#get the version and type of OS
if grep -Eqii "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
#CentOS
	packageManager='yum'
elif grep -Eqi "Red Hat Enterprise Linux Server" /etc/issue || grep -Eq "Red Hat Enterprise Linux Server" /etc/*-release; then
#RHEL
	packageManager='yum'
elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
#Aliyun
	packageManager='yum'
elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
#Fedora
	packageManager='yum'
elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
#Debian
	packageManager='apt-get'
elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
#Ubuntu
	packageManager='apt-get'
elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
#Raspbian
	packageManager='apt-get'
else
#unknow
	echo "unknow version of OS!"
	exit
fi

installCommandHead=$getPermission" "$packageManager" install -y "
installCommandHead_skipbroken=$installCommandHead" --skip-broken "
installCommandHead_skipbroken_nogpgcheck=$installCommandHead_skipbroken" --nogpgcheck "

groupinstallCommandHead=$getPermission" "$packageManager" groupinstall -y "
groupinstallCommandHead_skipbroken=$groupinstallCommandHead" --skip-broken "
groupinstallCommandHead_skipbroken_nogpgcheck=$groupinstallCommandHead_skipbroken" --nogpgcheck "


packageManagerLocalInstallCommand=$getPermission" "$packageManager" localinstall -y "
packageManagerLocalInstallCommand_skipbroken=$packageManagerLocalInstallCommand"  --skip-broken "
packageManagerLocalInstallCommand_skipbroken_nogpgcheck=$packageManagerLocalInstallCommand_skipbroken" --nogpgcheck "

#===================
#If you want to redirect uotput in file,please remove the note in the folloeing two lines.
#===================
#installCommandHead_skipbroken_nogpgcheck=$getPermission" "$packageManager" install -y --skip-broken  --nogpgcheck " 2>> $outputRedirectionCommand
#packageManagerLocalInstallCommand_skipbroken_nogpgcheck=$getPermission" "$packageManager" localinstall -y --skip-broken " 2>> $outputRedirectionCommand

binaryPackageManager="rpm"
binaryPackageImport=$getPermission" "$binaryPackageManager" --import "
changeOwn=$getPermission" chown -R "$userName":"$userName" $currentPath/* ."

readonly getPermission
readonly packageManager
readonly installCommandHead
readonly installCommandHead_skipbroken
readonly installCommandHead_skipbroken_nogpgcheck
readonly packageManagerLocalInstallCommand
readonly packageManagerLocalInstallCommand_skipbroken
readonly packageManagerLocalInstallCommand_skipbroken_nogpgcheck
readonly outputRedirectionFile
readonly outputRedirectionCommand
readonly userName
readonly binaryPackageManager
readonly binaryPackageImport
readonly changeOwn
readonly currentPath
readonly loopTime

if [[ -e "$currentPath/$outputRedirectionCommand" ]]
then
	$getPermission rm -f $currentPath/$outputRedirectionCommand
fi

initSystemTime()
{
#get system time for output log
	systemTime=$(date "+%Y-%m-%d %H:%M:%S")
}

enterCurrentRootPath()
{
#ensure current path in work path.
	cd $currentPath
}

#Make this shell file for centos linux install saoftware conveniently.
start()
{
#ready
	initSystemTime
	echo 'enter start()'"	$systemTime "
	echo 'enter start()'"	$systemTime " >> $outputRedirectionCommand
	echo $userName' ALL=(ALL) ALL'   >>  /etc/sudoers

	echo "menuentry 'windows 7' {"  >> /boot/grub2/grub.cfg
	echo 'insmod ntfs'  >> /boot/grub2/grub.cfg
	echo 'set root=(hd0,1)'  >> /boot/grub2/grub.cfg
	echo 'chainloader +1'  >> /boot/grub2/grub.cfg
	echo '}'  >> /boot/grub2/grub.cfg

	$installCommandHead_skipbroken_nogpgcheck  wget curl axel gcc gcc-++ g++ ntfs-3g aria2 grub-customizer
	initSystemTime
	echo 'leave start()'"	$systemTime "
	echo 'leave start()'"	$systemTime " >> $outputRedirectionCommand
}

installFirefox()
{
#install firefox browser
	initSystemTime
	echo 'enter installFirefox()'"	$systemTime "
	echo 'enter installFirefox()'"	$systemTime " >> $outputRedirectionCommand

	$getPermission  echo '[Desktop Entry]'  >  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Name=Firefox'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Name[zh_CN]=Firefox'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Comment=Firefox Client'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Exec=/opt/firefox/firefox'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Icon=/opt/firefox/firefox-logo.png'  >>  /usr/share/applications/Firefox.desktop     #The path and name of the browser's logo.
	$getPermission  echo 'Terminal=false'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Type=Application'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Categories=Application;'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'Encoding=UTF-8'  >>  /usr/share/applications/Firefox.desktop
	$getPermission  echo 'StartupNotify=true'  >>  /usr/share/applications/Firefox.desktop

	if [[ ! -e "/opt/firefox" ]]
	then
		if [[ ! -e "$currentPath/Firefox-latest-x86_64.tar.bz2" ]]
		then
			wget -P $currentPath/ http://download.firefox.com.cn/releases/firefox/56.0/zh-CN/Firefox-latest-x86_64.tar.bz2
			$changeOwn
		fi
		tar -jxvf $currentPath/Firefox-latest-x86_64.tar.bz2
		$changeOwn
		$getPermission  cp -r $currentPath/firefox /opt/
	fi

	$getPermission  cp -r $currentPath/firefox-logo* /opt/firefox/


	if [[ ! -e "$currentPath/flash_player_npapi_linux.x86_64.tar.gz" ]]
	then
		wget -P $currentPath/ https://fpdownload.adobe.com/get/flashplayer/pdc/27.0.0.130/flash_player_npapi_linux.x86_64.tar.gz
		$changeOwn
	fi
	
	tar -zxvf $currentPath/flash_player_npapi_linux.x86_64.tar.gz
	$changeOwn
	$getPermission  mkdir -p /usr/lib/mozilla/plugins/
	$getPermission  cp $currentPath/libflashplayer.so /usr/lib/mozilla/plugins/

	$getPermission  rm -rf $currentPath/firefox $currentPath/LGPL $currentPath/libflashplayer.so $currentPath/license.pdf $currentPath/readme.txt $currentPath/usr

#create soft link for firefox
	$getPermission ln -s /opt/firefox/firefox /usr/bin/firefox

	initSystemTime
	echo 'leave installFirefox()'"	$systemTime " 
	echo 'leave installFirefox()'"	$systemTime " >> $outputRedirectionCommand
}

settingRepo()
{
#setting some repo whitch more fast and abundant
#backup
	initSystemTime
	echo 'enter settingRepo()'"	$systemTime " 
	echo 'enter settingRepo()'"	$systemTime " >> $outputRedirectionCommand
	if [[ -e "/etc/yum.repos.d.backup" ]]
	then
		initSystemTime
		echo 'The path "/etc/yum.repos.d.backup" exist.'"	$systemTime " 
		echo 'The path "/etc/yum.repos.d.backup" exist.'"	$systemTime " >> $outputRedirectionCommand
	else
		$getPermission  mkdir -p /etc/yum.repos.d.backup
		$getPermission  cp /etc/yum.repos.d/* /etc/yum.repos.d.backup/
	fi

#install yum plugins.
#	$installCommandHead_skipbroken_nogpgcheck  yum-*
#disabled yum's plugins
#	$getPermission  sed -i 's#plugins=[01]#plugins=0#g' /etc/yum.conf

#mosquito
	$getPermission  echo '[mosquito-myrepo]'  >  /etc/yum.repos.d/mosquito-myrepo.repo
	$getPermission  echo 'name=Copr repo for myrepo owned by mosquito'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
	$getPermission  echo 'baseurl=http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-testing/epel-7-$basearch/'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
	$getPermission  echo 'skip_if_unavailable=True'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
	$getPermission  echo 'gpgcheck=0'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
	$getPermission  echo 'enabled=1'  >>  /etc/yum.repos.d/mosquito-myrepo.repo

#docker-repo
	$getPermission tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF

#nux-dextop
	if [[ ! -e "$currentPath/nux-dextop-release-0-5.el7.nux.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/nux-dextop-release-0-5.el7.nux.noarch.rpm
	$getPermission  sed -i 's#enabled=.*$#enabled=1#g' /etc/yum.repos.d/nux-dextop.repo
#elrepo
	$binaryPackageImport $currentPath/RPM-GPG-KEY-elrepo.org
	if [[ ! -e "$currentPath/elrepo-release-7.0-3.el7.elrepo.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://elrepo.reloumirrors.net/elrepo/el7/x86_64/RPMS/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/elrepo-release-7.0-3.el7.elrepo.noarch.rpm

#setting resolving power
#	$getPermission  sed -i 's#crashkernel=auto rhgb quiet# crashkernel=auto rhgb quiet vga=795 #g' /boot/grub2/grub.cfg

#Don't use this repo for the time being.
	$getPermission  sed -i 's#enabled=.*$#enabled=0#g' /etc/yum.repos.d/elrepo.repo

#rpmfusion
	if [[ ! -e "$currentPath/rpmfusion-free-release-7.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm
		$changeOwn
	fi
	if [[ ! -e "$currentPath/rpmfusion-nonfree-release-7.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/rpmfusion-free-release-7.noarch.rpm  $currentPath/rpmfusion-nonfree-release-7.noarch.rpm

#rpmforge
	if [[ ! -e "$currentPath/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm" ]]
	then
		wget -P $currentPath/ ftp://195.220.108.108/linux/dag/redhat/el7/en/x86_64/dag/RPMS/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm

#163
	$getPermission  cp $currentPath/CentOS7-Base-163.repo /etc/yum.repos.d/

#dnf
	if [[ ! -e "$currentPath/dnf-conf-0.6.4-2.sdl7.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://springdale.math.ias.edu/data/puias/unsupported/7/x86_64/dnf-conf-0.6.4-2.sdl7.noarch.rpm
		$changeOwn
	fi
	if [[ ! -e "$currentPath/dnf-0.6.4-2.sdl7.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://springdale.math.ias.edu/data/puias/unsupported/7/x86_64/dnf-0.6.4-2.sdl7.noarch.rpm
		$changeOwn
	fi
	if [[ ! -e "$currentPath/python-dnf-0.6.4-2.sdl7.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://springdale.math.ias.edu/data/puias/unsupported/7/x86_64/python-dnf-0.6.4-2.sdl7.noarch.rpm
		$changeOwn
	fi
	$installCommandHead_skipbroken_nogpgcheck  $currentPath/python-dnf-0.6.4-2.sdl7.noarch.rpm $currentPath/dnf-0.6.4-2.sdl7.noarch.rpm $currentPath/dnf-conf-0.6.4-2.sdl7.noarch.rpm
#dnf copr
	$getPermission  cp $currentPath/jkastner-dnf-plugins-core-epel-7.repo /etc/yum.repos.d/
	$installCommandHead_skipbroken_nogpgcheck  dnf-plugins-core

#epel
	if [[ ! -e "$currentPath/epel-release-7-10.noarch.rpm" ]]
	then
		wget -P $currentPath/ https://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-10.noarch.rpm
		$changeOwn
	fi
	
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/epel-release-7-10.noarch.rpm 
#ali
	$getPermission  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

#import mono GPG
	if [[ ! -e "/etc/pki/rpm-gpg/RPM-GPG-KEY-mono-ubuntu" ]]
	then
		$getPermission rpm --import $currentPath/RPM-GPG-KEY-mono-ubuntu
	fi
	if [[ ! -e "/etc/pki/rpm-gpg/RPM-GPG-KEY-mono-ubuntu" ]]
	then
		$getPermission cp $currentPath/RPM-GPG-KEY-mono-ubuntu /etc/pki/rpm-gpg
	fi


#refresh
	$getPermission  $packageManager  clean all
	$getPermission  $packageManager  makecache
#	$getPermission  $packageManager  update -y #update linux kernel
	initSystemTime

	echo 'leave settingRepo()'"	$systemTime " 
	echo 'leave settingRepo()'"	$systemTime " >> $outputRedirectionCommand
}
installShadowsocks()
{
#there is how to install proxy software,shadowsocks.
	initSystemTime
	echo 'enter installShadowsocks()'"	$systemTime "
	echo 'enter installShadowsocks()'"	$systemTime " >> $outputRedirectionCommand
	$getPermission  cp $currentPath/librehat-shadowsocks-epel-7.repo /etc/yum.repos.d/

#	$getPermission  $packageManager  update -y #update linux kernel
	$getPermission  $packageManager  makecache
	$installCommandHead_skipbroken_nogpgcheck  shadowsocks
	$installCommandHead_skipbroken_nogpgcheck  qt5-qtbase-devel
	$installCommandHead_skipbroken_nogpgcheck  shadowsocks-qt5
	$installCommandHead_skipbroken_nogpgcheck  shadowsock*

#logo
	$getPermission  mkdir -p /opt/shadowsocks
	$getPermission  cp $currentPath/shadowsocks-logo.png /opt/shadowsocks/shadowsocks-logo.png
	$getPermission  sed -i 's#Icon.*$#Icon=/opt/shadowsocks/shadowsocks-logo.png#g' /usr/share/applications/shadowsocks-qt5.desktop

#instakll ShadowsocksR client
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/electron-ssr-0.2.0-alpha-4.x86_64.rpm
#logo
	$getPermission cp $currentPath/shadowsocksr-logo.png /opt/ShadowsocksR客户端/shadowsocksr-logo.png
	$getPermission echo 'Icon=/opt/ShadowsocksR客户端/shadowsocksr-logo.png'  >  /usr/share/applications/electron-ssr.desktop

	initSystemTime
	echo 'leave installShadowsocks()'"	$systemTime "
	echo 'leave installShadowsocks()'"	$systemTime " >> $outputRedirectionCommand
}

installTeamViewer()
{
#there will install teamviewer.
	initSystemTime
	echo 'enter installTeamViewer()'"	$systemTime "
	echo 'enter installTeamViewer()'"	$systemTime " >> $outputRedirectionCommand

	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e $currentPath/teamviewer_12.0.85001.i686.rpm ]]
		then
			wget -O $currentPath/teamviewer_12.0.85001.i686.rpm https://dl.tvcdn.de/download/version_12x/teamviewer_12.0.85001.i686.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/teamviewer_12.0.85001.i686.rpm
	elif [[ s$packageManager == s"apt-get" ]]
	then
		if [[ ! -e $currentPath/teamviewer_12.0.85001_i386.deb ]]
		then
			wget -O $currentPath/teamviewer_12.0.85001_i386.deb https://dl.tvcdn.de/download/version_12x/teamviewer_12.0.85001_i386.deb
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/teamviewer_12.0.85001_i386.deb
	fi

	initSystemTime
	echo 'leave installTeamViewer()'"	$systemTime "
	echo 'leave installTeamViewer()'"	$systemTime " >> $outputRedirectionCommand
}

installPython3()
{
#This function will install Python3,and coexist with Python2.
	initSystemTime
	echo 'enter installPython3()'"	$systemTime "
	echo 'enter installPython3()'"	$systemTime " >> $outputRedirectionCommand

#	$getPermission  sed -i 's#/usr/bin/python.*$#/usr/bin/python2#g' /usr/bin/yum
#	$getPermission  sed -i 's#/usr/bin/python.*$#/usr/bin/python2#g' /usr/libexec/urlgrabber-ext-down
#	$getPermission  sed -i 's#/usr/bin/python.*$#/usr/bin/python2 -tt#g' /sbin/yum-complete-transaction

#Some preparations.
	$installCommandHead_skipbroken_nogpgcheck  zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make

	if [[ ! -e "/usr/local/python3" ]]
	then
		if [[ ! -e "$currentPath/Python-3.6.3.tar.xz" ]]
		then
			wget -P $currentPath/  "https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz"
			$changeOwn
		fi
		tar -Jxvf  $currentPath/Python-3.6.3.tar.xz
		$changeOwn
		cd $currentPath/Python-3.6.3
		$currentPath/Python-3.6.3/configure  --prefix=/usr/local/python3 --enable-optimizations
		$changeOwn
		make
		$changeOwn
		$getPermission  make install
		cd $currentPath

		$getPermission  rm -rf $currentPath/Python-3.6.3

	fi

#	$getPermission  rm -r /usr/bin/python
#	$getPermission  rm -r /usr/bin/python.backup
#	$getPermission  ln -s /usr/bin/python2.7 /usr/bin/python
#	$getPermission  cp  /usr/bin/python /usr/bin/python.backup
	$getPermission  rm -r /usr/bin/python3
	$getPermission  rm -r /usr/bin/python3.6.3
	$getPermission  ln -s /usr/local/python3/bin/python3 /usr/bin/python3.6
	$getPermission  ln -s /usr/bin/python3.6 /usr/bin/python3
	$getPermission  ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3

	$installCommandHead_skipbroken_nogpgcheck python-tools

#set default pip source
	$getPermission tee /home/${userName}/.pip/pip.conf <<-'EOF'
[global]
index-url = http://pypi.douban.com/simple
[install]
trusted-host=pypi.douban.com
EOF

	initSystemTime
	echo 'leave installPython3()'"	$systemTime "
	echo 'leave installPython3()'"	$systemTime " >> $outputRedirectionCommand
}

installNetease_cloud_music()
{
#install music player netease-cloud-music
	initSystemTime
	echo 'enter installNetease_cloud_music()'"	$systemTime "
	echo 'enter installNetease_cloud_music()'"	$systemTime " >> $outputRedirectionCommand

#download and install netease-cloud-music
	if [[ ! -e "/opt/netease-cloud-music" ]]
	then
		if [[ ! -e "$currentPath/netease-cloud-music_1.0.0-2_amd64_ubuntu14.04.deb" ]]
		then
			wget -P $currentPath/ http://s1.music.126.net/download/pc/netease-cloud-music_1.0.0-2_amd64_ubuntu14.04.deb
			$changeOwn
		fi
		ar -vx $currentPath/netease-cloud-music_1.0.0-2_amd64_ubuntu14.04.deb
		$changeOwn
		xz -dk $currentPath/data.tar.xz
		$changeOwn
		tar -xvf $currentPath/data.tar
		$changeOwn
		$getPermission  cp -r $currentPath/usr /

		$getPermission  rm -rf $currentPath/control.tar.gz $currentPath/data.tar.xz $currentPath/debian-binary $currentPath/data.tar $currentPath/usr
#chmod
		$getPermission  chmod 4755 /usr/lib/netease-cloud-music/chrome-sandbox

#update glibc lib.
#This lib bellow needn't to update
:<<!
#This is a multiline comment.
		if [[ ! -e "$currentPath/glibc-2.26.tar.gz" ]]
		then
			wget -P $currentPath/ http://ftp.gnu.org/gnu/glibc/glibc-2.26.tar.gz
			$changeOwn
		fi
		tar -zxf $currentPath/glibc-2.26.tar.gz
		$changeOwn
		mkdir $currentPath/glibc-2.26/build
		$changeOwn
		cd $currentPath/glibc-2.26/build
		$currentPath/glibc-2.26/configure --prefix=/usr/local/glibc-2.26
		$changeOwn
		make -j16
		$changeOwn
		$getPermission  make install
		cd $currentPath

		$getPermission  rm -rf $currentPath/glibc-2.26
!
	fi

#edit Desktop file
	$getPermission  mkdir -p /opt/netease-cloud-music
	$getPermission  cp $currentPath/netease-cloud-music-logo.png  /opt/netease-cloud-music
	$getPermission  sed -i 's#Icon.*$#Icon=/opt/netease-cloud-music/netease-cloud-music-logo.png#g' /usr/share/applications/netease-cloud-music.desktop


#install all of the lib
	$installCommandHead_skipbroken_nogpgcheck  linux-vdso.so.1 libcef.so libX11.so.6 libQt5Widgets.so.5 libQt5X11Extras.so.5

	$installCommandHead_skipbroken_nogpgcheck  libQt5DBus.so.5 libQt5Gui.so.5 libQt5Network.so.5 libQt5Multimedia.so.5 libQt5Xml.so.5

	$installCommandHead_skipbroken_nogpgcheck  libXext.so.6 libXtst.so.6 libfontconfig.so.1 libglib-2.0.so.0 libz.so.1 libQt5Core.so.5

	$installCommandHead_skipbroken_nogpgcheck  libdl.so.2 libstdc++.so.6 libm.so.6 libgcc_s.so.1 libpthread.so.0 libc.so.6 librt.so.1

	$installCommandHead_skipbroken_nogpgcheck  libgobject-2.0.so.0 libfreetype.so.6 libpangocairo-1.0.so.0

	$installCommandHead_skipbroken_nogpgcheck  libcairo.so.2 libpango-1.0.so.0 libXi.so.6 libnss3.so

	$installCommandHead_skipbroken_nogpgcheck  libnssutil3.so libsmime3.so libnspr4.so libasound.so.2 libXfixes.so.3 libgio-2.0.so.0

	$installCommandHead_skipbroken_nogpgcheck  libatk-1.0.so.0 libXcursor.so.1 libXrender.so.1 libXss.so.1 libXrandr.so.2

	$installCommandHead_skipbroken_nogpgcheck  libdbus-1.so.3 libexpat.so.1 libcups.so.2 libgtk-x11-2.0.so.0 libgdk-x11-2.0.so.0

	$installCommandHead_skipbroken_nogpgcheck  libgdk_pixbuf-2.0.so.0 ld-linux-x86-64.so.2 libxcb.so.1 libGL.so.1 libpng15.so.15

	$installCommandHead_skipbroken_nogpgcheck  libproxy.so.1 libssl.so.10 libcrypto.so.10 libpulse.so.0 libpcre.so.1 libicui18n.so.50

	$installCommandHead_skipbroken_nogpgcheck  libicuuc.so.50 libicudata.so.50 libpcre16.so.0 libgthread-2.0.so.0

	$installCommandHead_skipbroken_nogpgcheck libsystemd.so.0 libffi.so.6 libpangoft2-1.0.so.0 libthai.so.0 libharfbuzz.so.0

	$installCommandHead_skipbroken_nogpgcheck  libpixman-1.so.0 libEGL.so.1 libxcb-shm.so.0 libxcb-render.so.0 libplc4.so

	$installCommandHead_skipbroken_nogpgcheck  libplds4.so libgmodule-2.0.so.0 libselinux.so.1 libresolv.so.2 libmount.so.1

	$installCommandHead_skipbroken_nogpgcheck  libgssapi_krb5.so.2 libkrb5.so.3 libk5crypto.so.3 libcom_err.so.2 libavahi-common.so.3

	$installCommandHead_skipbroken_nogpgcheck  libavahi-client.so.3 libcrypt.so.1 libXinerama.so.1 libXcomposite.so.1

	$installCommandHead_skipbroken_nogpgcheck  libXdamage.so.1 libXau.so.6 libxcb-dri3.so.0 libxcb-present.so.0 libxcb-sync.so.1

	$installCommandHead_skipbroken_nogpgcheck  libxshmfence.so.1 libglapi.so.0 libX11-xcb.so.1 libxcb-glx.so.0 libxcb-dri2.so.0

	$installCommandHead_skipbroken_nogpgcheck  libXxf86vm.so.1 libdrm.so.2 libmodman.so.1 libpulsecommon-10.0.so libcap.so.2 liblzma.so.5

	$installCommandHead_skipbroken_nogpgcheck  libgcrypt.so.11 libgpg-error.so.0 libdw.so.1 libgraphite2.so.3 libxcb-xfixes.so.0

	$installCommandHead_skipbroken_nogpgcheck  libgbm.so.1 libblkid.so.1 libuuid.so.1 libkrb5support.so.0 libkeyutils.so.1 libfreebl3.so

	$installCommandHead_skipbroken_nogpgcheck  libICE.so.6 libSM.so.6 libwrap.so.0 libsndfile.so.1 libasyncns.so.0 libattr.so.1

	$installCommandHead_skipbroken_nogpgcheck  libelf.so.1 libbz2.so.1 libnsl.so.1 libgsm.so.1

	$installCommandHead_skipbroken_nogpgcheck  qt5-qtbase-gui qt5-qtx11extras qt5-qtmultimedia libXScrnSaver

#install decode ware
	$installCommandHead_skipbroken_nogpgcheck  gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools

	$installCommandHead_skipbroken_nogpgcheck  gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good

	$installCommandHead_skipbroken_nogpgcheck  gstreamer1-plugins-base gstreamer1

	$installCommandHead_skipbroken_nogpgcheck  gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly gstreamer-ffmpeg ffmpeg

	$installCommandHead_skipbroken_nogpgcheck  libvdpau mpg123 mplayer* *mplayer *mplayer-gui mplayer-gui* mplayer mplayer-gui
#*mplayer* *mplayer-gui* mplayer mplayer-gui

	initSystemTime
	echo 'leave installNetease_cloud_music()'"	$systemTime "
	echo 'leave installNetease_cloud_music()'"	$systemTime " >> $outputRedirectionCommand

}

installBlender()
{
#all of the blender's download address is https://download.blender.org/release/
#there will install blender.
	initSystemTime
	echo 'enter installBlender()'"	$systemTime "
	echo 'enter installBlender()'"	$systemTime " >> $outputRedirectionCommand

	if [[ ! -e $currentPath/blender-2.79b-linux-glibc219-x86_64.tar.bz2 ]]
	then
		wget -O $currentPath/blender-2.79b-linux-glibc219-x86_64.tar.bz2 https://download.blender.org/release/Blender2.79/blender-2.79b-linux-glibc219-x86_64.tar.bz2
		$changeOwn
	fi
	tar -jxvf $currentPath/blender-2.79b-linux-glibc219-x86_64.tar.bz2
	$changeOwn

	$getPermission mkdir -p /opt/Blender/blender-2.79b
	$getPermission chmod 777 -R /opt/Blender/*
	$getPermission cp -r $currentPath/blender-2.79b-linux-glibc219-x86_64/* /opt/Blender/blender-2.79b

#creat launcher for blender-2.79b
	$getPermission tee /usr/share/applications/blender-2.79b.desktop <<-'EOF'
[Desktop Entry]
Name=Blender-2.79b
Name[zh_CN]=Blender-2.79b
Comment=Blender-2.79b Client
Exec=/opt/Blender/blender-2.79b/blender
Icon=/opt/Blender/blender-2.79b/blender.svg
Terminal=false
Type=Application
Categories=Application;
Encoding=UTF-8
StartupNotify=true
GenericName=3D modeller
GenericName[es]=modelador 3D
GenericName[de]=3D-Modellierer
GenericName[fr]=modeleur 3D
GenericName[ru]=Редактор 3D-моделей
Comment=3D modeling, animation, rendering and post-production
Comment[es]=modelado 3D, animación, renderizado y post-producción
Comment[de]=3D-Modellierung, Animation, Rendering und Nachbearbeitung
Categories=Graphics;3DGraphics;
MimeType=application/x-blender;
EOF

	$getPermission  rm -rf $currentPath/blender-2.79b-linux-glibc219-x86_64

	initSystemTime
	echo 'leave installBlender()'"	$systemTime "
	echo 'leave installBlender()'"	$systemTime " >> $outputRedirectionCommand
}


installSoftwareBatch()
{
#install some software batched.
	initSystemTime
	echo 'enter installSoftwareBatch()'"	$systemTime "
	echo 'enter installSoftwareBatch()'"	$systemTime " >> $outputRedirectionCommand
	$installCommandHead_skipbroken_nogpgcheck  gcc gcc-++ g++ ntfs-3g

#install monodevelop
	$binaryPackageImport "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
	$getPermission yum-config-manager --add-repo http://download.mono-project.com/repo/centos/
:<<!
如果你想在安装monodevelop的时候增加数字签名验证。请在/etc/yum.repos.d/download.mono-project.com_repo_centos_.repo文件中追加一下两行
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mono-ubuntu
或者追加
gpgcheck=1
gpgkey=http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
如：
	$getPermission echo 'gpgcheck=1' >> /etc/yum.repos.d/download.mono-project.com_repo_centos_.repo
	$getPermission echo 'gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-mono-ubuntu' >> /etc/yum.repos.d/download.mono-project.com_repo_centos_.repo
!

	$installCommandHead_skipbroken_nogpgcheck  mono-complete
	$installCommandHead_skipbroken_nogpgcheck  monodevelop

#install chm reader
	$installCommandHead_skipbroken_nogpgcheck  xchm kchmviewer
#install PDF reader
	$installCommandHead_skipbroken_nogpgcheck  mendeley mendeleydesktop mendele* okular evince xPDF gv

#install docker kvm lxc
	$installCommandHead_skipbroken_nogpgcheck  kvm kvm* *kvm *kvm* docker docker-engine docker* *docker *docker* lxc lxc* *lxc *lxc*
	$installCommandHead_skipbroken_nogpgcheck  kvm docker docker-engine lxc lxc*
	$installCommandHead_skipbroken_nogpgcheck  kvm libvirt python-virtinst qemu-kvm virt-viewer bridge-utils
	$groupinstallCommandHead_skipbroken_nogpgcheck  Virtualization 'Virtualization Client' 'Virtualization Platform' 'Virtualization Tools'
	$installCommandHead_skipbroken_nogpgcheck  kvm kmod-kvm qemu kvm-qemu-img virt-viewervirt-manager
	$installCommandHead_skipbroken_nogpgcheck  kvm kvm* *kvm *kvm*

#install Latex editor
	$installCommandHead_skipbroken_nogpgcheck  lyx texworks texstudio emacs atom texmaker
	$installCommandHead_skipbroken_nogpgcheck  *texworks* texworks* *texworks *texmaker* texmaker* *texmaker
#install texstudio
	if [[ ! -e "$currentPath/texstudio-qt4-2.12.8-13.1.x86_64.rpm" ]]
	then
		wget -P $currentPath/ http://downloadcontent.opensuse.org/repositories/home:/jsundermeyer/CentOS_CentOS-7/x86_64/texstudio-qt4-2.12.8-13.1.x86_64.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/texstudio-qt4-2.12.8-13.1.x86_64.rpm
#finished

#install atmo
	if [[ ! -e "$currentPath/atom.x86_64.rpm" ]]
	then
		wget -P $currentPath/ https://atom-installer.github.com/v1.25.1/atom.x86_64.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/atom.x86_64.rpm
#finished

	$installCommandHead_skipbroken_nogpgcheck  createrepo cairo-dock thunderbird gimp evince p7zip-plugins p7zip-full p7zip-rar rar unrar

	$installCommandHead_skipbroken_nogpgcheck  gcc gcc-++ g++ ntfs-3g adb stardict fuse-ntfs-3g dict valgrind valgrin* grub-customizer

	$installCommandHead_skipbroken_nogpgcheck  gnome-utils gnome-system-monitor axel wget filezilla docky azureus autossh *utossh *utoss* autossh* autoss*

	$installCommandHead_skipbroken_nogpgcheck  deluge shutter starditc supertux zsnes acroread kdevelop anjuta netbeans grub-customizer

	$installCommandHead_skipbroken_nogpgcheck  codeblocks monodevelop glibc.i686 glibc-devel.i686 zlib-devel.i686 ncurses-devel.i686 anjuta

	$installCommandHead_skipbroken_nogpgcheck  cscope lnsight flawfinder crosstool indent flashgot wxwidgets xulrunner.i686 grub-customizer

	$installCommandHead_skipbroken_nogpgcheck  libXtst.i686 libjpeg* libjpeg libpng libpng* freetype freetype* ffmpeg ffmpeg* *ffmpeg *fmpeg*

	$installCommandHead_skipbroken_nogpgcheck  openssh-server openssh-client openssh samba telnet-server autossh *utossh *utoss* autossh* autoss*

	$installCommandHead_skipbroken_nogpgcheck  telnet ssh xinetd fcitx fcitx* makehuman darktable entangle hugin python python3 python-tools

	$installCommandHead_skipbroken_nogpgcheck  python-pip sublime-text xournal tree dia umbrello umlgraph gcc-c++ gcc-c++*

	$installCommandHead_skipbroken_nogpgcheck  gcc gcc-++ g++ ntfs-3g bluefish juffed anjuta asymptote audacious azureus boxes ffmpeg ffmpeg* *ffmpeg *fmpeg*

	$installCommandHead_skipbroken_nogpgcheck  brasero cmyktool codeblocks darkable deluge devhelp dia docky emacs codeblocks* python-tools

	$installCommandHead_skipbroken_nogpgcheck  empathy evolution feh filezilla fontforge umbrello  pinentry-gui ncurses dialog python-tool*

	$installCommandHead_skipbroken_nogpgcheck  fontmanager geary gedit gnomebaker gnusmallta gnu gparted gpick gthumb grub-customizer

	$installCommandHead_skipbroken_nogpgcheck  kdevelop kmplayer* kmplayer musique umbrello  pinentry-gui ncurses dialog

	$installCommandHead_skipbroken_nogpgcheck  monodevelop okteta pan pdf-shuffler pidgin qt qt5 scribus gcc-c++ gcc-c++*

	$installCommandHead_skipbroken_nogpgcheck  shotwell shutter supertuxkart supertux *smplayer smplayer* smplayer thunderbird transmission

	$installCommandHead_skipbroken_nogpgcheck  vlc xine zsnes kvm gdb *gdb gdb*  pinentry-gui ncurses dialog

	$installCommandHead_skipbroken_nogpgcheck  xen vitualbox samba openssh-server openssh-client openssh samba telnet-server telnet ssh

	$installCommandHead_skipbroken_nogpgcheck  xinetd openssh-server openssh-client openssh fcitx  pinentry-gui ncurses dialog

	$installCommandHead_skipbroken_nogpgcheck  fcitx* makehuman darktable entangle gcc-c++ gcc-c++*

	$installCommandHead_skipbroken_nogpgcheck  hugin sublime-text xournal kplayer smplayer* vlc* *vlc *vlc* *totem totem totem*

	$installCommandHead_skipbroken_nogpgcheck  *totem* smplayer vlc totem tree *ssh* ssh *ssh ssh* *network-manager network-manager

	$installCommandHead_skipbroken_nogpgcheck  network-manager* *network-manager*  *gdb* gdb 
#*gnome-mplayer* gnome-mplayer
#	$installCommandHead_skipbroken_nogpgcheck  *gnome-mplayer*

#install chrome
	if [[ ! -e "$currentPath/google-chrome-stable_current_x86_64.rpm" ]]
	then
		wget -P $currentPath/ https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/google-chrome-stable_current_x86_64.rpm

	$installCommandHead_skipbroken_nogpgcheck  lsb
	$installCommandHead_skipbroken_nogpgcheck  libXScrnSaver

#audio and video decode ware

	$installCommandHead_skipbroken_nogpgcheck  qt-recordmydesktop mvgather screenfetch pointdownload gparted k3b nscd
	
	$installCommandHead_skipbroken_nogpgcheck  recordmydeskto* recordmydesktop* *recordmydesktop *ecordmydesktop *ecordmydeskto* pavucontrol pavucontro*
	
	$installCommandHead_skipbroken_nogpgcheck  pavucontrol pavucontro* *pavucontrol

	$installCommandHead_skipbroken_nogpgcheck  unetbootin ms-sys win32codecs mplayer mplayer* smplayer *smplayer* gstreamer* kmplayer

	$installCommandHead_skipbroken_nogpgcheck  vlc potplayer xine quicktime vebvbox

	$installCommandHead_skipbroken_nogpgcheck  itunes totem-xine realplayer clenmentine audacious audacious-plugins-freeworld

	$installCommandHead_skipbroken_nogpgcheck  gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly

	$installCommandHead_skipbroken_nogpgcheck  libtunepimp-extras-freeworld xine-lib-extras-freeworld ffmpeg ffmpeg-libs gstreamer-ffmpeg

	$installCommandHead_skipbroken_nogpgcheck  xvidcore libdvdread libdvdnav lsdvd gstreamer-plugins-good gstreamer-plugins-bad

	$installCommandHead_skipbroken_nogpgcheck  gstreamer-plugins-ugly istanbul wink xvidcap pyvnc2swf recordmydesktop

	$installCommandHead_skipbroken_nogpgcheck  gtk-recordmydesktop kplayer smplayer* vlc* totem* 

# gnome-mplayer*

	$installCommandHead_skipbroken_nogpgcheck  gstreamer1-libav gstreamer1-plugins-bad-freeworld gstreamer1-plugins-base-tools

	$installCommandHead_skipbroken_nogpgcheck  gstreamer1-plugins-ugly gstreamer1-plugins-bad-free gstreamer1-plugins-good gstreamer1-plugins-base

	$installCommandHead_skipbroken_nogpgcheck  gstreamer1 gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly

	$installCommandHead_skipbroken_nogpgcheck  gstreamer-ffmpeg ffmpeg libvdpau mpg123 mplayer* mplayer-gui*

#install download tools
	$installCommandHead_skipbroken_nogpgcheck  multiget wget axel aria2 curl steadyflow flareget kget  xdm uget 

#install video edit tool
	$installCommandHead_skipbroken_nogpgcheck  flowblade openshot aegisub blender pitivi stopmotion jahshaka

#install subtitle tools
	$installCommandHead_skipbroken_nogpgcheck  gnome-subtitles aegisub subtitleeditor gaupol jubler subtitle composer aegisub aegisub xournal

#install audio editer
	$installCommandHead_skipbroken_nogpgcheck  ardour audacity hydrogen mixxx rosegarden musescore musescore
#install other software
	$installCommandHead_skipbroken_nogpgcheck   freeCAD libreCAD brl-CAD freecad librecad brl-cad krita mypaint gimp scribus

	$installCommandHead_skipbroken_nogpgcheck  inkscape imagemagick istanbul  recordmydesktop

	$installCommandHead_skipbroken_nogpgcheck  nepomuk lynx w3m clonezilla partimage redobackup mondorescue fsarchiver partclone g4l

	$installCommandHead_skipbroken_nogpgcheck  doclone gparted 

	$installCommandHead_skipbroken_nogpgcheck  darktable entangle hugin makehuman natron fontforge calligra flow iconv enca calligra-flow calligra*

	$installCommandHead_skipbroken_nogpgcheck  kplayer* smplayer* vlc* totem* mplayer* shotwell feh 

	$installCommandHead_skipbroken_nogpgcheck  VirtualBox virtualbox mkvtoolnix mkvtoolnix*

	$installCommandHead_skipbroken_nogpgcheck  akmod-VirtualBox kernel-devel

	$installCommandHead_skipbroken_nogpgcheck  *VirtualBox VirtualBox* *VirtualBox*  virtualbox *virtualbox virtualbox* *virtualbox*

	$installCommandHead_skipbroken_nogpgcheck  filezilla

	$installCommandHead_skipbroken_nogpgcheck  kernel-devel #*kernel-devel kernel-devel* *kernel-devel*

	$installCommandHead_skipbroken_nogpgcheck  p7zip p7zip-full p7zip-rar rar unrar isomaster electronic-wechat

#gnome-mplayer*

	$installCommandHead_skipbroken_nogpgcheck  ftp-yum samba nfs-utils nfs4 telnet-server xinetd openssh-server openssh-client openssh  httpd tree

#resolve the problem that can not input chinese in "WPS-office" for Debian.
#	$installCommandHead_skipbroken_nogpgcheck fcitx-frontend-qt4 fcitx-frontend-qt5 fcitx-libs-qt fcitx-libs-qt5 libfcitx-qt0 libfcitx-qt5-1

	initSystemTime
	echo 'leave installSoftwareBatch()'"	$systemTime "
	echo 'leave installSoftwareBatch()'"	$systemTime " >> $outputRedirectionCommand
}

installAudioCardDrive()
{
#This function to install audio card drive.
	initSystemTime
	echo 'enter installAudioCardDrive()'"	$systemTime " 
	echo 'enter installAudioCardDrive()'"	$systemTime " >> $outputRedirectionCommand
	$binaryPackageImport $currentPath/RPM-GPG-KEY-elrepo.org
	if [[ ! -e "$currentPath/elrepo-release-7.0-2.el7.elrepo.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
	

#You can remove the notes according to the situation.
	#$getPermission  $packageManager  --enablerepo=elrepo-kernel install -y kernel-ml
	#$getPermission  $packageManager  --enablerepo=elrepo-kernel install -y kernel-ml-devel

	$installCommandHead_skipbroken_nogpgcheck  $currentPath/nux-dextop-release-0-5.el7.nux.noarch.rpm
	$installCommandHead_skipbroken_nogpgcheck  $currentPath/adobe-release-x86_64-1.0-1.noarch.rpm

	$installCommandHead_skipbroken_nogpgcheck  flash-plugin icedtea-web vlc* smplayer* ffmpeg HandBrake-{gui,cli}
	$installCommandHead_skipbroken_nogpgcheck  gstreamer-plugins-bad-nonfree gstreamer1-plugins-bad-freeworld libdvdcss gstreamer{,1}-plugins-ugly
	initSystemTime
	echo 'leave installAudioCardDrive()'"	$systemTime "
	echo 'leave installAudioCardDrive()'"	$systemTime " >> $outputRedirectionCommand
}

installVirtualMachine()
{
#This function will install some virtual machine.
	initSystemTime
	echo 'enter installVirtualMachine()'"	$systemTime "
	echo 'enter installVirtualMachine()'"	$systemTime " >> $outputRedirectionCommand
	$installCommandHead_skipbroken_nogpgcheck  kvm kmod-kvm qemu kvm-qemu-img virt-viewervirt-manager
	initSystemTime
	echo 'leave installVirtualMachine()'"	$systemTime "
	echo 'leave installVirtualMachine()'"	$systemTime " >> $outputRedirectionCommand
}



installMailClientFromCommandLine()
{
#install flash plugins
	initSystemTime
	echo 'enter installMailClientFromCommandLine()'"	$systemTime "
	echo 'enter installMailClientFromCommandLine()'"	$systemTime " >> $outputRedirectionCommand

#install mail client from command line
	$installCommandHead_skipbroken_nogpgcheck  mutt swaks mailx sharutils sendEmail mailutils

	initSystemTime
	echo 'installMailClientFromCommandLine()'"	$systemTime "
	echo 'installMailClientFromCommandLine()'"	$systemTime " >> $outputRedirectionCommand
}

installFlashPlugin()
{
#install flash plugins
	initSystemTime
	echo 'enter installFlashPlugin()'"	$systemTime "
	echo 'enter installFlashPlugin()'"	$systemTime " >> $outputRedirectionCommand
	if [[ ! -e "$currentPath/adobe-release-x86_64-1.0-1.noarch.rpm" ]]
	then
		wget -P $currentPath/ http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/adobe-release-x86_64-1.0-1.noarch.rpm
	$installCommandHead_skipbroken_nogpgcheck  flash-plugin
	initSystemTime
	echo 'leave installFlashPlugin()'"	$systemTime "
	echo 'leave installFlashPlugin()'"	$systemTime " >> $outputRedirectionCommand
}

installLibreOfficeChineseFont()
{
	initSystemTime
	echo 'enter installLibreOfficeChineseFont()'"	$systemTime "
	echo 'enter installLibreOfficeChineseFont()'"	$systemTime " >> $outputRedirectionCommand
	$installCommandHead_skipbroken_nogpgcheck  libreoffice-langpack-zh-Hans
	initSystemTime
	echo 'leave installLibreOfficeChineseFont()'"	$systemTime "
	echo 'leave installLibreOfficeChineseFont()'"	$systemTime " >> $outputRedirectionCommand
}

installLibstdc()
{
	initSystemTime
	echo 'enter installLibstdc()'"	$systemTime "
	echo 'enter installLibstdc()'"	$systemTime " >> $outputRedirectionCommand
	$installCommandHead_skipbroken_nogpgcheck  libstdc++-4.4.7-11.el6.i686
	initSystemTime
	echo 'leave installLibstdc()'"	$systemTime "
	echo 'leave installLibstdc()'"	$systemTime " >> $outputRedirectionCommand
}

installGTK()
{
#install gtk+
	initSystemTime
	echo 'enter installGTK()'"	$systemTime "
	echo 'enter installGTK()'"	$systemTime " >> $outputRedirectionCommand
	$installCommandHead_skipbroken_nogpgcheck  build-essential gnome-core-devel pkg-config devhelp libglib2.0-doc libgtk2.0-doc glade libglade2-dev glade-gnome
	$installCommandHead_skipbroken_nogpgcheck  glade-common glade-doc libgtk3-dev libgtk3* gnome-devel gnome-devel-docs glade*
	$installCommandHead_skipbroken_nogpgcheck  gtk+-devel gtk2 gtk2-devel gtk2-devel-docs libgtk2.0* gnome-devel gnome-devel-docs libgtk3.0*  gtk3 gtk3-devel gtk3-devel-docs
	$installCommandHead_skipbroken_nogpgcheck gtk2 *gtk2 gtk2* *gtk2* gtk3 *gtk3 gtk3* *gtk3* gtk+ *gtk+ gtk+* *gtk+*
#install gtkmm
	$installCommandHead_skipbroken_nogpgcheck gtkmm gtkmm* glade glade* libgtkmm libgtkmm*

	initSystemTime
	echo 'leave installGTK()'"	$systemTime "
	echo 'leave installGTK()'"	$systemTime " >> $outputRedirectionCommand
}

installSublimeText()
{
#install sublime-text
	initSystemTime
	echo 'enter installSublimeText()'"	$systemTime "
	echo 'enter installSublimeText()'"	$systemTime " >> $outputRedirectionCommand
	$binaryPackageImport $currentPath/sublimehq-rpm-pub.gpg
	$getPermission  $packageManager"-config-manager" --add-repo $currentPath/sublime-text.repo

	$installCommandHead_skipbroken_nogpgcheck  sublime-text
	$installCommandHead_skipbroken_nogpgcheck  *sublime-text* *sublime-text sublime-text*
	$installCommandHead_skipbroken_nogpgcheck  *sublime* *sublime sublime sublime*

:<<!
resolve the problem that can not input chinese in "sublime-text" for Debian.
URL: https://www.sinosky.org/linux-sublime-text-fcitx.html
install lib
	$installCommandHead_skipbroken_nogpgcheck  build-essential libgtk2.0-dev
compile
	gcc -shared -o $currentPath/libsublime-imfix.so $currentPath/sublime-imfix.c `pkg-config --libs --cflags gtk+-2.0` -fPIC
	$changeOwn
There haven't finished it yet,if you want to resolve this problem which can not input chinese in "sublime-text",please fill it all.
!
	initSystemTime
	echo 'leave installSublimeText()'"	$systemTime "
	echo 'leave installSublimeText()'"	$systemTime " >> $outputRedirectionCommand
}

installWPS()
{
#install WPS office
	initSystemTime
	echo 'enter installWPS()'"	$systemTime "
	echo 'enter installWPS()'"	$systemTime " >> $outputRedirectionCommand

#create initiator of "WPS-Word"
	$getPermission echo '[Desktop Entry]'  >  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Name=WPS-Word'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Name[zh_CN]=WPS-Word'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Comment=WPS-Word Client'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Exec=/opt/wps-office_10.1.0.5672~a21_x86_64/wps'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Icon=/opt/wps-office_10.1.0.5672~a21_x86_64/WPS-Word-logo.png'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Terminal=false'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Type=Application'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Categories=Application;'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'Encoding=UTF-8'  >>  /usr/share/applications/WPS-Word.desktop
	$getPermission echo 'StartupNotify=true'  >>  /usr/share/applications/WPS-Word.desktop

#create initiator of "WPS-PPT"
	$getPermission cp /usr/share/applications/WPS-Word.desktop /usr/share/applications/WPS-PPT.desktop
	$getPermission sed -i 's#WPS-Word#WPS-PPT#g' /usr/share/applications/WPS-PPT.desktop
	$getPermission sed -i 's#Exec=.*$#Exec=/opt/wps-office_10.1.0.5672~a21_x86_64/wpp#g' /usr/share/applications/WPS-PPT.desktop
	$getPermission sed -i 's#Icon.*$#Icon=/opt/wps-office_10.1.0.5672~a21_x86_64/WPS-PPT-logo.png#g' /usr/share/applications/WPS-PPT.desktop

#create initiator of "WPS-Excel"
	$getPermission cp /usr/share/applications/WPS-Word.desktop /usr/share/applications/WPS-Excel.desktop
	$getPermission sed -i 's#WPS-Word#WPS-Excel#g' /usr/share/applications/WPS-Excel.desktop
	$getPermission sed -i 's#Exec=.*$#Exec=/opt/wps-office_10.1.0.5672~a21_x86_64/et#g' /usr/share/applications/WPS-Excel.desktop
	$getPermission sed -i 's#Icon.*$#Icon=/opt/wps-office_10.1.0.5672~a21_x86_64/WPS-Excel-logo.png#g' /usr/share/applications/WPS-Excel.desktop

#if wps exist,then skip this step.
	if [[ ! -e "$currentPath/wps-office_10.1.0.5672~a21_x86_64.tar.xz" ]]
	then
		wget -P $currentPath/ http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office_10.1.0.5672~a21_x86_64.tar.xz
		$changeOwn
	fi

	if [[ ! -e "/opt/wps-office_10.1.0.5672~a21_x86_64" ]]
	then
		tar -Jxvf $currentPath/wps-office_10.1.0.5672~a21_x86_64.tar.xz
		$changeOwn
		$getPermission cp -r $currentPath/wps-office_10.1.0.5672~a21_x86_64 /opt/
	fi

	$getPermission cp $currentPath/WPS-Excel-logo.png $currentPath/WPS-Word-logo.png $currentPath/WPS-PPT-logo.png  /opt/wps-office_10.1.0.5672~a21_x86_64/

#install fonts
	$getPermission /opt/wps-office_10.1.0.5672~a21_x86_64/install_fonts
	$currentPath/wps-office_10.1.0.5672~a21_x86_64/install_fonts

	$getPermission  rm -rf $currentPath/wps-office_10.1.0.5672~a21_x86_64

#install other wps.You can remove following three lines.
	if [[ ! -e "$currentPath/wps-office-10.1.0.5672-1.a21.x86_64.rpm" ]]
	then
		wget -P $currentPath/ http://kdl.cc.ksosoft.com/wps-community/download/a21/wps-office-10.1.0.5672-1.a21.x86_64.rpm
		$changeOwn
	fi
	$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/wps-office-10.1.0.5672-1.a21.x86_64.rpm


#resolve the problem that can not input chinese in "WPS-office" for Debian.
#	$installCommandHead_skipbroken_nogpgcheck fcitx-frontend-qt4 fcitx-frontend-qt5 fcitx-libs-qt fcitx-libs-qt5 libfcitx-qt0 libfcitx-qt5-1
	initSystemTime
	echo 'leave installWPS()'"	$systemTime "
	echo 'leave installWPS()'"	$systemTime " >> $outputRedirectionCommand
}

installUpdateAndUpgrade()
{
#This function will update&upgrade system.
	initSystemTime
	echo 'enter installUpdateAndUpgrade()'"	$systemTime "
	echo 'enter installUpdateAndUpgrade()'"	$systemTime " >> $outputRedirectionCommand
#	$getPermission  $packageManager  update -y --skip-broken #update linux kernel
	$getPermission  $packageManager  upgrade -y --skip-broken
	initSystemTime
	echo 'leave installUpdateAndUpgrade()'"	$systemTime "
	echo 'leave installUpdateAndUpgrade()'"	$systemTime " >> $outputRedirectionCommand
}

installAutoSSH()
{
#This function will install autossh
	initSystemTime
	echo 'enter installAutoSSH()'"	$systemTime "
	echo 'enter installAutoSSH()'"	$systemTime " >> $outputRedirectionCommand
	if [[ ! -e "$currentPath/autossh-1.4e.tgz" ]]
	then
		wget -P $currentPath/ http://www.harding.motd.ca/autossh/autossh-1.4e.tgz
		$changeOwn
	fi

#unzip tar
	tar -xf $currentPath/autossh-1.4e.tgz
	$changeOwn
#install autossh
	cd $currentPath/autossh-1.4e
	$currentPath/autossh-1.4e/configure
	make
	$getPermission make install

	cd $currentPath/
	$getPermission rm -rf $currentPath/autossh-1.4e

	initSystemTime
	echo 'leave installAutoSSH()'"	$systemTime "
	echo 'leave installAutoSSH()'"	$systemTime " >> $outputRedirectionCommand
}
startSSHService()
{
#This function setting ssh service.
	initSystemTime
	echo 'enter startSSHService()'"	$systemTime "
	echo 'enter startSSHService()'"	$systemTime " >> $outputRedirectionCommand
#start ssh service
	$getPermission service sshd restart
#setting ssh service powerboot
	$getPermission chkconfig sshd on
#setting ssh service powerboot disabled
#	$getPermission chkconfig sshd off
	initSystemTime
	echo 'leave startSSHService()'"	$systemTime "
	echo 'leave startSSHService()'"	$systemTime " >> $outputRedirectionCommand
}
installSogou()
{
#This function will install sogou.
	initSystemTime
	echo 'enter installSogou()'"	$systemTime "
	echo 'enter installSogou()'"	$systemTime " >> $outputRedirectionCommand
#unzip package
	tar -zxvf $currentPath/fcitx-and-sogou-package-x86_64.tar.gz
	$changeOwn

	temp=1
	while (( $temp <= 4 ))
	do

#install sogou
		$packageManagerLocalInstallCommand_skipbroken $currentPath/fcitx-and-sogou-package-x86_64/*.rpm
#安装图形输入法选择器
		$installCommandHead_skipbroken_nogpgcheck im-chooser
#结束 ibus 守护进程
		pkill ibus-daemon

#关闭 gnome-shell 对键盘的监听
		gsettings set org.gnome.settings-daemon.plugins.keyboard active false
#		gsettings "set org.gnome.settings-daemon.plugins.keyboard active false"
#切换输入法为 fcitx
		imsettings-switch fcitx
#重载 fcitx, 启动搜狗面板
		fcitx -r

		let temp++
	done
	unset temp

#最后，需要在Fcitx配置里面选择搜狗输入法，到这里就可以正常使用了.如果输入法面板错误无法打开，则重新运行while中的语句，重启一下就可以了！

	$changeOwn
	$getPermission rm -rf $currentPath/fcitx-and-sogou-package-x86_64

:<<!
如果WPS里面无法输入中文，则用如下办法解决：
分别修改/usr/bin/wps，/usr/bin/et，/usr/bin/wpp内容，添加黑体部分变量，如下：
#!/bin/bash
exportXMODIFIERS="@im=fcitx"
exportQT_IM_MODULE="fcitx"
gOpt=
#gOptExt=-multiply
........

本方法参考地址：http://www.cnblogs.com/Yiutto/p/6204085.html
!


	initSystemTime
	echo 'leave installSogou()'"	$systemTime "
	echo 'leave installSogou()'"	$systemTime " >> $outputRedirectionCommand
}

installWechat()
{
#in this function,we will install wechat
	initSystemTime
	echo 'enter installWechat()'"	$systemTime "
	echo 'enter installWechat()'"	$systemTime " >> $outputRedirectionCommand

#write launcher
	$getPermission  echo '[Desktop Entry]'  >  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Name=Electronic Wechat'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Name[zh_CN]=微信电脑版'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Name[zh_TW]=微信电脑版'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Exec=/opt/electronic-wechat-linux-x64/electronic-wechat'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Icon=/opt/electronic-wechat-linux-x64/Wechat-logo.png'  >>  /usr/share/applications/Wechat.desktop     #The path and name of the browser's logo.
	$getPermission  echo 'Terminal=false'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'X-MultipleArgs=false'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Type=Application'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Encoding=UTF-8'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'Categories=Application;Utility;Network;InstantMessaging;'  >>  /usr/share/applications/Wechat.desktop
	$getPermission  echo 'StartupNotify=true'  >>  /usr/share/applications/Wechat.desktop

#install
	if [[ ! -e "/opt/electronic-wechat-linux-x64" ]]
	then
		if [[ ! -e "$currentPath/electronic-wechat-linux-x64.tar.gz" ]]
		then
#old version
#			wget -O $currentPath/electronic-wechat-linux-x64.tar.gz https://github.com/geeeeeeeeek/electronic-wechat/releases/download/v1.4.0/linux-x64.tar.gz

			wget -O $currentPath/electronic-wechat-linux-x64.tar.gz https://github.com/geeeeeeeeek/electronic-wechat/releases/download/V2.0/linux-x64.tar.gz
			$changeOwn

		fi

#unzip tar
		tar -zxvf $currentPath/electronic-wechat-linux-x64.tar.gz
		$changeOwn
		$getPermission cp -r $currentPath/electronic-wechat-linux-x64  /opt/
	fi

	$getPermission rm -rf $currentPath/electronic-wechat-linux-x64

	initSystemTime
	echo 'leave installWechat()'"	$systemTime "
	echo 'leave installWechat()'"	$systemTime " >> $outputRedirectionCommand
}

#first we need to cp "mcp" to "/usr/bin/"
	$getPermission cp $currentPath/mcp /usr/bin/
	$getPermission chmod +x /usr/bin/mcp



#Then,we will install all of the software.


initSystemTime
echo "installing...	$systemTime "
echo "installing...	$systemTime " >> $outputRedirectionCommand

enterCurrentRootPath
settingRepo

enterCurrentRootPath
installSogou

enterCurrentRootPath
installFirefox

enterCurrentRootPath
installWPS

enterCurrentRootPath
installNetease_cloud_music

#enterCurrentRootPath
#installWechat

enterCurrentRootPath
installShadowsocks

enterCurrentRootPath
installPython3

enterCurrentRootPath
installBlender

enterCurrentRootPath
installUpdateAndUpgrade

enterCurrentRootPath
#installSoftwareBatch

enterCurrentRootPath
installAudioCardDrive

enterCurrentRootPath
installAutoSSH

enterCurrentRootPath
installVirtualMachine

enterCurrentRootPath
installFlashPlugin

enterCurrentRootPath
installLibreOfficeChineseFont

enterCurrentRootPath
installLibstdc

enterCurrentRootPath
installGTK

enterCurrentRootPath
installSublimeText

enterCurrentRootPath
startSSHService

enterCurrentRootPath
installTeamViewer

initSystemTime
echo "First installing already completed .	$systemTime "
echo "First installing already completed .	$systemTime " >> $outputRedirectionCommand

i=2
while (( $i <= $loopTime ))
do

	if [[ $i -eq 2 ]]
	then
		initSystemTime
		echo -e "\033[47;30mThen we will start reinstall some software ensure all software has been properly installed.	$systemTime \033[0m"
		echo "Then we will start reinstall some software ensure all software has been properly installed.	$systemTime " >> $outputRedirectionCommand

		initSystemTime
		echo -e "\033[47;30mPlease wait...	$systemTime \033[0m"
		echo "Please wait...	$systemTime " >> $outputRedirectionCommand
	fi

	initSystemTime
	echo "" >> $outputRedirectionCommand
	echo -e "\033[46;30mThen,the {$i}th repetition start.	$systemTime \033[0m"
	echo "Then,the {$i}th repetition start.	$systemTime " >> $outputRedirectionCommand
	echo "" >> $outputRedirectionCommand

	enterCurrentRootPath
	settingRepo

	enterCurrentRootPath
	installSogou

	enterCurrentRootPath
	installWPS

	enterCurrentRootPath
	installNetease_cloud_music

#	enterCurrentRootPath
#	installWechat

	enterCurrentRootPath
	installShadowsocks

	enterCurrentRootPath
	installPython3

	enterCurrentRootPath
	installUpdateAndUpgrade

	enterCurrentRootPath
#	installSoftwareBatch

	enterCurrentRootPath
	installAudioCardDrive

	enterCurrentRootPath
	installAutoSSH

	enterCurrentRootPath
	installVirtualMachine

	enterCurrentRootPath
	installFlashPlugin

	enterCurrentRootPath
	installLibreOfficeChineseFont

	enterCurrentRootPath
	installLibstdc

	enterCurrentRootPath
	installGTK

	enterCurrentRootPath
	installSublimeText

	enterCurrentRootPath
	startSSHService

	enterCurrentRootPath
	installTeamViewer

	enterCurrentRootPath
	installUpdateAndUpgrade

	initSystemTime
	echo -e "\033[46;30mCelebrate,the {$i}th repetition has finished.	$systemTime \033[0m"
	echo "Celebrate,the {$i}th repetition has finished.	$systemTime " >> $outputRedirectionCommand
	echo "" >> $outputRedirectionCommand

	let i++
done

initSystemTime
echo -e "\033[42;30mAll of work that install software have done.	$systemTime \033[0m"
echo "All of work that install software have done.	$systemTime " >> $outputRedirectionCommand

echo ""
echo "" >> $outputRedirectionCommand
echo ""
echo "" >> $outputRedirectionCommand

initSystemTime
echo -e "\033[;31mPlease run command \"fcitx-configtool\" and \"sogou-qimpanel\" to setting your sogou-pinyin typewrriting and then reboot you computer to enjoy the new system.	$systemTime \033[0m"
echo "Please run command \"fcitx-configtool\" and \"sogou-qimpanel\" to setting your sogou-pinyin typewrriting and then reboot you computer to enjoy the new system.	$systemTime " >> $outputRedirectionCommand

echo ""
echo "" >> $outputRedirectionCommand
echo ""
echo "" >> $outputRedirectionCommand
