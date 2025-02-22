#!/bin/sh
busybox httpd -p 23450 -h stat
taskset -c 1 wine orc_server.exe -sv 2345