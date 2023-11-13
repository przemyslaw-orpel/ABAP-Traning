*&---------------------------------------------------------------------*
*& Report  ZALV_REPORT
*&
*&---------------------------------------------------------------------*
*& Sample alv grid report using event, toolbar, layout, column settings
*& Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zalv_report.

class lcl_alv_event definition deferred.

" Declaration of the global variables
data:
  gt_equi          type standard table of equi,
  go_alv           type ref to cl_salv_table,
  gx_alv_error     type ref to cx_salv_msg,
  go_event_handler type ref to lcl_alv_event.

*----------------------------------------------------------------------*
*       CLASS lcl_alv_event DEFINITION
*----------------------------------------------------------------------*
class lcl_alv_event definition.
  public section.
    methods on_link_click for event link_click of cl_salv_events_table
      importing
          row
          column.

endclass.

*----------------------------------------------------------------------*
*       CLASS lcl_alv_event IMPLEMENTATION
*----------------------------------------------------------------------*
class lcl_alv_event implementation.
  method on_link_click.
    data: ls_equi  type equi,
          lv_equnr type equnr.

    " Read selected row
    read table gt_equi into ls_equi index row.

    set parameter id: 'EQN' field ls_equi-equnr.
    call transaction 'IE02' and skip first screen.

*    MESSAGE ls_equi-equnr type 'S'.


  endmethod.
endclass.


start-of-selection.
  perform set_alv_data.

end-of-selection.
  perform create_alv.
  perform set_layout.
  perform set_column_settings.
  perform set_toolbar.
  perform set_event.
  perform display_alv.

*&---------------------------------------------------------------------*
*&      Form  SET_ALV_DATA
*&---------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
form set_alv_data .
  " Select data from DB
  select * from equi into table gt_equi.

endform.


*&---------------------------------------------------------------------*
*&      Form  CREATE_ALV
*&---------------------------------------------------------------------*
*       Create ALV object
*----------------------------------------------------------------------*
form create_alv .
  " Get ALV object istance ready to use
  try.
      cl_salv_table=>factory(
        importing
         r_salv_table = go_alv
         changing
           t_table = gt_equi
      ).
    catch cx_salv_msg into gx_alv_error.
      write gx_alv_error->get_text( ).
  endtry.

endform.


*&---------------------------------------------------------------------*
*&      Form  SET_COLUMN_SETTINGS
*&---------------------------------------------------------------------*
*       Set column settings:
*       - Change header text
*       - Optimize column width
*       - Sort columns
*       - Set column color
*       - Hide columm
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
form set_column_settings .
  try.
      " Change header text
      data(lo_column) = go_alv->get_columns( )->get_column( 'ERNAM' ).
      lo_column->set_long_text( 'CREATOR' ).
      lo_column->set_medium_text( 'CREATOR').
      lo_column->set_short_text( 'CREATOR').

      " Optimize column width
      go_alv->get_columns( )->set_optimize( ).

      " Sort a column down
      go_alv->get_sorts( )->add_sort( columnname = 'EQUNR' sequence = if_salv_c_sort=>sort_down  ).

      " Colored column
      data(lo_column_tab) = cast cl_salv_column_table(
        go_alv->get_columns( )->get_column( 'ERNAM' ) ).

      lo_column_tab->set_key( abap_false ).
      lo_column_tab->set_color( value #( col = col_total ) ).

      " Hide mandat column
      go_alv->get_columns( )->get_column( 'MANDT' )->set_visible( abap_false ).

    catch cx_salv_not_found.
    catch cx_salv_existing.
    catch cx_salv_data_error.
  endtry.

endform.


*&---------------------------------------------------------------------*
*&      Form  SET_TOOLBAR
*&---------------------------------------------------------------------*
*       Set alv toolbar
*----------------------------------------------------------------------*
form set_toolbar .
  " Enable ALV toolbar
  go_alv->get_functions( )->set_all( ).  " set_default( ) to basic toolbar
endform.


*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
*       Enable layout, allow variant saving
*----------------------------------------------------------------------*
form set_layout .
  " Set layout key
  data(lo_layout) = go_alv->get_layout( ).
  lo_layout->set_key( value #( report = sy-repid ) ).

  " Allow variant saving
  lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
  lo_layout->set_default( abap_true  ).

endform.


*&---------------------------------------------------------------------*
*&      Form  SET_EVENT
*&---------------------------------------------------------------------*
*       Set on click event for transaction IE02
*----------------------------------------------------------------------*
form set_event .
  try.
      go_event_handler = new #( ).

      data(lo_column_tab) = cast cl_salv_column_table(
      go_alv->get_columns( )->get_column( 'EQUNR' ) ).

      lo_column_tab->set_cell_type( if_salv_c_cell_type=>hotspot ).

      data(lo_events) = go_alv->get_event( ).
      set handler go_event_handler->on_link_click for lo_events.
    catch cx_salv_not_found.

  endtry.

endform.


*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       Display alv
*----------------------------------------------------------------------*
form display_alv .

  " Show ALV Grid
  go_alv->display( ).
endform.