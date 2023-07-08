#!/bin/bash
# Этот скрипт работает для майнкравт сервера на версии 1.12.2 и на базе дистрибутивов Ubuntu/Debian
# Version - 0.90 (Добавлена возможность конфигурации нескольких настроек) 
# Донастроить 2 пункт
cd /root/script
alive=1
while [[ ${alive} -eq 1 ]]
do
echo -e "\e[92mHi, this a menu install your minecraft server, change\e[0m"
echo -e "\e[33m1 - install server and run, 2 - options server,3 - only install, 4 - remove all files, 5 - exit, 6 - start server\e[0m"
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
        rm jre-linux.tar.gz
        if [[ -d /usr/lib/jvm ]]
        then
                rm -r /usr/lib/jvm/
                mkdir /usr/lib/jvm/
        else
                mkdir /usr/lib/jvm/
        fi
        mv jre* /usr/lib/jvm/
        update-alternatives --install /usr/bin/java java /usr/lib/jvm/$(ls /usr/lib/jvm/)/bin/java 1
        java -version
        update-alternatives --config java
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

        echo -e "\e[92mStep 7 - start server\e[0m]"
        echo -e "\e[92mPlease, change you configuration pc. If you pc low - 1, if you pc medium - 2, if you pc good - 3, if you want castom - 4" #Пользователь выбирает свою конфигурацию
        read pc
        case ${pc} in
        1)
                if [[ $(free -m | awk 'NR==2{print$2}') -le 2048 ]]
                then
                        java -Xms256M -Xmx700M -jar server.jar nogui
                else
                        echo -e "\e[93mError\e[0m"
                fi
                ;;
        2)
                if [[ $(free -m | awk 'NR==2{print$2}') -le 4096 ]]
                then
                        java -Xms1024M -Xmx2048M -jar server.jar nogui
                else
                        echo -e "\e[93mError\e[0m"
                fi
                ;;
        3)
                if [[ $(free -m | awk 'NR==2{print$2}') -le 8192 ]]
                then
                        java -Xms3072M -Xmx4096M -jar server.jar nogui
                else
                        echo -e "\e[93mError\e[0m"
                fi
                ;;
        4)
                echo "minimum"
                read minimum
                echo "maximum"
                read maximum

                if [[ ( ${maximum} -gt ${minimum} ) && $(free -m | awk 'NR==2{print$2}') -ge ${maximum} && $(free -m | awk 'NR==2{print$2}') -ge ${minimum} ]]
                then
                        java -Xms${minimum}M -Xmx${maximum}M -jar server.jar nogui
                else
                        echo -e "\e[93mError\e[0m"
                fi
                ;;
                esac
                ;;

