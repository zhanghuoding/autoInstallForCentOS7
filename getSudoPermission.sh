#!/bin/bash


################################################################
#  author   :Owen Wang                                         #
#  time     :2017-10-07                                        #
#  modify   :2019-12-12                                        #
#  site     :Yunnan University                                 #
#  e-mail   :wangbobochn@gmail.com                             #
################################################################



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

packageManagerLocalInstallCommand=$getPermission" "$packageManager" localinstall -y "
packageManagerLocalInstallCommand_skipbroken=$packageManagerLocalInstallCommand"  --skip-broken "
packageManagerLocalInstallCommand_skipbroken_nogpgcheck=$packageManagerLocalInstallCommand_skipbroken" --nogpgcheck "

#===================
#If you want to redirect uotput in file,please remove the note in the folloeing two lines.
#===================
#installCommandHead_skipbroken_nogpgcheck=$getPermission" "$packageManager" install -y --skip-broken  --nogpgcheck " 2>> $outputRedirectionCommand
#packageManagerLocalInstallCommand_skipbroken_nogpgcheck=$getPermission" "$packageManager" localinstall -y --skip-broken " 2>> $outputRedirectionCommand

#创建用户 添加用户密码
groupadd $userName
useradd -g $userName $userName
passwd $userName


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

	$getPermission echo 'export TERM=xterm-256color' | $getPermission tee -ai /etc/bashrc
	$getPermission echo 'export TERM=screen.linux' | $getPermission tee -ai /etc/bashrc
#Perform the basic configuration for vimx
	$getPermission tee -ai /etc/vimrc <<-"EOF"

set t_Co=256
set number
set cursorline
highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
set cursorcolumn
highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
set autoindent
set smartindent
set laststatus=2
EOF

	$installCommandHead_skipbroken_nogpgcheck  wget curl axel gcc gcc-++ g++ gcc-* ntfs-3g aria2 grub-customizer yum-versionlock git* vim vim-X11 vim* p7zip-plugins p7zip-full p7zip-rar rar unrar bzip2 unzip zip *zip* enconv iconv  enca file file* libtool docker docker* mtr traceroute  network*
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria2
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria
	
#set configuration for keep alive for long time
	$getPermission sed -i 's/#TCPKeepAlive yes/TCPKeepAlive yes/g' /etc/ssh/sshd_config
	$getPermission sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 60/g' /etc/ssh/sshd_config
	$getPermission sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 30/g' /etc/ssh/sshd_config
	
	$getPermission echo 'export DISPLAY=:0.0' | $getPermission tee -ai /etc/bashrc
	$getPermission xhost +
	
	initSystemTime
	echo 'leave start()'"	$systemTime "
	echo 'leave start()'"	$systemTime " >> $outputRedirectionCommand
}


echo "work start...	$systemTime "
echo "work start...	$systemTime " >> $outputRedirectionCommand

start

echo "The work have done.	$systemTime "
echo "The work have done.	$systemTime " >> $outputRedirectionCommand

echo ""
echo "" >> $outputRedirectionCommand
echo ""
echo "" >> $outputRedirectionCommand

echo -e "\033[0;37m========================================================================\033[0m"
echo -e "\033[0;37m   Please run the following command to configure DNS.	$systemTime \033[0m"
echo -e "\033[0;37m   You can see the tutorial at websit:	\033[0m"
echo -e "\033[0;37m	[ https://www.cnblogs.com/baihuitestsoftware/articles/9519724.html ]	\033[0m"
echo -e "\033[0;37m	[ https://blog.csdn.net/u010599211/article/details/86672940 ]	\033[0m"
echo -e "\033[0;37m	[ https://www.cnblogs.com/liuhedong/p/10695969.html ]	\033[0m"
echo -e "\033[0;37m------------------------------------------------------------------------\033[0m"
echo -e "\033[0;37m										\033[0m"
echo -e "\033[0;37m	$sudo systemctl restart NetworkManager	\033[0m"
echo -e "\033[0;37m	$sudo nmcli con show	\033[0m"
echo -e "\033[0;37m	$sudo nmcli con mod "System eth0" ipv4.dns "114.114.114.114 8.8.8.8"	\033[0m"
echo -e "\033[0;37m	$sudo nmcli con up "System eth0"	\033[0m"
echo -e "\033[0;37m										\033[0m"
echo -e "\033[0;37m========================================================================\033[0m"
#echo -e "\033[41;30mPlease run the script named \"setup.sh\"to continue.	$systemTime \033[0m"
echo "Please run the script named \"setup.sh\"to continue.	$systemTime"
echo "Please run the script named \"setup.sh\"to continue.	$systemTime " >> $outputRedirectionCommand

echo ""
echo "" >> $outputRedirectionCommand
echo ""
echo "" >> $outputRedirectionCommand
