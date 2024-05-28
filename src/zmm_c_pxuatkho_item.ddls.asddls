@EndUserText.label: 'Phiếu xuất kho item projection view'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define view entity ZMM_C_PXUATKHO_ITEM as projection on ZMM_I_PXUATKHO_ITEM
{
    key MaterialDocumentYear,
    key MaterialDocument,
    key MaterialDocumentItem,
    key Plant,
    MaVatTu,
    TenVatTu,
    DVT,
    @Search.defaultSearchElement: true
    MaLo,
    HanSuDung,
    SoLuongYeuCau,
    QuantityInEntryUnit,
    //CompanyCodeCurrency,
    TaxAmountInCoCodeCrcy,
    currency,
    Gia,
    Tien,
    @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZMM_CL_DIACHIBOPHAN'
    virtual Z001  : abap.char( 100 ),
    /* Associations */
    _Header: redirected to parent ZMM_C_PXUATKHO
}
