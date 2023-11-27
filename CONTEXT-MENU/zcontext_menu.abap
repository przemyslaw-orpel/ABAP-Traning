*&---------------------------------------------------------------------*
*& Report  ZCONTEXT_MENU
*&
*&---------------------------------------------------------------------*
*& Example custom context menu (right mouse click on cell)
*& Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zcontext_menu.

class lcl_alv_event definition deferred.

" Declaration of the global variables
data:
  s100_ok      type syst_ucomm,
  gt_equi      type standard table of equi,
  go_alv_grid  type ref to cl_gui_alv_grid,
  gt_field_cat type lvc_t_fcat,
  go_event     type ref to lcl_alv_event.


class lcl_alv_event definition.
  public section.
    methods:
      on_context_req for event context_menu_request of cl_gui_alv_grid importing e_object,
      on_select_menu for event user_command  of cl_gui_alv_grid importing e_ucomm sender.

endclass.

class lcl_alv_event implementation.
  method on_context_req .
    " Clear all functions
    e_object->clear( ).

    " Add custom functions
    e_object->add_function( fcode = 'IE02' text = 'Edit equipment').
    e_object->add_function( fcode = 'IE03' text = 'Details equiment').

  endmethod.

  method on_select_menu.
    data:
      lv_equi type equi,
      ls_row  type lvc_s_row,
      ls_col  type lvc_s_col.

    " Get cell which was clicked
    call method go_alv_grid->get_current_cell
      importing
        es_row_id = ls_row
        es_col_id = ls_col.

    " Read equnr
    read table gt_equi into lv_equi index ls_row.

    " Parametr transaction IE02/IE03
    set parameter id: 'EQN' field lv_equi-equnr.
    call transaction e_ucomm and skip first screen.

  endmethod.
endclass.

start-of-selection.
  " Select data from DB
  select * from equi into table gt_equi.

  " Create CL_GUI_ALV_GRID Instance
  go_alv_grid = new #( i_parent = cl_gui_container=>default_screen ).

  " Build field catalog
  call function 'LVC_FIELDCATALOG_MERGE'
    exporting
      i_structure_name = 'EQUI'
    changing
      ct_fieldcat      = gt_field_cat.

  " Call the ALV
  go_alv_grid->set_table_for_first_display(
    changing
      it_outtab = gt_equi
      it_fieldcatalog = gt_field_cat ).

  " Register event
  go_event = new #( ).
  "Set handler for right click
  set handler go_event->on_context_req for go_alv_grid.

  "Set handler for select function menu
  set handler go_event->on_select_menu for go_alv_grid.

  "Display the ALV
  call screen 100.  "set s100_ok element


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       PBO
*----------------------------------------------------------------------*
module status_0100 output.
  set pf-status 'STATUS_100'.
  set titlebar 'TITLE_100'.
endmodule.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       PAI
*----------------------------------------------------------------------*
module user_command_0100 input.
  case s100_ok.
    when 'EXIT'.
      set screen 0.
      leave program.
  endcase.
endmodule.