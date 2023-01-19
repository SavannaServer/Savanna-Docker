#!/bin/sh

mkdir -p $PWD/purpur/
cd $PWD/purpur/

if [ ! -f server.jar ] || [ "$UPDATE" = "true" ]; then
    echo "> downloading latest $VERSION server jar..."
    rm -f server.jar
    wget -q https://api.purpurmc.org/v2/purpur/$VERSION/latest/download -O server.jar
    echo "> done."
fi

if [ ! -d plugins ]; then
    mkdir plugins
fi

if [ ! -f plugins/SavannaCore.jar ]; then
    echo "> Cloning latest SavannaCore plugin..."
    git clone https://github.com/RamuneRemonedo/SavannaCore temp-SavannaCore-cloned
    cd temp-SavannaCore-cloned
    echo "> Packaging SavannaCore plugin..."
    mvn package
    cd ..
    echo "> Movig plugin to plugins..."
    mv temp-SavannaCore-cloned/target/SavannaCore*.jar plugins/SavannaCore.jar
    rm -r temp-SavannaCore-cloned
    echo "> done."
fi

if [ "$EULA" = "true" ]; then
    echo "eula=true" > eula.txt
fi

if [ -z $MEMORY ]; then
    MEMORY=1G
fi

PURPUR="java -server -Xms$MEMORY -Xmx$MEMORY -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true --add-modules=jdk.incubator.vector -jar server.jar --nogui"
if [ ! -z $UID ] || [ ! -z $GID ]; then
    echo "> setting up permissions..."
    caps="-cap_$(seq -s ","-cap_ 0 $(cat /proc/sys/kernel/cap_last_cap))"
    SETPRIV="setpriv --clear-groups --inh-caps=$caps"
    if [ ! -z $UID ]; then
        SETPRIV="$SETPRIV --reuid=$UID"
        chown -R "$UID" "$PWD"
    fi
    if [ ! -z $GID ]; then
        SETPRIV="$SETPRIV --regid=$GID"
        chown -R ":$GID" "$PWD"
    fi
  PURPUR="$SETPRIV $PURPUR"
  echo "> done."
fi

echo "> starting purpurmc server v$VERSION ..."
$PURPUR
