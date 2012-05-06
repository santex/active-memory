#!/bin/bash -e

cd /home/hagen/myperl

getThem() {
for i in `ls -d ./ls . | grep -v tar.gz` ;
do 
cd $i
compile
cd ..
done
}


compile () {

if [ `ls Build` ]
then    # yes error(s) found, let send an email


rm ./Build     
perl Build.PL
./Build
sudo make install

else    # naa, everything looks okay
sudo make install

fi



}

getThem

