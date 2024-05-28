CLASS zmm_cl_diachibophan DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.

    METHODS:
      get_single_delivery_hdr_text IMPORTING iv_delivery TYPE I_OutboundDelivery-OutboundDelivery
                                             iv_textid   TYPE string
                                   RETURNING VALUE(text) TYPE string.
    DATA: g_entity TYPE string.
    CONSTANTS: gc_comm_scenario TYPE if_com_management=>ty_cscn_id VALUE 'ZCORE_CS_SAP',
               gc_service_id    TYPE if_com_management=>ty_cscn_outb_srv_id VALUE 'Z_API_SAP_REST'.
ENDCLASS.



CLASS ZMM_CL_DIACHIBOPHAN IMPLEMENTATION.


  METHOD get_single_delivery_hdr_text.
    TYPES:
      BEGIN OF lty_response_d,
        Text_Element      TYPE string,
        Text_Element_Text TYPE string,
      END OF lty_response_d,
      BEGIN OF lty_response,
        d TYPE lty_response_d,
      END OF  lty_response.
    TRY.
        DATA: lv_url      TYPE string,
              ls_response TYPE lty_response.
        lv_url = |sap/opu/odata/sap/API_OUTBOUND_DELIVERY_SRV;v=2/A_OutbDeliveryHeaderText(DeliveryDocument='{ condense( |{ iv_delivery ALPHA = OUT }| ) }',TextElement='{ iv_textid }',Language='EN')|.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement( comm_scenario  = gc_comm_scenario
                                                                                         service_id     = gc_service_id ).
        DATA(lo_web_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ) .
        DATA(lo_web_http_request) = lo_web_http_client->get_http_request( ).
        lo_web_http_request->set_uri_path(  i_uri_path = lv_url ).
        lo_web_http_request->set_header_fields( VALUE #(
        (  name = 'DataServiceVersion' value = '2.0' )
        (  name = 'Accept' value = 'application/json' )
         ) ).
        DATA(lo_web_http_response) = lo_web_http_client->execute( if_web_http_client=>get ).
        DATA(lv_response) = lo_web_http_response->get_text( ).
        TRY.
            xco_cp_json=>data->from_string( lv_response )->apply( VALUE #(
              ( xco_cp_json=>transformation->pascal_case_to_underscore )
              ( xco_cp_json=>transformation->boolean_to_abap_bool )
            ) )->write_to( REF #( ls_response ) ).
            text = ls_response-d-Text_Element_Text.
          CATCH cx_root INTO DATA(lx_root).
        ENDTRY.
      CATCH cx_http_dest_provider_error cx_web_http_client_error cx_web_message_error.
    ENDTRY.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.
    IF  g_entity = 'ZMM_C_PXUATKHO'.
      DATA: lt_phieuxuatkho TYPE STANDARD TABLE OF zmm_c_pxuatkho WITH DEFAULT KEY.
      lt_phieuxuatkho = CORRESPONDING #( it_original_data ).
      LOOP AT lt_phieuxuatkho REFERENCE INTO DATA(ls_phieuxuat).
        "Địa chỉ người nhận
        IF ls_phieuxuat->Customer IS NOT INITIAL.
          IF ls_phieuxuat->StreetName IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = ls_phieuxuat->StreetName.
          ENDIF.
          IF ls_phieuxuat->StreetPrefixName1 IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetPrefixName1 }|.
          ENDIF.
          IF ls_phieuxuat->StreetPrefixName2 IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetPrefixName2 }|.
          ENDIF.
          IF ls_phieuxuat->StreetSuffixName1 IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetSuffixName1 }|.
          ENDIF.
          IF ls_phieuxuat->StreetSuffixName2 IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetSuffixName2 }|.
          ENDIF.
          IF ls_phieuxuat->DistrictName IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->DistrictName }|.
          ENDIF.
          IF ls_phieuxuat->CityName IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->CityName }|.
          ENDIF.
          IF ls_phieuxuat->CountryName IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->CountryName }|.
          ENDIF.
        ELSE.
          IF ls_phieuxuat->StreetNameS IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = ls_phieuxuat->StreetNameS.
          ENDIF.
          IF ls_phieuxuat->StreetPrefixName1S IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetPrefixName1S }|.
          ENDIF.
          IF ls_phieuxuat->StreetPrefixName2S IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetPrefixName2S }|.
          ENDIF.
          IF ls_phieuxuat->StreetSuffixName1S IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetSuffixName1S }|.
          ENDIF.
          IF ls_phieuxuat->StreetSuffixName2S IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->StreetSuffixName2S }|.
          ENDIF.
          IF ls_phieuxuat->DistrictNameS IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->DistrictNameS }|.
          ENDIF.
          IF ls_phieuxuat->CityNameS IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->CityNameS }|.
          ENDIF.
          IF ls_phieuxuat->CountryNameS IS NOT INITIAL.
            ls_phieuxuat->DiaChiBoPhan = |{ ls_phieuxuat->DiaChiBoPhan }, { ls_phieuxuat->CountryNameS }|.
          ENDIF.
        ENDIF.

        "Lý do xuất hàng
        "Header text của delivery number Z005
        ls_phieuxuat->LyDoXuatHang = get_single_delivery_hdr_text( iv_delivery = ls_phieuxuat->DeliveryDocument iv_textid = 'Z005' ).
      ENDLOOP.
      ct_calculated_data = CORRESPONDING #( lt_phieuxuatkho ).
    ENDIF.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    g_entity = iv_entity.
    DATA: lt_elements TYPE TABLE OF string .
    IF  iv_entity = 'ZMM_C_PXUATKHO'.
      LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
        CASE <fs_calc_element>.
          WHEN 'DIACHIBOPHAN'.
            APPEND 'STREETNAME' TO lt_elements.
            APPEND 'STREETPREFIXNAME1' TO lt_elements.
            APPEND 'STREETPREFIXNAME2' TO lt_elements.
            APPEND 'STREETSUFFIXNAME1' TO lt_elements.
            APPEND 'STREETSUFFIXNAME2' TO lt_elements.
            APPEND 'DISTRICTNAME' TO lt_elements.
            APPEND 'CITYNAME' TO lt_elements.
            APPEND 'COUNTRYNAME' TO lt_elements.
            APPEND 'STREETNAMES' TO lt_elements.
            APPEND 'STREETPREFIXNAME1S' TO lt_elements.
            APPEND 'STREETPREFIXNAME2S' TO lt_elements.
            APPEND 'STREETSUFFIXNAME1S' TO lt_elements.
            APPEND 'STREETSUFFIXNAME2S' TO lt_elements.
            APPEND 'DISTRICTNAMES' TO lt_elements.
            APPEND 'CITYNAMES' TO lt_elements.
            APPEND 'COUNTRYNAMES' TO lt_elements.
          WHEN 'LYDOXUATHANG'.
            APPEND 'DELIVERYDOCUMENT' TO lt_elements.
          WHEN OTHERS.
        ENDCASE.
      ENDLOOP.
      SORT lt_elements.
      et_requested_orig_elements = CORRESPONDING #( lt_elements ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
