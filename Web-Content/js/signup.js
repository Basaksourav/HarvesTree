$(document).ready(function() {
  $('select').material_select();
  $('.modal').modal();
});

$(function(){
  $('#filled-in-box-id').change(function(){
    $('.collapsible').slideToggle(500);
  });
});

var methods = ["dc-card-id" , "net-b-id" , "m-wallet-id" , ""];
var tickSpans = ["dc-card-tick-id" , "net-b-tick-id" , "m-wallet-tick-id"];
var errSpans = ["dc-card-err-id" , "net-b-err-id" , "m-wallet-err-id"];
var j = 3;
function getPaymentMethod(paymethod){
  for(i = 0 ; i < 3 ; i++){
    if(this.id == methods[i]){
      document.getElementById(tickSpans[i]).innerHTML = "<img src='assets/images/green-tick.png' height='20' width='20' style='margin-left:5px'>";
      document.getElementById("pay-method-id").value = methods[i];
      j = i;
    }
    else {
      document.getElementById(tickSpans[i]).innerHTML = "";
      document.getElementById(errSpans[i]).innerHTML = "";
    }
  }
}

function noPayment(paymethod){
  if(this.checked == true){
    document.getElementById("pay-method-id").value = "";
  }
  else
    document.getElementById("pay-method-id").value = methods[j];
}

