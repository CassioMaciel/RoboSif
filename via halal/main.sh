#/bin/bash
lynx -dump -listonly http://www.fambrashalal.com.br/frigorificos-certificados | grep .pdf | cut -f 4- -d " " | sed -r "s/(.*)/wget \"\1\""/g | sh

cat compilado.txt | sed "s@ @@g" | grep -i sif | sed -r "s@(.*)-SIF:(.*)@NOME:\1  SIFa:\2@g" > SifTratados.txt
