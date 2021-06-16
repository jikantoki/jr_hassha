#!/bin/bash
ret=0
if [ "$#" != "2" ];then
	echo "引数1で発車メロディー音源を指定してね！(.wav)引数2で発車番線を指定してね！(1〜4)"
	exit 1
fi

echo "発車メロディースイッチは3.3vとGPIO21に接続してください、Ctrl + Cで終了します"
echo "発車メロディー再生待ち‥"
while :; do
	while :; do
		ret=`gpio -g read 21`
		if [ "$ret" = "1" ];then
			break
		fi
	done
	echo "$ret"
	
	#ここでメロディーを再生する
	melo_play(){
		while :;
		do
			ret=`gpio -g read 21`
			if [ "$ret" = "1" ];then
				#sleep 0.1
				aplay $1
			else
				break
			fi
		done
	}
	
	melo_stopwait(){
		echo "メロディー再生中"
		
		while :; do
			ret=`gpio -g read 21`
			if [ "$ret" = "0" ];then
				break
			fi
		done
		echo "$ret"
		#このタイミングで一度全ての音を止める
		killall aplay
	}
	
	melo_play $1 & melo_stopwait
	
	#ここでドア閉まる放送する
	door_close(){
		echo "ドア閉め放送中"
		aplay $1
		echo "再生できます"
	}
	door_close $2 & continue
	
	
done
#ここでプログラムの先頭に戻る

exit