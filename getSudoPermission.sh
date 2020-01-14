#!/bin/bash


################################################################
#  author   :Owen Wang                                         #
#  time     :2017-10-07                                        #
#  modify   :2020-01-14                                        #
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
"set t_Co=256
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

	$installCommandHead_skipbroken_nogpgcheck  wget curl axel gcc gcc-++ g++ gcc-* ntfs-3g aria2 grub-customizer yum-versionlock git* vim vim-X11 vim* p7zip-plugins p7zip-full p7zip-rar rar unrar bzip2 unzip zip *zip* enconv iconv  enca file file* libtool docker docker* mtr traceroute network* tmux* screen* fbida fbida* shellinabox pigz pbzip2 mgzip 
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
