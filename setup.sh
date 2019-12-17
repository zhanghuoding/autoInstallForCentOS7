#!/bin/bash


################################################################
#  author   :Owen Wang                                         #
#  time     :2017-10-07                                        #
#  modify   :2019-12-17                                        #
#  site     :Yunnan University                                 #
#  e-mail   :wangbobochn@gmail.com                             #
################################################################



#When you run this script,you should add the first parameter with your user name.
#The second parameter will control the time of install loop.So,the second parameter must be a digital.
#The third paramenter will decide whether upgrade or update your system,upgrade will be execute when 
#you give parameter "upgrade",and upgrade and update will all be execute when you give parameter as update.
#If you want to run this script,you should clear that whether you want to output redirection.
#You should add the forth parameter "-y" to achieve output redirection or "-n" to disabled redirection.

#executing example:
#  $sudo ./setup.sh username -y upgrade
#or executing lisk the follows:
#  $sudo ./setup.sh username -y noupgrade

#inorder to reuse this shell file,there are some variable


#this script need three parameters
if test $# -lt 4
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

readonly getPermission

userName=$1
loopTime=$2
#ensure the second parameter is a digital.
expr $loopTime "+" 10
if [[ $? != 0 ]]
then
	echo "Sorry! Please enter a digital with the second parameter!"
	exit
fi

whetherUpdateOrUpgrade=$3
readonly whetherUpdateOrUpgrade

outputRedirectionFlag=$4
readonly outputRedirectionFlag

currentPath=$( pwd )
currentPath=${currentPath}/Resource
readonly currentPath
if [[ ! -e $currentPath ]]
then
	$getPermission mkdir -p $currentPath
	$changeOwn
fi

if [[ s$outputRedirectionFlag == s"-y" ]]
then
	outputRedirectionFile="$currentPath/../outputInfo.log"
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

##################################################################################
##################################   Template   ##################################
##################################################################################
##################################################################################
:<<!
if [[ s$packageManager == s"yum" ]]
then
	xxxx
elif [[ s$packageManager == s"apt-get" ]]
then
	xxxx
fi
!
##################################################################################
##################################################################################
##################################################################################
##################################################################################



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

	$installCommandHead_skipbroken_nogpgcheck  wget curl axel gcc gcc-++ g++ gcc-* ntfs-3g aria2 grub-customizer yum-versionlock git* vim vim-X11 vim* p7zip-plugins p7zip-full p7zip-rar rar unrar bzip2 unzip zip *zip* enconv iconv  enca file file* libtool docker docker* mtr traceroute network* tmux* screen* fbida fbida*
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria2
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria
		
	echo $userName' ALL=(ALL) ALL'   >>  /etc/sudoers

	echo "menuentry 'windows 7' {"  >> /boot/grub2/grub.cfg
	echo 'insmod ntfs'  >> /boot/grub2/grub.cfg
	echo 'set root=(hd0,1)'  >> /boot/grub2/grub.cfg
	echo 'chainloader +1'  >> /boot/grub2/grub.cfg
	echo '}'  >> /boot/grub2/grub.cfg

##########################################################################
##########################################################################
#############    This part is very important!   ##########################
#####   The software package version will was locked below.    ###########
##########################################################################
#lock software package version
#		echo "exclude=gnome-shell.x86_64.0.3.28.3-6.el7"  >> /etc/yum.conf
#		echo "exclude=gnome-shell*"  >> /etc/yum.conf
##########################################################################
##########################################################################
##########################################################################
##########################################################################
##########################################################################

	initSystemTime
	echo 'leave start()'"	$systemTime "
	echo 'leave start()'"	$systemTime " >> $outputRedirectionCommand
}


installRemoteTools()
{
#ready
	initSystemTime
	echo 'enter installRemoteTools()'"	$systemTime "
	echo 'enter installRemoteTools()'"	$systemTime " >> $outputRedirectionCommand
#install sshpass
	if [[ ! -e "/opt/sshpass-1.06" ]]
	then	
#install from software repositories
		$installCommandHead_skipbroken_nogpgcheck sshpass sshpass*

#download the sources
		if [[ ! -e "$currentPath/sshpass-1.06.tar.gz" ]]
		then
			wget -P $currentPath/ https://nchc.dl.sourceforge.net/project/sshpass/sshpass/1.06/sshpass-1.06.tar.gz 
			$changeOwn
		fi
		
		tar -zxvf $currentPath/sshpass-1.06.tar.gz && cd $currentPath/sshpass-1.06
		$changeOwn
		$currentPath/sshpass-1.06/configure --prefix=/opt/sshpass-1.06 && make
		$getPermission make install && $getPermission mkdir -p /opt/sshpass-1.06
		cd $currentPath
		$getPermission rm -rf $currentPath/sshpass-1.06

		$getPermission cp /opt/sshpass-1.06/bin/sshpass /usr/bin/
	else
		echo "The version of sshpass is 'sshpass-1.06' ,so you needn't to update,program do nothing."
	fi

#install tcl
	if [[ ! -e "/opt/tcl8.6.9_has-been-installed" ]]
	then	
#install from software repositories
		$installCommandHead_skipbroken_nogpgcheck tcl tcl* tk tk*

#download the sources
		if [[ ! -e "$currentPath/tcl8.6.9-src.tar.gz" ]]
		then
			axel https://nchc.dl.sourceforge.net/project/tcl/Tcl/8.6.9/tcl8.6.9-src.tar.gz 
			$changeOwn
		fi
		
		tar -zxvf $currentPath/tcl8.6.9-src.tar.gz
		$changeOwn
		cd $currentPath/tcl8.6.9/unix && $currentPath/tcl8.6.9/unix/configure && make
		$getPermission make install && $getPermission mkdir -p /opt/tcl8.6.9_has-been-installed
		cd $currentPath
		$getPermission rm -rf $currentPath/tcl8.6.9
		
	else
		echo "The version of tcl is 'tcl8.6.9' ,so you needn't to update,program do nothing."
	fi

#install expect
	if [[ ! -e "/opt/expect5.45.4_has-been-installed" ]]
	then	
#install from software repositories
		$installCommandHead_skipbroken_nogpgcheck expect expectk expect*

#download the sources
		if [[ ! -e "$currentPath/expect5.45.4.tar.gz" ]]
		then
			axel https://nchc.dl.sourceforge.net/project/expect/Expect/5.45.4/expect5.45.4.tar.gz 
			$changeOwn
		fi
		
		tar -zxvf $currentPath/expect5.45.4.tar.gz
		$changeOwn
		cd $currentPath/expect5.45.4 && $currentPath/expect5.45.4/configure && make
		$getPermission make install && $getPermission mkdir -p /opt/expect5.45.4_has-been-installed
		cd $currentPath
		$getPermission rm -rf $currentPath/expect5.45.4
		
	else
		echo "The version of expect is 'expect5.45.4' ,so you needn't to update,program do nothing."
	fi
	initSystemTime
	echo 'leave installRemoteTools()'"	$systemTime "
	echo 'leave installRemoteTools()'"	$systemTime " >> $outputRedirectionCommand
}

