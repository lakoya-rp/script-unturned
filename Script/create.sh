#!/bin/bash

erreur1='Contactez Julien sur Github via ce lien : https://github.com/julien040/Unturned-Linux'

#Premier message de Bienvenue
echo -e "\e[91mBonjour, et bienvenue dans le script d'installation de serveur Linux sur Unturned."
echo ""
echo "Ce script est crée par le serveur LakoyaRP dans sa démarche d'aider la communauté Unturned"
echo ""
echo "Merci à Trojaner qui a aidé sur la partie RocketMod5, et qui permet donc que le script existe"
if [ -d "$PWD"/Unturned_Headless_Data ]
    then
    echo "Le serveur est déjà installé dans ce dossier, je vous invite donc à le mettre à jour"
    echo "Redirection vers le script de mise à jour dans 10s"
    sleep 10s
    
    ./update-server.sh
fi

if [[ $EUID -ne 0 ]]; then
   echo "Ce script doit être executé avec un utilisateur root" 1>&2
   sleep 2s
   exit 1
fi
clear
sleep 10s
echo "Vous allez être guidé pas à pas du début de l'installation jusqu'à la finalisation du serveur"
echo ""
echo "En cas de problème, merci de contacter Julien via https://github.com/julien040/Unturned-Linux"
echo ""
echo -e "\e[36mDans ce script, les indications seront en bleus, \e[32met les questions en verts"

#Attente afin de lire les messages
sleep 8s
clear
#Avertissement
echo -e "Vous allez répondre à une suite de questions afin de personnaliser le serveur."
echo ""
echo "Répondez y correctement afin de ne pas créer de bugs ; )"

#Attente afin de lire les messages
sleep 6s
clear
#Installation des dépendences ou non
echo "\e[36mChoisissez bien y ou n car le script pourrait être bloqué à cause de ça"
echo ""
echo -e "\e[32mQuestion :"
echo ""
read -p "Avez vous déjà installé un serveur Unturned sur cette machine ? (y ou n) :" yet

while [ -z "$yet" ] || [ "$yet" != 'y' ] || [ "$yet" != 'n' ]
do
        if [ "$yet" = "n" ]
            then
            break
        fi
        if [ "$yet" = "y" ]
            then
            break
        fi
        echo -e "\e[36mMauvaise syntaxe de la réponse (y ou n)"
        echo -e "\e[32m"
        echo ""
        read -p 'Merci de correctement répondre à la question' yet
done

#Mise à jour des dépendences et installation si possible
if [ "$yet" = "n" ]
    then 
    echo -e "\e[36mPuisque c'est la première installation d'un serveur Unturned, le script va installer les dépendences"
    apt-get update
    apt-get upgrade -y
    apt-get install -y unzip tar wget coreutils lib32gcc1 libgdiplus mono-complete screen
    echo ""
    echo "Dépendences installées"
    sleep 2s
elif [ "$yet" = "y" ]
    then
    echo -e "\e[36mMalgré que vous avez déjà installé Unturned sur cette machine, le script va mettre à jour les dépendences"
    apt-get update
    apt-get upgrade
    echo ""
    echo "Dépendences parfaitement mises à jour"
    sleep 2s
fi
clear
#Choix du dossier d'installation
echo -e "\e[36mChoisissez dans quel dossier installer le serveur Unturned ?(si aucun n'est indiqué, le serveur s'installera dans le dossier actuel "
echo -e "\e[32m"
echo ""
read -p "Indiquez le chemin complet du dossier sinon Unturned s'installera dans le dossier actuel :" folder
if [ -d "$folder" ]
    then
    echo -e "\e[36mLe serveur sera installé dans $folder"

else 
    mkdir "$folder"
    if [ -d "$folder" ]
        then
        echo -e "\e[36mLe script a réussi à créer le dossier. Le serveur sera donc installé dans $folder"
    else
        folder=$PWD
        echo -e  "\e[36mLe script n'a pas réussi à créer le dossier. Le script sera installé dans $PWD"
    fi
fi
#Choix du nom du serveur
clear
echo -e "\e[32m"
read -p "Comment voulez-vous nommer le serveur ? " nameserver
echo ""
echo -e "\e[36mDans le dossier /server , le serveur se nommera $nameserver"
sleep 2s

while [ -z "$nameserver" ]
do
        echo -e "\e[36mMauvaise syntaxe de la réponse"
        echo -e "\e[32m"
        echo ""
        read -p 'Merci de correctement répondre à la question' nameserver
done

