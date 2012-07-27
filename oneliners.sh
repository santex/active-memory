#!/usr/bin/bash
#Microstructures on the Terminal
count=0; 

#SHOW 1 RANDOM NODE
micro; echo "(returns a random node)";


#SHOW 10 RANDOM NODES
micro any 10; echo "(returns 10 random node)";

#SHOW 8 RANDOM PLANETS
micro planets 8; echo " (returns 8 random nodes from micro structure planets)";


#CREATE CHAOS 
sudo micro new chaos; echo " (creates micro structure chaos)";



#DUMP CHAOS 
sudo micro drop chaos; echo " (deletes micro structure chaos)";

#DUMP TOP NODES
perl -MAI::MicroStructure -le 'print for AI::MicroStructure->themes;'


#ITERATES TOP NODES
for i in `perl -MAI::MicroStructure -le 'print for AI::MicroStructure->themes;'`; do echo $i; done


#ITERATES ALL
for i in `perl -MAI::MicroStructure -le 'print  for AI::MicroStructure->themes';`; 
do echo "@@@@@@@@@@<SET>@@@@@@@@@@@@<"$count">@@@@@@@@@<"$i">@@@@@@@@@";
count=$(expr $count + 1); 
perl -MAI::MicroStructure::$i  -le '$m=AI::MicroStructure::'$i'; print join(",",$m->name(scalar $m)); 
print join(",",$m->categories()); '; 
done

