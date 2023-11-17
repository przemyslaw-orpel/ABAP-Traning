*&---------------------------------------------------------------------*
*& Report  ZALV_HIER_REPORT
*&
*&---------------------------------------------------------------------*
*& Sample CL_SALV_HIERSEQ_TABLE
*& Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zalv_hier_report.

types: begin of ty_ernam_tab,
         ernam  type ernam,
         expand type char01,
       end of ty_ernam_tab.

data:
  go_alv     type ref to cl_salv_hierseq_table,
  lt_binding type salv_t_hierseq_binding,
  ls_binding type salv_s_hierseq_binding,
  gt_master  type table of ty_ernam_tab,
  gt_slave   type table of equi.

" Select data
select distinct ernam into corresponding fields of table gt_master from equi.
select * from equi into table gt_slave.

" Bind master/slave tables
ls_binding-master = 'ERNAM'.
ls_binding-slave = 'ERNAM'.
append ls_binding to lt_binding.

" Create ALV istance
call method cl_salv_hierseq_table=>factory(
  exporting
    t_binding_level1_level2 = lt_binding
  importing
    r_hierseq               = go_alv
  changing
    t_table_level1          = gt_master
    t_table_level2          = gt_slave
                              ).

" Set toolbar
go_alv->get_functions( )->set_all( ).

" Set exapnd column
data(lr_columns) = go_alv->get_columns( 1 ). " 1 - Master table level
lr_columns->set_expand_column( 'EXPAND' ).

" Hide mandat column
go_alv->get_columns( 2 )->get_column( 'MANDT' )->set_visible( abap_false ). " 2 - Slave table level

" Display ALV
go_alv->display( ).