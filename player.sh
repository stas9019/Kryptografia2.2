#! /bin/bash


#check args
key="01234567890123456789012345678901"

#compile keystore
g++ /home/stas/ClionProjects/Keystore/main.cpp -lcrypto -lssl -o /home/stas/ClionProjects/Keystore/exe
keystorePath=/home/stas/ClionProjects/Keystore


function install
{
	touch conf
	
	keystorePath=$1
	keyID=$2
	password=$3 
	PIN=$4
		
		
	echo "$1" >> conf
	echo "$2" >> conf
	echo "$3" >> conf
	echo "$4" >> conf
	

	#run keystore app to encrypt conf file
	"$keystorePath/exe" "encrypt" "/home/stas/ClionProjects/Kryptografia2.2/conf" $key

}


if [ -f "conf" ]; then

	echo "Conf exist" 
	
	if [ $# -lt 1 ];then	
		echo "Not enough arguments"
		exit
	fi
	
	filePath=$1
	PIN=$2
	moment=$3

	"$keystorePath/exe" "decrypt" "/home/stas/ClionProjects/Kryptografia2.2/conf" $key
	

	kPath=`sed -n 1p conf`
	kID=`sed -n 2p conf`
	kPass=`sed -n 3p conf`
	echo $kPass
	kPIN=`sed -n 4p conf`
	echo $kPIN
	"$keystorePath/exe" "encrypt" "/home/stas/ClionProjects/Kryptografia2.2/conf" $key
	
	if [ "$kPIN" != "$PIN" ];then	
		echo "Wrong PIN, bye, bye"
		exit
	fi
	
	echo "$kPass" >> pass
		
	#run keystore app with key ID 	
	"$keystorePath/exe" $kID < pass

	rm pass
	
	#take key from temp file
	key=`cat "$keystorePath/temp"`
	rm "$keystorePath/temp"	
		
	#run krypto app with filePath, action, mode and key
	#/home/stas/ClionProjects/Kryptografia2.1/exe $filePath $action $mode $key	
	/home/stas/ClionProjects/Kryptografia2.1/exe $filePath decrypt CBC $key	
	
	./player /home/stas/ClionProjects/Kryptografia2.1/Decrypted $moment	
		
	
	
	
	
elif [ "$1" == install ]; then

	echo "install"
  
	if [ $# -lt 4 ];then	
		echo "Usage: install [keystore_path] [key_ID] [keystore_password]"
		exit
  	fi
  	
  	install "$2" "$3" "$4" "$5"		#keystore_path, key_id, password
  	exit
else
  echo "File not found"
  echo "Usage: install [keystore_path] [key_ID] [keystore_password]"
  exit 
fi


exit

if [ $# -lt 2 ];then	
	echo "Not enough arguments"
	exit
fi