installGCCForHigherVersion()
{
#This function will update your GCC to higher version.
	initSystemTime
	echo 'enter installGCCForHigherVersion()'"	$systemTime "
	echo 'enter installGCCForHigherVersion()'"	$systemTime " >> $outputRedirectionCommand

	gccV=$(gcc --version)
#	if [[ s$gccV == s"gcc (GCC) 8.3.0"* ]]
	if [[ ! -e "/opt/gcc-8.3.0_has-been-installed" ]]
	then
#install gmp
		if [[ ! -e "$currentPath/gmp-6.1.2.tar.bz2" ]]
		then
			wget -P $currentPath/ https://gmplib.org/download/gmp/gmp-6.1.2.tar.bz2
			$changeOwn
		fi
		tar -jxvf $currentPath/gmp-6.1.2.tar.bz2
		$changeOwn
		cd $currentPath/gmp-6.1.2
		mkdir -p $currentPath/gmp-6.1.2/build
		cd $currentPath/gmp-6.1.2/build
		$currentPath/gmp-6.1.2/configure --prefix=/usr/local/gmp-6.1.2 --build=x86_64-linux-gnu
		make -j4
		$changeOwn
		$getPermission  make install
		cd $currentPath
		$getPermission ln -s /usr/local/gmp-6.1.2/lib/libgmp.so.10.3.2 /usr/lib/libgmp.so.10
		$getPermission rm -f /lib/libgmp.so.10
		$getPermission ln -s /usr/local/gmp-6.1.2/lib/libgmp.so.10.3.2 /lib/libgmp.so.10
		$getPermission rm -rf $currentPath/gmp-6.1.2
#install mpfr
		if [[ ! -e "$currentPath/mpfr-4.0.2.tar.gz" ]]
		then
			wget -P $currentPath/ https://www.mpfr.org/mpfr-current/mpfr-4.0.2.tar.gz
			$changeOwn
		fi
		tar -zxvf $currentPath/mpfr-4.0.2.tar.gz && mkdir $currentPath/mpfr-4.0.2/build && cd $currentPath/mpfr-4.0.2/build
		$changeOwn
		$currentPath/mpfr-4.0.2/configure --build=x86_64-linux-gnu --prefix=/usr/local/mpfr-4.0.2 --with-gmp=/usr/local/gmp-6.1.2
		make -j4
		$changeOwn
		$getPermission make install
		cd $currentPath
		$getPermission ln -s /usr/local/mpfr-4.0.2/lib/libmpfr.so.6.0.2 /usr/lib/libmpfr.so.6
		$getPermission rm -f /lib/libmpfr.so.6
		$getPermission ln -s /usr/local/mpfr-4.0.2/lib/libmpfr.so.6.0.2 /lib/libmpfr.so.6
		$getPermission rm -rf $currentPath/mpfr-4.0.2
#install mpc
		if [[ ! -e "$currentPath/mpc-1.1.0.tar.gz" ]]
		then
			wget -P $currentPath/ http://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz
			$changeOwn
		fi
		tar -zxvf $currentPath/mpc-1.1.0.tar.gz && mkdir $currentPath/mpc-1.1.0/build && cd $currentPath/mpc-1.1.0/build
		$changeOwn
		$currentPath/mpc-1.1.0/configure --build=x86_64-linux-gnu --prefix=/usr/local/mpc-1.1.0 --with-gmp=/usr/local/gmp-6.1.2 --with-mpfr=/usr/local/mpfr-4.0.2
		make -j4
		$changeOwn
		$getPermission  make install
		cd $currentPath
		$getPermission ln -s /usr/local/mpc-1.1.0/lib/libmpc.so.3.1.0 /usr/lib/libmpc.so.3
		$getPermission rm -f /lib/libmpc.so.3
		$getPermission ln -s /usr/local/mpc-1.1.0/lib/libmpc.so.3.1.0 /lib/libmpc.so.3
		$getPermission rm -rf $currentPath/mpc-1.1.0
		
#preprocessing work
		$installCommandHead_skipbroken_nogpgcheck glibc-devel.i686 glibc-devel libgcc.i686 gcc gcc-c++ gcc-* libtool

#then install gcc
		if [[ ! -e "$currentPath/gcc-8.3.0.tar.gz" ]]
		then
			wget -P $currentPath/ http://mirrors.hust.edu.cn/gnu/gcc/gcc-8.3.0/gcc-8.3.0.tar.gz
			$changeOwn
		fi
		tar -zxvf $currentPath/gcc-8.3.0.tar.gz
		$changeOwn
		cd $currentPath/gcc-8.3.0
		$currentPath/gcc-8.3.0/contrib/download_prerequisites
		$changeOwn
#maybe there is an error "/usr/bin/ld: cannot find crt1.o: No such file or directory",so we find this file like bellow
		$getPermission find /usr/ -name crt*
		$getPermission ln -s /usr/lib/x86_64-redhat-linux6E/lib64/crt1.o /usr/lib/crt1.o
		$getPermission ln -s /usr/lib/x86_64-redhat-linux6E/lib64/crti.o /usr/lib/crti.o
		mkdir $currentPath/gcc-8.3.0/build && cd $currentPath/gcc-8.3.0/build
#set Path
		export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/
		export C_INCLUDE_PATH=/usr/include/x86_64-linux-gnu
		export CPLUS_INCLUDE_PATH=/usr/include/x86_64-linux-gnu

#if there is an error ".. ../mpc/src/mul.c:error: conflicting types for ‘mpfr_fmma’ 错误：与‘mpfr_fmma’类型冲突 ",then do bellow
		$getPermission sed -i 's/mpfr_fmma/mpfr_fmma_mp/g' /usr/local/mpfr-4.0.2/include/mpfr.h
#if there is an error "make[2]: *** [configure-stage1-zlib] 错误 1” then do fellow
		$getPermission ntpdate cn.pool.ntp.org


		$currentPath/gcc-8.3.0/configure --build=x86_64-linux-gnu --prefix=/usr/local/gcc-8.3.0 --with-gmp=/usr/local/gmp-6.1.2 --with-mpfr=/usr/local/mpfr-4.0.2 --with-mpc=/usr/local/mpc-1.1.0 --enable-checking=release --disable-multilib --program-suffix=-8.3.0
		make -j4
		$changeOwn
		$getPermission ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
		$getPermission make install && $getPermission mkdir -p /opt/gcc-8.3.0_has-been-installed
		cd $currentPath
		$getPermission rm -rf $currentPath/gcc-8.3.0
		
#then add the path of gcc-8.3.0 to system environment PATH
#		$getPermission echo 'export PATH=/usr/local/gcc-8.3.0/bin:$PATH' >> /etc/bashrc
		$getPermission mv /usr/bin/gcc /usr/bin/gcc-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gcc-8.3.0 /usr/bin/gcc
		$getPermission mv /usr/bin/gcc-ar /usr/bin/gcc-ar-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gcc-ar-8.3.0 /usr/bin/gcc-ar
		$getPermission mv /usr/bin/gcc-nm /usr/bin/gcc-nm-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gcc-nm-8.3.0 /usr/bin/gcc-nm
		$getPermission mv /usr/bin/gcc-ranlib /usr/bin/gcc-ranlib-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gcc-ranlib-8.3.0 /usr/bin/gcc-ranlib
		$getPermission mv /usr/bin/gcov /usr/bin/gcov-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gcov-8.3.0 /usr/bin/gcov
#		sudo update-alternatives --remove-all gcc
		$getPermission mv /usr/bin/c++ /usr/bin/c++-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/c++-8.3.0 /usr/bin/c++
		$getPermission mv /usr/bin/cpp /usr/bin/cpp-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/cpp-8.3.0 /usr/bin/cpp
		$getPermission mv /usr/bin/g++ /usr/bin/g++-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/g++-8.3.0 /usr/bin/g++
		$getPermission mv /usr/bin/gfortran /usr/bin/gfortran-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gfortran-8.3.0 /usr/bin/gfortran
		$getPermission mv /usr/bin/gcov-dump /usr/bin/gcov-dump-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gcov-dump-8.3.0 /usr/bin/gcov-dump
		$getPermission mv /usr/bin/gcov-tool /usr/bin/gcov-tool-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/gcov-tool-8.3.0 /usr/bin/gcov-tool
		$getPermission mv /usr/bin/x86_64-linux-gnu-gcc-nm /usr/bin/x86_64-linux-gnu-gcc-nm-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/x86_64-linux-gnu-gcc-nm-8.3.0 /usr/bin/x86_64-linux-gnu-gcc-nm
		$getPermission mv /usr/bin/x86_64-linux-gnu-gfortran /usr/bin/x86_64-linux-gnu-gfortran-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/x86_64-linux-gnu-gfortran-8.3.0 /usr/bin/x86_64-linux-gnu-gfortran
		$getPermission mv /usr/bin/linux-gnu-gcc-ranlib /usr/bin/linux-gnu-gcc-ranlib-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/linux-gnu-gcc-ranlib-8.3.0 /usr/bin/linux-gnu-gcc-ranlib
		$getPermission mv /usr/bin/x86_64-linux-gnu-gcc-ar /usr/bin/x86_64-linux-gnu-gcc-ar-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/x86_64-linux-gnu-gcc-ar-8.3.0 /usr/bin/x86_64-linux-gnu-gcc-ar
		$getPermission mv /usr/bin/x86_64-linux-gnu-c++ /usr/bin/x86_64-linux-gnu-c++-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/x86_64-linux-gnu-c++-8.3.0 /usr/bin/x86_64-linux-gnu-c++
		$getPermission mv /usr/bin/x86_64-linux-gnu-gcc /usr/bin/x86_64-linux-gnu-gcc-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/x86_64-linux-gnu-gcc-8.3.0 /usr/bin/x86_64-linux-gnu-gcc
		$getPermission mv /usr/bin/x86_64-linux-gnu-g++ /usr/bin/x86_64-linux-gnu-g++-4.8.5
		$getPermission ln -s /usr/local/gcc-8.3.0/bin/x86_64-linux-gnu-g++-8.3.0 /usr/bin/x86_64-linux-gnu-g++
#Then,we need create other soft links
		$getPermission cp $currentPath/gcc-8.3.0/x86_64-pc-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6.0.25 /lib64
#backup old soft link and create a new one
		$getPermission mv /usr/lib64/libstdc++.so.6 /usr/lib64/libstdc++.so.6.old
		$getPermission ln -s /usr/local/gcc-8.3.0/lib64/libstdc++.so.6.0.25 /usr/lib64/libstdc++.so.6
		$getPermission mv /lib64/libstdc++.so.6 /lib64/libstdc++.so.6.old
		$getPermission ln -s /usr/local/gcc-8.3.0/lib64/libstdc++.so.6.0.25 /lib64/libstdc++.so.6


	else
		echo "The version of gcc is 'gcc (GCC) 8.3.0' ,so you needn't to update,program do nothing."
	fi

	initSystemTime
	echo 'leave installGCCForHigherVersion()'"	$systemTime " 
	echo 'leave installGCCForHigherVersion()'"	$systemTime " >> $outputRedirectionCommand
}

installZhcon()
{
#install Chinese system zhcon
	initSystemTime
	echo 'enter installZhcon()'"	$systemTime "
	echo 'enter installZhcon()'"	$systemTime " >> $outputRedirectionCommand

	if [[ ! -e "/opt/zhcon-0.2.6_has-been-installed" ]]
	then	
#preprocessing work
		$installCommandHead_skipbroken_nogpgcheck ncurses* ncurses-devel fbida*

#download the sources
		if [[ ! -e "$currentPath/zhcon-0.2.5.tar.gz" ]]
		then
			wget -P $currentPath/ -O zhcon-0.2.5.tar.gz https://sourceforge.net/projects/zhcon/files/zhcon/0.2.6/zhcon-0.2.5.tar.gz/download
			$changeOwn
		fi
		
		if [[ ! -e "$currentPath/zhcon-0.2.5-to-0.2.6.diff.gz" ]]
		then
			wget -P $currentPath/ -O zhcon-0.2.5-to-0.2.6.diff.gz https://sourceforge.net/projects/zhcon/files/zhcon/0.2.6/zhcon-0.2.5-to-0.2.6.diff.gz/download
			$changeOwn
		fi
		
		tar -zxvf $currentPath/zhcon-0.2.5.tar.gz
		gunzip $currentPath/zhcon-0.2.5-to-0.2.6.diff.gz
		$changeOwn
		cd $currentPath/zhcon-0.2.5
		patch -p1 < $currentPath/zhcon-0.2.5-to-0.2.6.diff
		mkdir -p $currentPath/zhcon-0.2.5/build && cd $currentPath/zhcon-0.2.5/build
		export LIBS=" -lncurses"
#		$currentPath/zhcon-0.2.5/configure --prefix=/usr/local/zhcon-0.2.6
		$currentPath/zhcon-0.2.5/configure
		$getPermission sed -i 's/#include "fbdev.h"/#include "fbdev.h"\n#include <string.h>/g'  $currentPath/zhcon-0.2.5/src/display/fblinear4.h
		$getPermission sed -i 's/#include "fbdev.h"/#include "fbdev.h"\n#include <string.h>/g'  $currentPath/zhcon-0.2.5/src/display/fblinear8.h
		$getPermission sed -i 's/#include <string>/#include <string>\n#include <string.h>/g'  $currentPath/zhcon-0.2.5/src/basefont.h
		$getPermission sed -i 's/ *p = (unsigned int) p + mpText;/         p = (unsigned long int) p + mpText;/g'  $currentPath/zhcon-0.2.5/src/winime.cpp
		$getPermission sed -i 's/#include <vector>/#include <vector>\n#include <sys\/select.h>/g'  $currentPath/zhcon-0.2.5/src/inputmanager.h
		$getPermission sed -i 's/#include <string>/#include <string>\n#include <stdlib.h>/g'  $currentPath/zhcon-0.2.5/src/inputclient.h $currentPath/zhcon-0.2.5/src/configfile.h $currentPath/zhcon-0.2.5/src/zhcon.h
		$getPermission sed -i 's/#include <vector>/#include <vector>\n#include <stdlib.h>/g'  $currentPath/zhcon-0.2.5/src/inputmanager.h
		$getPermission sed -i 's/#include "cmdline.h"/#include "cmdline.h"\n#include <stdlib.h>/g'  $currentPath/zhcon-0.2.5/src/cmdline.c
	
		make -j4
		$changeOwn
		$getPermission make install && $getPermission mkdir -p /opt/zhcon-0.2.6_has-been-installed
		cd $currentPath
		$getPermission rm -rf $currentPath/zhcon-0.2.5

:<<!
		$getPermission ln -s /usr/local/zhcon-0.2.6/bin/zhcon /usr/bin/zhcon
		$getPermission ln -s /usr/local/zhcon-0.2.6/etc/zhcon.conf  /etc/zhcon.conf
		$getPermission ln -s /usr/local/zhcon-0.2.6/lib/zhcon /usr/share/zhcon
		$getPermission ln -s /usr/local/zhcon-0.2.6/man/man1/zhcon.1  /usr/share/man/man1/zhcon.1.gz
!

		$getPermission ln -s /usr/local/etc/zhcon.conf /etc/zhcon.conf
		$getPermission ln -s /usr/local/bin/zhcon /usr/bin/zhcon
		
		
#then we should modify the profile
		$getPermission sed -i '/#type := native | unicon/,+23d' /etc/zhcon.conf
		$getPermission tee -ai /etc/zhcon.conf <<-'EOF'
#type := native | unicon
#ime = 智能拼音,modules/cce/cce_pinyin.so,modules/cce/dict,gb2312,unicon
#ime = 全拼,,input/winpy.mb,gb2312,native
#ime = 五笔,,input/wb.mb,gb2312,native
#ime = 双拼,,input/winsp.mb,gb2312,native
#ime = ︽30,,input/big5-ary30.mb,big5,native
#ime = 緀,,input/big5-cj.mb,big5,native
#ime = 猔,,input/big5-phone.mb,big5,native
#ime = 礚郊μ,,input/big5-liu5.mb,big5,native
#ime = GBK拼音,modules/turbo/TL_hzinput.so,modules/turbo/dict/gbk/gbkpy_mb.tab,gbk,unicon
#ime = 自然码,modules/turbo/TL_hzinput.so,modules/turbo/dict/gb/zrm-2.tab,gb2312,unicon
#ime = 惧块な,modules/turbo/TL_hzinput.so,modules/turbo/dict/big5/pinyin.tab,big5,unicon
#ime = 緀块,modules/turbo/TL_hzinput.so,modules/turbo/dict/big5/cj.tab,big5,unicon
#ime = 虏块,modules/turbo/TL_hzinput.so,modules/turbo/dict/big5/simplex.tab,big5,unicon
ime = 全拼2,,input/py.mb,gb2312,native
ime = 双拼2,,input/py.mb,gb2312,native
#ime = 大众,,input/dzm.mb,gb2312,native
#ime = 英中,,input/ed.mb,gb2312,native
#ime = 简拼,,input/jp.mb,gb2312,native
#ime = 普通,,input/pt.mb,gb2312,native
#ime = 五笔二维,,input/wbew.mb,gb2312,native
#ime = 五笔划,,input/wbh.mb,gb2312,native
#ime = 繁体仓颉,,input/cjf.mb,gb2312,native
#ime = 简体仓颉,,input/cjj.mb,gb2312,native
EOF
		$getPermission chmod 4755 /usr/bin/fbi /usr/bin/fbgs
	else
		echo "The version of zhcon is 'zhcon-0.2.6' ,so you needn't to update,program do nothing."
	fi

	initSystemTime
	echo 'leave installZhcon()'"	$systemTime " 
	echo 'leave installZhcon()'"	$systemTime " >> $outputRedirectionCommand
}

