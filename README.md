# Atualização de NF

[![N|Solid](https://wiki.scn.sap.com/wiki/download/attachments/1710/ABAP%20Development.png?version=1&modificationDate=1446673897000&api=v2)](https://www.sap.com/brazil/developer.html)

Este tem como objeto fazer um modelo de base para que seja poupado trabalho quando houver uma solução de atualização de Nota Fiscal.

  - Utilização de BAPI
  - Atualização de cabeçalho, item, taxas e etc
  - Filtro para NF informada na Selection-Screen
  
## Atualização das informações 

É possivel fazer alteração dos valores que espera que sejam atualizados no pontos onde as informações são passadas para as estrutura/tabelas da BAPI. Nesse caso, estou alterando apenas o campo `taxsi4` que corresponde a *Situação de imposto COFINS*, mas ser aplicados a varios campos diferentes.
```abap
    loop at lt_j_1bnflin into ls_j_1bnflin .
      ls_j_1bnflin-taxsi4 = '04' .
      append ls_j_1bnflin to doc_item .
    endloop .
```

As informações são recuperadas pelas estruturas/tabelas `ls_j_1bnfdoc` e `lt_j_1bnflin`, mas as informações que serão atualizadas estão nos parâmetros de entrada da função `'J_1B_NF_DOCUMENT_UPDATE'`.

Apos a execução, é necessário um `commit` de bando de dados, que nesse caso é feito pela `BAPI` responsavel.

```abap
      call function 'BAPI_TRANSACTION_COMMIT'
*         exporting
*           wait          =
*         importing
*           return        =
                .
```
