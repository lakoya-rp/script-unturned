#!/bin/bash
#Message de bievenue
erreur1=`Contactez Julien sur Github via ce lien : https://github.com/julien040/Unturned-Linux`
echo "Bienvenue dans le script de mise à jour d'unturned"
echo "Le script va vérifier si le jeu se situe bien dans ce dossier"
sleep 2s

if [ -d $PWD/Unturned_Headless_Data ]
    then
    echo "Unturned est bien dans ce dossier, le script va continuer..."
    sleep 1s
else
    echo "Le script de mise à jour doit être lancé depuis le dossier du jeu"
    echo "Le script va donc se fermer dans 10s"
    sleep 10s
    exit 0
fi

#Demande version de RocketMod
echo "Merci d'indiquer si vous utilisez RocketMod 4 ou RocketMod 5"
read -p "(rm4 ou rm5)" servertype


if [ "$servertype" = "rm4" ]
    then
    wget https://ci.rocketmod.net/job/Rocket.Unturned/lastSuccessfulBuild/artifact/Rocket.Unturned/bin/Release/Rocket.zip
    unzip Rocket.zip
    mv $PWD/Scripts/Linux/* /$PWD/
    rm -r $PWD/Scripts/Linux
    rm -r $PWD/Scripts/Windows
    rm Rocket.zip
    echo "RocketMod 4 a été mis à jour"
    sleep 2s

elif [ "$servertype" = "rm5" ]
    then
    wget https://ci.appveyor.com/api/buildjobs/bjt7acowdq73nh4u/artifacts/Rocket.Unturned-5.0.0.237.zip
    unzip Rocket.Unturned-5.0.0.237.zip
    mv $PWD/Rocket.Unturned/ $PWD/Modules/
    rm README.md
    rm Rocket.Unturned-5.0.0.237.zip
    echo "RocketMod 5 a été mis à jour"
    sleep 2s

else
    echo "Une erreur s'est produite dans la mise à jour de RocketMod"
    echo "Impossible d'identifier la version de Rocketmod"
    echo "$erreur1"
    echo "Le script va être quitté dans 15s"
    sleep 15s
    exit
fi

#Mise à jour du jeu via Steam
echo "Le script va maintenant mettre à jour Unturned via Steam"
sleep 2s
echo "Suivant la vitesse de votre connexion internet, cela peut prend plus ou moins de temps"
sleep 2s
steamcmd +login anonymous +force_install_dir $PWD +app_update 1110390 validate +exit

echo "La mise à jour s'est déroulée comme prévu"
echo "Je vous invite donc à démarrer votre serveur"
sleep 3s

#Message
if [ "$servertype" = "rm4" ]
    then
    echo "Utiliser ./start.sh pour lancer le serveur"
elif [ "$servertype" = "rm5" ]
    then
    echo "Utiliser ./run-rm5 pour lancer le serveur"

echo "Le script va s'éteindre dans 5s"
sleep 5s
exit 0 