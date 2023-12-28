# Atualização de NF

![Static Badge](https://img.shields.io/badge/development-abap-blue)
![GitHub commit activity (branch)](https://img.shields.io/github/commit-activity/t/edmilson-nascimento/document_update)

Este tem como objeto fazer um modelo de base para que seja poupado trabalho quando houver uma solução de atualização de Nota Fiscal.

  - Utilização de BAPI
  - Atualização de cabeçalho, item, taxas e etc
  - Filtro para NF informada na `Selection-Screen`
  
## Recuperação das informações 

Antes de iniciar os ajustes, é muito importante que os dados sejam recuperados para que as tabelas obrigatórias BAPI sejam passadas corretamente. **Tabelas passadas sem informações, serão aceitas como deleção para esta BAPI.**
A recuperação dessas informações pode ser feita através da BAPI `'J_1B_NF_DOCUMENT_READ'` conforme abaixo.
```abap
        call function 'J_1B_NF_DOCUMENT_READ'
          exporting
            doc_number               = doc_number
          importing
            doc_header               = doc_header
          tables
            doc_partner              = doc_partner
            doc_item                 = doc_item
            doc_item_tax             = doc_item_tax
            doc_header_msg           = doc_header_msg
            doc_refer_msg            = doc_refer_msg
*           doc_ot_partner           =
*           doc_import_di            =
*           doc_import_adi           =
*           doc_cte_res              =
*           doc_cte_docref           =
          exceptions
            document_not_found       = 1
            docum_lock               = 2
            others                   = 3 .

        if sy-subrc eq 0 .

        else .
          message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        endif.
  ```
  
## Alteração das informações 

Apos a *Recuperação das informações*, ficam disponíveis as tabelas internas para que os dados sejam alterados. Basta atualizar o registro que deseja antes de chamar a próxima `BAPI`.

## Atualização das informações 

É possivel fazer alteração dos valores que espera que sejam atualizados no pontos onde as informações são passadas para as estrutura/tabelas da BAPI. Nesse caso, estou alterando apenas o campo `taxsi4` que corresponde a *Situação de impostos COFINS*, mas pode ser aplicados a varios campos diferentes.
```abap
    loop at lt_j_1bnflin into ls_j_1bnflin .
      ls_j_1bnflin-taxsi4 = '04' .
      append ls_j_1bnflin to doc_item .
    endloop .
```

As informações são recuperadas pelas estruturas/tabelas `ls_j_1bnfdoc` e `lt_j_1bnflin`, mas as informações que serão atualizadas estão nos parâmetros de entrada da função `J_1B_NF_DOCUMENT_UPDATE`.

Apos a execução, é necessário um `commit` de bando de dados, que nesse caso é feito pela `BAPI` responsavel.

```abap
      call function 'BAPI_TRANSACTION_COMMIT'
*         exporting
*           wait          =
*         importing
*           return        =
                .
```
