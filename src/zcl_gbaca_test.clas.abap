CLASS zcl_gbaca_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  interfaces if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gbaca_test IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DELETE FROM zstatus_gba.
    DELETE FROM zpriority_gba.
    DELETE FROM zcustomer_gba.
    DELETE FROM ztechnician_gba.

    INSERT zstatus_gba FROM TABLE @(
      VALUE #(
        ( status_code = 'PE' status_description = 'Pending' )
        ( status_code = 'CO' status_description = 'Completed' )
      )
    ).

    INSERT zpriority_gba FROM TABLE @(
      VALUE #(
        ( priority_code = 'A' priority_description = 'High' )
        ( priority_code = 'B' priority_description = 'Low' )
      )
    ).

    INSERT zcustomer_gba FROM TABLE @(
      VALUE #(
        ( customer_id = '00000001' name = 'Logali Group'       address = 'Madrid'      phone = '111111111' )
        ( customer_id = '00000002' name = 'Cliente Demo Uno'   address = 'Managua'     phone = '222222222' )
        ( customer_id = '00000003' name = 'Cliente Demo Dos'   address = 'Leon'        phone = '333333333' )
      )
    ).

    INSERT ztechnician_gba FROM TABLE @(
      VALUE #(
        ( technician_id = 'TEC00001' name = 'Carlos Perez' specialty = 'Networks' )
        ( technician_id = 'TEC00002' name = 'Ana Lopez'    specialty = 'Hardware' )
        ( technician_id = 'TEC00003' name = 'Luis Gomez'   specialty = 'Software' )
      )
    ).

    COMMIT WORK.

    out->write( 'Datos base cargados correctamente.' ).


  ENDMETHOD.

ENDCLASS.
