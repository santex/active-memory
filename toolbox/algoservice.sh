#!/bin/bash

down=" ☟ ";
up=" ㋡ ";
marker=" ☞ ";


if [ -z "$1" ]
then
echo $marker $0 "/tmp/Finance-Quant/2012-Feb-29/"; exit;
else
cd $1
fi


for i in `ls /tmp/backtest/*pdf`;
do 
share=`echo $i | replace "backtest/longtrend_backtest_" "" | replace ".pdf" ""`;


#more=`find * | grep "\/$share.php"`
chart=`find * | egrep "(/|_)$share[.](pdf|php|csv|png|jpg)$"`
set=`echo $chart | tr " " ","`

value=($(cat $i | grep "50.00 126.30 Tm " | replace "/F2 1 Tf 6.00 0.00 -0.00 6.00 50.00 126.30 Tm (" "" | replace ") Tj" "" | tr '\n' ' '));
echo $share,$value,$set; 

done

#array1=($(cat "$filename" | tr '\n' ' '))

#ratings/"$i".php";
#ssh -a root@algoservice.com ls  /var/www/vhosts/html5stockbot.com/httpdocs/data/upload/ratings/*/*php | replace '/var/www/vhosts/html5stockbot.com/httpdocs/data/upload/ratings/' '' | replace ".php" "" > ~/symbol.list; cat ~/symbol.list;

#echo "insert into activelog select *,UNIX_TIMESTAMP(),'',0 from active_guests where ip not in (select ip from activelog);" |  mysql -uhagen -px123pass csig -h algoservice.com; for i in `echo "(select ip from active_guests) " | mysql -uhagen -px123pass csig -h algoservice.com`;  do area=`echo $i | xargs geoip-lookup`; query=`echo 'update activelog set area="'$area'" where ip="'$i'"'`; echo $query | replace 'update activelog set area="" where ip="ip"' '' | mysql -uhagen -px123pass csig -h algoservice.com; echo $query; done



#<p class="bio ">㋡ of <a class="  twitter-atreply pretty-link" data-screen-name="boysnoizerec" href="/#!/boysnoizerec" rel="nofollow"><s>@</s><b>boysnoizerec</b></a> ❚ subscribe ☞ <a href="http://www.youtube.com/boysnoize" target="_blank" rel="nofollow" class="twitter-timeline-link">http://www.youtube.com/boysnoize</a> ❚ like ☞ <a href="http://www.facebook.com/boysnoize" target="_blank" rel="nofollow" class="twitter-timeline-link">http://www.facebook.com/boysnoize</a> ❚ shop ☞  <a href="http://www.boysnoize.com/shop" target="_blank" rel="nofollow" class="twitter-timeline-link">http://www.boysnoize.com/shop</a> ❚ BNR ☟
#</p>



