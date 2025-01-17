#! /bin/bash

#### Colors Output

RESET="\033[0m"			# Normal Colour
RED="\033[0;31m" 		# Error / Issues
GREEN="\033[0;32m"		# Successful       
BOLD="\033[01;01m"    	# Highlight
WHITE="\033[1;37m"		# BOLD
YELLOW="\033[1;33m"		# WARNINGing
PADDING="  "
DPADDING="\t\t"


#### Other Colors / Status Code

LGRAY="\033[0;37m"		# Light Gray
LRED="\033[1;31m"		# Light Red
LGREEN="\033[1;32m"		# Light GREEN
LBLUE="\033[1;34m"		# Light Blue
LPURPLE="\033[1;35m"	# Light Purple
LCYAN="\033[1;36m"		# Light Cyan
SORANGE="\033[0;33m"	# Standar Orange
SBLUE="\033[0;34m"		# Standar Blue
SPURPLE="\033[0;35m"	# Standar Purple      
SCYAN="\033[0;36m"		# Standar Cyan
DGRAY="\033[1;30m"		# Dark Gray
TIME=$(date +'%H:%M:%S')

banner(){

    clear
    echo -e "
${GREEN}   __  ___       ${SPURPLE} _      ______${RESET}
${GREEN}  /  |/  /__ ____${SPURPLE}| | /| / / __/${RESET}
${GREEN} / /|_/ / _ '/ -_${SPURPLE}) |/ |/ /\ \  ${RESET}
${GREEN}/_/  /_/\_,_/\__/${SPURPLE}|__/|__/___/ ${RESET}v{1.2#${YELLOW}dev${RESET}} by @sianturi1337

${SPURPLE}MaeWS${RESET} - ${SCYAN}LE${RESET}/${SCYAN}AMP${RESET} Automated installer\n\n"

}

checkPrivileges(){

    echo "[*] start at $(date)"
    echo -e "[*] ${GREEN}MaeWS${RESET} - ${SPURPLE}LEMP Edition${RESET} (${GREEN}Linux${RESET}, ${GREEN}Nginx${RESET}, ${GREEN}MySQL${RESET}, ${GREEN}PHP${RESET})\n\n"
    echo -e "[${LBLUE}${TIME}${RESET}] [${YELLOW}WARNING${RESET}] make sure you install the ${GREEN}MaeLEMP${RESET} on a clean server${reset}"

    if [ "$EUID" -ne 0 ]; then
        echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] oops! You must run this tools using root/superuser privileges."
    exit
    fi

}