installCSVKit()
{
#there will install csvkit.
	initSystemTime
	echo 'enter installCSVKit()'"	$systemTime "
	echo 'enter installCSVKit()'"	$systemTime " >> $outputRedirectionCommand

	$getPermission pip3 install update
	$getPermission pip3 install csvkit
	
	$getPermission ln -s /usr/local/python3/bin/in2csv /usr/local/bin/in2csv
	$getPermission ln -s /usr/local/python3/bin/csvformat /usr/local/bin/csvformat
	$getPermission ln -s /usr/local/python3/bin/csvcut /usr/local/bin/csvcut
	$getPermission ln -s /usr/local/python3/bin/csvgrep /usr/local/bin/csvgrep
	$getPermission ln -s /usr/local/python3/bin/csvsql /usr/local/bin/csvsql
	$getPermission ln -s /usr/local/python3/bin/csvclean /usr/local/bin/csvclean
	$getPermission ln -s /usr/local/python3/bin/csvjoin /usr/local/bin/csvjoin
	$getPermission ln -s /usr/local/python3/bin/csvstat /usr/local/bin/csvstat
	$getPermission ln -s /usr/local/python3/bin/csvpy /usr/local/bin/csvpy
	$getPermission ln -s /usr/local/python3/bin/csvjson /usr/local/bin/csvjson
	$getPermission ln -s /usr/local/python3/bin/csvsort /usr/local/bin/csvsort
	$getPermission ln -s /usr/local/python3/bin/csvstack /usr/local/bin/csvstack
	$getPermission ln -s /usr/local/python3/bin/csvlook /usr/local/bin/csvlook
	$getPermission ln -s /usr/local/python3/bin/sql2csv /usr/local/bin/sql2csv
	
	$installCommandHead_skipbroken_nogpgcheck head tail more less header column body cols


	initSystemTime
	echo 'leave installCSVKit()'"	$systemTime "
	echo 'leave installCSVKit()'"	$systemTime " >> $outputRedirectionCommand
}

installMarkdownPresentationTool()
{
#there will install mdp(Markdown presentation tool).
	initSystemTime
	echo 'enter installMarkdownPresentationTool()'"	$systemTime "
	echo 'enter installMarkdownPresentationTool()'"	$systemTime " >> $outputRedirectionCommand

	$installCommandHead_skipbroken_nogpgcheck git*
	
	mkdir $currentPath/mdpInstall && cd $currentPath/mdpInstall
	git clone https://github.com/visit1985/mdp.git
	cd $currentPath/mdpInstall/mdp && make
	$getPermission make install
	
#	echo 'export TERM=xterm-256color' | $getPermission tee -ai /etc/bashrc
#	echo 'export TERM=screen.linux' | $getPermission tee -ai /etc/bashrc

	initSystemTime
	echo 'leave installMarkdownPresentationTool()'"	$systemTime "
	echo 'leave installMarkdownPresentationTool()'"	$systemTime " >> $outputRedirectionCommand
}

installCMatrix()
{
#install CMtarix
	initSystemTime
	echo 'enter installCMatrix()'"	$systemTime "
	echo 'enter installCMatrix()'"	$systemTime " >> $outputRedirectionCommand

	if [[ ! -e "/opt/cmatrix-v2.0_has-been-installed" ]]
	then	
#preprocessing work
		$installCommandHead_skipbroken_nogpgcheck ncurses* ncurses-devel fbida* ncurses* gcc gcc-*

#download the sources
		if [[ ! -e "$currentPath/cmatrix-v2.0-Butterscotch.tar" ]]
		then
			wget -P $currentPath/ -O cmatrix-v2.0-Butterscotch.tar https://github.com/abishekvashok/cmatrix/releases/download/v2.0/cmatrix-v2.0-Butterscotch.tar
			$changeOwn
		fi
		
		tar -xvf $currentPath/cmatrix-v2.0-Butterscotch.tar
		$changeOwn
		cd $currentPath/cmatrix && $currentPath/cmatrix/configure && make
		$getPermission make install && $getPermission mkdir -p /opt/cmatrix-v2.0_has-been-installed
		cd $currentPath
		$getPermission rm -rf $currentPath/cmatrix

		$getPermission chmod 4755 /usr/bin/fbi /usr/bin/fbgs
	else
		echo "The version of CMatrix is 'cmatrix-v2.0' ,so you needn't to update,program do nothing."
	fi

	initSystemTime
	echo 'leave installCMatrix()'"	$systemTime " 
	echo 'leave installCMatrix()'"	$systemTime " >> $outputRedirectionCommand
}

