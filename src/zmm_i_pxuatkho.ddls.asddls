@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phiếu nhập kho'
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZMM_I_PXUATKHO as select distinct from I_MaterialDocumentHeader_2 as _header
    inner join ZMM_I_PXUATKHO_NOICHUOI as noiChuoi on _header.MaterialDocument = noiChuoi.MaterialDocument
                                                    and _header.MaterialDocumentYear = noiChuoi.MaterialDocumentYear
    inner join I_MaterialDocumentItem_2 as mdi on mdi.MaterialDocumentYear = _header.MaterialDocumentYear
                                                                and mdi.MaterialDocument = _header.MaterialDocument
                                                                and mdi.Plant = _header.Plant
                                                                and (mdi.GoodsMovementType = '631' or mdi.GoodsMovementType = '641' or mdi.GoodsMovementType = '161' or mdi.GoodsMovementType = '601')
                                                                and mdi.ReversedMaterialDocument is initial
    left outer join I_OperationalAcctgDocItem as ad on ad.OriginalReferenceDocument = noiChuoi.OriginalReferenceDocument 
                                                    and (ad.PostingKey = '89' or ad.PostingKey = '96')                                                            
    left outer join I_JournalEntry as jee on jee.OriginalReferenceDocument = noiChuoi.OriginalReferenceDocument
    left outer join I_OperationalAcctgDocItem as accountNoo on accountNoo.AccountingDocument = jee.AccountingDocument
                                                        and accountNoo.PostingKey = '89'
    left outer join I_OperationalAcctgDocItem as accountCoo on accountCoo.AccountingDocument = jee.AccountingDocument
                                                        and accountCoo.PostingKey = '96'
    left outer join I_CompanyCode as company on mdi.CompanyCode = company.CompanyCode
    left outer join I_Address_2 as adr on company.AddressID = adr.AddressID                                                             
    left outer join I_Plant as plant on mdi.Plant = plant.Plant
    left outer join I_Address_2 as adrPlant on  plant.AddressID = adrPlant.AddressID
    //Lấy diễn giải tên quốc gia của customer
    left outer join I_DeliveryDocument as dd on dd.DeliveryDocument = mdi.DeliveryDocument
    left outer join I_Customer as customer on dd.ShipToParty = customer.Customer
    left outer join I_Address_2 as countryAdrC on customer.AddressID = countryAdrC.AddressID
    left outer join I_CountryText as ct on countryAdrC.Country = ct.Country
                                        and ct.Language = 'E'
    //Lấy diễn giải tên quốc gia của supplier
    left outer join I_Supplier as supplier on mdi.Supplier = supplier.Supplier
    left outer join I_Address_2 as countryAdrS on customer.AddressID = countryAdrS.AddressID
    left outer join I_CountryText as ctS on countryAdrS.Country = ctS.Country
                                        and ctS.Language = 'E'  
    //Lấy ref                                          
    left outer join ZMM_I_GETINVOICENO1  as invoice1 on invoice1.ReferenceDocument = mdi.MaterialDocument
                                                                and invoice1.FiscalYear = mdi.MaterialDocumentYear
    left outer join ZMM_I_GETINVOICENO2  as invoice2 on invoice2.ReferenceSDDocument = mdi.DeliveryDocument 
                                                and invoice2.ReferenceSDDocumentItem = mdi.DeliveryDocumentItem
    left outer join  I_JournalEntry as je on je.OriginalReferenceDocument = invoice2.BillingDocument
    left outer join ZMM_I_GETBILLING as billingNo on billingNo.ReferenceSDDocument = mdi.DeliveryDocument                                    
    //left outer join I_JournalEntry as je on je.OriginalReferenceDocument = billingNo.BillingDocument
    left outer join ZMM_I_PXUATKHO_ACCOUNTNO as account_no on noiChuoi.OriginalReferenceDocument = account_no.OriginalReferenceDocument
    left outer join ZMM_I_PXUATKHO_ACCOUNTCO as account_co on noiChuoi.OriginalReferenceDocument = account_co.OriginalReferenceDocument
    left outer join   ZI_CHUKY as ktt on ktt.Id = 'KETOAN'
    association [0..1] to zmm_tb_pxkho as pxkdb on pxkdb.materialdocumentyear = _header.MaterialDocumentYear
                                                                and pxkdb.materialdocument = _header.MaterialDocument
                                                                and pxkdb.plant = _header.Plant                                                          
