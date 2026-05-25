CLASS zcl_work_order_validator_gba DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS validate_create_order
      IMPORTING
        iv_customer_id   TYPE zde_customer_id_gba
        iv_technician_id TYPE zde_technician_id_gba
        iv_priority      TYPE zde_priority_gba
      RETURNING
        VALUE(rv_valid)  TYPE abap_bool.

    METHODS validate_update_order
      IMPORTING
        iv_work_order_id TYPE zde_work_order_id_gba
      RETURNING
        VALUE(rv_valid)  TYPE abap_bool.

    METHODS validate_delete_order
      IMPORTING
        iv_work_order_id TYPE zde_work_order_id_gba
      RETURNING
        VALUE(rv_valid)  TYPE abap_bool.

    METHODS validate_status_and_priority
      IMPORTING
        iv_status       TYPE zde_status_gba
        iv_priority     TYPE zde_priority_gba
      RETURNING
        VALUE(rv_valid) TYPE abap_bool.

  PRIVATE SECTION.

    METHODS check_customer_exists
      IMPORTING
        iv_customer_id  TYPE zde_customer_id_gba
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

    METHODS check_technician_exists
      IMPORTING
        iv_technician_id TYPE zde_technician_id_gba
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

    METHODS check_order_exists
      IMPORTING
        iv_work_order_id TYPE zde_work_order_id_gba
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

    METHODS check_order_has_history
      IMPORTING
        iv_work_order_id TYPE zde_work_order_id_gba
      RETURNING
        VALUE(rv_exists) TYPE abap_bool.

    METHODS check_status_is_valid
      IMPORTING
        iv_status       TYPE zde_status_gba
      RETURNING
        VALUE(rv_valid) TYPE abap_bool.

    METHODS check_priority_is_valid
      IMPORTING
        iv_priority     TYPE zde_priority_gba
      RETURNING
        VALUE(rv_valid) TYPE abap_bool.

    METHODS get_order_status
      IMPORTING
        iv_work_order_id TYPE zde_work_order_id_gba
      RETURNING
        VALUE(rv_status) TYPE zde_status_gba.

ENDCLASS.


CLASS zcl_work_order_validator_gba IMPLEMENTATION.

  METHOD validate_create_order.

    rv_valid = abap_false.

    IF iv_customer_id IS INITIAL
       OR iv_technician_id IS INITIAL
       OR iv_priority IS INITIAL.
      RETURN.
    ENDIF.

    IF check_customer_exists( iv_customer_id ) = abap_false.
      RETURN.
    ENDIF.

    IF check_technician_exists( iv_technician_id ) = abap_false.
      RETURN.
    ENDIF.

    IF check_priority_is_valid( iv_priority ) = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


  METHOD validate_update_order.

    rv_valid = abap_false.

    IF iv_work_order_id IS INITIAL.
      RETURN.
    ENDIF.

    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    DATA(lv_status) = get_order_status( iv_work_order_id ).

    IF lv_status <> 'PE'.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


  METHOD validate_delete_order.

    rv_valid = abap_false.

    IF iv_work_order_id IS INITIAL.
      RETURN.
    ENDIF.

    IF check_order_exists( iv_work_order_id ) = abap_false.
      RETURN.
    ENDIF.

    DATA(lv_status) = get_order_status( iv_work_order_id ).

    IF lv_status <> 'PE'.
      RETURN.
    ENDIF.

    IF check_order_has_history( iv_work_order_id ) = abap_true.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


  METHOD validate_status_and_priority.

    rv_valid = abap_false.

    IF check_status_is_valid( iv_status ) = abap_false.
      RETURN.
    ENDIF.

    IF check_priority_is_valid( iv_priority ) = abap_false.
      RETURN.
    ENDIF.

    rv_valid = abap_true.

  ENDMETHOD.


  METHOD check_customer_exists.

    SELECT SINGLE FROM zcustomer_gba
      FIELDS @abap_true
      WHERE customer_id = @iv_customer_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_technician_exists.

    SELECT SINGLE FROM ztechnician_gba
      FIELDS @abap_true
      WHERE technician_id = @iv_technician_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_order_exists.

    SELECT SINGLE FROM zworkorder_gba
      FIELDS @abap_true
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_order_has_history.

    SELECT SINGLE FROM zwork_ord_hi_gba
      FIELDS @abap_true
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_exists.

    IF sy-subrc <> 0.
      rv_exists = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_status_is_valid.

    SELECT SINGLE FROM zstatus_gba
      FIELDS @abap_true
      WHERE status_code = @iv_status
      INTO @rv_valid.

    IF sy-subrc <> 0.
      rv_valid = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD check_priority_is_valid.

    SELECT SINGLE FROM zpriority_gba
      FIELDS @abap_true
      WHERE priority_code = @iv_priority
      INTO @rv_valid.

    IF sy-subrc <> 0.
      rv_valid = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD get_order_status.

    SELECT SINGLE FROM zworkorder_gba
      FIELDS status
      WHERE work_order_id = @iv_work_order_id
      INTO @rv_status.

  ENDMETHOD.

ENDCLASS.
