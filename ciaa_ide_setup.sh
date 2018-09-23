#!/bin/sh
#
# Copyright 2015, Pablo Ridolfi. All rights reserved.
#
# This file is part of the CIAA Project: www.proyecto-ciaa.com.ar
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

arch=$(arch)
ciaa_ide_path=$HOME/ciaa-ide

echo ""
echo "**************************************"
echo "Instalation script for CIAA-IDE-Linux."
echo "**************************************"
echo ""

if [ $arch = x86_64 ]
then
	echo "**********************************************"
	echo "1) Installing additional packages (64-bits)..."
	echo "**********************************************"
	sudo apt-get update
	sudo apt-get -y install php7.2-cli libftdi-dev libusb-1.0-0-dev git git-gui libgtk2.0-0:i386 libxtst6:i386 libpangox-1.0-0:i386 libpangoxft-1.0-0:i386 libidn11:i386 libglu1-mesa:i386 libncurses5:i386 libudev1:i386 libusb-1.0:i386 libusb-0.1:i386 gtk2-engines-murrine:i386 libnss3-1d:i386 libwebkitgtk-1.0-0 gtkterm --fix-missing
else
	echo "**********************************************"
	echo "1) Installing additional packages (32-bits)..."
	echo "**********************************************"
	sudo apt-get update
	sudo apt-get -y install php7.2-cli libftdi-dev libusb-1.0-0-dev git git-gui libgtk2.0-0 libxtst6 libpangox-1.0-0 libpangoxft-1.0-0 libidn11 libglu1-mesa libncurses5 libudev1 libusb-1.0 libusb-0.1 gtk2-engines-murrine libnss3-1d libwebkitgtk-1.0-0 gtkterm --fix-missing
fi

echo ""
echo "*********************************"
echo "2) Adding $USER to dialout group."
echo "*********************************"
sudo adduser $USER dialout

echo ""
echo "**********************************************"
echo "3) Creating folder $ciaa_ide_path..."
echo "**********************************************"
mkdir $ciaa_ide_path
cd $ciaa_ide_path

echo ""
echo "*******************************************************"
echo "4) Downloading and unpacking arm-none-eabi toolchain..."
echo "*******************************************************"
sudo apt-get remove binutils-arm-none-eabi gcc-arm-none-eabi
sudo add-apt-repository ppa:team-gcc-arm-embedded/ppa
sudo apt-get update
sudo apt-get -y install gcc-arm-embedded --fix-missing
echo 'export PATH=$PATH:/usr/arm-none-eabi/bin' >> $HOME/.bashrc

echo ""
echo "*************************************************"
echo "5) Downloading, unpacking and building OpenOCD..."
echo "*************************************************"

# wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/openocd/0.10.0-4/openocd_0.10.0.orig.tar.bz2
# tar -xvjf openocd_0.10.0.orig.tar.bz2
# openocd_path=$ciaa_ide_path/openocd_0.10.0.orig
# cd $openocd_path
# ./configure --enable-ftdi
# make

# echo ""
# echo "**********************************************"
# echo "6) Adding udev rules and restarting service..."
# echo "**********************************************"
# sudo cp $openocd_path/contrib/99-openocd.rules /etc/udev/rules.d/
sudo apt-get -y install openocd --fix-missing # A partir de Ubuntu 16.04 esta actualizado en v0.9
sudo service udev restart

echo ""
echo "******************************************"
echo "6) Cloning CIAA-Firmware GIT repository..."
echo "******************************************"
cd $ciaa_ide_path
sudo apt-get -y install git --fix-missing
git clone --recursive https://github.com/ciaa/Firmware.git

echo ""
if [ $arch = x86_64 ]
then
	echo "*****************************************"
	echo "7) Downloading Eclipse C/C++ (64-bits)..."
	echo "*****************************************"
	# wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz
	# tar -xzvf eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz
	sudo apt-get -y install eclipse-cdt --fix-missing
else
	echo "*****************************************"
	echo "7) Downloading Eclipse C/C++ (32-bits)..."
	echo "*****************************************"
	# wget http://eclipse.c3sl.ufpr.br/technology/epp/downloads/release/luna/SR2/eclipse-cpp-luna-SR2-linux-gtk.tar.gz
	# tar -xzvf eclipse-cpp-luna-SR2-linux-gtk.tar.gz
	sudo apt-get -y install eclipse-cdt --fix-missing
fi

echo ""
if [ $arch = x86_64 ]
then
	echo "**********************************************"
	echo "8) Downloading and installing JRE (64-bits)..."
	echo "**********************************************"
 	# wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jre-7u79-linux-x64.tar.gz
	# cd $ciaa_ide_path/eclipse
	# tar -xzvf ../jre-7u79-linux-x64.tar.gz
	sudo apt-get -y install openjdk-11-jre --fix-missing

	
else
	echo "**********************************************"
	echo "8) Downloading and installing JRE (32-bits)..."
	echo "**********************************************"
	# wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u79-b15/jre-7u79-linux-i586.tar.gz
	# cd $ciaa_ide_path/eclipse
	# tar -xzvf ../jre-7u79-linux-i586.tar.gz
	sudo apt-get -y install openjdk-11-jre --fix-missing

fi
# mv jre1.7.0_79/ jre/

echo ""
echo "**************************"
echo "9) Writing start script..."
echo "**************************"
cd $ciaa_ide_path
echo "#!/bin/sh
export PATH=\$PATH:$toolchain_path/bin:$openocd_path/src
echo \"Starting CIAA-IDE...\"
$ciaa_ide_path/eclipse/eclipse &" > ciaa-ide
chmod +x ciaa-ide

# echo ""
# echo "*****************************"
# echo "10) Updating splash screen..."
# echo "*****************************"
# cd $ciaa_ide_path
# wget http://www.proyecto-ciaa.com.ar/devwiki/lib/exe/fetch.php?media=docu:fw:bm:ide:splash.bmp.tar.gz -O splash.bmp.tar.gz
# cd eclipse/plugins/org.eclipse.platform_4.4.2.v20150204-1700/
# mv splash.bmp splash.bmp.old
# tar -xzvf ../../../splash.bmp.tar.gz

echo ""
echo "*****************************"
echo "11) Move .cproject and .project..."
echo "*****************************"
mv $ciaa_script_path/project  $ciaa_ide_path/Firmware/.project
mv $ciaa_script_path/cproject $ciaa_ide_path/Firmware/.cproject

echo ""
echo "*****************************"
echo "12) Delete bz2 and gz files"
echo "*****************************"
cd $ciaa_ide_path
rm *.gz
rm *.bz2
rm *.bz2.*

echo ""
echo "****************************************************************************************"
echo "Done! You can run CIAA-IDE by executing"
echo "$ $ciaa_ide_path/ciaa-ide"
echo "Remember to install GNU ARM plug-in on Eclipse (http://gnuarmeclipse.livius.net/)."
echo "Help > Install New Software... > Work with: http://gnuarmeclipse.sourceforge.net/updates"
echo "****************************************************************************************"
