"Work order update badi example
"Author: Przemyslaw Orpel
class zcl_im_pm_woupdate definition
  public
  final
  create public .

  public section.

    interfaces if_badi_interface .
    interfaces if_ex_workorder_update .
  protected section.
  private section.
ENDCLASS.



CLASS ZCL_IM_PM_WOUPDATE IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~ARCHIVE_OBJECTS
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_AUFNR                        TYPE        CAUFVD-AUFNR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~archive_objects.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~AT_DELETION_FROM_DATABASE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_AUFK                        TYPE        TABLE
* | [--->] IT_AUTYP                       TYPE        AUFK-AUTYP
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~at_deletion_from_database.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~AT_RELEASE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_AKTYP                        TYPE        RC27S-AKTYP
* | [--->] I_NO_DIALOG                    TYPE        C (default =SPACE)
* | [--->] I_FLG_COL_RELEASE              TYPE        C (default =SPACE)
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [EXC!] FREE_FAILED_ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~at_release.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~AT_SAVE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [EXC!] ERROR_WITH_MESSAGE
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~at_save.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~BEFORE_UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER                      TYPE        COBAI_T_HEADER(optional)
* | [--->] IT_HEADER_OLD                  TYPE        COBAI_T_HEADER_OLD(optional)
* | [--->] IT_ITEM                        TYPE        COBAI_T_ITEM(optional)
* | [--->] IT_ITEM_OLD                    TYPE        COBAI_T_ITEM_OLD(optional)
* | [--->] IT_SEQUENCE                    TYPE        COBAI_T_SEQUENCE(optional)
* | [--->] IT_SEQUENCE_OLD                TYPE        COBAI_T_SEQUENCE_OLD(optional)
* | [--->] IT_OPERATION                   TYPE        COBAI_T_OPERATION(optional)
* | [--->] IT_OPERATION_OLD_AFVC          TYPE        COBAI_T_OPERATION_OLD_AFVC(optional)
* | [--->] IT_OPERATION_OLD_AFVV          TYPE        COBAI_T_OPERATION_OLD_AFVV(optional)
* | [--->] IT_OPERATION_OLD_AFVU          TYPE        COBAI_T_OPERATION_OLD_AFVU(optional)
* | [--->] IT_COMPONENT                   TYPE        COBAI_T_COMPONENT(optional)
* | [--->] IT_COMPONENT_OLD               TYPE        COBAI_T_COMPONENT_OLD(optional)
* | [--->] IT_RELATIONSHIP                TYPE        COBAI_T_RELATIONSHIP(optional)
* | [--->] IT_RELATIONSHIP_OLD            TYPE        COBAI_T_RELATIONSHIP_OLD(optional)
* | [--->] IT_PSTEXT                      TYPE        COBAI_T_PSTEXT(optional)
* | [--->] IT_PSTEXT_OLD                  TYPE        COBAI_T_PSTEXT_OLD(optional)
* | [--->] IT_MILESTONE                   TYPE        COBAI_T_MILESTONE(optional)
* | [--->] IT_MILESTONE_OLD               TYPE        COBAI_T_MILESTONE_OLD(optional)
* | [--->] IT_PLANNED_ORDER               TYPE        COBAI_T_PLANNED_ORDER(optional)
* | [--->] IT_STATUS                      TYPE        COBAI_T_STATUS(optional)
* | [--->] IT_STATUS_OLD                  TYPE        COBAI_T_STATUS_OLD(optional)
* | [--->] IT_OPR_RELATIONS               TYPE        COBAI_T_OPR_RELATIONS(optional)
* | [--->] IT_OPR_RELATIONS_OLD           TYPE        COBAI_T_OPR_RELATIONS_OLD(optional)
* | [--->] IT_DOCLINK                     TYPE        COBAI_T_DOCLINK(optional)
* | [--->] IT_DOCLINK_OLD                 TYPE        COBAI_T_DOCLINK_OLD(optional)
* | [--->] IT_PRT_ALLOCATION              TYPE        COBAI_T_PRT_ALLOCATION(optional)
* | [--->] IT_PRT_ALLOCATION_OLD          TYPE        COBAI_T_PRT_ALLOCATION_OLD(optional)
* | [--->] IT_PMPARTNER                   TYPE        COBAI_T_PMPARTNER(optional)
* | [--->] IT_PMPARTNER_OLD               TYPE        COBAI_T_PMPARTNER_OLD(optional)
* | [--->] IT_PIINSTRUCTION               TYPE        COBAI_T_PIINSTRUCTION(optional)
* | [--->] IT_PIINSTRUCTIONVALUE          TYPE        COBAI_T_PIINSTRUCTIONVALUE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~before_update.
    "Check transaction
    if sy-tcode <> 'IW31' and sy-tcode <> 'IW21'.
      return.
    endif.

    "Read order header
    read table it_header into data(ls_header) index 1.

    data(lv_aufnr) = ls_header-aufnr.
    data(lv_ktext) = ls_header-ktext.
    data(lv_ernam) = ls_header-ernam .
    data(lv_erdate) = ls_header-erdat.
    data(lv_werks) = ls_header-werks.

    "Do something ...
    "Example add some data to database etc
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~CMTS_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_MATNR                        TYPE        AFPOD-MATNR
* | [--->] I_PROD_PLANT                   TYPE        AFPOD-DWERK
* | [--->] I_PLAN_PLANT                   TYPE        AFPOD-PWERK
* | [<-->] FLG_CMTS_ALLOWED               TYPE        FLAG
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~cmts_check.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~INITIALIZE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_CAUFVDB                     TYPE        CAUFVDB
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~initialize.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~IN_UPDATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_HEADER                      TYPE        COBAI_T_HEADER(optional)
* | [--->] IT_HEADER_OLD                  TYPE        COBAI_T_HEADER_OLD(optional)
* | [--->] IT_ITEM                        TYPE        COBAI_T_ITEM(optional)
* | [--->] IT_ITEM_OLD                    TYPE        COBAI_T_ITEM_OLD(optional)
* | [--->] IT_SEQUENCE                    TYPE        COBAI_T_SEQUENCE(optional)
* | [--->] IT_SEQUENCE_OLD                TYPE        COBAI_T_SEQUENCE_OLD(optional)
* | [--->] IT_OPERATION                   TYPE        COBAI_T_OPERATION(optional)
* | [--->] IT_OPERATION_OLD               TYPE        COBAI_T_OPERATION_OLD(optional)
* | [--->] IT_COMPONENT                   TYPE        COBAI_T_COMPONENT(optional)
* | [--->] IT_COMPONENT_OLD               TYPE        COBAI_T_COMPONENT_OLD(optional)
* | [--->] IT_DOCLINK                     TYPE        COBAI_T_DOCLINK(optional)
* | [--->] IT_DOCLINK_OLD                 TYPE        COBAI_T_DOCLINK_OLD(optional)
* | [--->] IT_PRT_ALLOCATION              TYPE        COBAI_T_PRT_ALLOCATION(optional)
* | [--->] IT_PRT_ALLOCATION_OLD          TYPE        COBAI_T_PRT_ALLOCATION_OLD(optional)
* | [--->] IT_MILESTONE                   TYPE        COBAI_T_MILESTONE(optional)
* | [--->] IT_MILESTONE_OLD               TYPE        COBAI_T_MILESTONE_OLD(optional)
* | [--->] IT_PLANNED_ORDER               TYPE        COBAI_T_PLANNED_ORDER(optional)
* | [--->] IT_RELATIONSHIP                TYPE        COBAI_T_RELATIONSHIP(optional)
* | [--->] IT_RELATIONSHIP_OLD            TYPE        COBAI_T_RELATIONSHIP_OLD(optional)
* | [--->] IT_PMPARTNER                   TYPE        COBAI_T_PMPARTNER(optional)
* | [--->] IT_PMPARTNER_OLD               TYPE        COBAI_T_PMPARTNER_OLD(optional)
* | [--->] IT_PSTEXT                      TYPE        COBAI_T_PSTEXT(optional)
* | [--->] IT_PSTEXT_OLD                  TYPE        COBAI_T_PSTEXT_OLD(optional)
* | [--->] IT_PIINSTRUCTION               TYPE        COBAI_T_PIINSTRUCTION(optional)
* | [--->] IT_PIINSTRUCTIONVALUE          TYPE        COBAI_T_PIINSTRUCTIONVALUE(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~in_update.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~NUMBER_SWITCH
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_AUFNR_OLD                    TYPE        CAUFVD-AUFNR
* | [--->] I_AUFNR_NEW                    TYPE        CAUFVD-AUFNR
* | [--->] I_AUFPL_OLD                    TYPE        CAUFVD-AUFPL
* | [--->] I_AUFPL_NEW                    TYPE        CAUFVD-AUFPL
* | [--->] I_AUTYP                        TYPE        AUFTYP(optional)
* | [<-->] I_AUFNR_CHANGE                 TYPE        CAUFVD-AUFNR(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~number_switch.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACTIVATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] I_ORDER_STATUS                 TYPE        CO_ORDER_STATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~reorg_status_activate.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACT_CHECK
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] I_ORDER_STATUS                 TYPE        CO_ORDER_STATUS
* | [EXC!] REORG_NOT_ALLOWED
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~reorg_status_act_check.
  endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_IM_PM_WOUPDATE->IF_EX_WORKORDER_UPDATE~REORG_STATUS_REVOKE
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_HEADER_DIALOG               TYPE        COBAI_S_HEADER_DIALOG
* | [--->] I_ORDER_STATUS                 TYPE        CO_ORDER_STATUS
* +--------------------------------------------------------------------------------------</SIGNATURE>
  method if_ex_workorder_update~reorg_status_revoke.
  endmethod.
ENDCLASS.