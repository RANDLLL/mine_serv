#!/bin/bash
# Этот скрипт работает для майкравт сервера на версии 1.12.2 и на базе дистрибутивов Ubuntu/Debian
# Version - 0.5
cd /root/script
echo "Hello, this a script for install and options minecraft server"
sleep 3
echo " step 1 - install java "
sleep 3
if [[ -f jre-linux.tar.gz  ]] # Проверка на наличие файла 
then
	echo "this file exist"
else
	wget https://javadl.oracle.com/webapps/download/AutoDL?BundleId=248233_ce59cff5c23f4e2eaf4e778a117d4c5b -O jre-linux.tar.gz # Скачивание архива 
	echo "file installed"
fi
echo "step 2 - unzip procces"
sleep 3
tar xvfz jre-linux.tar.gz # Распаковка
echo "step 3 - install kernel"
sleep 3
if [[ -f server.jar ]]
then
	echo "kernel exist"
else
	wget https://launcher.mojang.com/v1/objects/886945bfb2b978778c3a0288fd7fab09d315b25f/server.jar
	echo "kerner installed"
fi
echo "step 4 - test start server" # Это нужно для того, чтобы появились нужные файлы для настройки
java -Xms256M -Xmx700M -jar server.jar nogui # Запуск сервера xms - минимум xmx - максимум
echo "step 5 - check file eula"
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
echo "step 6 - change style game"
echo "1 - license, 2 - pirate"
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
echo "step 7 - start server"
java -Xms256M -Xmx700M -jar server.jar nogui

