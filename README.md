# Atualização de NF

[![N|Solid](https://wiki.scn.sap.com/wiki/download/attachments/1710/ABAP%20Development.png?version=1&modificationDate=1446673897000&api=v2)](https://nodesource.com/products/nsolid)

Este tem como objeto fazer um modelo de base para que seja poupado trabalho quando houver uma solução de atualização de Nota Fiscal.

  - Utilização de BAPI
  - Atualização de cabeçalho, item, taxas e etc
  - Filtro para NF informada na Selection-Screen

# Atualizações

  - Import a HTML file and watch it magically convert to Markdown

```abap
    types:
      range_docnum type range of j_1bnfdoc-docnum,
      range_nftype type range of j_1bnfdoc-nftype,
      range_bukrs  type range of j_1bnfdoc-bukrs .

```
