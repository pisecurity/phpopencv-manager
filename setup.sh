#!/bin/sh

/opt/pisecurity/opencv-manager/install-release.sh 3.4.1

apt-get install php-cli php-dev

mkdir -p /opt/pisecurity-3rdparty
if [ ! -d /opt/pisecurity-3rdparty/php-opencv ]; then
	git clone https://github.com/php-opencv/php-opencv /opt/pisecurity-3rdparty/php-opencv
	cd /opt/pisecurity-3rdparty/php-opencv
	git checkout 3.4
	phpize
	CFLAGS="-s -O2" CXXFLAGS="-s -O2" ./configure --with-opencv
fi

cd /opt/pisecurity-3rdparty/php-opencv
make
make install

for phpver in `ls /etc/php`; do
	file=/etc/php/$phpver/mods-available/opencv.ini
	if [ ! -f $file ]; then
		echo "; priority=20" >$file
		echo "extension=opencv.so" >>$file
	fi
done

phpenmod opencv
