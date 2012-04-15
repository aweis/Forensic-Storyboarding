#!/bin/bash

echo 'Welcome to the Storyboarding lab'
echo 'by Adam Weis and Tim Vaughan'

echo 'please enter the path to your video'

read VIDEO_FILE

if [ -f ${VIDEO_FILE} ]
then
  echo "The file you want to analyze: ${VIDEO_FILE}"
  #ffmpeg script from kesden
  ffmpeg -g 600 -i ${VIDEO_FILE} tmpvideo.mpeg

  #mplayer to grab the keyframes
  mplayer -vo jpeg:outdir=frames -vf framestep=I -frames 100 tmpvideo.mpeg

  #clean up tmpvideo.mpeg
  rm tmpvideo.mpeg
  
else
  echo 'bad input'
fi

