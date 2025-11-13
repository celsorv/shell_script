#!/bin/bash

declare -A meses=(
  ["janeiro"]="01"
  ["fevereiro"]="02"
  ["marco"]="03"
  ["março"]="03"
  ["abril"]="04"
  ["maio"]="05"
  ["junho"]="06"
  ["julho"]="07"
  ["agosto"]="08"
  ["setembro"]="09"
  ["outubro"]="10"
  ["novembro"]="11"
  ["dezembro"]="12"
)

for arquivo in *.pdf; do
  nome="${arquivo%.pdf}"
  novo="${meses[$nome]}"
  if [[ -n "$novo" ]]; then
    mv "$arquivo" "${novo}.pdf"
  else
    echo "⚠️ Mês desconhecido: $arquivo"
  fi
done
