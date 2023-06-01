#!/bin/bash
# Этот скрипт работает для майкравт сервера на версии 1.12.2 и на базе дистрибутивов Ubuntu/Debian
# Version - 0.7
# Донастроить 2 пункт
cd /root/script
alive=1
while [[ ${alive} -eq 1 ]] 
do
echo -e "\e[92mHi, this a menu install your minecraft server, change\e[0m"
echo -e "\e[33m1 - install server and run, 2 - oprions server,3 - only install, 4 - remove all files, 5 - exit\e[0m"
read change
case ${change} in
1)
echo -e "\e[92mHello, this a script for install and options minecraft server\e[0m"
sleep 3
echo -e "\e[92mStep 1 - installing java\e[0m"
sleep 3
if [[ -f jre-linux.tar.gz  ]] # Проверка на наличие файла 
then
	echo "this file exist"
else
	wget https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248233_ce59cff5c23f4e2eaf4e778a117d4c5b -O jre-linux.tar.gz # Скачивание архива 
	echo "file installed"
fi
echo -e "\e[92mStep 2 - unziping\e[0m"
sleep 3
tar xvfz jre-linux.tar.gz # Распаковка
echo -e "\e[92mStep 3 - installing kernel\e[0m"
sleep 3
if [[ -f server.jar ]]
then
	echo "kernel exist"
else
	wget https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar
	echo "kerner installed"
fi
echo -e "\e[92mStep 4 - test start server\e[0m" # Это нужно для того, чтобы появились нужные файлы для настройки
java -Xms256M -Xmx700M -jar server.jar nogui # Запуск сервера xms - минимум xmx - максимум
echo -e "\e[92mStep 5 - checking file eula\e[0m"
sleep 3
if [[ -f eula.txt ]]
then
	sed -i 's/eula=false/eula=true/g' eula.txt # Смена строчки
	echo "change eula.txt"
else
	touch eula.txt
	echo "eula=true" > eula.txt
	echo "add eula"
fi
echo -e "\e[92mStep 6 - change style game\e[0m"
echo -e "\e[92m1 - license, 2 - pirate\e[0m"
read style
case ${style} in
1)
	if grep -Fxq "online-mode=true" server.properties # F - искать фиксированную строку x - искать точное совпадение всей строки, а не только ее части q - не выводить результат поиска на экран
	then	
		echo "change on license"
	else
		sed -i '/online-mode=false/d' server.properties # Удалить строчку
		echo "online-mode=true" >> server.properties # Добавить в конец файла строчку
		echo "change on license"
	fi
	;;
2)
	if grep -Fxq "online-mode=false" server.properties
	then
		echo "change on pirate"
	else
		sed -i '/online-mode=true/d' server.properties
		echo "online-mode=false" >> server.properties
		echo "change on pirate"
	fi
	;;
esac
echo -e "\e[92mStep 7 - start server\e[0m"
java -Xms256M -Xmx700M -jar server.jar nogui
;;
2)
	echo -e "\e[92mChange what you want change\e[0m"
	echo -e "1 - max-tick-time, 2 - generator-settings, 3 - allow nether, 4 - force-gamemode, 5 - gamemode\n"
	echo -e "6 - enable-query, 7 - player-idle-timeout, 8 - difficulity, 9 - spawn-monsters, 10 - op-permission-level\n "
	echo -e "11 - pvp, 12 - snooper-enabled, 13 - level-type, 14 - hardcore, 15 - enable-command-block\n"
	echo -e "16 - max-player, 17 - network-compression-threshold, 18 - resource-pack-shal, 19 - max-world-size, 20 - server-port\n"
	echo -e "21 - server-ip, 22 - spawn-npcs, 23 - allow-flight, 24 - level-name, 25 - view-distance\n"
	echo -e "26 - resource-pack, 27 - spawn-animals, 28 - white-list, 29 - generate-structures, 30 - online-mode\n"
	echo -e "31 - max-build-height, 32 - level-seed, 33 - prevent-proxy-connections, 34 - use-native-transport, 35 - motd\n"
	echo -e "36 - enable-rcon\n"
	;;
3)
	echo -e "\e[92mStep 1 - installing java\e[0m"
	sleep 3
	if [[ -f jre-linux.tar.gz  ]]  
	then
		echo "this file exist"
	else
		wget https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248233_ce59cff5c23f4e2eaf4e778a117d4c5b -O jre-linux.tar.gz  
		echo "file installed"
	fi
	echo -e "\e[92mStep 2 - unziping\e[0m"
	sleep 3
	tar xvfz jre-linux.tar.gz 
	echo -e "\e[92mStep 3 - install kernel\e[0m"
	sleep 3
	if [[ -f server.jar ]]
	then
		echo "kernel exist"
	else
		wget https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar
		echo "kerner installed"
	fi
	echo -e "\e[92mStep 4 - test start server\e[0m" 
	java -Xms256M -Xmx700M -jar server.jar nogui 
	echo -e "\e[92mStep 5 - check file eula\e[0m"
	sleep 3
	if [[ -f eula.txt ]]
	then
		sed -i 's/eula=false/eula=true/g' eula.txt 
		echo "change eula.txt"
	else
		touch eula.txt
		echo "eula=true" > eula.txt
		echo "add eula"
	fi
	echo -e "\e[92mComplete\e[0m"
	;;
4)
	echo "Are you sure?"
	echo "1 - yes, 2 - no"
	read sure
	if [[ ${sure} -eq 1 ]]
	then
		rm -r banned-ips.json banned-players.json eula.txt jre1.8.0_371 jre-linux.tar.gz logs ops.json server.jar server.properties usercache.json whitelist.json world
		echo "Files delite"
	else 
		echo "Okay"
	fi
	;;
5)
	alive=0
	echo "bye"
	;;
esac
done

