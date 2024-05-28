@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Nối chuỗi'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_I_PXUATKHO_NOICHUOI as select distinct from I_MaterialDocumentHeader_2 as noiChuoi
{
    key noiChuoi.MaterialDocumentYear,
    key noiChuoi.MaterialDocument,
    concat(noiChuoi.MaterialDocument,noiChuoi.MaterialDocumentYear) as OriginalReferenceDocument
}
