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
    out->write( 'Hola, mundo!' ).
  ENDMETHOD.

ENDCLASS.
