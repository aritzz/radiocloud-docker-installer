#!/bin/bash
APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=yes
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e '\033[0;31m \t\t┌────────────────────────────┐
\t\t│▛▀▖     ▌▗    ▞▀▖▜         ▌│
\t\t│▙▄▘▝▀▖▞▀▌▄ ▞▀▖▌  ▐ ▞▀▖▌ ▌▞▀▌│
\t\t│▌▚ ▞▀▌▌ ▌▐ ▌ ▌▌ ▖▐ ▌ ▌▌ ▌▌ ▌│
\t\t│▘ ▘▝▀▘▝▀▘▀▘▝▀ ▝▀  ▘▝▀ ▝▀▘▝▀▘│
\t\t└────────────────────────────┘'

echo -e '\n'
sleep 1
echo -e '\033[0;35m\t      *** Irrati-automatizazio sistema ***\n'
sleep 1
echo -e '\033[0mOngi etorri instalatzaile automatizatura. Instalazio hau Docker birtualizazioa erabiliz egingo da.'
echo -e 'Zure sisteman bakarrik beharrezkoak diren aplikazioak instalatuko dira Docker martxan jartzeko.'
echo -e '\nInstalatzaile honek ez du inongo bermerik, eta edozein akats eman dezake. \nGaratzailea ez da arduratzen honek sor ditzakeen datu-galera edo bestelako arazoez'
read -p "Ados al zaude honekin? (B/E) " -n 1 -r
if [[ $REPLY =~ ^[Ee]$ ]]
then
	echo -e "\nInstalaziotik irtetzen.\n"
	exit
fi

echo 'Instalazioaren hasiera' > instalazioa.log

####### DOCKER INSTALAZIOA
echo -e "\n\n\033[1;32m*** Dockerren instalazioa"
echo -e "\033[0mDocker instalatuko dugu jarraian. Zure pasahitza eskatuko dizu root gisa instalatzeko."
sudo apt-get remove docker docker-engine docker.io >> instalazioa.log
sudo apt-get update >> instalazioa.log
sudo apt-get install \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     wget \
     software-properties-common -y >> instalazioa.log
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -  >/dev/null 2>/dev/null
sudo apt-key fingerprint 0EBFCD88  >/dev/null 2>/dev/null
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"  >> instalazioa.log
sudo apt-get update  >> instalazioa.log
sudo apt-get install docker-ce -y >> instalazioa.log
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose -# >> instalazioa.log
sudo chmod +x  /usr/local/bin/docker-compose
if hash docker 2>/dev/null; then
    echo -e "\t\t\t\t\t\t\t\\t\033[0;31m INSTALATUTA"
else
    echo "Ezin izan da instalatu, begiratu instalazioa.log fitxategia"
    exit
fi


########## MAKINEN PRESTAKETA
zone='Europe/Madrid'
echo -e "\n\n\033[1;32m*** Ingurunearen prestaketa"
echo -e "\033[0mSoftwarea instalatzeko ingurunea prestatuko dugu. Hainbat galdera egingo zaizkizu."
#read -p "> Zein da zure ordu-zona? (timezone, Espainiarako jarri 'Europe/Madrid') " zone
#if [ -z "$zone" ]
#then
#	echo "  Ez da aukerarik eman, Europe/Madrid esleitzen"
#	zone='Europe/Madrid'
#fi

read -p "> RadioCore erreproduktorea instalatu nahi duzu? (B/E) " -n 1 -r
if [[ $REPLY =~ ^[Ee]$ ]]
then
	echo -e "\nInstalazioa erreproduktore gabe egingo da.\n"
        composer_file='composer_gabe.yml'
else 
	echo -e "\nInstalazio osoa egingo da, erreproduktorea barne.\n"
        composer_file='composer_osoa.yml'
fi
pasahitza=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 14`
sed -i -e "s/example/$pasahitza/g" $composer_file
sed -i -e "s/example/$pasahitza/g" core/Dockerfile
sed -i -e "s/example/$pasahitza/g" daemon/Dockerfile

########## MAKINEN INSTALAZIOA

echo -e "\n\n\033[1;32m*** Softwarearen instalazioa"
echo -e "\033[0mSoftwarea instalatuko da jarraian. Itxaron minutu batzuk."
sleep 1
echo -e "- Direktorioak prestatzen"
sleep 1
sudo mkdir -p /opt/radiocloud
echo -e "- RadioCloud deskargatzen eta despaketatzen"
wget https://github.com/aritzz/radiocloud/archive/1.2.tar.gz -O web.tar.gz -q
sudo tar -zxf web.tar.gz -C /opt/radiocloud/
sudo mv /opt/radiocloud/radiocloud-1.2 /opt/radiocloud/web 
sudo mkdir -p /opt/radiocloud/emisioa/defektuzkoa
sleep 1
echo -e "- Docker edukiontziak abiarazten compose bidez"
cp $composer_file docker-compose.yml
sudo docker-compose up -d
sudo docker-compose run web chown -R www-data:www-data /var/www/html

echo -e "\n\n\033[1;32m*** INSTALAZIOAREN BUKAERA"
echo -e "\033[0mInstalazioa bukatuta dago. Hona hemen beharrezko datuak, apunta itzazu nonbait.\n"
echo -e "\033[0;37m== Datubaserako sarrera PHPMYADMIN bidez"
echo -e "\033[0mErabiltzailea: root"
echo -e "Pasahitza: $pasahitza"
echo -e "Helbidea: http://localhost:8080"
echo -e "\033[0;37m== RadioCloud web bidezko interfazera sarrera"
echo -e "\033[0mErabili datu hauek konfigurazioa gauzatzeko"
echo -e "Helbidea: http://localhost"
echo -e "Datubasearen helbidea: mysql"
rm web.tar.gz

