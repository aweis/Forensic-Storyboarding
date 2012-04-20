#!/bin/bash

#http://ffmpeg.org/pipermail/ffmpeg-user/2012-HTML_FILEebruary/005279.html
#ffmpeg -vf select="eq(pict_type\,PICT_TYPE_I)" -i MELT.MP4 -vsync 2 -s 73x41 -f image2 thumbnails-%02d.jpeg

if [ $# == 0 ] then
  echo "Usage: ${0} <filename>"
else if [ ! -f ${1} ] then
  echo "Usage: ${0} <filename>"
else

#convert to mp4 for display purposes
ffmpeg -i ${1} -sameq display.mp4

#remove anything in the frames directory
rm ./frames/*

TIME_CODE_FILE="keyframe-timecodes.txt"

ffmpeg -vf select="eq(pict_type\,PICT_TYPE_I)" -i ${1} -vsync 2 -s 73x41 -f image2 ./frames/thumbnails-%d.jpeg -loglevel debug 2>&1 | grep "pict_type:I -> select:1" | cut -d " " -f 6 - > ${TIME_CODE_FILE} 

HTML_FILE="site.html"

#Header HTML information
echo '<!DOCTYPE html>' > ${HTML_FILE}
echo '<html lang="en">' >> ${HTML_FILE}
echo '<head>' >> ${HTML_FILE}
echo '<meta charset="utf-8" />' >> ${HTML_FILE}
echo '<title>Video Analysis</title>' >> ${HTML_FILE}

echo '<link rel="stylesheet" href="stylesheets/normalize.css">' >> ${HTML_FILE}
echo '<link rel="stylesheet" href="stylesheets/style.css">' >> ${HTML_FILE}

echo '</head>' >> ${HTML_FILE}

echo '<body>' >> ${HTML_FILE}
echo '<div id="wrapper">' >> ${HTML_FILE}

echo '<h1>Video Storyboard</h1>' >> ${HTML_FILE}

echo '<div id="vid_wrapper">' >> ${HTML_FILE}
echo '<video id="vid" preload controls="controls">' >> ${HTML_FILE}
echo "<source src=\"display.mp4\" type=\"video/mp4\" />" >> ${HTML_FILE}
echo 'Your browser does not support the video tag.' >> ${HTML_FILE}
echo '</video>' >> ${HTML_FILE}


echo '<script type="text/javascript">' >> ${HTML_FILE}
echo 'var myvid = document.getElementById("vid");' >> ${HTML_FILE}
echo 'myvid.load();' >> ${HTML_FILE}
echo '</script>' >> ${HTML_FILE}



echo '<ul class="images">' >> ${HTML_FILE}
#Count for grabbing the images from the frames directory
Count=1
cat ${TIME_CODE_FILE} |
while read line
do
  T=`echo ${line} | cut -b 3-`
  echo "<li><figure><a onclick=\"myvid.currentTime=${T};\" href=\"#\"><img src=\"frames/thumbnails-${Count}.jpeg\" /></a></figure></li>" >> ${HTML_FILE}
  Count=`expr ${Count} + 1`
done
echo '</ul>' >> ${HTML_FILE}
echo '</div>' >> ${HTML_FILE}
echo '</div>' >> ${HTML_FILE}

echo '</body>' >> ${HTML_FILE}
echo '</html>' >> ${HTML_FILE}

rm ${TIME_CODE_FILE}
fi
fi
