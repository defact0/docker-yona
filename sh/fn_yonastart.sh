#!/bin/bash

rm -rf /usr/yona/RUNNING_PID
PORT=9000
YONA_DATA=/usr/yona;export YONA_DATA
JAVA_OPTS="-Xmx2048m -Xms1024m -Dyona.data=$YONA_DATA -DapplyEvolutions.default=true -Dhttp.port=$PORT" /usr/yona/bin/yona

echo '[INFO] yona is start...'