#Choix obligatoire de RocketMod4 ou RocketMod5
clear
echo "(Attention : RocketMod 5 est instable pour le moment)"
echo -e "\e[32m"
echo ""
read -p "Souhaitez-vous un serveur sur RocketMod4 ou RockerMod5 (rm4 ou rm5) ?" servertype

while [ -z "$servertype" ] || [ "$servertype" != 'rm4' ] || [ "$servertype" != 'rm5' ]
do
        if [ "$servertype" = "rm4" ]
            then
            break
        fi
        if [ "$servertype" = "rm5" ]
            then
            break
        fi
        echo -e "\e[36mMauvaise syntaxe de la réponse (rm4 ou rm5)"
        echo -e "\e[32m"
        read -p 'Merci de correctement répondre à la question' servertype
done


#Réponse au choix de type de serveur
if [ "$servertype" = "rm4" ]
    then
    echo -e '\e[36mLe serveur sera sous RocketMod4'
elif [ "$servertype" = "rm5" ]
    then
    echo -e "\e[36mLe serveur sera sous RocketMod 5 (instable)"

else 
    echo -e "\e[36mErreur dans le script à la ligne 62."
    echo "$erreur1"
fi

#Début de l'installation
echo ""
echo -e "\e[36mLe script va installer Unturned dans le dossier $folder"
sleep 2s
echo ""
echo -e "\e[36mSuivant la vitesse de votre connexion internet, cela peut prend plus ou moins de temps"
echo ""
sleep 2s

cd "$folder"
#Téléchargement Steam
curl -s https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -vxz
chmod 777 ./steamcmd.sh
sleep 10s
echo "Téléchargement de Steam..."
./steamcmd.sh +login anonymous +force_install_dir "$folder" +app_update 1110390 +@sSteamCmdForcePlatformBitness 64 validate +exit

#Vérification du téléchargement de Steam
if [ -d "$folder"/Unturned_Headless_Data ]
    then
    echo -e "\e[36mSteam vient de finir de télécharger Unturned !"
    echo "Le script va maintenant installer RocketMod !"
    cp -f $folder/linux64/steamclient.so $folder/Unturned_Headless_Data/Plugins/x86_64/steamclient.so
    cd "$folder" || exit
    cp linux32/steamclient.so /lib
    cp linux64/steamclient.so /lib64

else
    echo "Le script n'a pas pu télécharger Unturned"
    echo "$erreur1"
    sleep 6s
    exit
fi

sleep 5s
cd "$folder"
wget https://raw.githubusercontent.com/julien040/Unturned-Linux/master/Script/run-rm5.sh
chmod 777 rum-rm5.sh

wget https://raw.githubusercontent.com/julien040/Unturned-Linux/master/Script/update-server.sh
chmod 777 update-server.sh
clear
#Installation de Rocket
if [ "$servertype" = "rm4" ]
    then
    wget https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip
    unzip Rocket.zip
    mv $folder/Scripts/Linux/* /$folder/
    rm -r $folder/Scripts/Linux
    rm -r $folder/Scripts/Windows
    rm Rocket.zip
    chmod 755 start.sh
    chmod 755 update.sh
    echo -e "\e[36mRocketMod 4 vient d'être installé"
    sleep 3s

elif [ "$servertype" = "rm5" ]
    then
    wget https://ci.appveyor.com/api/buildjobs/bjt7acowdq73nh4u/artifacts/Rocket.Unturned-5.0.0.237.zip
    unzip Rocket.Unturned-5.0.0.237.zip
    mv $folder/Rocket.Unturned/ $folder/Modules/
    rm README.md
    rm Rocket.Unturned-5.0.0.237.zip
    echo -r "\e[36mRocketMod 5 a été installé"
    sleep 3s

else 
    echo -r "\e[36mUne erreur s'est produite. Impossible d'installer RocketMod"
    echo "$erreur1"

fi

#Démarrage du serveur
clear
cd "$folder"
if [ "$servertype" = "rm4" ]
    then
    echo -e "\e[36mDémarrage du serveur"
    echo "Désormais, pour démarrer le serveur, faites start.sh nomduserveur"
    sleep 4s
    ./start.sh "$nameserver"
    exit 0

elif [ "$servertype" = "rm5" ]
    then
    echo -e "\e[36mDémarrage du serveur"
    echo "Désormais, pour démarrer le serveur, faites run-rm5 nomduserveur"
    sleep 4s
    ./run-rm5.sh "$nameserver"
    exit 0
fi
exit