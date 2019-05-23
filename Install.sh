#!/usr/bin/env/ bash


f_docchk(){
	
	dist=$(sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/os-release)
	reddist=$(cat /etc/redhat-release| awk -F" " '{print $1,$2}')
	otherdist=$(cat /etc/os-release |grep "ID_" |cut -d"\"" -f2)

	if [[ $dist = debian ]]; then
		installer="apt-get"
	elif [[ $reddist = "Red Hat" ]]; then
		installer="yum"
	elif [[ $otherdist = "rhel fedora" ]]; then
		installer="yum"
	elif [[ $otherdist = debian ]]; then
		installer="apt-get"
	else
		echo "os not supported"
	fi

	if [ $installer = yum ]; then
		rpm -qa |grep "docker" &> /dev/null
	elif [ $installer = "apt-get" ]; then
		dpkg -l docker &> /dev/null
	fi
	
	if [ $? -ge 1 ]; then
		wget -qO- get.docker.com | bash
	else
		echo "Docker installed"
	fi

	systemctl enable docker && systemctl start docker
}

distros1="centos rhel suse"
distros2="debian ubuntu linuxmint"

f_docchk

f_docfig(){

	read -p "Enter Distro to download: " distro
	
	sudo docker search $distro
	
	read -p "Choose an image from the list: " image
	
	echo "Getting image..."
	sudo docker run $image || exit
	
	read -p "Enter NameTag for the image: " tag
	sudo docker tag $image $tag
}

read -p "Create a new docker? y/n " answer

if [ $answer = y ]; then 
	f_docfig
else
	read -p "Enter dist name: " distro
	read -p "Enter the tag name: " tag
fi

f_lampins(){
	
	for i in $distros1; do
        	if [ $distro = $i ]; then
			installr="yum"
        	fi
    	done

    	for n in $distros2; do
        	if [ $distro = $n ]; then
			installr="apt-get"
        	fi
    	done

	if [ $distro = fedora ];then
		installr="dnf"
	fi	

	echo "installing Git & Lamp"
	sudo docker run $tag /bin/bash -c "$installr install -y -q git && git clone https://github.com/GolanSho/LAMP_install_PY.git && bash LAMP_install_PY/Bashinstall.sh"
		
}

f_lampins
