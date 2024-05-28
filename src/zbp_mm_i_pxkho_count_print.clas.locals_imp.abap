CLASS lhc_zmm_i_pxkho_count_print DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zmm_i_pxkho_count_print RESULT result.

ENDCLASS.

CLASS lhc_zmm_i_pxkho_count_print IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