installMPlayer()
{
#install mplayer but exclude skin
	initSystemTime
	echo 'enter installMPlayer()'"	$systemTime "
	echo 'enter installMPlayer()'"	$systemTime " >> $outputRedirectionCommand

	if [[ ! -e "/opt/MPlayer-1.4_has-been-installed" ]]
	then	
#preprocessing work
		$installCommandHead_skipbroken_nogpgcheck mpalyer mplayer* yasm* alsa*  madplay* libmad* gtk+* gtk2*

#then install codecs
		if [[ ! -e "$currentPath/all-20110131.tar.bz2" ]]
		then
			wget -P $currentPath/ http://www.mplayerhq.hu/MPlayer/releases/codecs/all-20110131.tar.bz2
			$changeOwn
		fi
		$getPermission mkdir -p /usr/local/lib/codecs
		tar -jxvf $currentPath/all-20110131.tar.bz2
		$changeOwn
		$getPermission cp -r $currentPath/all-20110131/* /usr/local/lib/codecs/
		$getPermission rm -rf $currentPath/all-20110131
#then install mplayer
		if [[ ! -e "$currentPath/MPlayer-1.4.tar.gz" ]]
		then
			wget -P $currentPath/ http://www.mplayerhq.hu/MPlayer/releases/MPlayer-1.4.tar.gz
			$changeOwn
		fi
		tar -zxvf $currentPath/MPlayer-1.4.tar.gz
		$changeOwn
		cd $currentPath/MPlayer-1.4/
		$currentPath/MPlayer-1.4/configure --prefix=/usr/local/mplayer-1.4  --codecsdir=/usr/local/lib/codecs/ --enable-gui --enable-freetype  --language=zh_CN
		make -j4
		$changeOwn
		$getPermission make install && $getPermission mkdir -p /opt/MPlayer-1.4_has-been-installed
		$getPermission chmod 4755 /usr/bin/mplayer
		cd $currentPath
		$getPermission rm -rf $currentPath/MPlayer-1.4

		$installCommandHead_skipbroken_nogpgcheck libaa libaa* libcaca libcaca* alsa-utils*
#		$getPermission sed -i "s/GRUB_CMDLINE_LINUX=\"crashkernel=auto rhgb quiet\"/GRUB_CMDLINE_LINUX=\"crashkernel=auto rhgb quiet vga=795\"/g"  /etc/sysconfig/grub
#		$getPermission grub2-mkconfig -o /boot/grub2/grub.cfg

	else
		echo "The version of mplayer is 'MPlayer 1.4-4.8.5 (C) 2000-2019 MPlayer Team' ,so you needn't to update,program do nothing."
	fi

#Then write a shell script inorde to convenient for daily use.
	$getPermission tee -i /usr/bin/shell_my_MPlayer.sh <<-'EOF'
#!/bin/bash

########################################################################
#You can use this script to play a video like                          #
#   $shell_my_MPlayer.sh ~/my/testVideo.avi                            #
#   $shell_my_MPlayer.sh -playlist ~/my/testVideo.avi                  #
#You can also use this script to play many videos by a list like       #
#   $shell_my_MPlayer.sh -playlist ~/my/list                           #
#   $shell_my_MPlayer.sh ~/my/list                                     #
#You can play a directory like                                         #
#   $shell_my_MPlayer.sh ./                                            #
#   $shell_my_MPlayer.sh /home/user/video                              #
#   $shell_my_MPlayer.sh /home/user/video/                             #
#   $shell_my_MPlayer.sh -playlist ./                                  #
#   $shell_my_MPlayer.sh -playlist /home/user/video                    #
#   $shell_my_MPlayer.sh -playlist /home/user/video/                   #
########################################################################


#this script need two parameters at least
if test $# -lt 1
then
	echo "Sorry! You have to set one parameters for excute at least."
	echo "You can set one or two parameters and try again."
	exit
fi

para0=$0
para1=$1
para2=$2
paraAll=$*
playList="playlist"
readonly playList
playFile=""


fun_PlayList()
{
	subLen=$(( ${#para2} - 1 ))
	lastChar=${para2:$subLen:1}

	if [[ "s${lastChar}" == "s*" ]] 
	then
		para2="${para2:0:$subLen}"
		subLen=$(( ${#para2} - 1 ))
		lastChar=${para2:$subLen:1}
	fi

	if test ! -e "$para2"
	then
		echo "No such file or directory!"
		exit
	fi

	if test -d "$para2"
	then
		currentPath=$( pwd )
		if [[ "s${para2:0:1}" == "s~" ]]
		then
			cd ~
			para2="$( pwd )${para2:1}"
			cd "${currentPath}"
		else
			if [[ "s${para2:0:1}" == "s." ]]
			then
				if [[ "s${para2:1:1}" == "s." ]]
				then
					temp=$( pwd )
					temp=${temp%/*}
					para2="${temp}${para2:2}"
				else
					para2="$( pwd )${para2:1}"
				fi
			fi
		fi
		cd "${para2}"
		para2="$( pwd )/"
		cd "${currentPath}"

		if test ! -r "${para2}"
		then
			echo "This directory dose not have read or write permissions!"
			exit
		fi
		if test ! -w "${para2}"
		then
			echo "This directory dose not have read or write permissions!"
			exit
		fi

		rm -f "${para2}${playList}"
		ls "${para2}"* > "${para2}${playList}"
		playFile="${para2}${playList}"
	else
		if test -f "${para2}"
		then
			if test ! -r "${para2}"
			then
				echo "This directory dose not have read or write permissions!"
				exit
			fi
		fi

		if is_TextFile
		then
			playFile="${para2}"
		else
			fun_PlayVideo
		fi
	fi
		
	mplayer -vo fbdev2 -geometry 4000:0 -zoom -vf scale -x 400 -y 225 -ao alsa -loop 0 -playlist "${playFile}"
	exit
}

fun_PlayVideo()
{
	playFile="${para2}"
	mplayer -vo fbdev2 -geometry 4000:0 -zoom -vf scale -x 400 -y 225 -ao alsa -loop 0 "${playFile}"
	exit
}

is_TextFile()
{
#For a shell function,if return 0,means function execute successfully,and $? equals true
#if return 1,means function execute failed,and $? equals false
	while :
	do
		temp1=$( file "${para2}" )
		temp2="${temp1}"
		temp1="${temp1#*symbolic link to *}"
		if [[ ${#temp2} -gt ${#temp1} ]]
		then
			temp1="${temp1:1}"
			temp1="${temp1%\'*}"
			para2="${temp1}"
		else
			unset temp1
			unset temp2
			break
		fi
		unset temp1
		unset temp2
	done

	temp1=$( file "${para2}" )
	temp2="${temp1}"
	temp1="${temp1#*${para2}: }"
	temp3="${temp1}"
	temp1="${temp1% text*}"
	if [[ ${#temp3} -gt ${#temp1} ]]
	then
		unset temp1
		unset temp2
		unset temp3
#If this file is a text file,return 0.
		return 0
	else
		unset temp1
		unset temp2
		unset temp3
#If this file is not a text file,return 1.
		return 1
	fi
}

########################       start      ###########################
if [[ s$para1 == s"-playlist" ]]
then
	para2=${paraAll#*${para1}}
	para2=`echo $para2 | awk '{gsub(/^\s+|\s+$/, "");print}'`
#	para2=${para2// /\\ }

	fun_PlayList
else
	para2=${paraAll#*${para0}}
	para2=`echo $para2 | awk '{gsub(/^\s+|\s+$/, "");print}'`
#	para2=${para2// /\\ }

	if test ! -e "$para2"
	then
		echo "No such file or directory!"
		exit
	fi

	if test -d "$para2"
	then
		fun_PlayList
	fi

	if test -f "$para2"
	then
		if test ! -r "${para2}"
		then
			echo "This directory dose not have read or write permissions!"
			exit
		fi
		if is_TextFile
		then
			fun_PlayList
		else
			fun_PlayVideo
		fi
	fi
fi
EOF

	$getPermission chmod +x /usr/bin/shell_my_MPlayer.sh
	$getPermission ln -s /usr/bin/shell_my_MPlayer.sh /usr/bin/myMPlayer

	initSystemTime
	echo 'leave installMPlayer()'"	$systemTime " 
	echo 'leave installMPlayer()'"	$systemTime " >> $outputRedirectionCommand
}

installFbGrab()
{
#install install FbGrab
	initSystemTime
	echo 'enter installFbGrab()'"	$systemTime "
	echo 'enter installFbGrab()'"	$systemTime " >> $outputRedirectionCommand

	if [[ ! -e "/opt/fbgrab-1.3_has-been-installed" ]]
	then	
#preprocessing work
		$installCommandHead_skipbroken_nogpgcheck splint libpng libpng* zlib splint* libpng* zlib* libjpeg libjpeg*

#then install codecs
		if [[ ! -e "$currentPath/fbgrab-1.3.tar.gz" ]]
		then
			wget -P $currentPath/ https://fbgrab.monells.se/fbgrab-1.3.tar.gz
			$changeOwn
		fi
		tar -zxvf $currentPath/fbgrab-1.3.tar.gz
		$changeOwn
		cd $currentPath/fbgrab-1.3/
		make
		$changeOwn
		$getPermission make install && $getPermission mkdir -p /opt/fbgrab-1.3_has-been-installed
		$getPermission chmod 4755 /usr/bin/fbgrab
		cd $currentPath
		$getPermission rm -rf $currentPath/fbgrab-1.3

	else
		echo "The version of FbGrab is 'fbgrab-1.3' ,so you needn't to update,program do nothing."
	fi

	initSystemTime
	echo 'leave installFbGrab()'"	$systemTime " 
	echo 'leave installFbGrab()'"	$systemTime " >> $outputRedirectionCommand
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

	if [[ s$packageManager == s"yum" ]]
	then
	
:<<!
		if [[ -e "/etc/yum.repos.d.backup" ]]
		then
			initSystemTime
			echo 'The path "/etc/yum.repos.d.backup" exist.'"	$systemTime " 
			echo 'The path "/etc/yum.repos.d.backup" exist.'"	$systemTime " >> $outputRedirectionCommand
		else
			$getPermission  mkdir -p /etc/yum.repos.d.backup
			$getPermission  cp /etc/yum.repos.d/* /etc/yum.repos.d.backup/
		fi
!

	$getPermission  rm -rf /etc/yum.repos.d.backup
	$getPermission  mkdir -p /etc/yum.repos.d.backup
	$getPermission  cp /etc/yum.repos.d/* /etc/yum.repos.d.backup/

#install yum plugins.
#		$installCommandHead_skipbroken_nogpgcheck  yum-*
#disabled yum's plugins
#		$getPermission  sed -i 's#plugins=[01]#plugins=0#g' /etc/yum.conf

#mosquito
		$getPermission  echo '[mosquito-myrepo]'  >  /etc/yum.repos.d/mosquito-myrepo.repo
		$getPermission  echo 'name=Copr repo for myrepo owned by mosquito'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
		$getPermission  echo 'baseurl=http://copr-be.cloud.fedoraproject.org/results/mosquito/myrepo-testing/epel-7-$basearch/'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
		$getPermission  echo 'skip_if_unavailable=True'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
		$getPermission  echo 'gpgcheck=0'  >>  /etc/yum.repos.d/mosquito-myrepo.repo
		$getPermission  echo 'enabled=1'  >>  /etc/yum.repos.d/mosquito-myrepo.repo

#docker-repo
		$getPermission tee -i /etc/yum.repos.d/docker.repo <<-'EOF'
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
		if [[ ! -e "$currentPath/elrepo-release-7.0-4.el7.elrepo.noarch.rpm" ]]
		then
			wget -P $currentPath/ http://elrepo.reloumirrors.net/elrepo/el7/x86_64/RPMS/elrepo-release-7.0-4.el7.elrepo.noarch.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/elrepo-release-7.0-4.el7.elrepo.noarch.rpm

#setting resolving power
#		$getPermission  sed -i 's#crashkernel=auto rhgb quiet# crashkernel=auto rhgb quiet vga=795 #g' /boot/grub2/grub.cfg

#Don't use this repo for the time being.
		$getPermission  sed -i 's#enabled=.*$#enabled=0#g' /etc/yum.repos.d/elrepo.repo

#rpmfusion
		if [[ ! -e "$currentPath/rpmfusion-free-release-8.noarch.rpm" ]]
		then
			wget -P $currentPath/ http://download1.rpmfusion.org/free/el/rpmfusion-free-release-8.noarch.rpm
			$changeOwn
		fi
		if [[ ! -e "$currentPath/rpmfusion-nonfree-release-8.noarch.rpm" ]]
		then
			wget -P $currentPath/ http://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-8.noarch.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/rpmfusion-free-release-8.noarch.rpm  $currentPath/rpmfusion-nonfree-release-8.noarch.rpm

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
		if [[ ! -e "$currentPath/epel-release-7-11.noarch.rpm" ]]
		then
			wget -P $currentPath/ https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
			$changeOwn
		fi
	
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/epel-release-7-11.noarch.rpm		
#ali
		$getPermission  wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
		$getPermission  wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7-cloud.repo
		$getPermission  wget -P /etc/yum.repos.d/ http://mirrors.aliyun.com/repo/epel-7.repo

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

	elif [[ s$packageManager == s"apt-get" ]]
	then
		echo 'Nothing to do!'
	fi

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
	if [[ s$packageManager == s"yum" ]]
	then
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/electron-ssr-0.2.0-alpha-4.x86_64.rpm
	elif [[ s$packageManager == s"apt-get" ]]
	then
		echo 'There is nothing to do!'
	fi
#logo
	$getPermission cp $currentPath/shadowsocksr-logo.png /opt/ShadowsocksR客户端/shadowsocksr-logo.png
	$getPermission echo 'Icon=/opt/ShadowsocksR客户端/shadowsocksr-logo.png'  >>  /usr/share/applications/electron-ssr.desktop

	initSystemTime
	echo 'leave installShadowsocks()'"	$systemTime "
	echo 'leave installShadowsocks()'"	$systemTime " >> $outputRedirectionCommand
}

installBaidunetdisk()
{
	initSystemTime
	echo 'enter installBaidunetdisk()'"	$systemTime "
	echo 'enter installBaidunetdisk()'"	$systemTime " >> $outputRedirectionCommand
#install BaiduNetdisk GUI client
:<<?
	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e $currentPath/baidunetdisk_linux_2.0.1.rpm ]]
		then
			wget -O $currentPath/baidunetdisk_linux_2.0.1.rpm http://issuecdn.baidupcs.com/issue/netdisk/LinuxGuanjia/baidunetdisk_linux_2.0.1.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/baidunetdisk_linux_2.0.1.rpm
	elif [[ s$packageManager == s"apt-get" ]]
	then
		echo 'There is nothing to do!'
	fi
?
	$installCommandHead_skipbroken_nogpgcheck  baidunetdisk*
	$installCommandHead_skipbroken_nogpgcheck  baidunetdisk*

#then set starter's logo
	$getPermission mkdir /opt/Baidu/Baidunetdisk -p
	$getPermission cp $currentPath/netdisk_logo.ico /opt/Baidu/Baidunetdisk
	$getPermission chown $userName:$userName /usr/share/applications/baidunetdisk.desktop
	$getPermission echo 'Icon=/opt/Baidu/Baidunetdisk/netdisk_logo.ico' >> /usr/share/applications/baidunetdisk.desktop

#then you need update and upgrade your system
#if start can not excute still,then update libstdc++
	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e $currentPath/libstdc++-8.1.0-5.26.el7.x86_64.rpm ]]
		then
			wget -O $currentPath/libstdc++-8.1.0-5.26.el7.x86_64.rpm ftp://ftp.pbone.net/mirror/ftp5.gwdg.de/pub/opensuse/repositories/home:/aevseev:/devel/CentOS7/x86_64/libstdc++-8.1.0-5.26.el7.x86_64.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/libstdc++-8.1.0-5.26.el7.x86_64.rpm
	elif [[ s$packageManager == s"apt-get" ]]
	then
		echo 'There is nothing to do!'
	fi

#install BaiduNetdisk command line client named BaiduPCS-Go
	if [[ ! -e "/opt/BaiduPCS-Go-v3.5.6-linux-amd64" ]]
	then
		if [[ ! -e "$currentPath/BaiduPCS-Go-v3.5.6-linux-amd64.zip" ]]
		then
			wget -P $currentPath/ https://github.com/iikira/BaiduPCS-Go/releases/download/v3.5.6/BaiduPCS-Go-v3.5.6-linux-amd64.zip
			$changeOwn
		fi
		unzip $currentPath/BaiduPCS-Go-v3.5.6-linux-amd64.zip
		$changeOwn
		$getPermission mkdir -p /opt/Baidu/BaiduPCS-Go-v3.5.6-linux-amd64
		$getPermission cp -r $currentPath/BaiduPCS-Go-v3.5.6-linux-amd64/* /opt/Baidu/BaiduPCS-Go-v3.5.6-linux-amd64/
		$getPermission ln -s /opt/Baidu/BaiduPCS-Go-v3.5.6-linux-amd64/BaiduPCS-Go /usr/local/bin/baidupcs
		$getPermission rm -rf $currentPath/BaiduPCS-Go-v3.5.6-linux-amd64

	else
		echo "The version of BaiduPCS-Go is 'BaiduPCS-Go-v3.5.6-linux-amd64' ,so you needn't to update,program do nothing."
	fi

	initSystemTime
	echo 'leave installBaidunetdisk()'"	$systemTime "
	echo 'leave installBaidunetdisk()'"	$systemTime " >> $outputRedirectionCommand
}

installTeamViewer()
{
#there will install teamviewer.
	initSystemTime
	echo 'enter installTeamViewer()'"	$systemTime "
	echo 'enter installTeamViewer()'"	$systemTime " >> $outputRedirectionCommand

	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e $currentPath/teamviewer.x86_64.rpm ]]
		then
			wget -O $currentPath/teamviewer.x86_64.rpm https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/teamviewer.x86_64.rpm
	elif [[ s$packageManager == s"apt-get" ]]
	then
		if [[ ! -e $currentPath/teamviewer_amd64.deb ]]
		then
			wget -O $currentPath/teamviewer_amd64.deb https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/teamviewer_amd64.deb
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
			wget -P $currentPath/ https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tar.xz
			$changeOwn
		fi
		tar -Jxvf  $currentPath/Python-3.6.3.tar.xz
		$changeOwn
		cd $currentPath/Python-3.6.3

#Then we need modify some file
		tkv=$(rpm -qa | grep ^tk)
		tclv=$(rpm -qa | grep ^tcl)
		echo $tkv
		echo $tclv
		tkvl=${tkv#*tk-}
		tclvl=${tclv#*tcl-}
		echo $tkvl
		echo $tclvl
		tkvll=${tkvl#devel-*tk-}
		tclvll=${tclvl#devel-}
		echo $tkvll
		echo $tclvll
		tkvlf=${tkvll:0:3}
		tclvlf=${tclvll:0:3}
		echo $tkvlf
		echo $tclvlf
		$getPermission sed -i 's/# _tkinter _tkinter.c tkappinit.c -DWITH_APPINIT \\/ _tkinter _tkinter.c tkappinit.c -DWITH_APPINIT \\/g' $currentPath/Python-3.6.3/Modules/Setup.dist
		$getPermission sed -i 's/#\t-L\/usr\/local\/lib \\/\t-L\/usr\/local\/lib \\/g' $currentPath/Python-3.6.3/Modules/Setup.dist
		$getPermission sed -i 's/#\t-I\/usr\/local\/include \\/\t-I\/usr\/local\/include \\/g' $currentPath/Python-3.6.3/Modules/Setup.dist
		$getPermission sed -i 's/#\t-ltk8.2 -ltcl8.2 \\/\t-ltk'$tkvlf' -ltcl'$tclvlf' \\/g' $currentPath/Python-3.6.3/Modules/Setup.dist
		$getPermission sed -i 's/#\t-lX11/\t-lX11/g' $currentPath/Python-3.6.3/Modules/Setup.dist
#Some file have been modified.

		$currentPath/Python-3.6.3/configure  --prefix=/usr/local/python3 --enable-optimizations
		$changeOwn
		make -j4
		$changeOwn
		$getPermission  make install
		cd $currentPath

#Then we need modify some file
		$getPermission cp /usr/local/python3/lib/python3.6/tkinter/__init__.py /usr/local/python3/lib/python3.6/tkinter/__init__.py.backup
		$getPermission sed -i 's/if tk_version != _tkinter.TK_VERSION:/ /g' /usr/local/python3/lib/python3.6/tkinter/__init__.py
		$getPermission sed -i 's/raise RuntimeError("tk.h version (%s) doesn.*/ /g' /usr/local/python3/lib/python3.6/tkinter/__init__.py
		$getPermission sed -i 's/% (_tkinter.TK_VERSION, tk_version))/ /g' /usr/local/python3/lib/python3.6/tkinter/__init__.py
		$getPermission sed -i 's/if tcl_version != _tkinter.TCL_VERSION:/ /g' /usr/local/python3/lib/python3.6/tkinter/__init__.py
		$getPermission sed -i 's/raise RuntimeError("tcl.h version (%s) doesn.*/ /g' /usr/local/python3/lib/python3.6/tkinter/__init__.py
		$getPermission sed -i 's/% (_tkinter.TCL_VERSION, tcl_version))/ /g' /usr/local/python3/lib/python3.6/tkinter/__init__.py
#Some file have been modified.

		$getPermission  rm -rf $currentPath/Python-3.6.3

	fi

#	$getPermission  rm -r /usr/bin/python
#	$getPermission  rm -r /usr/bin/python.backup
#	$getPermission  ln -s /usr/bin/python2.7 /usr/bin/python
#	$getPermission  cp  /usr/bin/python /usr/bin/python.backup
	$getPermission  rm -rf /usr/bin/python3
	$getPermission  rm -rf /usr/bin/python3.6.3
	$getPermission  ln -s /usr/local/python3/bin/python3 /usr/bin/python3.6
	$getPermission  ln -s /usr/bin/python3.6 /usr/bin/python3
	$getPermission  mv /usr/bin/pip3 /usr/bin/pip3.old
	$getPermission  mv /usr/bin/pip3.6 /usr/bin/pip3.6.old
	$getPermission  ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3.6
	$getPermission  ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
	$getPermission  rm -f /usr/bin/pip
	$getPermission  ln -s /usr/local/python3/bin/pip3 /usr/bin/pip

	$getPermission  pip3 install --upgrade pip

	$installCommandHead_skipbroken_nogpgcheck python-tools python-devel python3-devel libevent-devel gevent

#set default pip source
	if [[ s${userName} == s"root" ]]
	then
		$getPermission mkdir -p /root/.pip
		$getPermission tee -i /root/.pip/pip.conf <<-'EOF'
[global]
index-url = http://pypi.douban.com/simple
[install]
trusted-host=pypi.douban.com
EOF
	else
		$getPermission mkdir -p /home/${userName}/.pip
		$getPermission tee -i /home/${userName}/.pip/pip.conf <<-'EOF'
[global]
index-url = http://pypi.douban.com/simple
[install]
trusted-host=pypi.douban.com
EOF
	fi

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
#After installed netease_cloud_music,we should update our GCC for higher version,by execute function "installGCCForHigherVersion()",and then we can use netease_cloud_music normally.


#download and install netease-cloud-music GUI client
	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e "/opt/netease-cloud-music" ]]
		then
			if [[ ! -e "$currentPath/netease-cloud-music_1.1.0_amd64_ubuntu.deb" ]]
			then
				wget -P $currentPath/ http://d1.music.126.net/dmusic/netease-cloud-music_1.1.0_amd64_ubuntu.deb
				$changeOwn
			fi
			ar -vx $currentPath/netease-cloud-music_1.1.0_amd64_ubuntu.deb
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

		$installCommandHead_skipbroken_nogpgcheck  vlc* *vlc *vlc* vlc *smplayer smplayer* smplayer 

		$installCommandHead_skipbroken_nogpgcheck  vlc* *vlc *vlc* vlc *smplayer smplayer* smplayer 
