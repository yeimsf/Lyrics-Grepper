#!/bin/bash

# Avalanche Lyrics Grepper
# Author: Youssef Fakhry
# github: https://github.com/yeimsf

clean_search_item() {
    local cleanup_tokens=(demo live acoustic remix bonus topic vevo video official Demo Live Acoustic Remix Bonus Topic VEVO Video Official)
}

helpDoc="Help :::\n----- AVALANCHE Lyrics Finder -----\n-u <URL> | specifies a url\n-p || --mode-playlist | specifies whether to find lyrics for a playlist of songs\n-s || --mode-single | specifies whether to find lyrics for a single song\n"

Str_Array=($(echo $@ | tr '\b' '\n'))
numOptions=$#

if [ "${1}" = '-h' ]
then
    echo -e "$helpDoc"
    exit
else
    for (( counter=0; counter<${numOptions}; counter++))
    do
        bina=`expr $counter % 2`
        if [ $bina -eq 0 -a ${Str_Array[counter]} = '-u' ]
        then
            url=${Str_Array[counter + 1]}
            vidid=${url:17:11}
            jsonResVidTitle=$(curl -G -s https://www.googleapis.com/youtube/v3/videos -d part=snippet -d key="AIzaSyDagL3KHQTkMiDHfrz2i4Fyl_iqua2le3A" -d id="$vidid" | grep -m 1 'title')
            jsonResChanTitle=$(curl -G -s https://www.googleapis.com/youtube/v3/videos -d part=snippet -d key="AIzaSyDagL3KHQTkMiDHfrz2i4Fyl_iqua2le3A" -d id="$vidid" | grep -m 1 'channelTitle')
            vidtitlen=`expr length "$jsonResVidTitle" - 20`
            chantitlen=`expr length "$jsonResChanTitle" - 27`
            song=${jsonResVidTitle:18:$vidtitlen}
            artist=${jsonResChanTitle:25:$chantitlen}
            artist=$(echo $artist | tr '[:upper:]' '[:lower:]' | sed -e 's/([^()]*)//g' | sed -e 's/[[^[]]*]//g' | sed -e 's/vevo//g' | sed -e 's/video//g' | sed -e 's/remix//g' | sed -e 's/vevo//g' | sed -e 's/topic//g')
            song=$(echo $song | tr '[:upper:]' '[:lower:]' | sed -e 's/([^()]*)//g' | sed -e 's/[[^[]]*]//g' | sed -e 's/vevo//g' | sed -e 's/video//g' | sed -e 's/remix//g' | sed -e 's/vevo//g' | sed -e 's/topic//g')
            echo $artist
            echo $song
            exit
        else
            echo -e "Invalid argument - See help page '-h'"
            exit
        fi
    done
fi
