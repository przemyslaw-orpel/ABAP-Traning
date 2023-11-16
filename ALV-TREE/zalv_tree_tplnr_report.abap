*&---------------------------------------------------------------------*
*& Report  ZALV_TREE_TPLNR_REPORT
*&
*&---------------------------------------------------------------------*
*&  Example alv tree using tplnr hierarchy with tplnr short texts
*&  Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zalv_tree_report.


types: begin of ty_tree_tab,
         node_key    type i,  "tplnr
         node_parent type i,  "tplma
         tplnr       type tplnr,
         pltxt       type pltxt,
       end of ty_tree_tab.

field-symbols: <fs_line> type ty_tree_tab.

data:
  go_alv_tree      type ref to cl_salv_tree,
  gt_empty_tab     type table of ty_tree_tab,
  gt_tree_tab      type table of ty_tree_tab,
  gv_expand_icon   type salv_de_tree_image,
  gv_collapse_icon type salv_de_tree_image,
  gv_hier_icon     type salv_de_tree_image.

start-of-selection.
  perform select_data.
  perform create_tree.
  perform create_nodes.
  perform set_toolbar.
  perform hide_column.
  perform set_column_settings.
  perform display_tree.

*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       Generete hierarchy data for alv tree table
*----------------------------------------------------------------------*
form select_data .
  types: begin of ty_tplnr_key,
           tplma    type tplma,
           node_key type i,
         end of ty_tplnr_key.

  data: lt_tplnr_key type table of  ty_tplnr_key,
        lt_iflot     type table of iflot,
        lv_node_key  type i,
        lv_parent    type i.

  " Select data from DB
  select distinct * from iflot
    into table lt_iflot order by tplma tplnr.

  " Set node key to tplnr
  loop at lt_iflot into data(lv_tplma).
    append value ty_tplnr_key( tplma = lv_tplma-tplnr
                               node_key = sy-tabix ) to lt_tplnr_key.
  endloop.

  " Set node_key and parent for tplnr
  loop at lt_iflot into data(lv_iflot).
    lv_node_key = 0.
    lv_parent = 0.

    " Find node key (tplnr)
    read table lt_tplnr_key into data(wa_tplnr_key)
       with table key tplma = lv_iflot-tplnr.
    if sy-subrc eq 0.
      lv_parent = wa_tplnr_key-node_key.
    endif.

    " Find parent key (tplma)
    read table lt_tplnr_key into wa_tplnr_key
       with table key tplma = lv_iflot-tplma.
    if sy-subrc eq 0.
      lv_node_key = wa_tplnr_key-node_key.
    endif.

    " Add row to tree table
    append value ty_tree_tab(
        node_key    =  lv_parent
        node_parent = lv_node_key
        tplnr       = lv_iflot-tplnr ) to gt_tree_tab.
  endloop.

  " Fill short texts (pltxt)
  loop at gt_tree_tab  assigning field-symbol(<fs_tree_tab>).
    select single pltxt from iflotx
      into <fs_tree_tab>-pltxt
      where tplnr = <fs_tree_tab>-tplnr.
  endloop.

  " Important! Sort tree tabel by node_key and parent
  sort gt_tree_tab by node_key node_parent.
endform.


*&---------------------------------------------------------------------*
*&      Form  CREATE_TREE(
*&---------------------------------------------------------------------*
*       Create ALV TREE object with empty tree table
*----------------------------------------------------------------------*
form create_tree.
  try.
      cl_salv_tree=>factory(
        importing
          r_salv_tree = go_alv_tree
        changing
          t_table     = gt_empty_tab ).
    catch cx_salv_error into data(gx_alv_error).
      message gx_alv_error->get_text( ) type 'E'.
  endtry.
endform.


*&---------------------------------------------------------------------*
*&      Form  CREATE_NODES
*&---------------------------------------------------------------------*
*       Create parent/child nodes
*----------------------------------------------------------------------*
form create_nodes .
  data:  lo_node type ref to cl_salv_node.

  " Set tree structure icon
  gv_expand_icon = icon_expand_all.
  gv_collapse_icon = icon_collapse_all.
  gv_hier_icon = icon_tree.

  " Get nodes from alv tree
  data(lo_nodes) = go_alv_tree->get_nodes( ).

  " Filling the tree
  try.
      loop at gt_tree_tab assigning <fs_line>.
        if <fs_line>-node_parent eq 0.
          " Add first nodes
          lo_node = lo_nodes->add_node(
                                related_node   = ''
                                relationship   = cl_gui_column_tree=>relat_last_child
                                collapsed_icon = gv_expand_icon
                                expanded_icon  = gv_collapse_icon
                                data_row       = <fs_line>
                                row_style      = if_salv_c_tree_style=>emphasized_a
                                text           = | { <fs_line>-tplnr }| ).
        else.
          lo_node = lo_nodes->add_node(
                                 related_node   = conv #( <fs_line>-node_parent )
                                 relationship   = cl_gui_column_tree=>relat_last_child
                                 collapsed_icon = gv_expand_icon
                                 expanded_icon  = gv_collapse_icon
                                 data_row       = <fs_line>
                                 row_style      = if_salv_c_tree_style=>emphasized_a
                                 text           = | { <fs_line>-tplnr }| ).
        endif.
      endloop.
    catch cx_salv_msg into data(gx_alv_error).
      message gx_alv_error->get_text( ) type 'E'.
  endtry.
endform.


*&---------------------------------------------------------------------*
*&      Form  SET_TOOLBAR
*&---------------------------------------------------------------------*
*       Set toolbar - all functions
*----------------------------------------------------------------------*
form set_toolbar .
  go_alv_tree->get_functions( )->set_all( ).
endform.


*&---------------------------------------------------------------------*
*&      Form  HIDE_COLUMN
*&---------------------------------------------------------------------*
*       Hide NOTE_KEY and PARENT column
*----------------------------------------------------------------------*
form hide_column .
  try.
      data(lo_note_col) = go_alv_tree->get_columns( )->get_column( 'NODE_KEY' ).
      lo_note_col->set_visible( abap_false ).

      data(lo_parent_col) = go_alv_tree->get_columns( )->get_column( 'NODE_PARENT' ).
      lo_parent_col->set_visible( abap_false ).

    catch cx_salv_not_found into data(gx_alv_error).
      message gx_alv_error->get_text( ) type 'E'.
  endtry.
endform.


*&---------------------------------------------------------------------*
*&      Form  SET_COLUMN_SETTINGS
*&---------------------------------------------------------------------*
*       Set tree header alv
*       Optimalize column width
*----------------------------------------------------------------------*
form set_column_settings .
  "  Set tree header alv
  data(lo_settings) = go_alv_tree->get_tree_settings( ).
  lo_settings->set_hierarchy_header( 'TPLNR TREE' ).
  lo_settings->set_hierarchy_size( 40 ).
  lo_settings->set_hierarchy_icon( gv_hier_icon ).

  " Optimalize column width
  go_alv_tree->get_columns( )->set_optimize( ).
endform.


*&---------------------------------------------------------------------*
*&      Form  DISPLAY_TREE
*&---------------------------------------------------------------------*
*       Display ALV Tree grid
*----------------------------------------------------------------------*
form display_tree .
  " Show alv tree
  go_alv_tree->display( ).
endform.