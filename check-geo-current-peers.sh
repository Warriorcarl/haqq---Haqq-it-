export DATA_DIR=/home/haqq/.haqqd
source $HOME/.bash_profile

##
ADDRBOOK=$DATA_DIR/config/addrbook.json
FILE=addr.txt
FILE_ADDR=addr.txt
FILE_COUNTRY=country.txt
FILE_ORG=org.txt
FILE_CITY=city.txt

##
curl -s http://localhost:${HAQQ_PORT}657/net_info | jq | grep -e "remote_ip" \
| awk '{print $2}' | tr -d "," | xargs | fmt -w 1 | sort -u  > $FILE_ADDR

##
rm $FILE_COUNTRY $FILE_ORG $FILE_CITY

COUNT=0
while read IP
do
    IP_INFO=`curl -s ipinfo.io/$IP`
    COUNTRY=`echo $IP_INFO |jq -r .country` ;
    ORG=`echo $IP_INFO |jq -r .org` ;
    CITY=`echo $IP_INFO |jq -r .city` ;
    echo $COUNTRY >> $FILE_COUNTRY ;
    echo $ORG  >> $FILE_ORG ;
    echo $CITY >> $FILE_CITY ;
    COUNT=$(($COUNT+1)) ;
done < $FILE_ADDR
echo 'Number of IP addr :' $COUNT | tee -a $LOG;

##
echo "Country top 10:"
cat $FILE_COUNTRY | sort | uniq -c |  sort -k1 -n -r |head -n10
echo "Org top 10:"
cat $FILE_ORG | sort | uniq -c |  sort -k1 -n -r |head -n10
echo "City top 10:"
cat $FILE_CITY | sort | uniq -c |  sort -k1 -n -r |head -n10