#*mplayer* *mplayer-gui* mplayer mplayer-gui

	elif [[ s$packageManager == s"apt-get" ]]
	then
		if [[ ! -e "$currentPath/netease-cloud-music_1.1.0_amd64_ubuntu.deb" ]]
		then
			wget -P $currentPath/ http://d1.music.126.net/dmusic/netease-cloud-music_1.1.0_amd64_ubuntu.deb
		fi
		$changeOwn
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/netease-cloud-music_1.1.0_amd64_ubuntu.deb
	fi
	
#download and install netease-cloud-music command line client named NetEase-MusicBox
	$installCommandHead_skipbroken_nogpgcheck aria* libnotify* dbus* qt* python-*
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria2
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria
	$getPermission pip3 install –upgrade pip
	$getPermission pip3 install sip
	if [[ ! -e "/opt/NetEase-MusicBox_has-been-installed" ]]
	then
#install sip
		if [[ ! -e "$currentPath/sip-4.19.17.tar.gz" ]]
		then
			wget -P $currentPath/ https://www.riverbankcomputing.com/static/Downloads/sip/4.19.17/sip-4.19.17.tar.gz 
			$changeOwn
		fi
		tar -zxvf $currentPath/sip-4.19.17.tar.gz && cd $currentPath/sip-4.19.17
		$changeOwn
		python3 $currentPath/sip-4.19.17/configure.py
		make -j4
		$changeOwn
		$getPermission  make install
		cd $currentPath
		$getPermission rm -rf $currentPath/sip-4.19.17
