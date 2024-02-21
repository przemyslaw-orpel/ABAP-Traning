"Author: Przemyslaw Orpel
class zcl_noti_service definition
  public
  final
  create public .

  public section.

    interfaces if_http_extension .

    methods read_noti
      importing
        !ip_qmnum      type qmnum
      returning
        value(rp_json) type string .
  protected section.
  private section.
ENDCLASS.



CLASS ZCL_NOTI_SERVICE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_NOTI_SERVICE->IF_HTTP_EXTENSION~HANDLE_REQUEST
* +-------------------------------------------------------------------------------------------------+
* | [--->] SERVER                         TYPE REF TO IF_HTTP_SERVER
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_http_extension~handle_request.
    constants: lc_qmnum type string value 'qmnum'.

    data: lt_inparams type tihttpnvp,
          ls_inparam  type ihttpnvp,
          lv_qmnum    type qmnum.

    "Check request method
    if server->request->get_header_field( '~request_method' ) ne 'GET'.
      server->response->set_header_field( name = 'Allow' value = 'GET' ).
      server->response->set_status( code = '405' reason = 'Method not allowed' ).
      return.
    endif.

    "Read params
    server->request->get_form_fields( changing fields = lt_inparams ).
    read table lt_inparams into ls_inparam with table key name = lc_qmnum.

    "Cast param value to qmnum
    lv_qmnum = ls_inparam-value.

    "Create json
    data(lv_json) = read_noti( lv_qmnum ).
    server->response->set_cdata( data = lv_json ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_NOTI_SERVICE->READ_NOTI
* +-------------------------------------------------------------------------------------------------+
* | [--->] IP_QMNUM                       TYPE        QMNUM
* | [<-()] RP_JSON                        TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method read_noti.
    "Read notification data from DB
    select distinct * from viqmel
      into @data(ls_viqmel)
      where qmnum = @ip_qmnum.
    endselect.

    "Retrun JSON
    rp_json = /ui2/cl_json=>serialize( data = ls_viqmel ).
  endmethod.
ENDCLASS.