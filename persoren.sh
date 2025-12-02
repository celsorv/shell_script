#!/bin/bash

# Este script renomeia arquivos no formato
# "Captura de tela de YYYY-MM-DD HH-MM-SS.png",
# pedindo ao usuário um prefixo e renomeando-os
# em ordem cronológica com sufixos PREFIXO_01.png, PREFIXO_02.png...

# Pergunta o prefixo desejado
read -p "Digite o prefixo desejado para os arquivos: " prefixo

# Array com os arquivos (mantém nomes com espaços corretamente)
mapfile -t arquivos < <(printf '%s\n' Captura\ de\ tela\ de\ *.png | sort)

contador=1

for arq in "${arquivos[@]}"; do
    # Ignora se o arquivo não existe (caso o glob não encontre nada)
    [[ ! -e "$arq" ]] && continue

    # Extrai a parte da data/hora usando regex
    # usa grep com PCRE (-P) e extrai timestamp
    timestamp=$(echo "$arq" | grep -oP '\d{4}-\d{2}-\d{2} \d{2}-\d{2}-\d{2}')

    # Verifica se o nome realmente tem o padrão esperado
    if [[ -z "$timestamp" ]]; then
        echo "Ignorando: $arq (não segue o padrão esperado)"
        continue
    fi

    # Número sequencial com dois dígitos
    num=$(printf "%02d" "$contador")

    novo_nome="${prefixo}_${num}.png"

    echo "Renomeando: '$arq' -> '$novo_nome'"
    mv -- "$arq" "$novo_nome"

    ((contador++))
done

echo "Concluído!"
