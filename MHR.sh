#!/bin/sh

function tellUsage () {
	printf "\nUsage: ./MHR.sh server_jar_path [delay_after_server_start] [death_message_interval]\n\n"
}
if [ "$1" == "help" ]; then
	tellUsage
	exit 0
fi

function notice () {
	printf "> $1"
}
function blankline () {
	printf "\n"
}

function announcement () {
	screen -S Minecraft -p 0 -X stuff "`printf "say $1\r"`"
}

function getPlayers () {
	local playerCount=`ls world/players | wc -w | xargs`
	echo "$playerCount"
}

function getDeadPlayers () {
	local playerCount=`cat banned-players.txt | wc -l`
	local playerCount=$((playerCount - 3)) 
	echo "$playerCount"
}

minecraftJarPath=$1
if [[ -z "$1" ]]; then
	tellUsage
	exit 0
fi

startDelay=$2
if [[ -z "$2" ]]; then
	startDelay=10
fi

messageDelay=$s3
if [[ -z "$3" ]]; then
	messageDelay=60
fi

secPerTick=3


clear
printf "\nMinecraftHardcoreReset 1.0 by David da Silva Contín\n\n"

printf "Config:\n"
sleep 1
notice "mineserver jar path: $minecraftJarPath\n"
sleep 1
notice "server start delay: $startDelay\n"
sleep 1
notice "message delay: $messageDelay s\n\n"
sleep 2

if ! screen -list | grep -q "Minecraft"; then
	notice "Starting Minecraft server...\n"
    screen -S Minecraft -d -m java -Xmx1024M -Xms1024M -jar $minecraftJarPath nogui
    sleep $startDelay
fi
notice "Server found!\n\n"

sleep 5

function resetServer () {
	notice "Resetting Minecraft Hardcore server...\n\n"
	screen -S Minecraft -p 0 -X stuff "`printf "stop\r"`"
	sleep 1
	rm -rf world
	rm banned-players.txt
	screen -S Minecraft -d -m java -Xmx1024M -Xms1024M -jar $minecraftJarPath nogui
	notice "Server restarting...\n\n"
	sleep $startDelay
}

timer=0

function statusCheck () {

	if [ ! -e world/players ]; then 
		resetServer
	fi
	if [ ! -e banned-players.txt ]; then 
		resetServer
	fi
	
	players=`getPlayers`
	deadPlayers=`getDeadPlayers`

	clear
	printf "\nMinecraftHardcoreReset 1.0 by David da Silva Contín\n\n"
	printf "Config:\n"
	notice "mineserver jar path: $minecraftJarPath\n"
	notice "server start delay: $startDelay\n"
	notice "message delay: $messageDelay s\n\n"
	notice "Players in world: "
	printf "$players\n"
	notice "Dead Players in world: "
	printf "$deadPlayers\n"
	notice "Counter: $timer s\n\n"

	timer=$(($timer + $secPerTick))

	if [ "$timer" -ge "$messageDelay" ]; then
		timer=$(($timer - $messageDelay))
		announcement "Dead Players: $deadPlayers/$players"
	fi

	if [ "$deadPlayers" -ge "$players" ] && [ "$players" -gt 0 ]; then
		announcement "Everyone is dead! wololo"
		sleep 2
		resetServer
	fi

	sleep $secPerTick
	statusCheck
}

statusCheck