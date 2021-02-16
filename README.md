# Timelapse
Bash shell scripts to capture and process frames from an IP camera to generate a timelapse video.

## Dependencies
- The capture script requires ffmpeg.
- The generate script requires mencoder.

## Usage
When called, the capture script prompts for details of the capture you want to run, before capturing frames from the camera as JPG files. 

- Period: Time between frame captures. It is assumed that the capture process takes about 2 seconds, as such there's an enforced minimum period value of 2.
- Duration: Capture duration in hours, leave empty to switch to entering the duration in minutes.
- Directory: Name of directory to capture frames to. Leave empty to name the directory based on the capture start time.
- Start: The time (hh:mm) to start the capture in the next 24 hours. Leave empty to start the capture immediately.

The generate script generates an AVI video from all the JPG images captured in a directory.
- It is called with a single parameter which is the name of a subdirectory containing the JPG files to process.
- It assumes the files are names in a chrological order (the default from the capture script).
- The script will generate an avi file in the current directory, named after the directory containing the JPG files, with an ".avi" suffix.

## Testing and Robustness
- These scripts are not especially robust and entering invalid values is likely to result 'undefined' behaviour.
- I have tested the capture script with an RTSP stream from a TP-Link C200 Tapo camera (a rather cheap '1080p' IP camera).
