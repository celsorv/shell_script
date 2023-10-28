# --------------------------------------------------_------------------------
# Renomeia todos os arquivos de um diretório, ordenado pelo nome dos arquivos
#
#     Exemplo de uso:
#          ./aren.sh receita- --source-dir minha_pasta
#
#              source-dir   file  ext        source-dir   prefix    ext
#              ___________/______.___        ___________/________##.___
#          De "minha_pasta/Amanda.txt" para "minha_pasta/receita-01.txt"
#          De "minha_pasta/Lilian.txt" para "minha_pasta/receita-02.doc"
#          De "minha_pasta/Milena.pdf" para "minha_pasta/receita-02.pdf"
#
#     Sintaxe:
#     aren <prefixo> [--source-dir <diretório>] [--verbose-off] [--timing]
# ---------------------------------------------------------------------------

#!/bin/bash

inicio=$(date +%s%N)

mostrar=1
tempo=0
prefixo=""

diretorio="."		# diretório padrão

argumentos=("$@")	# cria um array

for ((i = 0; i < ${#argumentos[@]}; i++)); do

   arg="${argumentos[i]}"
    
   case "$arg" in
   
		--source-dir)
			diretorio="${argumentos[i+1]}"
			((i++))  # Avança o índice em 1
			;;
	
		--verbose-off)
			mostrar=0
			;;

		--timing)
			tempo=1
			;;
	
		*)
			prefixo="${arg}"
			;;
	
	esac   	 

done

echo  # salta linha

if [ -z "$prefixo" ]; then
   echo "Uso: aren <prefixo> [--source-dir <diretório>] [--verbose-off] [--timing]"
   echo "Exemplo: ./aren.sh prog- --source-dir ./labor/ --verbose-off --timing"
   echo
   exit 1
fi

contador=1

# Para cada arquivo no diretório ordenado por nome
find "$diretorio" -maxdepth 1 -type f ! -name "*.sh" | sort | while read -r arquivo; do

    # Extraia a extensão do arquivo
    extensao="${arquivo##*.}"

    # Crie o novo nome do arquivo com o prefixo e o contador
    novo_nome="$diretorio/$prefixo$(printf "%02d" $contador).$extensao"

    # Renomeie o arquivo
    mv "$arquivo" "$novo_nome"

	 if [ "$mostrar" -eq 1 ]; then
	 	echo "De \"$arquivo\" para \"$novo_nome\""
	 fi

    # Incrementa o contador
    contador=$((contador + 1))

done

if [ $tempo -eq 1 ]; then
	fim=$(date +%s%N)
	diferenca=$((($fim - $inicio) / 1000000))
	echo
	echo "$diferenca milissegundos"
fi

echo  # salta linha
