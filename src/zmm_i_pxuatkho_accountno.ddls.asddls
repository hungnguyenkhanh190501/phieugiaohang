@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy account nợ'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_I_PXUATKHO_ACCOUNTNO as select distinct from I_OperationalAcctgDocItem as account_no
{
//    key account_no.FiscalYear,
 //  key account_no.AccountingDocument,
     key account_no.OriginalReferenceDocument,
    //key account_no.Plant,
    account_no.GLAccount as account89
}where(account_no.DebitCreditCode = 'S')
//association [0..1] to I_OperationalAcctgDocItem as ad on $projection.MaterialDocumentYear =ad.FiscalYear
//                                                                            and $projection.MaterialDocument = ad.AccountingDocument
//                                                                            and $projection.Plant = ad.Plant
//{
//    key account_no.MaterialDocumentYear,
//    key account_no.MaterialDocument,
//    key account_no.Plant,
//    ad.GLAccount
//}where(ad.PostingKey = '89')
