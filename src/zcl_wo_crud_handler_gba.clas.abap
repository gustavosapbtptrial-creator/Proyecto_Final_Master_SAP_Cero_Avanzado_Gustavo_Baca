CLASS zcl_wo_crud_handler_gba DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES ty_work_order TYPE zworkorder_gba.

    METHODS create_work_order
      IMPORTING
        is_work_order     TYPE ty_work_order
      RETURNING
        VALUE(rv_message) TYPE string.

    METHODS read_work_order
      IMPORTING
        iv_work_order_id  TYPE zde_work_order_id_gba
      RETURNING
        VALUE(rs_work_order) TYPE ty_work_order.

    METHODS update_work_order
      IMPORTING
        is_work_order     TYPE ty_work_order
      RETURNING
        VALUE(rv_message) TYPE string.

    METHODS delete_work_order
      IMPORTING
        iv_work_order_id  TYPE zde_work_order_id_gba
      RETURNING
        VALUE(rv_message) TYPE string.

  PRIVATE SECTION.

    DATA mo_validator TYPE REF TO zcl_work_order_validator_gba.

    METHODS get_next_history_id
      RETURNING
        VALUE(rv_history_id) TYPE zde_history_id_gba.

    METHODS insert_history
      IMPORTING
        iv_work_order_id      TYPE zde_work_order_id_gba
        iv_change_description TYPE zde_change_description_gba.

ENDCLASS.


CLASS zcl_wo_crud_handler_gba IMPLEMENTATION.

  METHOD create_work_order.

    mo_validator = NEW #( ).

    IF mo_validator->validate_create_order(
         iv_customer_id   = is_work_order-customer_id
         iv_technician_id = is_work_order-technician_id
         iv_priority      = is_work_order-priority ) = abap_false.

      rv_message = 'No se puede crear la orden. Cliente, técnico o prioridad no válidos.'.
      RETURN.

    ENDIF.

    IF mo_validator->validate_status_and_priority(
         iv_status   = is_work_order-status
         iv_priority = is_work_order-priority ) = abap_false.

      rv_message = 'No se puede crear la orden. Estado o prioridad no válidos.'.
      RETURN.

    ENDIF.

    SELECT SINGLE FROM zworkorder_gba
      FIELDS work_order_id
      WHERE work_order_id = @is_work_order-work_order_id
      INTO @DATA(lv_existing_order).

    IF sy-subrc = 0.
      rv_message = 'No se puede crear la orden. El ID de orden ya existe.'.
      RETURN.
    ENDIF.

    DATA(ls_work_order) = is_work_order.

    IF ls_work_order-creation_date IS INITIAL.
      ls_work_order-creation_date = cl_abap_context_info=>get_system_date( ).
    ENDIF.

    IF ls_work_order-status IS INITIAL.
      ls_work_order-status = 'PE'.
    ENDIF.

    INSERT zworkorder_gba FROM @ls_work_order.

    IF sy-subrc = 0.
      COMMIT WORK.
      rv_message = 'Orden de trabajo creada correctamente.'.
    ELSE.
      ROLLBACK WORK.
      rv_message = 'Error al crear la orden de trabajo.'.
    ENDIF.

  ENDMETHOD.


  METHOD read_work_order.

    CLEAR rs_work_order.

    SELECT SINGLE FROM zworkorder_gba
      FIELDS *
      WHERE work_order_id = @iv_work_order_id
      INTO @rs_work_order.

  ENDMETHOD.


  METHOD update_work_order.

    mo_validator = NEW #( ).

    IF mo_validator->validate_update_order(
         iv_work_order_id = is_work_order-work_order_id ) = abap_false.

      rv_message = 'No se puede actualizar la orden. No existe o no está en estado pendiente.'.
      RETURN.

    ENDIF.

    IF mo_validator->validate_status_and_priority(
         iv_status   = is_work_order-status
         iv_priority = is_work_order-priority ) = abap_false.

      rv_message = 'No se puede actualizar la orden. Estado o prioridad no válidos.'.
      RETURN.

    ENDIF.

    UPDATE zworkorder_gba
      SET customer_id   = @is_work_order-customer_id,
          technician_id = @is_work_order-technician_id,
          status        = @is_work_order-status,
          priority      = @is_work_order-priority,
          description   = @is_work_order-description
      WHERE work_order_id = @is_work_order-work_order_id.

    IF sy-subrc = 0.

      insert_history(
        iv_work_order_id      = is_work_order-work_order_id
        iv_change_description = 'Work order updated' ).

      COMMIT WORK.
      rv_message = 'Orden de trabajo actualizada correctamente.'.

    ELSE.

      ROLLBACK WORK.
      rv_message = 'Error al actualizar la orden de trabajo.'.

    ENDIF.

  ENDMETHOD.


  METHOD delete_work_order.

    mo_validator = NEW #( ).

    IF mo_validator->validate_delete_order(
         iv_work_order_id = iv_work_order_id ) = abap_false.

      rv_message = 'No se puede eliminar la orden. No existe, no está pendiente o tiene historial.'.
      RETURN.

    ENDIF.

    DELETE FROM zworkorder_gba
      WHERE work_order_id = @iv_work_order_id.

    IF sy-subrc = 0.
      COMMIT WORK.
      rv_message = 'Orden de trabajo eliminada correctamente.'.
    ELSE.
      ROLLBACK WORK.
      rv_message = 'Error al eliminar la orden de trabajo.'.
    ENDIF.

  ENDMETHOD.


  METHOD get_next_history_id.

    SELECT SINGLE FROM zwork_ord_hi_gba
      FIELDS MAX( history_id )
      INTO @DATA(lv_last_history_id).

    IF lv_last_history_id IS INITIAL.
      rv_history_id = '000000000001'.
    ELSE.
      rv_history_id = lv_last_history_id + 1.
    ENDIF.

  ENDMETHOD.


  METHOD insert_history.

    DATA(ls_history) = VALUE zwork_ord_hi_gba(
      history_id          = get_next_history_id( )
      work_order_id       = iv_work_order_id
      modification_date   = cl_abap_context_info=>get_system_date( )
      change_description  = iv_change_description ).

    INSERT zwork_ord_hi_gba FROM @ls_history.

  ENDMETHOD.

ENDCLASS.
