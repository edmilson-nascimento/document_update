

report  z_document_update.

data:
  ls_j_1bnfdoc   type j_1bnfdoc,
  ls_j_1bnflin   type j_1bnflin,
  lt_j_1bnflin   type table of j_1bnflin,

  doc_number     type j_1bnfdoc-docnum,
  doc_header     type j_1bnfdoc,
  doc_partner    type table of j_1bnfnad,
  doc_item       type table of j_1bnflin,
  doc_item_tax   type table of j_1bnfstx,
  doc_header_msg type table of j_1bnfftx,
  doc_refer_msg  type table of j_1bnfref .


select single *
  into ls_j_1bnfdoc
  from j_1bnfdoc
 where docnum eq '0067321948' . " nro fictício

if sy-subrc eq 0 .

  select *
    into table lt_j_1bnflin
    from j_1bnflin
   where docnum eq ls_j_1bnfdoc-docnum .

  if sy-subrc eq 0 .

    doc_number = ls_j_1bnfdoc-docnum .
    doc_header = ls_j_1bnfdoc .

    loop at lt_j_1bnflin into ls_j_1bnflin .
      ls_j_1bnflin-taxsi4 = '04' .
      append ls_j_1bnflin to doc_item .
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
*       doc_ot_partner              =
*       doc_import_di               =
*       doc_import_adi              =
*       doc_cte_docref              =
*       doc_cte_res                 =
      exceptions
        document_not_found          = 1
        update_problem              = 2
        doc_number_is_initial       = 3
        others                      = 4 .

    if sy-subrc eq 0.

      call function 'BAPI_TRANSACTION_COMMIT'
*         exporting
*           wait          =
*         importing
*           return        =
                .

    else .

      message id sy-msgid type sy-msgty number sy-msgno
            with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

    endif.


  endif .

endif .
