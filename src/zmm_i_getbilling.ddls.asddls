@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy Billing No'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_I_GETBILLING as select from I_BillingDocumentItemBasic as bli
//inner join I_MaterialDocumentItem_2 as mdi on mdi.DeliveryDocument = bli.ReferenceSDDocument 
inner join I_BillingDocumentBasic as bl on bl.BillingDocument = bli.BillingDocument
                                        and bl.CancelledBillingDocument is initial or bl.CancelledBillingDocument is null
{
    key bli.BillingDocument,
    key bli.ReferenceSDDocument
}
