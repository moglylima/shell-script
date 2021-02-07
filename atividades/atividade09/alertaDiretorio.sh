#!/bin/bash
# Correção: 3,0.

TEMPO=$1
DIRETORIO=$2

LISTAGEM_INICIAL=$(ls $DIRETORIO)

#Lista de arquivos da pasta $d com a data da de modificação
LISTA_DATA_MOD=$(for i in $(ls $DIRETORIO); do date -r $DIRETORIO/$i +$i"-"%d/%m/%y"-"%H:%M:%S; done)

#Criando arquivo dirSensors.log
touch dirSensors.log

while true; do
        #data atual do sistema
        DATE_NOW=$(date +[%d-%m-%Y\ %H:%M:%S])

        #Nova lista de arquivos da pasta $d
        NOVA_LISTAGEM=$(ls $DIRETORIO)

        #quantidade de arquivos antes do monitoramento
        quantOld=$(printf "$LISTAGEM_INICIAL" | wc -l)

        #quantidade de arquivos depois do monitoramento
        quantNew=$(printf "$NOVA_LISTAGEM" | wc -l)

        #nova lista de arquivos da pasta $d com as novas datas de modificação
        LISTA_DATA_NEWMOD=$(for i in $(ls $DIRETORIO); do date -r $DIRETORIO/$i +$i"-"%d/%m/%y"-"%H:%M:%S; done)

        #Usando comando comm para verificar os arquivos adicionados
        adC=$(comm -13 <(printf "$LISTAGEM_INICIAL\n") <(printf "$NOVA_LISTAGEM\n"))

        #usando comando comm para verificar os arquivos removidos
        rmV=$(comm -23 <(printf "$LISTAGEM_INICIAL\n") <(printf "$NOVA_LISTAGEM\n"))

        #usando comando comm para ver quais arquivos são semelhantes
        alT=$(comm -12 <(printf "$LISTAGEM_INICIAL\n") <(printf "$NOVA_LISTAGEM\n"))
        altSim=

        #verificando se o arquivo foi realmente alterado
        for i in $(comm -13 <(printf "$LISTA_DATA_MOD\n") <(printf "$LISTA_DATA_NEWMOD\n"))
        do
                arq=$(echo $i | cut -d- -f1)
                if [ $(grep "^$arq$" <(printf "$alT\n") | wc -l) ] && [ $(grep "^$arq$" <(printf "$adC\n") | wc -l) == 0 ]
                then
                        altSim="$altSim $arq,"
                fi
        done
        altSim=$(echo "$altSim" | sed 's/,$//')

        #texto que vai ser mandado para dirSensors.log
        str="$DATE_NOW Alteração! $quantOld->$quantNew."
        #variável responsável por informar se houve ou não modificação
        print=0

        if [ "$rmV" ]; then
                #informando que houve modificação
                print=1
                #informando quais arquivos foram removidos
                str="$str Removidos: $(printf "$rmV" | tr '\n' ',' | sed 's/,/, /g')."
        fi
        if [ "$adC" ]; then
                #informando que houve modificação
                print=1
                #informando quais arquivos foram adicionados
                str="$str Adicionados: $(printf "$adC" | tr '\n' ',' | sed 's/,/, /g')."
        fi
        if [ "$altSim" ]; then
                #informando que houve modificação
                print=1
                #informando quais arquivos foram alterados
                str="$str Alterados:$altSim."
        fi
        # 1 = houve modificação. 0 = não houve modificação
        if [ $print == 1 ]; then
                echo "$str"
                echo "$str" >> dirSensors.log
        fi

        # atualizando as modificações
        LISTAGEM_INICIAL=$NOVA_LISTAGEM
        # atualizando as datas de modificações
        LISTA_DATA_MOD=$LISTA_DATA_NEWMOD
        sleep $TEMPO
done
