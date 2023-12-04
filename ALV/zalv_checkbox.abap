*&---------------------------------------------------------------------*
*& Report  ZALV_CHEKBOX
*&
*&---------------------------------------------------------------------*
*& Sample CL_SALV_TABLE colum checkbox OOP
*& Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zalv_chekbox.

data: s100_ok type syst_ucomm.

class lc_screen definition.
  public section.
    class-data:
      screen type ref to lc_screen.
    class-methods:
      create_screen.
    methods:
      constructor,
      select_data,
      create_alv,
      set_columns_setting,
      create_button,
      set_handler,
      display_alv,
      on_button_click for event added_function of cl_salv_events,
      on_link_click for event link_click of cl_salv_events_table importing row column.

  private section.
    types: begin of ty_equi_view,
             chkbox type flag,
             equnr  type equnr,
             eqktx  type ktx01,
             ernam  type ernam,
             erdat  type erdat,
           end of ty_equi_view.
    data:
      go_alv  type ref to cl_salv_table,
      gt_equi type table of ty_equi_view.

endclass.

class lc_screen implementation.
  method constructor.
    me->select_data( ).
    me->create_alv( ).
    me->set_columns_setting( ).
    me->set_handler( ).
    me->create_button( ).
    me->display_alv( ).

  endmethod.

  method create_screen.
    if screen is initial.
      screen = new #( ).
    endif.
  endmethod.

  method select_data.
    " Select data from DB
    select * from equi join eqkt on equi~equnr = eqkt~equnr
      into corresponding fields of table @gt_equi.
  endmethod.

  method create_alv.
    " Create ALV instance
    try.
        cl_salv_table=>factory(
          exporting
          r_container = cl_gui_container=>default_screen
          importing
            r_salv_table = go_alv
            changing
              t_table = gt_equi ).
      catch cx_salv_msg into data(lx_error).
        message lx_error->get_text( ) type 'E'.
    endtry.
  endmethod.

  method set_columns_setting.
    " Set checkbox
    try.
        data(lo_chk_col) = cast cl_salv_column_table( go_alv->get_columns( )->get_column( 'CHKBOX' ) ).
        lo_chk_col->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ).
      catch cx_salv_not_found into data(lx_error).
        message lx_error->get_text( ) type 'E'.
    endtry.

    " Optimalize columns width
    go_alv->get_columns( )->set_optimize( ).
  endmethod.

  method create_button.
    " Add custom button
    try.
        go_alv->get_functions( )->add_function(
        name = 'READEQUI'
        icon = conv string( icon_check )
        text = 'Checked equnr'
        tooltip = 'Checked equnr'
        position = if_salv_c_function_position=>right_of_salv_functions ).
      catch cx_salv_existing cx_salv_wrong_call into data(lx_error).
        message lx_error->get_text( ) type 'E'.
    endtry.
  endmethod.

  method set_handler.
    data(lo_event) = go_alv->get_event( ).
    set handler me->on_link_click for lo_event.
    set handler me->on_button_click for lo_event.
  endmethod.

  method on_link_click.
    " check or uncheck checkbox
    read table gt_equi assigning field-symbol(<fs_row>) index  row.
    if <fs_row>-chkbox is initial.
      <fs_row>-chkbox = 'X'.
    else.
      clear <fs_row>-chkbox.
    endif.

    " Refresh alv
    go_alv->refresh( ).

  endmethod.

  method on_button_click.
    "Read checked equnr
    data: lt_equnr type table of equnr.
    loop at gt_equi into data(ls_row).
      if ls_row-chkbox eq 'X'.
        append ls_row-equnr to lt_equnr.
      endif.
    endloop.

  endmethod.

  method display_alv.
    " Show ALV
    go_alv->display( ).
  endmethod.
endclass.

start-of-selection.
  call screen 100.


*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       PBO
*----------------------------------------------------------------------*
module status_0100 output.
  set pf-status 'STATUS_100'.
  set titlebar 'TITLE_100'.
  lc_screen=>create_screen( ).
endmodule.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       PAI
*----------------------------------------------------------------------*
module user_command_0100 input.
  case s100_ok.
    when 'ABORT'.
      leave program.
  endcase.
endmodule.