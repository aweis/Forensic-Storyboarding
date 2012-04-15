#!/bin/bash

echo 'Welcome to the Storyboarding lab'
echo 'by Adam Weis and Tim Vaughan'

echo 'please enter the path to your video'

read VIDEO_FILE

if [ -f ${VIDEO_FILE} ]
then
  echo $VIDEO_FILE
else
  echo 'bad input'
fi

