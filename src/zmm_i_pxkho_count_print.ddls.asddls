@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Đếm số lần in pxk'
define root view entity ZMM_I_PXKHO_COUNT_PRINT as select from zmm_tb_pxkho
{
    
    key materialdocumentyear,
    key materialdocument    ,
    key plant              ,
    z_count       
}
