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
  
  HTML_FILE="output.html"

  echo "<html>" > ${HTML_FILE}
  echo "<head>" >> ${HTML_FILE}
  echo "<title>Key Frames</title>" >> ${HTML_FILE}
  echo "</head>" >> ${HTML_FILE}
  
  echo "<body>" >> ${HTML_FILE}
  echo "<h1>The keyframes</h1>" >> ${HTML_FILE}

  #echo "<ul style=\"list-style-type: none; margin: 0; padding: 0;\">" >> ${HTML_FILE}
  echo "<table style=\"border: 1px solid black;\">" >> ${HTML_FILE} 
  #loop through the files
  for file in ./frames/*
  do
    echo "<tr><td style=\"border: 1px solid black;\"><img src=\"${file}\" /></td></tr>" >> ${HTML_FILE}
  done
  echo "</table>" >> ${HTML_FILE}

  echo "</body>" >> ${HTML_FILE}
  echo "</html>" >> ${HTML_FILE}

else
  echo 'bad input'
fi

