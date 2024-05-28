@EndUserText.label: 'Phiếu xuất kho projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZMM_C_PXUATKHO
  as projection on ZMM_I_PXUATKHO
{
          @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
          multipleSelections: false , defaultValue: '2023' }
          @Search.defaultSearchElement: true
  key     MaterialDocumentYear,
          @Search.defaultSearchElement: true
  key     MaterialDocument,
          @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
          multipleSelections: false , defaultValue: '1100' }
          @Search.defaultSearchElement: true
  key     Plant,
          z_count,
          PrintStatus,
          @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
          multipleSelections: false , defaultValue: '1000' }
          @Search.defaultSearchElement: true
          CompanyCode,
          CompanyCodeName,
          accountNo,
          accountCo,
          PlantName,
          StreetNameDiaDiemCompany,
          CityNameDiaDiemCompany,
          DeliveryDocumentType,
          DeliveryTypeDescription,
          @Search.defaultSearchElement: true
          Supplier,
          @Search.defaultSearchElement: true
          Customer,
          @Search.defaultSearchElement: true
          DeliveryDocument,
          @Search.defaultSearchElement: true
          PlannedGoodsIssueDate,
          @Search.defaultSearchElement: true
          PostingDate,
          @Search.defaultSearchElement: true
          GoodsMovementType,
          @Search.defaultSearchElement: true
          AccountingDocumentType,
          invoiceDocument,
          DocumentReferenceID,
          @Search.defaultSearchElement: true
          CreatedByUser,
          nameNguoiNhanHang,    
          StreetNamePlant,
          CityNamePlant,
          MauSo,
          ThongTuSo,
          NgayTTS,
          CompanyCodeCurrency,
          TaxAmountInCoCodeCrcy,
          PNK_KTT,
          StreetNameS,
          StreetPrefixName1S,
          StreetPrefixName2S,
          StreetSuffixName1S,
          StreetSuffixName2S,
          DistrictNameS,
          CityNameS,
          CountryNameS,
          //dữ liệu customer
          StreetName,
          StreetPrefixName1,
          StreetPrefixName2,
          StreetSuffixName1,
          StreetSuffixName2,
          DistrictName,
          CityName,
          CountryName,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZMM_CL_DIACHIBOPHAN'
  virtual DiaChiBoPhan : abap.char( 200 ),
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZMM_CL_DIACHIBOPHAN'
  virtual LyDoXuatHang : abap.char(200),
          /* Associations */

          _Item : redirected to composition child ZMM_C_PXUATKHO_ITEM
}
