<?php
//echo "aka";exit;
include_once(TPATH_CLASS_GEN."class.sendmail.php");
$mailObj = new SendPHPMail();
//$Data = {};
$Data['iplanid'] = $_SESSION['planid'];
$Data['icompanyid'] = $_SESSION['cid'];
$Data['vfname'] = $_REQUEST['vfname'];
$Data['vlname'] = $_REQUEST['vlname'];
$Data['vacno'] = $_REQUEST['vacno'];
$Data['vcvv'] = $_REQUEST['vcvv'];
$Data['vexpdate'] = $_REQUEST['expmonth'] . $_REQUEST['expyear'];
$Data['etransactionstatus'] = 'Inprocess';//$_REQUEST['vtransactionstatus'];
//$Data['vprice'] = $_SESSION['vprice'];
$planid = $_SESSION['planid']  ;
$sql = "select * from plan Where iplanid = '$planid' ";

$plan_info = $obj->MySQLSelect($sql);
if ($_SESSION['discount'] == 'yes') {
$Data['vprice'] = ($plan_info[0]['vprice'])/2;
}else{
	$Data['vprice'] = $plan_info[0]['vprice'];
}
#echo "<pre>";
#print_r($Data);
//echo $vcat[0];

//PAYPAL INTEGRATION
$Data['ddate'] = date("Y-m-d H:i:s");
$company_transaction_id = $obj->MySQLQueryPerform("company_transactions",$Data,'insert');

//$company_transaction_id = 17;
#echo 'hi';exit;

error_reporting(0);
require_once 'CallerService.php';
require_once 'constants.php';


include_once($inc_class_path."application/Shopcart.class.php5");

#echo "<pre>";
#print_r($_REQUEST);exit;

$API_UserName="sandbo_1348812018_biz_1348812947_biz_api1.gmail.com";//API_USERNAME;
$API_Password="1348812986";//API_PASSWORD;
$API_Signature="A0TPLFHxuMBRJ83hvVi0v4D2TD08ACflexIVQVD77GXossUY.o-JcPI3";//API_SIGNATURE;
$API_Endpoint ="https://api-3t.sandbox.paypal.com/nvp";//API_ENDPOINT;

/*$API_UserName="kav1911_api1.yahoo.com";//API_USERNAME;
$API_Password="KAXQ3E9ZSWHDTPRL";//API_PASSWORD;
$API_Signature="Aj5sUx7ubKcny3xs1DWp80ym5PFdAT3FYK2n3nKNVMGMrNdLoI2Dvvlu";//API_SIGNATURE;
$API_Endpoint ="https://api-3t.sandbox.paypal.com/nvp";//API_ENDPOINT;*/
//API Username	kav1911_api1.yahoo.com
//API Password	KAXQ3E9ZSWHDTPRL
//Signature	Aj5sUx7ubKcny3xs1DWp80ym5PFdAT3FYK2n3nKNVMGMrNdLoI2Dvvlu

$paymentType = 'Sale';
//$amount = '10.00';
//$creditCardType = 'Visa';
//$creditCardNumber = '4093999694412324';
//$expDateMonth = '09';
//$expDateYear = '2017';
//$cvv2Number = '123';
$firstName = $_REQUEST['vfname'];
$lastName = $_REQUEST['vlname'];
//$state = 'FL';
//$zip = '33770';
$email = $_SESSION['email'];//'akankshita.satapathy@php2india.com';//
//$address1 = '707 W. Bay Drive';
$address1 = $_SESSION['address'];//'Zensar Technologies, Inc.2107 North First Street, Suite 360 San Jose, California, 95131';//

$currencyCode="USD";

if($_REQUEST['ctype']=='VI')
{
  $creditCardType =urlencode('Visa');
}elseif($_REQUEST['ctype']=='MC'){
    $creditCardType =urlencode('Mastercard');
}elseif($_REQUEST['ctype']=='AX'){
    $creditCardType =urlencode('American Express');
}
$creditCardNumber = urlencode($_REQUEST['vacno']);
$expDateMonth =urlencode($_REQUEST['expmonth']);
$expDateYear =urlencode($_REQUEST['expyear']);
$cvv2Number = urlencode($_REQUEST['vcvv']);

