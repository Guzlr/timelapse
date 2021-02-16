#!/bin/bash
#set -x

# Set URL to point at camera, e.g:
URL="rtsp://<username>:<password>@<ip address>/<stream>"

echo "================================================================================"
echo "===                        Timelapse capture script                          ==="
echo "================================================================================"

# Get capture period
read -p "Capture period in seconds (minimum 2): " PERIOD
if [ "$PERIOD" == "" ] || [ "$PERIOD" -lt "2" ]; then
    echo "You must specify a capture period of at least 2 seconds"
    exit 1
fi

# Get capture duration
read -p "Capture duration in hours (return for minutes): " DURATION
if [ "$DURATION" == "" ]; then
    read -p "Capture duration in minutes: " DURATION
    let "DURATION  = $DURATION * 60"
else
    let "DURATION  = $DURATION * 60 * 60"
fi

# Calculate total number of frames to be captured
declare -i FRAMES=$DURATION/$PERIOD

# Get and create the capture directory
find . -maxdepth 1 -type d
read -p "Capture directory (enter for auto): " OUTDIR

# Get capture start time (in the next 24 hours)
declare -i USTART=0
read -p "Capture start time (hh:mm) in next 24hrs, empty=now: " START

# Empty start time means 'now'
if [ "$START" == "" ]; then
    USTART=$(date +"%s")
else
    USTART=$(date --date="${START}" +"%s")
    # If start time is in the past, add 24 hours (in seconds)
    if [ $USTART -lt $(date +"%s") ]; then
        let "USTART = $USTART + 86400"
    fi
fi

if [ "$OUTDIR" == "" ]; then
   OUTDIR=`date -d @$USTART +"%Y-%m-%d_%H-%M-%S"`
fi
mkdir -p $OUTDIR

echo "================================================================================"
echo Starting capture at: $(date -d @$USTART +"%Y-%m-%d %H:%M:%S")
echo Capturing a frame every $PERIOD seconds for $DURATION seconds
echo Capturing $FRAMES frames in total in directory $OUTDIR
echo "================================================================================"

# Wait for start time
if [ $(date +"%s") -lt $USTART ]; then
    let "SLEEP = $USTART - $(date +"%s")"
    echo Waiting to start capture at $(date -d @$USTART +"%H:%M:%S")...
    sleep $SLEEP
fi

# Start capture loop
while [ $FRAMES -gt 0 ]
do
    OUTFILE=$OUTDIR/`date +"img-%Y-%m-%d_%H-%M-%S.jpg"`
    echo "$FRAMES: $OUTFILE"
    ffmpeg -loglevel fatal -rtsp_transport tcp -i "$URL" -r 1 -vframes 1 $OUTFILE
    FRAMES=$[$FRAMES-1]
    # Reduce sleep by 2 secs (assuming capture takes about 2 secs)
    sleep $[$PERIOD-2]
done
