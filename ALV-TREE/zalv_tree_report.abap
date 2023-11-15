*&---------------------------------------------------------------------*
*& Report  ZALV_TREE_REPORT
*&
*&---------------------------------------------------------------------*
*& Simply CL_SALV_TREE example
*& Author: Przemyslaw Orpel
*&---------------------------------------------------------------------*
report zalv_tree_report.


types: begin of ty_tree_tab,
         parent type i,
         child  type i,
         name   type string,
       end of ty_tree_tab.

field-symbols: <fs_line> type ty_tree_tab.

data:
  go_alv_tree  type ref to cl_salv_tree,
  gt_empty_tab type table of ty_tree_tab,
  gt_tree_tab  type table of ty_tree_tab.

start-of-selection.
  perform select_data.
  perform create_tree.
  perform create_nodes.
  perform set_toolbar.
  perform set_column_settings.
  perform display_tree.

*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       Generete data for alv tree table
*----------------------------------------------------------------------*
form select_data .
  data: ls_row  type ty_tree_tab,
        lv_i    type i value 0,
        lv_j    type i value 1,
        lv_name type string.

  ls_row-parent = lv_i.
  ls_row-child = lv_j.
  ls_row-name = | Node: { lv_i }.{ lv_j }|.
  append ls_row to gt_tree_tab.


  do 4 times.
    add 1 to lv_i.
    do 3 times.
      add 1 to lv_j.
      ls_row-parent = lv_i.
      ls_row-child = lv_j.
      lv_name = |Node: { lv_i }.{ lv_j }|.

      ls_row-name = lv_name.
      append ls_row to gt_tree_tab.
    enddo.
  enddo.

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
  data:
    lo_node          type ref to cl_salv_node,
    lv_expand_icon   type salv_de_tree_image,
    lv_collapse_icon type salv_de_tree_image,
    lv_hier_icon     type salv_de_tree_image.

  " Set tree structure icon
  lv_expand_icon = icon_expand_all.
  lv_collapse_icon = icon_collapse_all.
  lv_hier_icon = icon_tree.

  " Get nodes from alv tree
  data(lo_nodes) = go_alv_tree->get_nodes( ).

  " Sort tree table
  sort gt_tree_tab by parent child .

  " Filling the tree
  loop at gt_tree_tab assigning <fs_line>.
    try.
        if <fs_line>-parent eq 0.
          " Add first node

          lo_node = lo_nodes->add_node(
                                   related_node   = ''
                                   relationship   = cl_gui_column_tree=>relat_last_child
                                   collapsed_icon = lv_expand_icon
                                   expanded_icon  = lv_collapse_icon
                                   data_row       = <fs_line>
                                   text           = |{ <fs_line>-name } | ).
        else.
          " Add related note, node key is <fs_line>-parent
          lo_node = lo_nodes->add_node(
                                   related_node   = conv #( <fs_line>-parent )
                                   relationship   = cl_gui_column_tree=>relat_last_child
                                   data_row       = <fs_line>
                                   text           = |{ <fs_line>-name } | ).
        endif.
      catch cx_salv_msg.
        message 'Create nodes error' type 'E'.
    endtry.
  endloop.
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
*&      Form  SET_COLUMN_SETTINGS
*&---------------------------------------------------------------------*
*       Set tree header alv
*       Optimalize column width
*----------------------------------------------------------------------*
form set_column_settings .
  data: lv_hier_icon type salv_de_tree_image value icon_tree.

  "  Set tree header alv
  data(lo_settings) = go_alv_tree->get_tree_settings( ).
  lo_settings->set_hierarchy_header( 'Node Header' ).
  lo_settings->set_hierarchy_icon( lv_hier_icon ).

  " Optimalize column
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