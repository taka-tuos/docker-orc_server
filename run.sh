#!/bin/sh
busybox httpd -p 23450 -h stat
wine orc_server.exe -sv 2345