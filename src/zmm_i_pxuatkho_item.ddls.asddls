//@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phiếu xuất kho item'
@Metadata.ignorePropagatedAnnotations: true
//@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_I_PXUATKHO_ITEM as select distinct from I_MaterialDocumentItem_2 as item
    inner join I_MaterialDocumentHeader_2 as header on header.MaterialDocumentYear = item.MaterialDocumentYear
                                                                and header.MaterialDocument = item.MaterialDocument
                                                                and header.Plant = item.Plant
                                                                and (item.GoodsMovementType = '631' or item.GoodsMovementType = '641' or item.GoodsMovementType = '161' or item.GoodsMovementType = '601')
                                                                and item.ReversedMaterialDocument is initial
    left outer join I_ClfnObjectClassDEX as cocd on item.Batch = cocd.ClfnObjectID
    
    left outer join ZI_BATCH_NCC as cc19 on cc19.Batch = item.Batch
                                            and cc19.Material = item.Material
                                            and cc19.Plant = item.Plant
    
    left outer join ZI_BATCH_HANSUDUNG as cc20 on cc20.Batch = item.Batch
                                                and cc20.Material = item.Material
                                                and cc20.Plant = item.Plant       
                                                     
    left outer join I_PurchaseOrderItemAPI01 as poi on item.PurchaseOrder = poi.PurchaseOrder
                                                   and item.PurchaseOrderItem = poi.PurchaseOrderItem
    left outer join I_DeliveryDocumentItem as ddi on ddi.DeliveryDocument = item.DeliveryDocument
                                            and ddi.DeliveryDocumentItem = item.DeliveryDocumentItem
                                                   
    left outer join I_SalesDocumentItem as sdi on ddi.ReferenceSDDocument = sdi.SalesDocument
                                                   and ddi.ReferenceSDDocumentItem = sdi.SalesDocumentItem
                                                   
    left outer join I_ProductText as ipt on item.Material = ipt.Product
                                    and ipt.Language = 'E'
    association to parent ZMM_I_PXUATKHO as _Header on  $projection.MaterialDocumentYear = _Header.MaterialDocumentYear
                                                     and $projection.MaterialDocument        = _Header.MaterialDocument
                                                     and $projection.Plant = _Header.Plant
    association [0..1] to I_OperationalAcctgDocItem as ad on $projection.MaterialDocumentYear =ad.FiscalYear
                                                                            and $projection.MaterialDocument = ad.AccountingDocument
                                                                            and $projection.Plant = ad.Plant                                                 
{
    key item.MaterialDocumentYear,
    key item.MaterialDocument,
    key item.MaterialDocumentItem,
    key item.Plant,
    //BC14
    item.Material as MaVatTu,
    //BC15
//    case
//        when item.Material = ad._Product._Text.Product
//            then ad._Product._Text.ProductName
//   end
   ipt.ProductName as TenVatTu,
   //BC16
   item.EntryUnit as DVT,
   //BC1
   cc19.CharcValue as MaLo,
 case
    when cc20.CharcFromNumericValue is not null
        then cast(cast (cast( cc20.CharcFromNumericValue as abap.dec( 8 , 0 )   ) as abap.char( 20 )) as abap.dats )  
        else ''
   end as HanSuDung,
    //end 
    //BC19
    item.PurchaseOrder,
    item.PurchaseOrderItem,
    
    item.SalesOrder,
    item.SalesOrderItem,
    _Header.AccountingDocumentType,
    @Semantics.quantity.unitOfMeasure: 'DVT'
     case when poi.PurchaseOrder is null or poi.PurchaseOrder is initial
          then sdi.OrderQuantity
          else poi.OrderQuantity end as SoLuongYeuCau,    
//    case
//    when _Header.AccountingDocumentType = 'WE'
//            then poi.OrderQuantity
//        when _Header.AccountingDocumentType = 'WL'
//            then sdi.OrderQuantity
//     end as SoLuongYeuCau,
     @Semantics.quantity.unitOfMeasure: 'DVT'
     //BC20
     item.QuantityInEntryUnit,
     case 
        when sdi.TransactionCurrency is null or sdi.TransactionCurrency is initial
            then poi.DocumentCurrency
            else sdi.TransactionCurrency
    
    end as currency,
    @Semantics.amount.currencyCode: 'currency'
    ad.TaxAmountInCoCodeCrcy,//BC 26
     case when poi.PurchaseOrder is null or poi.PurchaseOrder is initial
          then sdi.TransactionCurrency
          else poi.DocumentCurrency end as DocumentCurrency,
    @Semantics.amount.currencyCode: 'currency'
    //BC21
//    case 
//        when _Header.AccountingDocumentType = 'WE'
//            then poi.NetPriceAmount
//        when _Header.AccountingDocumentType = 'WL' 
//            then sdi.NetPriceAmount
//    end as Gia,
     case when poi.PurchaseOrder is null or poi.PurchaseOrder is initial
          then sdi.NetPriceAmount
          else poi.NetPriceAmount end as Gia,
    _Header.AccountingDocumentType as typeTesst,
     @Semantics.amount.currencyCode: 'currency'
    poi.NetPriceAmount as gia1,
     @Semantics.amount.currencyCode: 'currency'
    sdi.NetPriceAmount as gia2,
    //BC22 BC23 BC24 BC25 BC27 xử lý trên ui
    //BC26
     @Semantics.amount.currencyCode: 'currency'
//    case
//    when _Header.AccountingDocumentType = 'WE'
//            then cast(poi.NetPriceAmount as abap.dec( 11, 2 )) * cast(item.QuantityInEntryUnit as abap.dec( 13, 3 ))
//        when _Header.AccountingDocumentType = 'WL'
//            then cast(sdi.NetPriceAmount as abap.dec( 11, 2 )) * cast(item.QuantityInEntryUnit as abap.dec( 13, 3 ))
//     end as Tien,
   cast ( ( cast(  $projection.Gia as abap.dec( 23, 2 ) ) * item.QuantityInEntryUnit ) as abap.curr( 23,2 ) ) as Tien,

    _Header
}
