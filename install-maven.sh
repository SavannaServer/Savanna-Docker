#!/bin/bash
set -x 

declare -r apacheMavenDownloadUrl="https://dlcdn.apache.org/maven/maven-3/3.8.7/binaries/apache-maven-3.8.7-bin.tar.gz"
declare -r directoryName="mvn/"

if [[ $apacheMavenDownloadUrl =~ ([^/]+)\-bin\.tar\.gz$ ]]
then
    declare -r resultFileName=$BASH_REMATCH
    declare -r resultDirectoryName=${BASH_REMATCH[1]}
else
    printf "\nIncorrcet format of Apache Maven download url!\n"
    exit 1
fi

mkdir $directoryName
cd $directoryName

wget $apacheMavenDownloadUrl
tar -zxf $resultFileName
declare -r workingDir=$(pwd)

sudo ln -s "$workingDir/$resultDirectoryName/bin/mvn" /bin/mvn
rm -v $resultFileName

printf "\nMaven 3 is installed!\n"