#install PyQt4
		if [[ ! -e "$currentPath/PyQt4_gpl_x11-4.12.3.tar.gz" ]]
		then
			wget -P $currentPath/ https://nchc.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.12.3/PyQt4_gpl_x11-4.12.3.tar.gz
			$changeOwn
		fi
		tar -zxvf $currentPath/PyQt4_gpl_x11-4.12.3.tar.gz&& cd $currentPath/PyQt4_gpl_x11-4.12.3
		$changeOwn
		echo "yes" | python3 $currentPath/PyQt4_gpl_x11-4.12.3/configure.py -q /usr/lib64/qt4/bin/qmake
		make -j4
		$changeOwn
		$getPermission make install
		cd $currentPath
		$getPermission rm -rf $currentPath/PyQt4_gpl_x11-4.12.3
#install mpg123
		if [[ ! -e "$currentPath/mpg123-1.25.6-1.el7.x86_64.rpm" ]]
		then
			wget -P $currentPath/ http://mirror.centos.org/centos/7/os/x86_64/Packages/mpg123-1.25.6-1.el7.x86_64.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck  $currentPath/mpg123-1.25.6-1.el7.x86_64.rpm

		$getPermission sed -i '/  "mpg123_parameters": {/{n;s/ *"value": \[\],/    "value": ["-b","144"],/g}' ~/.netease-musicbox/config.json
		$getPermission pip3 install NetEase-MusicBox && $getPermission mkdir -p /opt/NetEase-MusicBox_has-been-installed
		$getPermission ln -s /usr/local/python3/bin/musicbox /usr/local/bin/musicbox
		$getPermission ln -s /usr/local/python3/bin/musicbox /usr/local/bin/music

	else
		echo "The version of NetEase-MusicBox is 'NetEase-MusicBox' ,so you needn't to update,program do nothing."
	fi

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

	if [[ ! -e "/opt/Blender/blender-2.79b" ]]
	then
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

		$getPermission  rm -rf $currentPath/blender-2.79b-linux-glibc219-x86_64
	fi

#creat launcher for blender-2.79b
	$getPermission tee -i /usr/share/applications/blender-2.79b.desktop <<-'EOF'
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
	if [[ s$packageManager == s"yum" ]]
	then
		$getPermission yum-config-manager --add-repo http://download.mono-project.com/repo/centos/
	fi

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
	$installCommandHead_skipbroken_nogpgcheck  cmus* mp3blaster* moc herrie sox pytone pyradio ogg123 mpg123

#install Latex editor
	$installCommandHead_skipbroken_nogpgcheck  lyx texworks texstudio emacs atom texmaker
	$installCommandHead_skipbroken_nogpgcheck  *texworks* texworks* *texworks *texmaker* texmaker* *texmaker
#install texstudio
	if [[ s$packageManager == s"yum" ]]
	then
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
	fi
#finished

	$installCommandHead_skipbroken_nogpgcheck  createrepo cairo-dock thunderbird gimp evince p7zip-plugins p7zip-full p7zip-rar rar unrar bzip2 unzip zip *zip* file file* libtool docker docker* mtr traceroute network* tmux* screen* fbida fbida*

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

	$installCommandHead_skipbroken_nogpgcheck  hugin sublime-text xournal kplayer smplayer* vlc* *vlc *vlc*

	$installCommandHead_skipbroken_nogpgcheck  *totem totem totem* *totem* totem totem-xine

	$installCommandHead_skipbroken_nogpgcheck  minicom splint libpng zlib splint* libpng* zlib* libjpeg libjpeg*

	$installCommandHead_skipbroken_nogpgcheck  smplayer vlc tree *ssh* ssh *ssh ssh* *network-manager network-manager

	$installCommandHead_skipbroken_nogpgcheck  network-manager* *network-manager*  *gdb* gdb lspci* alsa* fbida*
#*gnome-mplayer* gnome-mplayer
#	$installCommandHead_skipbroken_nogpgcheck  *gnome-mplayer*

#install chrome
	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e "$currentPath/google-chrome-stable_current_x86_64.rpm" ]]
		then
			wget -P $currentPath/ https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/google-chrome-stable_current_x86_64.rpm
	fi

	$installCommandHead_skipbroken_nogpgcheck  lsb
	$installCommandHead_skipbroken_nogpgcheck  libXScrnSaver

#audio and video decode ware

	$installCommandHead_skipbroken_nogpgcheck  qt-recordmydesktop mvgather screenfetch pointdownload gparted k3b nscd
	
	$installCommandHead_skipbroken_nogpgcheck  recordmydeskto* recordmydesktop* *recordmydesktop *ecordmydesktop *ecordmydeskto* pavucontrol pavucontro*
	
	$installCommandHead_skipbroken_nogpgcheck  pavucontrol pavucontro* *pavucontrol

	$installCommandHead_skipbroken_nogpgcheck  unetbootin ms-sys win32codecs mplayer mplayer* smplayer *smplayer* gstreamer* kmplayer

	$installCommandHead_skipbroken_nogpgcheck  vlc potplayer xine quicktime vebvbox

	$installCommandHead_skipbroken_nogpgcheck  itunes realplayer clenmentine audacious audacious-plugins-freeworld

	$installCommandHead_skipbroken_nogpgcheck  gstreamer-plugins-good gstreamer-plugins-bad gstreamer-plugins-ugly

	$installCommandHead_skipbroken_nogpgcheck  libtunepimp-extras-freeworld xine-lib-extras-freeworld ffmpeg ffmpeg-libs gstreamer-ffmpeg

	$installCommandHead_skipbroken_nogpgcheck  xvidcore libdvdread libdvdnav lsdvd gstreamer-plugins-good gstreamer-plugins-bad

	$installCommandHead_skipbroken_nogpgcheck  gstreamer-plugins-ugly istanbul wink xvidcap pyvnc2swf recordmydesktop

	$installCommandHead_skipbroken_nogpgcheck  gtk-recordmydesktop kplayer smplayer* vlc*

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
	
	$installCommandHead_skipbroken_nogpgcheck  imagemagick imagemagick* imagemagic* convert* convert

	$installCommandHead_skipbroken_nogpgcheck  nepomuk lynx w3m clonezilla partimage redobackup mondorescue fsarchiver partclone g4l

	$installCommandHead_skipbroken_nogpgcheck  doclone gparted 

	$installCommandHead_skipbroken_nogpgcheck  darktable entangle hugin makehuman natron fontforge calligra flow iconv enca calligra-flow calligra*

	$installCommandHead_skipbroken_nogpgcheck  kplayer* smplayer* vlc* mplayer* shotwell feh 

	$installCommandHead_skipbroken_nogpgcheck  VirtualBox virtualbox mkvtoolnix mkvtoolnix*

	$installCommandHead_skipbroken_nogpgcheck  akmod-VirtualBox kernel-devel

	$installCommandHead_skipbroken_nogpgcheck  *VirtualBox VirtualBox* *VirtualBox*  virtualbox *virtualbox virtualbox* *virtualbox*

	$installCommandHead_skipbroken_nogpgcheck  filezilla ffmpeg* nfs* ftp* lftp* pandoc* libreoffice* pdftk* pdf* git*
	
	$installCommandHead_skipbroken_nogpgcheck  libstdc++-4.8.5-36.el7_6.2.i686 zlib-1.2.7-18.el7.i686
	
	$installCommandHead_skipbroken_nogpgcheck  tmux* screen* tmux screen mc ranger range* htop htop* top

	$installCommandHead_skipbroken_nogpgcheck  kernel-devel #*kernel-devel kernel-devel* *kernel-devel*

	$installCommandHead_skipbroken_nogpgcheck  p7zip p7zip-full p7zip-rar rar unrar isomaster electronic-wechat

	$installCommandHead_skipbroken_nogpgcheck  screengrab screen* centerim center*
	
	$installCommandHead_skipbroken_nogpgcheck  tcl tcl* tk tk* expect expect*
#Install vimx so that we can use the system pasteboard.
	$installCommandHead_skipbroken_nogpgcheck vim-gtk vim-gnome vim-X11
	$installCommandHead_skipbroken_nogpgcheck vim-X11


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
	if [[ s$packageManager == s"yum" ]]
	then
		$binaryPackageImport $currentPath/RPM-GPG-KEY-elrepo.org
		if [[ ! -e "$currentPath/elrepo-release-7.0-2.el7.elrepo.noarch.rpm" ]]
		then
			wget -P $currentPath/ http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
	fi
	

#You can remove the notes according to the situation.
	#$getPermission  $packageManager  --enablerepo=elrepo-kernel install -y kernel-ml
	#$getPermission  $packageManager  --enablerepo=elrepo-kernel install -y kernel-ml-devel

	if [[ s$packageManager == s"yum" ]]
	then
		$installCommandHead_skipbroken_nogpgcheck  $currentPath/nux-dextop-release-0-5.el7.nux.noarch.rpm
		$installCommandHead_skipbroken_nogpgcheck  $currentPath/adobe-release-x86_64-1.0-1.noarch.rpm
	fi

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
	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e "$currentPath/adobe-release-x86_64-1.0-1.noarch.rpm" ]]
		then
			wget -P $currentPath/ http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/adobe-release-x86_64-1.0-1.noarch.rpm
		$installCommandHead_skipbroken_nogpgcheck  flash-pluginnager == s"apt-get" ]]
	elif [[ s$packageManager == s"apt-get" ]]
	then
		echo 'Nothing to do!'
	fi
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

