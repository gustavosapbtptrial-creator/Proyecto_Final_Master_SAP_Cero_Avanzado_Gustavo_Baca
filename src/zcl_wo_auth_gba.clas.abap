CLASS zcl_wo_auth_gba DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS can_create_order
      RETURNING VALUE(rv_allowed) TYPE abap_bool.

    METHODS can_read_order
      RETURNING VALUE(rv_allowed) TYPE abap_bool.

    METHODS can_update_order
      RETURNING VALUE(rv_allowed) TYPE abap_bool.

    METHODS can_delete_order
      RETURNING VALUE(rv_allowed) TYPE abap_bool.

ENDCLASS.


CLASS zcl_wo_auth_gba IMPLEMENTATION.

  METHOD can_create_order.

    AUTHORITY-CHECK OBJECT 'ZWOAUTHGBA'
      ID 'ACTVT' FIELD '01'.

    rv_allowed = xsdbool( sy-subrc = 0 ).

  ENDMETHOD.


  METHOD can_read_order.

    AUTHORITY-CHECK OBJECT 'ZWOAUTHGBA'
      ID 'ACTVT' FIELD '03'.

    rv_allowed = xsdbool( sy-subrc = 0 ).

  ENDMETHOD.


  METHOD can_update_order.

    AUTHORITY-CHECK OBJECT 'ZWOAUTHGBA'
      ID 'ACTVT' FIELD '02'.

    rv_allowed = xsdbool( sy-subrc = 0 ).

  ENDMETHOD.


  METHOD can_delete_order.

    AUTHORITY-CHECK OBJECT 'ZWOAUTHGBA'
      ID 'ACTVT' FIELD '06'.

    rv_allowed = xsdbool( sy-subrc = 0 ).

  ENDMETHOD.

ENDCLASS.
