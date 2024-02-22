class zcl_mailer definition public final create public .
  public section.
    class-data:
      mailer type ref to zcl_mailer.
    class-methods:
      send_mail
        importing
                  ip_content     type string
                  ip_cont_descr  type string
                  ip_subject     type string
                  ip_recipent    type string
                  ip_sender      type syst_uname
        returning value(rp_sent) type abap_bool.
    methods:
      constructor.
  private section.
    methods:
      set_content
        importing
          ip_content    type string
          ip_cont_descr type string,
      set_subject importing ip_subject type string,
      set_sender importing ip_sender type syst_uname,
      set_recipent importing ip_recipent type string.

    data: gr_mail        type ref to cl_bcs,
          gr_mime_helper type ref to cl_gbt_multirelated_service,
          gv_sended      type abap_bool.
ENDCLASS.



CLASS ZCL_MAILER IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_MAILER->CONSTRUCTOR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method constructor.
    try.
        gr_mail = cl_bcs=>create_persistent( ).
        gr_mime_helper = new #( ).
      catch cx_send_req_bcs.
    endtry.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_MAILER=>SEND_MAIL
* +-------------------------------------------------------------------------------------------------+
* | [--->] IP_CONTENT                     TYPE        STRING
* | [--->] IP_CONT_DESCR                  TYPE        STRING
* | [--->] IP_SUBJECT                     TYPE        STRING
* | [--->] IP_RECIPENT                    TYPE        STRING
* | [--->] IP_SENDER                      TYPE        SYST_UNAME
* | [<-()] RP_SENT                        TYPE        ABAP_BOOL
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method send_mail.
    if mailer is initial.
      mailer = new #( ).
    endif.
    try.
        mailer->set_content( ip_content = ip_content ip_cont_descr = ip_cont_descr ).
        mailer->set_subject( ip_subject ).
        mailer->set_sender( ip_sender ).
        mailer->set_recipent( ip_recipent ).

        "Send mail and return rp_sent
        mailer->gr_mail->send( receiving result = rp_sent ).
        commit work.
      catch cx_send_req_bcs.
        rollback work.
    endtry.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAILER->SET_CONTENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IP_CONTENT                     TYPE        STRING
* | [--->] IP_CONT_DESCR                  TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method set_content.
    data: lv_describe type so_obj_des.
    lv_describe = ip_cont_descr.
    "Create mail content
    data(lt_soli) = cl_document_bcs=>string_to_soli( ip_content ).

    "Set HTML body
    gr_mime_helper->set_main_html( content = lt_soli description = lv_describe ).
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAILER->SET_RECIPENT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IP_RECIPENT                    TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method set_recipent.
    data: lv_recipent type adr6-smtp_addr.
    lv_recipent = ip_recipent.
    try.
        "Set recipent
        data(lo_recipient) = cl_cam_address_bcs=>create_internet_address( lv_recipent ).
        gr_mail->add_recipient( lo_recipient ).
      catch cx_send_req_bcs cx_address_bcs.
    endtry.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAILER->SET_SENDER
* +-------------------------------------------------------------------------------------------------+
* | [--->] IP_SENDER                      TYPE        SYST_UNAME
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method set_sender.
    "Set mail sender
    try.
        data(lo_sender) = cl_sapuser_bcs=>create( ip_sender ).
        me->gr_mail->set_sender( lo_sender ).
      catch cx_send_req_bcs cx_address_bcs.
    endtry.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_MAILER->SET_SUBJECT
* +-------------------------------------------------------------------------------------------------+
* | [--->] IP_SUBJECT                     TYPE        STRING
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method set_subject.
    data: lv_subject type so_obj_des.
    lv_subject = ip_subject.
    try.
        "Set mail subject
        data(lo_doc_bcs) = cl_document_bcs=>create_from_multirelated(
                            i_subject = lv_subject
                            i_multirel_service = gr_mime_helper ).

        me->gr_mail->set_document( lo_doc_bcs ).
      catch cx_send_req_bcs cx_gbt_mime cx_bcom_mime cx_document_bcs.
    endtry.
  endmethod.
ENDCLASS.