#if wps exist,then skip this step.
:<<!
#The package by ".tar.xz" format was ended.
	if [[ ! -e "/opt/wps-office" ]]
	then
		if [[ ! -e "$currentPath/wps-office_10.1.0.6758_x86_64.tar.xz" ]]
		then
			wget -P $currentPath/ http://kdl.cc.ksosoft.com/wps-community/download/6757/wps-office_10.1.0.6758_x86_64.tar.xz
			$changeOwn
		fi

		$getPermission mkdir -p /opt/wps-office
		tar -Jxvf $currentPath/wps-office_10.1.0.6758_x86_64.tar.xz
		$changeOwn
		$getPermission cp -r $currentPath/wps-office_10.1.0.6758_x86_64/* /opt/wps-office

		$getPermission cp $currentPath/WPS-Excel-logo.png $currentPath/WPS-Word-logo.png $currentPath/WPS-PPT-logo.png  /opt/wps-office/

#install fonts
		$getPermission /opt/wps-office/install_fonts
		$currentPath/wps-office_10.1.0.6758_x86_64/install_fonts

		$getPermission  rm -rf $currentPath/wps-office_10.1.0.6758_x86_64


#create initiator of "WPS-Word"
		$getPermission echo '[Desktop Entry]'  >  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Name=WPS-Word'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Name[zh_CN]=WPS-Word'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Comment=WPS-Word Client'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Exec=/opt/wps-office/wps'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Icon=/opt/wps-office/WPS-Word-logo.png'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Terminal=false'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Type=Application'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Categories=Application;'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'Encoding=UTF-8'  >>  /usr/share/applications/WPS-Word.desktop
		$getPermission echo 'StartupNotify=true'  >>  /usr/share/applications/WPS-Word.desktop

#create initiator of "WPS-PPT"
		$getPermission cp /usr/share/applications/WPS-Word.desktop /usr/share/applications/WPS-PPT.desktop
		$getPermission sed -i 's#WPS-Word#WPS-PPT#g' /usr/share/applications/WPS-PPT.desktop
		$getPermission sed -i 's#Exec=.*$#Exec=/opt/wps-office/wpp#g' /usr/share/applications/WPS-PPT.desktop
		$getPermission sed -i 's#Icon.*$#Icon=/opt/wps-office/WPS-PPT-logo.png#g' /usr/share/applications/WPS-PPT.desktop

#create initiator of "WPS-Excel"
		$getPermission cp /usr/share/applications/WPS-Word.desktop /usr/share/applications/WPS-Excel.desktop
		$getPermission sed -i 's#WPS-Word#WPS-Excel#g' /usr/share/applications/WPS-Excel.desktop
		$getPermission sed -i 's#Exec=.*$#Exec=/opt/wps-office/et#g' /usr/share/applications/WPS-Excel.desktop
		$getPermission sed -i 's#Icon.*$#Icon=/opt/wps-office/WPS-Excel-logo.png#g' /usr/share/applications/WPS-Excel.desktop

	fi
!

#install other wps.You can remove following three lines.
	if [[ s$packageManager == s"yum" ]]
	then
		if [[ ! -e "$currentPath/wps-office-11.1.0.8392-1.x86_64.rpm" ]]
		then
			wget -P $currentPath/ https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/8392/wps-office-11.1.0.8392-1.x86_64.rpm
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/wps-office-11.1.0.8392-1.x86_64.rpm
	elif [[ s$packageManager == s"apt-get" ]]
	then
		if [[ ! -e "$currentPath/wps-office_11.1.0.8392_amd64.deb" ]]
		then
			wget -P $currentPath/ https://wdl1.cache.wps.cn/wps/download/ep/Linux2019/8392/wps-office_11.1.0.8392_amd64.deb
			$changeOwn
		fi
		$packageManagerLocalInstallCommand_skipbroken_nogpgcheck   $currentPath/wps-office_11.1.0.8392_amd64.deb
	fi

#repair a bug that wps cann't running and hint "/opt/kingsoft/wps-office/office6/wps: /lib64/libc.so.6: version `GLIBC_2.18' not found (required by /opt/kingsoft/wps-office/office6/libc++abi.so.1):"
	wget -P $currentPath/ http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz
	$changeOwn
	tar -zxvf $currentPath/glibc-2.18.tar.gz
	$changeOwn
	mkdir $currentPath/glibc-2.18/build
	cd $currentPath/glibc-2.18/build
	$currentPath/glibc-2.18/configure --prefix=/usr
	$changeOwn
	make -j2 && $getPermission  make install
	cd $currentPath
	$getPermission rm -rf $currentPath/glibc-2.18

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

	if [[ s$whetherUpdateOrUpgrade == s"upgrade" ]]
	then
		$getPermission  $packageManager  upgrade -y --skip-broken
	elif [[ s$whetherUpdateOrUpgrade == s"update" ]]
	then
		$getPermission  $packageManager  upgrade -y --skip-broken
		#update linux kernel
		$getPermission  $packageManager  update -y --skip-broken
	fi

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
	
#set configuration for keep alive for long time
	$getPermission sed -i 's/#TCPKeepAlive yes/TCPKeepAlive yes/g' /etc/ssh/sshd_config
	$getPermission sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 60/g' /etc/ssh/sshd_config
	$getPermission sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 30/g' /etc/ssh/sshd_config

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
	if [[ s$packageManager == s"yum" ]]
	then
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
#			gsettings "set org.gnome.settings-daemon.plugins.keyboard active false"
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
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
gOpt=
#gOptExt=-multiply
........

本方法参考地址：http://www.cnblogs.com/Yiutto/p/6204085.html
!
	elif [[ s$packageManager == s"apt-get" ]]
	then
		echo 'Nothing to do!'
	fi

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

installCalibre()
{
#in this function,we will install Calibre,which is a e-book processing tool.
	initSystemTime
	echo 'enter installCalibre()'"	$systemTime "
	echo 'enter installCalibre()'"	$systemTime " >> $outputRedirectionCommand

#install
	if [[ ! -e "/opt/calibre-3.46.0_has-been-installed" ]] && [[ ! -e /opt/Calibre ]]
	then
		if [[ ! -e "$currentPath/calibre-3.46.0.tar.xz" ]]
		then
			axel https://download.calibre-ebook.com/3.46.0/calibre-3.46.0.tar.xz
			$changeOwn

		fi

#unzip tar
		tar -xvJf $currentPath/calibre-3.46.0.tar.xz
		$changeOwn
		cd $currentPath/calibre-3.46.0
		#calibre requires python >= 2.7.9 and < 3.
		$getPermission python2.8 $currentPath/calibre-3.46.0/setup.py install && $getPermission mkdir -p /opt/calibre-3.46.0_has-been-installed
		cd  $currentPath
		$changeOwn
	fi
	$getPermission rm -rf $currentPath/calibre-3.46.0

#if install failed,reinstall bellow:
	if [[ ! -e "/opt/calibre-3.46.0_has-been-installed" ]] && [[ ! -e /opt/Calibre ]]
	then
		if [[ ! -e "$currentPath/linux-installer.sh" ]]
		then
			axel https://download.calibre-ebook.com/linux-installer.sh
			$changeOwn
		fi
		$getPermission chmod +x $currentPath/linux-installer.sh
		$getPermission $currentPath/linux-installer.sh install_dir=/opt/Calibre
		cd  $currentPath
		$changeOwn
	fi
	$getPermission rm -f $currentPath/linux-installer.sh

	initSystemTime
	echo 'leave installCalibre()'"	$systemTime "
	echo 'leave installCalibre()'"	$systemTime " >> $outputRedirectionCommand
}
installGitBook()
{
#in this function,we will install GitBook,a command line tool (and Node.js library) for building beautiful books using GitHub/Git and Markdown (or AsciiDoc).
	initSystemTime
	echo 'enter installGitBook()'"	$systemTime "
	echo 'enter installGitBook()'"	$systemTime " >> $outputRedirectionCommand

#install node.js
	if [[ ! -e "/opt/Node/node-v10.16.3" ]]
	then
		if [[ ! -e "$currentPath/node-v10.16.3.tar.gz" ]]
		then
			axel https://nodejs.org/dist/v10.16.3/node-v10.16.3.tar.gz
			$changeOwn
		fi

#unzip tar
		tar -zxvf $currentPath/node-v10.16.3.tar.gz
		$changeOwn
		cd $currentPath/node-v10.16.3 && $currentPath/node-v10.16.3/configure --prefix==/opt/Node/node-v10.16.3
		$changeOwn
		make && $getPermission make install
		cd  $currentPath
		$changeOwn
	fi
	$getPermission rm -rf $currentPath/node-v10.16.3

#install GitBook
	$getPermission npm install -g gitbook
	$getPermission npm install -g gitbook-cli
	
	initSystemTime
	echo 'leave installGitBook()'"	$systemTime "
	echo 'leave installGitBook()'"	$systemTime " >> $outputRedirectionCommand
}

createCustomScript()
{
#in this function,we will create some custom script to make more convenient
	initSystemTime
	echo 'enter createCustomScript()'"	$systemTime "
	echo 'enter createCustomScript()'"	$systemTime " >> $outputRedirectionCommand

#Recursively change the file or directory name from a full-horn symbol to a half-horn symbol.
	$getPermission  tee -i /usr/bin/changeFileOrFolderNameFromFullToHalfCorner.sh <<-"EOF"
#!/bin/bash

echo "###################################################################"
echo "# Preparing to Recursively modify files in the folder" 
echo "###################################################################"

fileList='./fileList'
readonly fileList
globalName=""

changeName()
{
	oldName="$*"
	oldName=${oldName#*changeName }
	if [ "s$oldName" == "s" ]
	then
		echo "There is function changeName"
		return
	fi
#	echo "$oldName"
	newName=$oldName
	newName=`echo "$newName" | sed 's/《/[[/g'`
	newName=`echo "$newName" | sed 's/》/]]/g'`
	newName=`echo "$newName" | sed 's/<</[[/g'`
	newName=`echo "$newName" | sed 's/>>/]]/g'`
	newName=`echo "$newName" | sed 's/——/--/g'`
	newName=`echo "$newName" | sed 's/【/[/g'`
	newName=`echo "$newName" | sed 's/】/]/g'`
	newName=`echo "$newName" | sed 's/（/(/g'`
	newName=`echo "$newName" | sed 's/）/)/g'`
	newName=`echo "$newName" | sed 's/·/_/g'`
	newName=`echo "$newName" | sed 's/、/+/g'`
	newName=`echo "$newName" | sed 's/“/"/g'`
	newName=`echo "$newName" | sed 's/”/"/g'`
	newName=`echo "$newName" | sed 's/：/:/g'`
	newName=`echo "$newName" | sed 's/；/;/g'`
	newName=`echo "$newName" | sed 's/！/!/g'`
	newName=`echo "$newName" | sed 's/￥/$/g'`
	newName=`echo "$newName" | sed 's/~/~/g'`
	newName=`echo "$newName" | sed 's/，/,/g'`
	newName=`echo "$newName" | sed 's/。/./g'`
	newName=`echo "$newName" | sed 's/？/?/g'`
	newName=`echo "$newName" | sed 's/ /_/g'`
	
	newName=`echo "$newName" | sed s/‘/\'/g`
	newName=`echo "$newName" | sed s/’/\'/g`
	newName=`echo "$newName" | sed 's/{/{/g'`
	newName=`echo "$newName" | sed 's/}/}/g'`
	
	globalName="$newName"

	if [ "s$oldName" != "s$newName" ]
	then
		echo "Change file name from \"$oldName\" to \"$newName\"."
		mv "$oldName" "$newName"
	else
		echo "File \"$newName\" need not to be moved."
	fi
}
travFolder()
{
	currentDir="$*"
	currentDir=${currentDir#*travFolder }
	fList=`ls "$currentDir"`
	cd "$currentDir"
	echo "===========current path $currentDir====================="
	echo "$fList" > $fileList
	cat $fileList
	while read f
	do
		if [ "s$f" == "s@eaDir" ]
		then
			continue
		fi
		if test -d "$f"
		then
			changeName "$f"
			travFolder "$globalName"
		fi

		if [ "s$f" != "sfileList" ]
		then
			changeName "$f"
		fi
	done < $fileList
	rm $fileList
	cd ..
}
travFolder "$1"

EOF

	$getPermission chmod +x /usr/bin/changeFileOrFolderNameFromFullToHalfCorner.sh
	$getPermission ln -s /usr/bin/changeFileOrFolderNameFromFullToHalfCorner.sh /usr/bin/file_folderNameChangeFromFullToHalfCorner

#######################################################################
:<<!
Here recod some tips in use.
First is video edit:
video spilt:
$ffmpeg -ss 0 -t 26.7 -accurate_seek -i ./input.mp4 -codec copy -avoid_negative_ts 1 ./output.mp4
video contcat(method 1):
$ffmpeg -i ./input_0.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts ./input_0.ts
$ffmpeg -i ./input_1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts ./input_1.ts
$ffmpeg -i "concat:input_0.ts|input_1.ts" -c copy -bsf:a aac_adtstoasc -movflags +faststart output.mp4
$rm ./input_0.mp4 ./input_1.mp4

video contcat(method 2):
$tee ./filelist <<-"EOF"
file 'input_0.mp4'
file 'input_1.mp4'
file 'input_2.mp4'
EOF
$ffmpeg -f concat -i filelist -c copy output.mp4

!
#######################################################################



	initSystemTime
	echo 'leave createCustomScript()'"	$systemTime "
	echo 'leave createCustomScript()'"	$systemTime " >> $outputRedirectionCommand
}

#Then,we will install all of the software.
executeInstallWork()
{
	if [[ $1 -eq 1 ]]
	then
		initSystemTime
		echo "installing...	$systemTime "
		echo "installing...	$systemTime " >> $outputRedirectionCommand
	fi

	enterCurrentRootPath
	settingRepo

	enterCurrentRootPath
	installRemoteTools

	enterCurrentRootPath
	installSogou

	enterCurrentRootPath
	installGCCForHigherVersion

	enterCurrentRootPath
	installZhcon

	enterCurrentRootPath
	installCMatrix

	enterCurrentRootPath
	installMarkdownPresentationTool

	enterCurrentRootPath
	installMPlayer

	if [[ $1 -eq 1 ]] || [[ $1 -eq 2 ]]
	then
		enterCurrentRootPath
		installFirefox
	fi

	enterCurrentRootPath
	installWPS

	enterCurrentRootPath
	installNetease_cloud_music

	enterCurrentRootPath
	installBaidunetdisk

	enterCurrentRootPath
	installWechat

	enterCurrentRootPath
	installShadowsocks

	enterCurrentRootPath
	installPython3

	enterCurrentRootPath
	installCSVKit

	enterCurrentRootPath
	installBlender

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

	enterCurrentRootPath
	installSoftwareBatch
	
	enterCurrentRootPath
	installCalibre
	
	enterCurrentRootPath
	installGitBook

	enterCurrentRootPath
	createCustomScript

	if [[ $loopTime -eq 1 ]]
	then
		enterCurrentRootPath
		installUpdateAndUpgrade
	elif [[ $loopTime -gt 1 ]] && [[ $1 -ge 2 ]]
	then
		enterCurrentRootPath
		installUpdateAndUpgrade
	fi

}


init()
{
#do some initial work
#first we need to cp "mcp" to "/usr/bin/"
	$getPermission cp $currentPath/mcp /usr/bin/
	$getPermission chmod +x /usr/bin/mcp
	$getPermission echo 'export TERM=xterm-256color' | $getPermission tee -ai /etc/bashrc
	$getPermission echo 'export TERM=screen.linux' | $getPermission tee -ai /etc/bashrc
#Perform the basic configuration for vimx
#	$getPermission tee -ai /etc/vimrc <<-"EOF"
#
#set t_Co=256
#set number
#set cursorline
#highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
#set cursorcolumn
#highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
#set autoindent
#set smartindent
#set laststatus=2
#EOF

	$getPermission tee -i /etc/vimrc <<-"EOF"

if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,latin1
endif

set nocompatible	" Use Vim defaults (much better!)
set bs=indent,eol,start		" allow backspacing over everything in insert mode
"set ai			" always set autoindenting on
"set backup		" keep a backup file
set viminfo='20,\"50	" read/write a .viminfo file, don't store more
			" than 50 lines of registers
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup redhat
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=[4%dm
     set t_Sf=[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"
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

	$getPermission tee -i /etc/bashrc <<-"EOF"

# /etc/bashrc

# System wide functions and aliases
# Environment stuff goes in /etc/profile

# It's NOT a good idea to change this file unless you know what you
# are doing. It's much better to create a custom.sh shell script in
# /etc/profile.d/ to make custom changes to your environment, as this
# will prevent the need for merging in future updates.

# are we an interactive shell?
if [ "$PS1" ]; then
  if [ -z "$PROMPT_COMMAND" ]; then
    case $TERM in
    xterm*|vte*)
      if [ -e /etc/sysconfig/bash-prompt-xterm ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-xterm
      elif [ "${VTE_VERSION:-0}" -ge 3405 ]; then
          PROMPT_COMMAND="__vte_prompt_command"
      else
          PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    screen*)
      if [ -e /etc/sysconfig/bash-prompt-screen ]; then
          PROMPT_COMMAND=/etc/sysconfig/bash-prompt-screen
      else
          PROMPT_COMMAND='printf "\033k%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
      fi
      ;;
    *)
      [ -e /etc/sysconfig/bash-prompt-default ] && PROMPT_COMMAND=/etc/sysconfig/bash-prompt-default
      ;;
    esac
  fi
  # Turn on parallel history
  shopt -s histappend
  history -a
  # Turn on checkwinsize
  shopt -s checkwinsize
  [ "$PS1" = "\\s-\\v\\\$ " ] && PS1="[\u@\h \W]\\$ "
  # You might want to have e.g. tty in prompt (e.g. more virtual machines)
  # and console windows
  # If you want to do so, just add e.g.
  # if [ "$PS1" ]; then
  #   PS1="[\u@\h:\l \W]\\$ "
  # fi
  # to your custom modification shell script in /etc/profile.d/ directory
fi

if ! shopt -q login_shell ; then # We're not a login shell
    # Need to redefine pathmunge, it get's undefined at the end of /etc/profile
    pathmunge () {
        case ":${PATH}:" in
            *:"$1":*)
                ;;
            *)
                if [ "$2" = "after" ] ; then
                    PATH=$PATH:$1
                else
                    PATH=$1:$PATH
                fi
        esac
    }

    # By default, we want umask to get set. This sets it for non-login shell.
    # Current threshold for system reserved uid/gids is 200
    # You could check uidgid reservation validity in
    # /usr/share/doc/setup-*/uidgid file
    if [ $UID -gt 199 ] && [ "`/usr/bin/id -gn`" = "`/usr/bin/id -un`" ]; then
       umask 002
    else
       umask 022
    fi

    SHELL=/bin/bash
    # Only display echos from profile.d scripts if we are no login shell
    # and interactive - otherwise just process them to set envvars
    for i in /etc/profile.d/*.sh; do
        if [ -r "$i" ]; then
            if [ "$PS1" ]; then
                . "$i"
            else
                . "$i" >/dev/null
            fi
        fi
    done

    unset i
    unset -f pathmunge
fi
# vim:ts=4:sw=4
export TERM=xterm-256color
export TERM=screen.linux
export DISPLAY=:0.0
EOF

	$installCommandHead_skipbroken_nogpgcheck  wget curl axel gcc gcc-++ g++ gcc-* ntfs-3g aria2 grub-customizer yum-versionlock git* vim vim-X11 vim* p7zip-plugins p7zip-full p7zip-rar rar unrar bzip2 unzip zip *zip* enconv iconv  enca file file* libtool docker docker*
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria2
	$getPermission ln -s /usr/bin/aria2c /usr/bin/aria
	
#set configuration for keep alive for long time
	$getPermission sed -i 's/#TCPKeepAlive yes/TCPKeepAlive yes/g' /etc/ssh/sshd_config
	$getPermission sed -i 's/#ClientAliveInterval 0/ClientAliveInterval 60/g' /etc/ssh/sshd_config
	$getPermission sed -i 's/#ClientAliveCountMax 3/ClientAliveCountMax 30/g' /etc/ssh/sshd_config
	
	$getPermission echo 'export DISPLAY=:0.0' | $getPermission tee -ai /etc/bashrc
	$getPermission xhost +
}

i=1
while (( $i <= $loopTime ))
do

	if [[ $i -eq 1 ]]
	then
		#do some initial work
		init
		
		initSystemTime
		echo "installing...	$systemTime "
		echo "installing...	$systemTime " >> $outputRedirectionCommand
	fi

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

	executeInstallWork $i

	if [[ $i -eq 1 ]]
	then
		initSystemTime
		echo "First installing already completed .	$systemTime "
		echo "First installing already completed .	$systemTime " >> $outputRedirectionCommand
	fi

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
echo -e "\033[0;34m####################################################################################\033[0m"
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
echo -e "\033[;31mPlease run command \"fcitx-configtool\" and \"sogou-qimpanel\" to setting your sogou-pinyin typewrriting and then reboot you computer to enjoy the new system.	$systemTime \033[0m"
echo "Please run command \"fcitx-configtool\" and \"sogou-qimpanel\" to setting your sogou-pinyin typewrriting and then reboot you computer to enjoy the new system.	$systemTime " >> $outputRedirectionCommand
echo -e "\033[0;34m####################################################################################\033[0m"

echo ""
echo "" >> $outputRedirectionCommand
echo ""
echo "" >> $outputRedirectionCommand