function validator(){
  var fname = document.signup_form.fname.value;
  var mname = document.signup_form.mname.value;
  var lname = document.signup_form.lname.value;
  var email = document.signup_form.email.value;
  var phn = document.signup_form.phn.value;
  var add_line1 = document.signup_form.add_line1.value;
  var city = document.signup_form.city.value;
  var state = document.signup_form.state.value;
  var pin = document.signup_form.pin.value;
  var passwd = document.signup_form.passwd.value;
  var re_passwd = document.signup_form.re_passwd.value;

  var card_no = document.signup_form.card_no.value;
  var month = document.getElementById("month-list-id").options[document.getElementById("month-list-id").selectedIndex].value;
  var year = document.getElementById("year-list-id").options[document.getElementById("year-list-id").selectedIndex].value;
  var cardholder = document.signup_form.cardholder.value;
  var bank = document.getElementById("bank-list-id").options[document.getElementById("bank-list-id").selectedIndex].value;
  var wallet = document.getElementById("wallet-list-id").options[document.getElementById("wallet-list-id").selectedIndex].value;
  var wallet_phn = document.signup_form.wallet_phn.value;

  var validName = /^[A-Z]{1}([A-Z]*|[a-z]*)$/;
  var validFullName = /^[A-Z]{1}([A-Z]*|[a-z]*)( [A-Z]{1}([A-Z]*|[a-z]*))*$/;
  var validEmail = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
  var validPhn = /^(0|\+91)?\d{10}$/;
  var validCity = /^[A-Za-z]+([\s|-]{1}[A-Za-z]+)*$/;
  var validPin = /^[1-9]{1}[0-9]{5}$/;
  var validPasswd = /.{8}/;
  var validCardNo = /^[0-9]{16}$/;

  var status = true;
  var pay_method_status = true;

  // First Name
  if(fname == ""){
    document.getElementById("fname-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validName.test(fname))){
    document.getElementById("fname-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("fname-err-id").innerHTML = "";

  // Middle Name
  if(mname != "" && !(validName.test(mname))){
    document.getElementById("mname-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("mname-err-id").innerHTML = "";

  // Last Name
  if(lname == ""){
    document.getElementById("lname-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validName.test(lname))){
    document.getElementById("lname-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("lname-err-id").innerHTML = "";

  // Email
  if(email == ""){
    document.getElementById("email-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validEmail.test(email))){
    document.getElementById("email-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("email-err-id").innerHTML = "";

  // Phone Number
  if(phn == ""){
    document.getElementById("phn-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validPhn.test(phn))){
    document.getElementById("phn-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("phn-err-id").innerHTML = "";

  // Address Line 1
  if(add_line1 == ""){
    document.getElementById("add-line1-err-id").innerHTML = " Blank";
    status = false;
  }
  else
    document.getElementById("add-line1-err-id").innerHTML = "";

  // City
  if(city == ""){
    document.getElementById("city-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validCity.test(city))){
    document.getElementById("city-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("city-err-id").innerHTML = "";

  // State
  if(state == ""){
    document.getElementById("state-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validCity.test(state))){
    document.getElementById("state-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("state-err-id").innerHTML = "";

  // Pincode
  if(pin == ""){
    document.getElementById("pin-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validPin.test(pin))){
    document.getElementById("pin-err-id").innerHTML = " Invalid";
    status = false;
  }
  else
    document.getElementById("pin-err-id").innerHTML = "";

  // Password
  if(passwd == ""){
    document.getElementById("passwd-err-id").innerHTML = " Blank";
    status = false;
  }
  else if(!(validPasswd.test(passwd))){
    document.getElementById("passwd-err-id").innerHTML = " At least 8 character";
    status = false;
  }
  else
    document.getElementById("passwd-err-id").innerHTML = "";

  // Retype Password
  if(re_passwd == ""){
    document.getElementById("re-passwd-err-id").innerHTML = " Blank";
    status = false;
  }
  else
    document.getElementById("re-passwd-err-id").innerHTML = "";

  // Matching password and retyped password
  if(passwd!="" && re_passwd!=""){
    if(passwd != re_passwd){
      document.getElementById("re-passwd-err-id").innerHTML = " Mismatch";
      status = false;
    }
    else
      document.getElementById("re-passwd-err-id").innerHTML = "";
  }

  //Payment methods
  //Checkbox not checked
  if(document.getElementById("filled-in-box-id").checked == false){

    //Debit/Credit card
    if(document.getElementById("pay-method-id").value == "dc-card-id"){

      //Card No.
      if(card_no == ""){
        document.getElementById("card-no-err-id").innerHTML = " Blank";
        pay_method_status = false;
      }
      else if(!(validCardNo.test(card_no))){
        document.getElementById("card-no-err-id").innerHTML = " Invalid";
        pay_method_status = false;
      }
      else
        document.getElementById("card-no-err-id").innerHTML = "";

      //Month
      if(month == ""){
        document.getElementById("month-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("month-list-err-id").innerHTML = "";

      //Year
      if(year == ""){
        document.getElementById("year-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("year-list-err-id").innerHTML = "";

      //Cardholder's Name
      if(cardholder == ""){
        document.getElementById("cardholder-err-id").innerHTML = " Blank";
        pay_method_status = false;
      }
      else if(!(validFullName.test(cardholder))){
        document.getElementById("cardholder-err-id").innerHTML = " Invalid";
        pay_method_status = false;
      }
      else
        document.getElementById("cardholder-err-id").innerHTML = "";

      //Method Heading
      if(pay_method_status == false)
        document.getElementById("dc-card-err-id").innerHTML = " Error";
      else
        document.getElementById("dc-card-err-id").innerHTML = "";

      //Other methods and checkbox
      document.getElementById("bank-list-err-id").innerHTML = "";
      document.getElementById("net-b-err-id").innerHTML = "";
      document.getElementById("wallet-list-err-id").innerHTML = "";
      document.getElementById("wallet-phn-err-id").innerHTML = "";
      document.getElementById("m-wallet-err-id").innerHTML = "";
      document.getElementById("filled-in-box-err-id").innerHTML = "";
    }
    //Net Banking
    else if(document.getElementById("pay-method-id").value == "net-b-id"){

      //Name of Bank
      if(bank == ""){
        document.getElementById("bank-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("bank-list-err-id").innerHTML = "";

      //Method Heading
      if(pay_method_status == false)
        document.getElementById("net-b-err-id").innerHTML = " Error";
      else
        document.getElementById("net-b-err-id").innerHTML = "";

      //Other methods and checkbox
      document.getElementById("card-no-err-id").innerHTML = "";
      document.getElementById("month-list-err-id").innerHTML = "";
      document.getElementById("year-list-err-id").innerHTML = "";
      document.getElementById("cardholder-err-id").innerHTML = "";
      document.getElementById("dc-card-err-id").innerHTML = "";
      document.getElementById("wallet-list-err-id").innerHTML = "";
      document.getElementById("wallet-phn-err-id").innerHTML = "";
      document.getElementById("m-wallet-err-id").innerHTML = "";
      document.getElementById("filled-in-box-err-id").innerHTML = "";

    }
    else if(document.getElementById("pay-method-id").value == "m-wallet-id"){

      //Name of Wallet
      if(wallet == ""){
        document.getElementById("wallet-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("wallet-list-err-id").innerHTML = "";

      //Wallet Phone Number
      if(wallet_phn == ""){
        document.getElementById("wallet-phn-err-id").innerHTML = " Blank";
        pay_method_status = false;
      }
      else if(!(validPhn.test(wallet_phn))){
        document.getElementById("wallet-phn-err-id").innerHTML = " Invalid";
        pay_method_status = false;
      }
      else
        document.getElementById("wallet-phn-err-id").innerHTML = "";

      //Method Heading
      if(pay_method_status == false)
        document.getElementById("m-wallet-err-id").innerHTML = " Error";
      else
        document.getElementById("m-wallet-err-id").innerHTML = "";

      //Other methods and checkbox
      document.getElementById("card-no-err-id").innerHTML = "";
      document.getElementById("month-list-err-id").innerHTML = "";
      document.getElementById("year-list-err-id").innerHTML = "";
      document.getElementById("cardholder-err-id").innerHTML = "";
      document.getElementById("dc-card-err-id").innerHTML = "";
      document.getElementById("bank-list-err-id").innerHTML = "";
      document.getElementById("net-b-err-id").innerHTML = "";
      document.getElementById("filled-in-box-err-id").innerHTML = "";
    }
    else{
      document.getElementById("filled-in-box-err-id").innerHTML = " Specify a payment method";
      status = false;
    }
  }
  else
    document.getElementById("filled-in-box-err-id").innerHTML = "";

  //return status;
  if(status==false || pay_method_status==false)
    return false;
  else
    return true;
}
