#!/bin/bash

#########################################################################
# NOME: usage.sh
# DESCRIÇÃO: Gera um relatório de tempo de uso (uptime) do sistema.
#            Analisa os reboots dos últimos 7 dias, calcula o tempo
#            total acumulado e a média diária de atividade.
#
# FUNCIONAMENTO:
#   1. Filtra logs do sistema através do comando 'last reboot'.
#   2. Remove sessões ativas ('still running') para não afetar a média.
#   3. Normaliza o campo 'dia' para 2 dígitos (ex: 04 em vez de 4).
#   4. Processa durações curtas e longas (acima de 24h/1 dia).
#
# USO: ./usage.sh
#########################################################################

echo "-------------------------------------------------------"
echo "       LINUX - RELATÓRIO DE USO - ÚLTIMA SEMANA"
echo "-------------------------------------------------------"
echo -e "DATA\t\tINÍCIO\t\tTÉRMINO\t\tDURAÇÃO"
echo "-------------------------------------------------------"

# 1. Filtramos apenas entradas de 'reboot' (quando o sistema iniciou)
# 2. O campo $10 do 'last' para 'reboot' mostra quanto tempo o sistema ficou UP.
data_info=$(last reboot -s -7days | grep "reboot" | grep -v "running" | awk '{print $5"|"$6"|"$7"|"$8"|"$10"|"$11}' | tr -d '()')

total_minutos=0
contagem_sessoes=0

for linha in $data_info; do

    # Separando os dados
    diasem=$(echo $linha | cut -d'|' -f1)
    dianum=$(printf "%02d" $(echo $linha | cut -d'|' -f3))
    inicio=$(echo $linha | cut -d'|' -f4)
    termino=$(echo $linha | cut -d'|' -f5)
    duracao=$(echo $linha | cut -d'|' -f6)

    # TRATAMENTO DE DURAÇÃO:
    # Caso 1: Sessão durou mais de 24h (formato 1+02:30)
    if [[ $duracao == *"+"* ]]; then
        dias=$(echo $duracao | cut -d+ -f1)
        resto=$(echo $duracao | cut -d+ -f2)
        h=$(echo $resto | cut -d: -f1)
        m=$(echo $resto | cut -d: -f2)
        minutos_sessao=$(( (dias * 1440) + (h * 60) + m ))

    # Caso 2: Sessão durou menos de 24h (formato 02:30)
    else
        h=$(echo $duracao | cut -s -d: -f1)
        m=$(echo $duracao | cut -s -d: -f2)

        # Garante que campos vazios virem 0 para evitar erro matemático no shell
        [[ -z $h ]] && h=0
        [[ -z $m ]] && m=0

        minutos_sessao=$(( (h * 60) + m ))
    fi

    if [ $minutos_sessao -gt 0 ]; then
        total_minutos=$((total_minutos + minutos_sessao))
        echo -e "$dianum $diasem\t\t$inicio\t\t$termino\t\t$duracao"
        ((contagem_sessoes++))
    fi

done

# CONVERSÃO PARA FORMATO FINAL:
# Transforma o grande total de minutos de volta para Horas e Minutos
horas=$((total_minutos / 60))
minutos=$((total_minutos % 60))

# Média aritmética baseada em uma semana (7 dias)
media_total_min=$((total_minutos / 7))
m_horas=$((media_total_min / 60))
m_minutos=$((media_total_min % 60))

echo "-------------------------------------------------------"
echo "TEMPO TOTAL ACUMULADO: ${horas}h ${minutos}min"
echo "MÉDIA DIÁRIA (7 DIAS): ${m_horas}h ${m_minutos}min"
echo "-------------------------------------------------------"
