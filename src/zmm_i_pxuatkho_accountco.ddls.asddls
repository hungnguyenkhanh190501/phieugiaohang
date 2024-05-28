@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Lấy account có'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_I_PXUATKHO_ACCOUNTCO as select distinct from I_OperationalAcctgDocItem as account_co

{
//    key account_co.FiscalYear,
//    key account_co.AccountingDocument,
    key account_co.OriginalReferenceDocument,
    //key account_co.Plant,
    account_co.GLAccount as account96
}where(account_co.DebitCreditCode = 'H')
