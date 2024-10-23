report  z_document_update.

tables:
  j_1bnfdoc .

select-options:
  docnum for j_1bnfdoc-docnum obligatory .
parameters:
  taxsi4 type j_1bnflin-taxsi4
         default '06' obligatory,
  taxlw4 type j_1bnflin-taxlw4
         default 'C50' obligatory,
  taxlw5 type j_1bnflin-taxlw5
         default 'P50' obligatory.

start-of-selection .

  data:
    ls_j_1bnfdoc   type j_1bnfdoc,
    lt_j_1bnfdoc   type table of j_1bnfdoc,

    doc_number     type j_1bnfdoc-docnum,
    doc_header     type j_1bnfdoc,
    doc_partner    type table of j_1bnfnad,
    doc_item       type table of j_1bnflin,
    doc_item_tax   type table of j_1bnfstx,
    doc_header_msg type table of j_1bnfftx,
    doc_refer_msg  type table of j_1bnfref .

  field-symbols:
    <j_1bnflin>    type j_1bnflin .


  select *
    into table lt_j_1bnfdoc
    from j_1bnfdoc
   where docnum in docnum .

  if sy-subrc eq 0 .

      loop at lt_j_1bnfdoc into ls_j_1bnfdoc .

        doc_number = ls_j_1bnfdoc-docnum .

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

        if sy-subrc <> 0 .
          message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
        endif.


        loop at doc_item assigning <j_1bnflin> .

          <j_1bnflin>-taxsi4 = taxsi4 .
          <j_1bnflin>-taxsi5 = taxsi4 .

          <j_1bnflin>-taxlw4 = taxlw4 .
          <j_1bnflin>-taxlw5 = taxlw5 .

        endloop .

        call function 'J_1B_NF_DOCUMENT_UPDATE'
          exporting
            doc_number                  = doc_number
            doc_header                  = doc_header
          tables
            doc_partner                 = doc_partner
            doc_item                    = doc_item
            doc_item_tax                = doc_item_tax
            doc_header_msg              = doc_header_msg
            doc_refer_msg               = doc_refer_msg
*           doc_ot_partner              =
*           doc_import_di               =
*           doc_import_adi              =
*           doc_cte_docref              =
*           doc_cte_res                 =
          exceptions
            document_not_found          = 1
            update_problem              = 2
            doc_number_is_initial       = 3
            others                      = 4 .

        if sy-subrc eq 0.

          call function 'BAPI_TRANSACTION_COMMIT'
*           exporting
*             wait          =
*           importing
*             return        =
                    .

        else .

          message id sy-msgid type sy-msgty number sy-msgno
                with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

        endif.

      endloop .

  endif .
