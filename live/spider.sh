#!/bin/bash

if [ -e ~/test.m3u ]; then
	rm -f ~/test.m3u
fi

touch ~/test.m3u
echo '#EXTM3U' > ~/test.m3u

num=3221225700

while (( $num < 3221227000 ))
do
	wget -qs http://39.134.24.162/dbiptv.sn.chinamobile.com/PLTV/88888888/224/${num}/1.m3u8
	if [ $? -eq 0 ]; then
		echo '#EXTINF:-1 ,'${num} >> ~/test.m3u
		echo 'http://39.134.24.162/dbiptv.sn.chinamobile.com/PLTV/88888888/224/'${num}'/1.m3u8' >> ~/test.m3u
	fi
	wget -qs http://39.134.24.166/dbiptv.sn.chinamobile.com/PLTV/88888890/224/${num}/index.m3u8
	if [ $? -eq 0 ]; then
		echo '#EXTINF:-1 ,'${num} >> ~/test.m3u
		echo 'http://39.134.24.166/dbiptv.sn.chinamobile.com/PLTV/88888890/224/'${num}'/index.m3u8' >> ~/test.m3u
	fi
	let num++
done

echo 'completed'
