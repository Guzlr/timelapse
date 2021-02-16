#! /bin/bash

FPS=10

if [ "$1" == "" ]; then
  echo "Usage: $0 <directory containing jpgs>"
  exit 1
fi

DIR=${@%/}

if [ -d $DIR ]; then
   pushd $DIR
   rm -f files.txt
   ls -1tr *.jpg | grep -v files.txt > files.txt
   mencoder -nosound -noskip -oac copy -ovc copy -o ../$DIR.avi -mf fps=$FPS 'mf://@files.txt'
   popd
fi
