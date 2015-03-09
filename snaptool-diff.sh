#! /bin/bash
echo

if [ $# -lt 2 ]; then
    echo ">> please, specify two directory path"
    exit 1
fi

if [ -e ${1} ] && [ -d ${1} ]; then
    left=${1}
else
    echo ">> first directory has incorrect path"
    exit 1
fi

if [ -e ${2} ] && [ -d ${2} ]; then
    right=${2}
else
    echo ">> second directory has incorrect path"
    exit 1
fi

if [ ${left: -1}='/' ]; then
    left=${left}/
fi

if [ ${right: -1}='/' ]; then
    right=${right}/
fi

echo ">> early project state directory: ${left}"
echo ">> later project state directory: ${right}"

diff='diff -rN'
diffFiles=$(${diff} ${left} ${right} | grep "${diff}" | awk '{print $4}')

if [ ${#diffFiles[@]} -eq 0 ]; then
    echo ">> there is no difference in files"
else
    if [ $# -eq 3 ]; then
        outputDir=${3}
        if [ ${outputDir: -1}='/' ]; then
            outputDir=${outputDir}/
        fi
    else
        outputDir="$(pwd)/diff/"
    fi
    
    if [ -e ${outputDir} ]; then
        echo ">> recreating output directory: ${outputDir}"
        rm -rf ${outputDir}
    fi
    mkdir ${outputDir}
      
    echo ">> output directory: ${outputDir}"

    cp=0
    none=""
    for file in ${diffFiles[@]}; do
        relFile=${file/${right}/${none}}
        fileName=$(basename ${relFile})
        dirName=$(dirname ${relFile})
        
        if [ ${dirName}='.' ]; then
            mkdir -p ${outputDir}${dirName}
        fi
        
        targetDir="${outputDir}${dirName}/"
        if cp ${file} ${targetDir}; then
           echo "    ${file} -> ${targetDir}"
           ((cp=cp+1))
        fi        
    done;
    
    if [ $cp -eq 0 ]; then
        echo ">> no files was copied"
    else
        echo ">> copied files: $cp"
        
        cd ${outputDir}
        diffArch='diff.'$(date +"%m-%d-%y-%H.%M.%S")'.tar.gz'
        
        if tar -czf ${diffArch} *; then
            echo ">> differential archive created: ${diffArch}"
        fi
    fi
fi