$amount =  urlencode($Data['vprice']);
//$amount = urlencode($_SESSION[Cart][sess_total_price]+$CREDIT_CARD_PROCESSING_FEE);
//$amount = '10.00';

$nvpstr ="&PAYMENTACTION=$paymentType&AMT=$amount&CREDITCARDTYPE=$creditCardType&ACCT=$creditCardNumber&EXPDATE=".$expDateMonth.$expDateYear."&CVV2=$cvv2Number&FIRSTNAME=$firstName&LASTNAME=$lastName&STREET=$address1&COUNTRYCODE=US&CURRENCYCODE=$currencyCode&EMAIL=$email";
$RECresArray=hash_call("CreateRecurringPaymentsProfile",$nvpstr);
$RECresArray=hash_call("DoDirectPayment",$nvpstr);



//echo "<pre>";
//print_r($RECresArray);exit;

#echo "<pre>";
#print_r($_POST);exit;
if($RECresArray['ACK'] == 'Success'){
    $TRANSACTIONID =$RECresArray['TRANSACTIONID']; 
    #echo $TRANSACTIONID;exit;
  //  $iShoppingHistId = $_SESSION['iShoppingHistId'];
    
    $updateplan_sql = "update company_transactions set etransactionstatus  = 'Accepted',`vtransactionid` = '".$TRANSACTIONID."' 
    where icptransactionid = '".$company_transaction_id."'";
    $obj->sql_query($updateplan_sql);
    
    $payment_status = 'Completed';
 
    $Name = $_REQUEST['vfname'] .' '. $_REQUEST['vlname'];
     $Email=$_SESSION['email'];
     $to=$_SESSION['email'];;
     $body_arr = Array("#PASSWORD#","#TONAME#","#PHONE#","#CADDRESS#","#PSTATUS#","#NAME#","#SITE_NAME#","#Email#","#MAIL_FOOTER#","#SITE_URL#",);
     $post_arr = Array($_SESSION['password'],$Name,$_SESSION['phone'],$_SESSION['address'],'Accepted',$Name,$SITE_NAME,$Email,$MAIL_FOOTER,$tconfig["tsite_url"]);
     $mailObj->Send("COMPANY_REGISTER","Administator",$to,$body_arr,$post_arr);
     
     
     $Name = $_REQUEST['vfname'] .' '.$_REQUEST['vlname'];
     $Email=$_SESSION['adminvemail'];
     $to=$_SESSION['adminvemail'];
     $body_arr = Array("#PSTATUS#","#PLAN#","#PHONE#","#CADDRESS#","#NAME#","#SITE_NAME#","#EMAIL#","#MAIL_FOOTER#","#SITE_URL#");
     $post_arr = Array($payment_status,$planid,$_SESSION['phone'],$_SESSION['address'],$Name,$SITE_NAME,$Email,$MAIL_FOOTER,$tconfig["tsite_url"]);
     $mailObj->Send("COMPANY_REGISTER_ADMIN","Administator",$to,$body_arr,$post_arr);
    
     echo "success";


     
     
     
}else{
     
    $TRANSACTIONID =$RECresArray['TRANSACTIONID']; 
    #echo $TRANSACTIONID;exit;
  //  $iShoppingHistId = $_SESSION['iShoppingHistId'];
    
   $updateplan_sql = "update company_transactions set etransactionstatus  = 'Declined',`vtransactionid` = '".$TRANSACTIONID."' 
    where icptransactionid = '".$company_transaction_id."'";
    $obj->sql_query($updateplan_sql);
    
      $payment_status = 'Declined';
 
     $Name = $_REQUEST['vfname'] .' '. $_REQUEST['vlname'];
     $Email=$_SESSION['email'];
     $to=$_SESSION['email'];;
     $body_arr = Array("#PASSWORD#","#TONAME#","#PHONE#","#CADDRESS#","#PSTATUS#","#NAME#","#SITE_NAME#","#Email#","#MAIL_FOOTER#","#SITE_URL#",);
     $post_arr = Array($_SESSION['password'],$Name,$_SESSION['phone'],$_SESSION['address'],'Accepted',$Name,$SITE_NAME,$Email,$MAIL_FOOTER,$tconfig["tsite_url"]);
     $mailObj->Send("COMPANY_REGISTER","Administator",$to,$body_arr,$post_arr);
     
     
     $Name = $_REQUEST['vfname'] .' '.$_REQUEST['vlname'];
     $Email=$_SESSION['adminvemail'];
     $to=$_SESSION['adminvemail'];
     $body_arr = Array("#PSTATUS#","#PLAN#","#PHONE#","#CADDRESS#","#NAME#","#SITE_NAME#","#EMAIL#","#MAIL_FOOTER#","#SITE_URL#");
     $post_arr = Array($payment_status,$planid,$_SESSION['phone'],$_SESSION['address'],$Name,$SITE_NAME,$Email,$MAIL_FOOTER,$tconfig["tsite_url"]);
     $mailObj->Send("COMPANY_REGISTER_ADMIN","Administator",$to,$body_arr,$post_arr);
     echo "Your transaction is unsucessful.Please varify your payment Details.";
    
}  
//$_SESSION["response_array"] = $RECresArray;

