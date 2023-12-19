*&---------------------------------------------------------------------*
*& Report  ZALV_ICON
*&
*&---------------------------------------------------------------------*
*&  ALV Column icons + tooltips example
*&  Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zalv_icon.

types: begin of ty_icon,
         id   type icon_d,
         name type iconname,
       end of ty_icon.

data: lt_icon     type standard table of ty_icon,
      lv_value    type lvc_value,
      lv_tip      type lvc_tip,
      lo_tooltips type ref to cl_salv_tooltips,
      lo_alv      type ref to cl_salv_table.

" Select all icon from db
select * from icon into corresponding fields of table lt_icon.

" Create ALV object
try.
    cl_salv_table=>factory(
      importing
        r_salv_table = lo_alv
      changing
        t_table = lt_icon
    ).
  catch cx_salv_msg into data(gx_alv_error).
    write gx_alv_error->get_text( ).
endtry.

" Set columm text
data(lo_col) = lo_alv->get_columns( ).
data(lo_id) = cast cl_salv_column_table( lo_col->get_column( 'ID' ) ).
lo_id->set_short_text( 'ID' ).
lo_id->set_icon( if_salv_c_bool_sap=>true ).
lo_col->get_column( 'NAME' )->set_short_text( 'NAME' ).

" Set tooltips
lo_tooltips = lo_alv->get_functional_settings( )->get_tooltips( ).
loop at lt_icon into data(ls_icon).
  try.
      lv_value  = ls_icon-id.
      lv_tip = ls_icon-name.
      lo_tooltips->add_tooltip( type     = cl_salv_tooltip=>c_type_icon
                             value    = lv_value
                             tooltip  = lv_tip ).
    catch cx_salv_existing.
  endtry.
endloop.

" Set toolbar
lo_alv->get_functions( )->set_all( ).

" Display ALV
lo_alv->display( ).