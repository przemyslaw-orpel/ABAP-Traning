*&---------------------------------------------------------------------*
*& Report  ZHTML_CONTAINER
*&
*&---------------------------------------------------------------------*
*&  Sample using HTML in CL_GUI_CONTAINER + HTML Event
*&  Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zhtml_container.

data: s100_ok type syst_ucomm.

class lc_screen definition.
  public section.
    class-data:
     screen type ref to lc_screen.
    class-methods:
      create_screen.
    methods:
      constructor.
  private section.
    methods:
      split_screen,
      create_html,
      set_hanlder,
      display_html,
      on_sapevent for event sapevent of cl_abap_browser importing action.
    data:
      gv_html     type string,
      go_splitter type ref to cl_gui_splitter_container,
      go_header   type ref to cl_gui_container,
      go_main     type ref to cl_gui_container.
endclass.
class lc_screen implementation.
  method constructor.
    me->split_screen( ).
    me->create_html( ).
    me->set_hanlder( ).
    me->display_html( ).
  endmethod.
  method create_screen.
    if screen is initial.
      screen = new #( ).
    endif.
  endmethod.
  method split_screen.
    " Create splitter
    go_splitter = new #( parent = cl_gui_container=>default_screen
                         rows = 2
                         columns = 1 ).
    " Set first row height 10%
    go_splitter->set_row_height( id = 1 height = 10 ).

    " Set containers
    go_header = go_splitter->get_container( row = 1 column = 1 ).
    go_main = go_splitter->get_container( row = 2 column = 1 ).
  endmethod.
  method create_html.
    " Set html
    gv_html = |<html><body style="background: #0A2647; font-family: Arial;">| &
              |<h2 style="color:#D2E9E9;">Sample using HTML in CL_GUI_CONTAINER</h2>| &
              |<a style="color:#D2E9E9;" href=SAPEVENT:"ClickEvent">Click event</a></body></html>|.
  endmethod.
  method set_hanlder.
    "Register handler
    set handler on_sapevent.
  endmethod.
  method display_html.
    " Display html
    cl_abap_browser=>show_html(
      container = go_header
      html_string = gv_html
      modal = abap_false
      check_html = abap_false
      context_menu = abap_false  ).
  endmethod.
  method on_sapevent.
    message action type 'S'.
  endmethod.
endclass.

start-of-selection.
  call screen 100. " Set s100_ok element

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