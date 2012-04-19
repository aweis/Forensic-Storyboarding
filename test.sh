#!/bin/bash

#http://ffmpeg.org/pipermail/ffmpeg-user/2012-February/005279.html

#ffmpeg -vf select="eq(pict_type\,PICT_TYPE_I)" -i MELT.MP4 -vsync 2 -s 73x41 -f image2 thumbnails-%02d.jpeg

timeCodes="keyframe-timecodes.txt"

ffmpeg -vf select="eq(pict_type\,PICT_TYPE_I)" -i ${1} -vsync 2 -s 73x41 -f image2 ./frames/thumbnails-%d.jpeg -loglevel debug 2>&1 | grep "pict_type:I -> select:1" | cut -d " " -f 6 - > ${timeCodes} 

F="site.html"

echo '<html>' > ${F}
echo '<head>' >> ${F}
echo '<title>Sample site</title>' >> ${F}

echo '</head>' >> ${F}

echo  '<body>' >> ${F}

echo '<h1> Hello World</h1>' >> ${F}
echo '<video id="vid" width="320" height="240" preload controls="controls">' >> ${F}
echo "<source src=\"${1}\" type=\"video/mp4\" />" >> ${F}
echo 'Your browser does not support the video tag.' >> ${F}
echo '</video>' >> ${F}

echo '<script type="text/javascript">' >> ${F}
echo 'var myvid = document.getElementById("vid");' >> ${F}
echo 'myvid.load();' >> ${F}
echo '</script>' >> ${F}


echo '</body>' >> ${F}

Count=1
cat ${timeCodes} |
while read line
do
  T=`echo ${line} | cut -b 3-`
  echo "<br /><a onclick=\"myvid.currentTime=${T};\" href=\"#\"><img src=\"frames/thumbnails-${Count}.jpeg\" /></a>" >> ${F}
  Count=`expr ${Count} + 1`
done


echo '</html>' >> ${F}

rm ${timeCodes}

