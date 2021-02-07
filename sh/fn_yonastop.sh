#!/bin/bash

rm -rf /usr/yona/RUNNING_PID
pid=`ps -ef | grep java | grep com.typesafe.play | awk '{print $2}'`
kill $pid

echo '[INFO] yona is stop...'