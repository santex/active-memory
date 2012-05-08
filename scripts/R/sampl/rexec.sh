 for i in ls ./*; do echo $i | R --vanilla; c=$(echo $i  | replace "\.r" "" ); sh -c  "mv ./Rplots.pdf  ./plots/"$i".pdf"; done

