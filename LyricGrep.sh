#!/bin/bash

# Avalanche Lyrics Grepper
# Author: Youssef Fakhry
# github: https://github.com/yeimsf

rm_extra_spaces() {
    echo $@ | sed 's/^[[:space:]]*//; s/[[:space:]] *$//;
                   #s/[[:space:]][[:space:]]*/ /g'
}

clean_search_item() {
    local cleanup_tokens=(demo live acoustic remix bonus topic vevo video official)
    local item=$@
    rm_extra_spaces $item
    item=${item//[.,?!\/\']/}        # remove special chars
    item=${item:l}                   # lowercase
    for token in $cleanup_tokens; do # remove tokens
        echo ${item/\{$token\}/}
    done
}

helpDoc="Help :::\n----- AVALANCHE Lyrics Finder -----\n-u <URL> | specifies a url\n-p || --mode-playlist | specifies whether to find lyrics for a playlist of songs\n-s || --mode-single | specifies whether to find lyrics for a single song\n"

mode=0
url=""
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
            #artist=$(echo $jsonResChanTitle | tr ' ' '-')
            #song=$(echo $jsonResVidTitle | tr ' ' '-')
            artist=$(clean_search_item $artist) 
            song=$(clean_search_item $song)
            echo $artist
            echo $song
            #channtitle=$(echo $jsonRes 2>&1 | grep 'channelTitle')
            #echo -e "$vidtitle\n$channtitle"
            #echo $(curl https://www.googleapis.com/youtube/v3/videos?key=AIzaSyDagL3KHQTkMiDHfrz2i4Fyl_iqua2le3A&part=snippet&id=$vidid)
            #echo $(title=wget -qO- ${url} |  perl -l -0777 -ne 'print $1 if /<title.*?>\s*(.*?)(?: - youtube)?\s*<\/title/si')
            exit
        else
            echo -e "Invalid argument - See help page '-h'"
            exit
        fi
    done
fi
