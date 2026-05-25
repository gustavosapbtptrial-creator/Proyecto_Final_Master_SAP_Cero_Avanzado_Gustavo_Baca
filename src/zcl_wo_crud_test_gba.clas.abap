CLASS zcl_wo_crud_test_gba DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.

    METHODS test_create_work_order
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS test_read_work_order
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS test_update_work_order
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

    METHODS test_delete_work_order
      IMPORTING
        io_out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.


CLASS zcl_wo_crud_test_gba IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    out->write( 'Iniciando pruebas CRUD de Ordenes de Trabajo...' ).

    test_create_work_order( out ).
    test_read_work_order( out ).
    test_update_work_order( out ).
    test_delete_work_order( out ).

    out->write( 'Pruebas CRUD finalizadas.' ).

  ENDMETHOD.


  METHOD test_create_work_order.

    DATA(lo_crud) = NEW zcl_wo_crud_handler_gba( ).

    DATA(ls_work_order) = VALUE zworkorder_gba(
      work_order_id = '0000000001'
      customer_id   = '00000001'
      technician_id = 'TEC00001'
      creation_date = cl_abap_context_info=>get_system_date( )
      status        = 'PE'
      priority      = 'A'
      description   = 'Test work order' ).

    DATA(lv_message) = lo_crud->create_work_order( ls_work_order ).

    io_out->write( 'CREATE:' ).
    io_out->write( lv_message ).

  ENDMETHOD.


  METHOD test_read_work_order.

    DATA(lo_crud) = NEW zcl_wo_crud_handler_gba( ).

    DATA(ls_work_order) = lo_crud->read_work_order(
      iv_work_order_id = '0000000001' ).

    io_out->write( 'READ:' ).

    IF ls_work_order-work_order_id IS INITIAL.
      io_out->write( 'Orden no encontrada.' ).
    ELSE.
      io_out->write( ls_work_order ).
    ENDIF.

  ENDMETHOD.


  METHOD test_update_work_order.

    DATA(lo_crud) = NEW zcl_wo_crud_handler_gba( ).

    DATA(ls_work_order) = VALUE zworkorder_gba(
      work_order_id = '0000000001'
      customer_id   = '00000001'
      technician_id = 'TEC00002'
      creation_date = cl_abap_context_info=>get_system_date( )
      status        = 'PE'
      priority      = 'B'
      description   = 'Updated work order' ).

    DATA(lv_message) = lo_crud->update_work_order( ls_work_order ).

    io_out->write( 'UPDATE:' ).
    io_out->write( lv_message ).

  ENDMETHOD.


  METHOD test_delete_work_order.

    DATA(lo_crud) = NEW zcl_wo_crud_handler_gba( ).

    DATA(lv_message) = lo_crud->delete_work_order(
      iv_work_order_id = '0000000001' ).

    io_out->write( 'DELETE:' ).
    io_out->write( lv_message ).

  ENDMETHOD.

ENDCLASS.