//header("Location:".$site_url."paymentsucess");
//exit();

   /*  unset($_SESSION['planid']);
     unset($_SESSION['cid']);
     unset($_SESSION['cemail']);
     unset($_SESSION['address']);
     unset($_SESSION['phone']);
     unset($_SESSION['password']);
     //echo "success";*/
exit();

















/*    $Data['ddate'] = date("Y-m-d H:i:s");
    $id = $obj->MySQLQueryPerform("company_transactions",$Data,'insert');
    if($id) {
		
         $Name = $_REQUEST['vfname'] .' '. $_REQUEST['vlname'];
         $Email=$_SESSION['email'];
         $to=$Email;
         $body_arr = Array("#PASSWORD#","#TONAME#","#PHONE#","#CADDRESS#","#PSTATUS#","#NAME#","#SITE_NAME#","#Email#","#MAIL_FOOTER#","#SITE_URL#",);
         $post_arr = Array($_SESSION['password'],$Name,$_SESSION['phone'],$_SESSION['address'],'Accepted',$Name,$SITE_NAME,$Email,$MAIL_FOOTER,$tconfig["tsite_url"]);
         $mailObj->Send("COMPANY_REGISTER","Administator",$to,$body_arr,$post_arr);
       

         $Name = $_REQUEST['vfname'] .' '.$_REQUEST['vlname'];
         $Email=$_SESSION['email'];
         $to=$_SESSION['adminvemail'];
         $body_arr = Array("#PSTATUS#","#PLAN#","#PHONE#","#CADDRESS#","#NAME#","#SITE_NAME#","#EMAIL#","#MAIL_FOOTER#","#SITE_URL#");
         $post_arr = Array('Accepted',$planid,$_SESSION['phone'],$_SESSION['address'],$Name,$SITE_NAME,$Email,$MAIL_FOOTER,$tconfig["tsite_url"]);
         $mailObj->Send("COMPANY_REGISTER_ADMIN","Administator",$to,$body_arr,$post_arr);
    

		// echo "success";
		 
		  unset($_SESSION['planid']);
		  unset($_SESSION['cid']);
		  unset($_SESSION['cemail']);
		  unset($_SESSION['address']);
		  unset($_SESSION['phone']);
		  unset($_SESSION['password']);
		  echo "success";
	}
	//$sql = "select * from company  ORDER BY icompanyid DESC LIMIT 1";
	

 // echo "success";
  exit;
	
//echo "<pre>";
//print_r($row[0]['icompanyid']);exit;
	
#    if($id)$var_msg = "Admin is Added Successfully.";else $var_msg="Eror-in Add.";
#	header("Location: ".$tconfig["tpanel_url"]."/index.php?file=ad-administrator&mode=view&var_msg=$var_msg");
#	exit;*/
?>