composition [0..*] of ZMM_I_PXUATKHO_ITEM as _Item
{
    @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
  multipleSelections: false }
  @Search.defaultSearchElement: true
    key _header.MaterialDocumentYear,
    @Search.defaultSearchElement: true
    key _header.MaterialDocument,
    @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
  multipleSelections: false , defaultValue: '1100' }
  @Search.defaultSearchElement: true
    key mdi.Plant,//6
        pxkdb.z_count,
    case 
        when pxkdb.z_count = 0 or pxkdb.z_count is null
            then 'Chưa in'
        else 'Đã in'
    end as PrintStatus,
  @Consumption.filter: { mandatory: true , selectionType: #SINGLE,
  multipleSelections: false , defaultValue: '1000' }
  @Search.defaultSearchElement: true
    mdi.CompanyCode,//4
    adr.AddresseeFullName as CompanyCodeName,
    adr.StreetName as StreetNameDiaDiemCompany,
    adr.CityName as CityNameDiaDiemCompany,//BC2
    //5
    noiChuoi.OriginalReferenceDocument,
//    accountNoo.GLAccount as accountNo,
//    accountCoo.GLAccount as accountCo,
   account_no.account89 as accountNo,//BC6
   account_co.account96 as accountCo,//BC7
    mdi._Plant.PlantName,//7 BC11
    //8
    _header._DeliveryDocument.DeliveryDocumentType,
    //9
    case when _header._DeliveryDocument.DeliveryDocumentType = 'LF' 
            then ' Xuất kho bán hàng'
        when _header._DeliveryDocument.DeliveryDocumentType = 'RL'
            then 'Xuất trả nhà cung cấp'
        when _header._DeliveryDocument.DeliveryDocumentType = 'NL'
            then 'Xuât kho điều chuyển nội bộ'
    end as DeliveryTypeDescription,
    //10
    @Search.defaultSearchElement: true
    mdi.Supplier,
    //11
    @Search.defaultSearchElement: true
    mdi._DeliveryDocument.ShipToParty as Customer,
    mdi.Customer as Customer1,
    customer.Customer as Customer2,
    //12
    @Search.defaultSearchElement: true
    cast(mdi.DeliveryDocument as zde_pxk_deliverynumber) as DeliveryDocument,
    
    //13
    @Search.defaultSearchElement: true
    cast(_header._DeliveryDocument.PlannedGoodsIssueDate as zde_pxk_planneddeliverydate) as PlannedGoodsIssueDate,
     //14
     @Search.defaultSearchElement: true
     _header.PostingDate,
     //15
     @Search.defaultSearchElement: true
     //16
     mdi.GoodsMovementType,
     //17
     @Search.defaultSearchElement: true
     _header.AccountingDocumentType,
