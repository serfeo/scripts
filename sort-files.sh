#! /bin/bash
echo
if [ $# -ne 0 ] && [ -e ${1} ]; then
    echo ">> directory for sorting: ${1}"
    cd ${1}
else
    echo ">> please specify the full path of directory"
    exit 1
fi    

dirs=("video" "audio" "pictures" "books" "archives" "jars" "utils" "torrents" "files")

videoExts="mp4"
audioExts="mp3,wav"
picturesExts="jpg"
booksExts="pdf,djvu"
archiveExts="zip"
jarsExts="jar"
utilsExts="tar.gz,deb,tgz"
torrentsExts="torrent"
filesExts="html,js,js.map,txt"
exts=(${videoExts} ${audioExts} ${picturesExts} ${booksExts} ${archiveExts} ${jarsExts} ${utilsExts} ${torrentsExts} ${filesExts})

echo 
echo ">> creating default directories..."
cr=0
for dir in ${dirs[@]}
do
    if [ ! -e ${dir} ]; then
        mkdir ${dir}
        echo "    ${dir}"
        ((cr=cr+1))
    fi
done
if [ ${cr} -eq 0 ]; then
    echo ">> done. all directories already created"
else
    echo ">> done. created ${cr} directories"
fi

echo
echo ">> moving files"
mv=0
for index in ${!dirs[@]}
do
    IFS=',' read -a c_exts <<< "${exts[${index}]}"
    for ext in ${c_exts[@]} 
    do
        for file in *.${ext}
        do
            if [ -e "${file}" ]; then
                if mv "${file}" ${dirs[${index}]}; then
                    echo "    ${file} -> ${dirs[${index}]}"
                    ((mv=mv+1))
                fi
            fi
        done
    done
done
if [ ${mv} -eq 0 ]; then
    echo ">> done. there are no new files"
else
    echo ">> done. Moved ${mv} files"
fi

