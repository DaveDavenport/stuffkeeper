#!/bin/bash

VERSION=`cat wscript | sed  -e '/^VERSION.*/!d;' -e "s/^VERSION=//g;s/'//g"`

if [ -z "$VERSION" ]
then
    echo "No version found.";
    exit;
fi

mkdir release/

cd release
git clone git://git.sarine.nl/stuffkeeper
cd stuffkeeper
git checkout -b $VERSION
cd src/
for a in *.gob;
do
    gob2 $a
done
rm *.gob
cd ../
./configure
make dist
cp *.tar.bz2 ../
cd ../
rm -rf stuffkeeper
cd ../