//    case 
//        when _header.AccountingDocumentType = 'WE' and ad.PurchasingDocument = _header.ReferenceDocument
//            then ad.AccountingDocument
//        when _header.AccountingDocumentType = 'WL' and ad.SalesDocument = _header.ReferenceDocument
//            then ad.AccountingDocument
//   end 
    case when invoice1.SupplierInvoice is initial or invoice1.SupplierInvoice is null
            then invoice2.BillingDocument
            else invoice1.SupplierInvoice
    end as invoiceDocument,
   //billingNo.BillingDocument as invoiceDocument,
   case when invoice1.SupplierInvoiceIDByInvcgParty is initial or invoice1.SupplierInvoiceIDByInvcgParty is null
        then je.DocumentReferenceID
        else invoice1.SupplierInvoiceIDByInvcgParty
    end as  DocumentReferenceID,
   //18
   //je.DocumentReferenceID, //BC26
   @Search.defaultSearchElement: true
   //19
   _header._DeliveryDocument.CreatedByUser,
   

   
   case
        when concat_with_space(mdi._Supplier.BusinessPartnerName2,concat_with_space(mdi._Supplier.BusinessPartnerName3, mdi._Supplier.BusinessPartnerName4,1),1) is null 
            then concat_with_space(mdi._DeliveryDocument._ShipToParty.BusinessPartnerName2,concat_with_space(mdi._DeliveryDocument._ShipToParty.BusinessPartnerName3, mdi._DeliveryDocument._ShipToParty.BusinessPartnerName4,1),1)
            else concat_with_space(mdi._Supplier.BusinessPartnerName2,concat_with_space(mdi._Supplier.BusinessPartnerName3, mdi._Supplier.BusinessPartnerName4,1),1)
   end as nameNguoiNhanHang,//BC8
   //BC 9
   countryAdrS.StreetName as StreetNameS,
   countryAdrS.StreetPrefixName1 as StreetPrefixName1S,
   countryAdrS.StreetPrefixName2 as StreetPrefixName2S,
   countryAdrS.StreetSuffixName1 as StreetSuffixName1S,
   countryAdrS.StreetSuffixName2 as StreetSuffixName2S,
   countryAdrS.DistrictName as DistrictNameS,
   countryAdrS.CityName as CityNameS,
   ctS.CountryName as CountryNameS,
   countryAdrC.StreetName,
   countryAdrC.StreetPrefixName1,
   countryAdrC.StreetPrefixName2,
   countryAdrC.StreetSuffixName1,
   countryAdrC.StreetSuffixName2,
   countryAdrC.DistrictName,
   countryAdrC.CityName,
   ct.CountryName,
//   case
//        when mdi.Customer = ''
//            then concat_with_space(mdi._Supplier._AddressRepresentation.StreetName,concat_with_space(mdi._Supplier._AddressRepresentation.StreetPrefixName1,concat_with_space(mdi._Supplier._AddressRepresentation.StreetPrefixName2,concat_with_space(mdi._Supplier._AddressRepresentation.StreetSuffixName1,concat_with_space(mdi._Supplier._AddressRepresentation.StreetSuffixName2,concat_with_space(mdi._Supplier._AddressRepresentation.DistrictName,concat_with_space(mdi._Supplier._AddressRepresentation.CityName,ctS.CountryName,1),1),1),1),1),1),1)
//        else concat(mdi._Customer._AddressRepresentation.StreetName,concat(mdi._Customer._AddressRepresentation.StreetPrefixName1,concat(mdi._Customer._AddressRepresentation.StreetPrefixName2,concat(mdi._Customer._AddressRepresentation.StreetSuffixName1,concat(mdi._Customer._AddressRepresentation.StreetSuffixName2,concat(mdi._Customer._AddressRepresentation.DistrictName,concat(mdi._Customer._AddressRepresentation.CityName,ct.CountryName)))))))
//   end as DiaChiBoPhan ,
   //BC10
   //BC11 chỉ tiêu 7 ở trung gian
   //BC12
    adrPlant.StreetName as StreetNamePlant,
    adrPlant.CityName as CityNamePlant,
   //BC13 STT
   
   

    '01-TC-QT-04'as MauSo,//BC3
   '200/2014/TT-BTC' as ThongTuSo,//BC4
   '22/12/2014' as NgayTTS, //B5
    mdi.CompanyCodeCurrency,
     //BC 24,25 xử lý trên ui
     ad.TaxAmountInCoCodeCrcy,
    ktt.Hoten as PNK_KTT,  //BC28
   
    _Item
}