2)
        if [[ -f server.properties.bak ]]
        then
                echo -e "\e[92mBackup file server.properties exist\e[0m"
        else
                echo -e "\e[92mCreating backup server.properies\e[0m" #Создание бэкапфайла с параметрами
                touch server.properties.bak
                cat server.properties > server.properties.bak
                echo -e "\e[92mComplete\e[0m"
                sleep 2
        fi
        echo -e "\e[33mIf your dont know how to configure this options, follow to link\e[0m \e[95mhttps://wiki-minecraft.ru/Server.properties\e[0m"
        sleep 3
        echo -e "\e[92mChange what you want change\e[0m"
        echo -e "1 - max-tick-time, 2 - generator-settings, 3 - allow nether, 4 - force-gamemode, 5 - gamemode\n"
        echo -e "6 - enable-query, 7 - player-idle-timeout, 8 - difficulity, 9 - spawn-monsters, 10 - op-permission-level\n "
        echo -e "11 - pvp, 12 - snooper-enabled, 13 - level-type, 14 - hardcore, 15 - enable-command-block\n"
        echo -e "16 - max-player, 17 - network-compression-threshold, 18 - resource-pack-shal, 19 - max-world-size, 20 - server-port\n"
        echo -e "21 - server-ip, 22 - spawn-npcs, 23 - allow-flight, 24 - level-name, 25 - view-distance\n"
        echo -e "26 - resource-pack, 27 - spawn-animals, 28 - white-list, 29 - generate-structures, 30 - online-mode\n"
        echo -e "31 - max-build-height, 32 - level-seed, 33 - prevent-proxy-connections, 34 - use-native-transport, 35 - motd\n"
        echo -e "36 - enable-rcon\n"

        read options
        case ${options} in
		1)
			echo "Write max tick time (default 60000)"
			read mtt
			sed -i "s/max-tick-time=.*/max-tick-time=${mtt}/g" server.properties
			echo "Your max tick time ${mtt}"
			;;
		2)
			echo "Write generator settings"
		        read gese
			sed -i "s/generator-settings=.*/generator-settings=${gese}"
			echo "Your generator settings ${gese}"
			;;
		
                3)
                        echo "Allow nether? "Yes" or "No" "
                        read allownether
                        if [[ ${allownether} == Yes ]]
                        then
                                sed -i "s/allow-nether=false/allow-nether=true/g" server.properties
                                echo "Change on true"
                        elif [[ ${allownether} == No ]]
                        then
                                sed -i "s/allow-nether=true/allow-nether=false/g" server.properties
                                echo "Change on false"
                        else
                                echo "Error, write "Yes" or "No" "
                        fi
                        ;;
                4)
                        echo "Force-gamemode 'Yes' or 'No'"
                        read forcegam
                        if [[ ${forcegam} == Yes ]]
                        then
                                sed -i "s/force-gamemode=false/force-gamemode=true/g" server.properties
                                echo "Change on true"
                        elif [[ ${forcegam} == No ]]
                        then
                                sed -i "s/force-gamemode=true/force-gamemode=false/g" server.properties
                                echo "Change on false"
                        else
                                echo "Error, write 'Yes' or 'No' "
                        fi
                        ;;
                5)
                        echo "Choose gamemode 1 - survival, 2 - creative, 3 - adventure, 4 - spectator "
                        read gamemode
                        case ${gamemode} in
                                1)
                                        sed -i "s/gamemode=.*/gamemode=survival/g" server.properties
                                        echo -e "\e[92mChange on survival\e[0m"
                                        ;;
                                2)
                                        sed -i "s/gamemode=.*/gamemode=creative/g" server.properties
                                        echo -e "\e[92mChange on creative\e[0m"
                                        ;;
                                3)
                                        sed -i "s/gamemode=.*/gamemode=adventure/g" server.properties
                                        echo -e "\e[92mChange on adventure\e[0m"
                                        ;;
                                4)
                                        sed -i "s/gamemode=.*/gamemode=spectator/g" server.properties
                                        echo -e "\e[92mChange on spectator\e[0m"
                                        ;;
                        esac
                        ;;
                6)
                        echo "1 - on enable query, 2 - off"
                        read enqu
                        if [[ enqu -eq 1 ]]
                        then
                                sed -i "s/enable-query=.*/enable-query=true/g" server.properties
                                echo "enable query ON"
                        elif [[ enqu -eq 2 ]]
                        then
                                sed -i "s/enable-query=.*/enable-query=false/g" server.properties
                                echo "enable query OFF"
                        else
                                echo "Error, write 1 or 2"
                        fi
                        ;;
		7)
			echo "Write player idle timeout (default 0)"
			read pit
			sed -i "s/player-idle-timeout=.*/player-dile-timeout=${pit}/g" server.properties
			echo "Your player idle timeout ${pit}"
			;;
		8)
			echo "Choose difficulty. 1 - peaceful, 2 - easy, 3 - normal, 4 - hard"
			read diff
			case ${diff} in
				1) 
					sed -i "s/difficulty=.*/difficulty=1/g" server.properties
					echo "Your difficulty PEACEFUL"
					;;
				2)
					sed -i "s/difficulty=.*/difficulty=2/g" server.properties
                                        echo "Your difficulty EASY"
					;;
				3)
					sed -i "s/difficulty=.*/difficulty=3/g" server.properties
                                        echo "Your difficulty NORMAL"
					;;
				4)
					sed -i "s/difficulty=.*/difficulty=4/g" server.properties
                                        echo "Your difficulty HARD"
					;;
				*)
					echo "Error. Write number 1 - 4"
					;;
			esac
			;;
                9)
                        echo "Spawn monsters? 1 - yes, 2 - no"
                        read spmo
                        if [[ ${spmo} -eq 1 ]]
                        then
                                sed -i "s/spawn-monsters=.*/spawn-monsters=true/g" server.properties
                                echo "Spawn monsters ON"
                        elif [[ ${spmo} -eq 2 ]]
                        then
                                sed -i "s/spawn-monsters=.*/spawn-monsters=false/g" server.properties
                                echo "Spawn monsters OFF"
                        else
                                echo "Error, write 1 or 2"
                        fi
                        ;;
		10)
			echo "Choose op permission level. 1 - 4 (default 4)"
                        read opl
                        case ${opl} in
                                1)
                                        sed -i "s/op-permission-level=.*/op-permission-level=1/g" server.properties
                                        echo "Your permission 1"
                                        ;;
                                2)
                                        sed -i "s/op-permission-level=.*/op-permission-level=2/g" server.properties
                                        echo "Your permission 2"
                                        ;;
                                3)
                                        sed -i "s/op-permission-level=.*/op-permission-level=3/g" server.properties
                                        echo "Your permission 3"
                                        ;;
                                4)
                                        sed -i "s/op-permission-level=.*/op-permission-level=4/g" server.properties
                                        echo "Your permission 4"
                                        ;;
                                *)
                                        echo "Error. Write number 1 - 4"
                                        ;;
                        esac
			;;

                11)
                        echo "1 - Yes, 2 - No"
                        read pvp
                        if [[ ${pvp} -eq 1 ]]
                        then
                                sed -i "s/pvp=.*/pvp=true/g" server.properties
                                echo "pvp on"
                        elif [[ ${pvp} -eq 2 ]]
                        then
                                sed -i "s/pvp=.*/pvp=false/g" server.properties
                                echo "pvp off"
                        else
                                echo "Error, write 1 or 2"
                        fi
                        ;;

		12)
			echo "Snooper enabled? 1 - Yes, 2 - No"
			read snen
			if [[ ${snen} -eq 1 ]]
			then
				sed -i "s/snooper-enabled=.*/snooper-enabled=true/g" server.properties
				echo "Your snooper ON"
			elif [[ ${snen} -eq 2 ]]
			then
				sed -i "s/snooper-enabled=.*/snooper-nabled=false/g" server.properties
				echo "Your snooper OFF"
			else 
				echo "Error.Write 1 or 2"
			fi
			;;

                16)
                        echo "Max players 0 - 2147483647"
                        read maxpl
                        sed -i "s/max-players=.*/max-players=${maxpl}/g" server.properties
                        echo "max-players = ${maxpl}"
                        ;;

		20)
			echo "Wtire your port 1 - 65535"
			read sepo
			if [[ ${sepo} -le 65535 && ${sepo} -ge 1 ]]
			then
				sed -i "s/server-port=.*/server-port=${sepo}/g" server.properties	
				echo "Your port ${sepo}"
			else
				echo "Error. Wtire number 1 - 65535"
			fi
			;;
		21)
			echo "Write your ip server"
			read seip
			sed -i "s/server-ip=.*/server-ip=${seip}/g" server.properties 
			echo "YOUR IP ${seip}"
			;;

		22)
			echo "Spawn npc? 1 - Yes, 2 - No"
			read spnp
			if [[ ${spnp} -eq 1 ]]
                        then
                                sed -i "s/spawn-npcs=.*/spawn-npcs=true/g" server.properties
                                echo "Change on true"
                        elif [[ ${spnp} -eq 2 ]]
                        then
                                sed -i "s/spawn-npcs=.*/spawn-npcs=false/g" server.properties
                                echo "Change on false"
                        else
                                echo "Error, white 1 or 2"
                        fi
                        ;;


		23)	
			echo "Allow flight? 1 - Yes, 2 - No"
			read alfi
			if [[ ${alfi} -eq 1 ]]
			then
				sed -i "s/allow-flight=.*/allow-flight=true/g" server.properties
				echo "Flight is ON"
			elif [[ ${alfi} -eq 2 ]]
			then
				sed -i "s/allow-flight=.*/allow-flight=false/g" server.properties
				echo "Flight is OFF"
			else
				echo "Error.Write 1 or 2"
			fi
			;;

		24)
			echo "Write name of direcroty.You should be in the same directory as the server files. DEFAULT world"
			read levelname
			if [[ -z ${levelname} ]]
			then
				echo "Error.Wtire name of directory with map"
			else
				sed -i "s/level-name=.*/level-name=${levelname}/g" server.properties
				echo "You wtire ${levelname}"
			fi
			;;
			

                26)
                        #Не работает
                        echo "wtire link your resource-pack. example https://minecraft-inside.ru/download/264353/"
                        read repa
                        sed -i "s/resource-pack=.*/resource-pack=${repa}/g" server.properties
                        echo "okey"
                        ;;

		25)
			echo "View distance.Write 3 - 15"
			read vidi
			if [[ ${vidi} -ge 3 && ${vidi} -le 15 ]]
			then
				sed -i "s/view-distance=.*/view-distance=${vidi}/g" server.properties
				echo "View distance is ${vidi}"
			else
				echo "Error.Write number 3 - 15"
			fi
			;;

		27)
			echo "Spawn animals? 1 - Yes, 2 - No"
			read span
			if [[ ${span} -eq 1 ]]
                        then
                                sed -i "s/spawn-animals=.*/spawn-animals=true/g" server.properties
                                echo "Change on true"
                        elif [[ ${span} -eq 2 ]]
                        then
                                sed -i "s/spawn-animals=.*/spawn-animals=false/g" server.properties
                                echo "Change on false"
                        else
                                echo "Error, white 1 or 2"
                        fi
                        ;;


		28)
			echo "Choose white-list. 1 - true, 2 - false"
			read whli
			if [[ ${whli} -eq 1 ]]
			then 
				sed -i "s/white-list=.*/white-list=true/g" server.properties
				echo "Change on true"
			elif [[ ${whli} -eq 2 ]]
			then
				sed -i "s/white-list=.*/white-list=false/g" server.properties
				echo "Change on false"
			else
				echo "Error, white 1 or 2"
			fi
			;;

		29)
			echo "Choose generate structures. 1 - true, 2 - false"
			read gest
			if [[ ${gest} -eq 1 ]]
			then
				sed -i "s/generate-structures=.*/generate-structures=true/g" server.properties
				echo "Generate strctures ON"
			elif [[ ${gest} -eq 2 ]]
			then
				sed -i "s/generate-structures=.*/generate-structures=false/g" server.properties
				echo "Generate structures OFF"
			else
				echo "Error.Write 1 or 2"
			fi
			;;

                30)
                        echo "Choose online-mode 1 - true, 2 - false"
                        read onmode
                        if [[ ${onmode} -eq 1 ]]
                        then
                                sed -i "s/online-mode=.*/online-mode=true/g" server.properties
                                echo "Choose true"
                        elif [[ ${onmode} -eq 2 ]]
                        then
                                sed -i "s/online-mode=.*/online-mode=false/g" server.properties
                                echo "Choose false"
                        else
                                echo "Error, wtire 1 or 2"
                        fi
                        ;;

                31)
                        echo "Choose max build height 64 - 256"
                        read maxbuild
                        if (( ${maxbuild} % 16 == 0 ))
                        then
                                if [[ ${maxbuild} -le 256 && ${maxbuild} -gt 0 ]]
                                then
                                        sed -i "s/max-build-height=.*/max-build-height=${maxbuild}/g" server.properties
                                        echo "Max build height = ${maxbuild}"
                                else
                                echo "Error"
                                fi
                        else
                                echo "Error.You number must / 16"
                        fi
                        ;;
		
		32)
			echo "WIRNING. YOU WORLD WILL BE DELITED, IF YOU WRITE SEED, YOUR READY? 1 - Yes, 2 - NO"
			read delworld
			if [[ ${delworld} -eq 1 ]]
			then	
				echo "Write seed"
				read lese
				sed -i "s/level-seed=.*/level-seed=${lese}/g" server.properties
				echo "Your seed ${lese}"
				rm -r world/
			elif [[ ${delworld} -eq 2 ]]
			then
				echo "Okay"
			else
				echo "Error.Write 1 or 2"
			fi
			;;
		34)
			echo "Use native transport? 1 - Yes, 2 - No"
			read unt
			if [[ ${unt} -eq 1 ]]
			then
				sed -i "s/use-native-transport=.*/use-native-transport=true/g" server.properties
				echo "Use native transport ON"
			elif [[ ${unt} -eq 2 ]]
			then
				sed -i "s/use-native-transport=.*/use-native-transport=false/g" server.properties
				echo "Use native transport OFF"
			else
				echo "Error.Write 1 or 2"
			fi
			;;

                35)
                        echo "description your server"
                        read desc
                        if [[ ${#desc} -gt 60 ]]
                        then
                                echo "Error, your description > 60"
                        else
                                sed -i "s/motd=.*/motd=${desc}/g" server.properties
                                echo "Your description good"
                        fi
                        ;;

		smugdance)
			xdg-open "https://www.youtube.com/watch?v=tYntRuUAME0"
;;

        esac
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
        rm jre-linux.tar.gz
        if [[ -d /usr/lib/jvm ]]
        then
                rm -r /usr/lib/jvm/
                mkdir /usr/lib/jvm/
        else
                mkdir /usr/lib/jvm/
        fi
        mv jre* /usr/lib/jvm/
        update-alternatives --install /usr/bin/java java /usr/lib/jvm/$(ls /usr/lib/jvm/)/bin/java 1
        java -version
        update-alternatives --config java
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
                rm -r server.properties.bak banned-ips.json banned-players.json eula.txt jre1.8.0_371 jre-linux.tar.gz logs ops.json server.jar server.properties usercache.json whitelist.json world
                echo "Files delite"
        else
                echo "Error"
        fi
        ;;
5)
        alive=0
        echo "bye"
        ;;
6)
        echo -e "\e[93mChecking files\e[0m"
        if [[ -f eula.txt && -f server.properties && -f server.jar && -d "/usr/lib/jvm/$(ls /usr/lib/jvm/)" ]]
                then
			echo "License or pirate? 1 - license, 2 - pirate"
			read style
			if [[ ${style} -eq 1 ]]
			then
				sed -i "s/online-mode=.*/online-mode=true/g" server.properties
				echo "License is true"
			elif [[ ${style} -eq 2 ]]
			then
				sed -i "s/online-mode=.*/online-mode=false/g" server.properties
				echo "Pirate is true"
			else
				echo "Error, write 1 or 2"
			fi

                echo -e "\e[92mPlease, change you configuration pc. If you pc low - 1, if you pc medium - 2, if you pc good - 3, if you want castom - 4"
                read pc
                case ${pc} in
                1)
                        if [[ $(free -m | awk 'NR==2{print$2}') -le 2048 ]]
                        then
                                java -Xms256M -Xmx700M -jar server.jar nogui
                        else
                                echo -e "\e[93mError\e[0m"
                        fi
                        ;;
                2)
                        if [[ $(free -m | awk 'NR==2{print$2}') -le 4096 ]]
                        then
                                java -Xms1024M -Xmx2048M -jar server.jar nogui
                        else
                                echo -e "\e[93mError\e[0m"
                        fi
                        ;;
                3)
                        if [[ $(free -m | awk 'NR==2{print$2}') -le 8192 ]]
                        then
                                java -Xms3072M -Xmx4096M -jar server.jar nogui
                        else
                                echo -e "\e[93mError\e[0m"
                        fi
                        ;;
                4)
                        echo "minimum"
                        read minimum
                        echo "maximum"
                        read maximum

                        if [[ ( ${maximum} -gt ${minimum} ) && $(free -m | awk 'NR==2{print$2}') -ge ${maximum} && $(free -m | awk 'NR==2{print$2}') -ge ${minimum} ]]
                        then
                                java -Xms${minimum}M -Xmx${maximum}M -jar server.jar nogui
                        else
                                echo -e "\e[93mError\e[0m"
                        fi
                        ;;
                esac
                else
                        echo -e "\e[91mFiles not find\e[0m"
        fi
        ;;
esac
done