checkOS_package() {

    echo -e "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] checking OS for Compability"
    if [[ ${OSTYPE} == "linux-gnu" ]]; then
        if [[ "$(cat /etc/os-release | grep PRETTY_NAME | cut -d '"' -f2 | awk '{print $1;}')" =~ ^(Ubuntu|Debian)$ ]]; then
            if command -v mariadb &> /dev/null; then
                echo -e "[${LBLUE}${TIME}${RESET}] [${LGREEN}INFO${RESET}] ${GREEN}MySQL${RESET} is already installed"
            else
                echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] ${RED}MySQL${RESET} is not installed, trying to install..."
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] updating repository ------->> "
                `sudo apt -qq -y update &> /dev/null` #Updating repository with silent options
                wait
                echo -e "[${GREEN}DONE${RESET}]"
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] installing MySQL ------->> "
                `sudo apt install mariadb-server mariadb-client -y -qq &> /dev/null`
                echo -e "[${GREEN}DONE${RESET}]"
                if [[ -z $(apt -qq list mariadb-server &> /dev/null) ]]; then
                    echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] failed to install MySQL (MariaDB), check manually required."
                fi
            fi
            if command -v nginx &> /dev/null; then
                echo -e "[${LBLUE}${TIME}${RESET}] [${LGREEN}INFO${RESET}] ${GREEN}Nginx${RESET} is already installed"
            else
                echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] ${RED}Nginx${RESET} is not installed, trying to install..."
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] updating repository ------->> "
                `sudo apt -qq -y update &> /dev/null` #Updating repository with silent options
                wait
                echo -e "[${GREEN}DONE${RESET}]"
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] installing Nginx ------->> "
                `sudo apt install nginx -y -qq &> /dev/null`
                echo -e "[${GREEN}DONE${RESET}]"
                if [[ -z $(apt -qq list Nginx &> /dev/null) ]]; then
                    echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] failed to install Nginx, check manually required."
                fi
            fi
            if command -v php &> /dev/null; then
                echo -e "[${LBLUE}${TIME}${RESET}] [${LGREEN}INFO${RESET}] ${GREEN}PHP${RESET} is already installed"
            else
                echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] ${RED}PHP${RESET} is not installed, trying to install..."
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] installing APT libraries ------->> "
                `sudo apt install lsb-release ca-certificates apt-transport-https software-properties-common -y -qq &> /dev/null`
                echo -e "[${GREEN}DONE${RESET}]"
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] adding ${GREEN}ppa:ondrej/php${RESET} to repository "
                `add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1`
                echo -e "[${GREEN}DONE${RESET}]"
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] updating repository ------->> "
                `sudo apt -qq -y update &> /dev/null` #Updating repository with silent options
                wait
                echo -e "[${GREEN}DONE${RESET}]"
                echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] installing PHP ------->> "
                `sudo apt install php-fpm php-mysql php-cli php-zip php-mbstring php-imap php-common php-redis php-xml -y -qq &> /dev/null`
                echo -e "[${GREEN}DONE${RESET}]"
                if [[ -z $(apt -qq list php 2>/dev/null) ]]; then
                    echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] failed to install PHP, check manually required."
                fi
            fi
                    
        else
            echo -e "[${LBLUE}${TIME}${RESET}] [${LRED}ERROR${RESET}] OS not compatible, Your Operating System is ${GREEN}${OSTYPE}${RESET}"
            echo -e "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] supported OS ${GREEN}Debian${RESET} or ${GREEN}Ubuntu${RESET} (linux-gnu)"
            exit
        fi
    else
        echo -e "[${LBLUE}${TIME}${RESET}] [${LRED}ERROR${RESET}] OS not compatible, Your Operating System is ${GREEN}${OSTYPE}${RESET}"
        echo -e "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] supported OS ${GREEN}Debian${RESET} or ${GREEN}Ubuntu${RESET} (linux-gnu)"
        exit
    fi

}

checkService(){

    echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] enabling Nginx service ------->> "
    `systemctl enable nginx &>/dev/null && systemctl restart nginx &>/dev/null`
    wait
    echo -e "[${GREEN}DONE${RESET}]"
    echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] Nginx service status ------->> "
    if [[ $(systemctl is-active nginx) == "active" ]]; then
        echo -e "[${GREEN}ACTIVE${RESET}]"
    else
        echo -e "[${LRED}ERROR${RESET}]"
        echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] failed to start Nginx, check manually required"
    fi
    echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] enabling MySQL (MariaDB) service ------->> "
    `systemctl enable mysql &>/dev/null && systemctl restart mysql &>/dev/null`
    wait
    echo -e "[${GREEN}DONE${RESET}]"
    echo -ne "[${LBLUE}${TIME}${RESET}] [${GREEN}INFO${RESET}] MySQL (MariaDB) service status ------->> "
    if [[ $(systemctl is-active mysql) == "active" ]]; then
        echo -e "[${GREEN}ACTIVE${RESET}]"
    else
        echo -e "[${LRED}ERROR${RESET}]"
        echo -e "[${LBLUE}${TIME}${RESET}] [${RED}ERROR${RESET}] failed to start MySQL (MariaDB), check manually required"
    fi

    echo "[*] ended at $(date)"
}


banner
checkPrivileges
checkOS_package
checkService
exit
