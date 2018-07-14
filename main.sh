#/bin/bash
rm estabelecimentos.txt
rm source1


cat Sifs.txt
for sifs in $(cat Sifs.txt | sed 's/ //g')
do
lynx -dump -listonly "http://extranet.agricultura.gov.br/sigsif_cons/!ap_estabelec_nacional_lista?nr_sif=$sifs&nm_razao_social=&nr_cnpj=&nm_sort=nr_sif" | grep "id_estabelecimento=" | sed 's@http://@#@g' | cut -d '#' -f '2-' | sed -r 's#(.*)#http://\1#g' | sort | uniq >> estabelecimentos.txt
done

echo "CNPJ;NOME FANTASIA;RAZÃO SOCIAL;SIF;ENDEREÇO;BAIRRO;CEP;MUNICIPIO;UF;TELEFONE;FAX;SITE" > ./todos.csv

for estabelecimentos in $(cat estabelecimentos.txt | sort | uniq )
do
lynx -source "$estabelecimentos"  |  tr '[\000-\011\013-\037\177-\377]' '.'  | grep -E -i 'NAME="nr_cnpj"|NAME="nm_razao_social"|NAME="nr_sif"|name="nm_fantasia"|name="tx_logradouro"|name="nm_bairro"|name="nr_cep"|name="nm_municipio"|name="sg_uf"|name="nr_telefone"|name="nr_fax"|name="tx_site"|name="ds_classe_estab"' | sed 's/^.*NAME="//g' | sed 's/".*VALUE="/@/g' | sed 's/".*$//g' | cut -f '2' -d '@' | tr "\n" ";" | sed -r 's/;$/\n/' >> ./todos.csv
done
