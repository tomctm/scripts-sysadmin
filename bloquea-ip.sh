#/bin/bash

# Realizamos scrip para bloquear ips que se autentican a correo fuera de Espanha



#sacamos as ips do log que se conectaron mal
cat /var/log/mail.log | grep "SASL LOGIN authentication failed" | awk {'print $7'} | cut  -f2 -d[ | cut -f1 -d] | sort | uniq >> /home/webmaster/ips-malascorreo.txt

#geolocalizamolas

for x in $(cat /home/webmaster/ips-malascorreo.txt); do

	geoiplookup -f /home/webmaster/GeoIP.dat $x | awk {'print $4'} | cut -f1 -d, >> /home/webmaster/geolocalizamos.txt




	for i in $(cat /home/webmaster/geolocalizamos.txt); do

		if [ $i = ES ]; then 

			echo "ip de espanistan"

		else
			iptables -A INPUT -s $x -j DROP
			echo "ip baneada"

		fi
	done

done

rm -f /home/webmaster/ips-malascorreo.txt
rm -f /home/webmaster/geolocalizamos.txt
	

