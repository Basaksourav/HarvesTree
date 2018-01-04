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
      document.getElementById(tickSpans[i]).innerHTML = "<img src='assets/images/blue-tick.png' height='20' width='20' style='margin-left:5px'>";
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
    document.getElementById("pay-method-id").value = '';
  }
  else{
    document.getElementById("pay-method-id").value = methods[j];
  }
}

function validator(){
  var fname = document.signup_form.f_name.value;
  var mname = document.signup_form.m_name.value;
  var lname = document.signup_form.l_name.value;
  var email = document.signup_form.email.value;
  var mobile = document.signup_form.mobile.value;
  var password = document.signup_form.password.value;
  var repassword = document.signup_form.repassword.value;

  var cardNo = document.signup_form.card_no.value;
  var month = document.getElementById("month-list").options[document.getElementById("month-list").selectedIndex].value;
  var year = document.getElementById("year-list").options[document.getElementById("year-list").selectedIndex].value;
  var cardholdersName = document.signup_form.cardholders_name.value;
  var bank = document.getElementById("bank-list").options[document.getElementById("bank-list").selectedIndex].value;
  var wallet = document.getElementById("wallet-list").options[document.getElementById("wallet-list").selectedIndex].value;
  var walletMobile = document.signup_form.wallet_mobile.value;

  var validName = /[A-Z]{1}[a-z]+[]{0}$/;
  var validEmail = /[a-zA-Z0-9.-_]+[@]{1}[a-z]+[.]{1}[a-z.]+[]{0}$/;
  var validMobile = /[7-9]{1}[0-9]{9}$/;
  var validCardNo = /[0-9]{16}$/;
  var status = true;
  var payment_status = true;

  // First Name
  if(fname == ""){
    document.getElementById("fname-error").innerHTML = " Blank";
    status = false;
  }
  else if(!(validName.test(fname))){
    document.getElementById("fname-error").innerHTML = " Invalid";
    status = false;
  }
  else{
    document.getElementById("fname-error").innerHTML = "";
  }

  // Middle Name
  if(mname != "" && !(validName.test(mname))){
    document.getElementById("mname-error").innerHTML = " Invalid";
  }
  else{
    document.getElementById("mname-error").innerHTML = "";
  }

  // Last Name
  if(lname == ""){
    document.getElementById("lname-error").innerHTML = " Blank";
    status = false;
  }
  else if(!(validName.test(lname))){
    document.getElementById("lname-error").innerHTML = " Invalid";
    status = false;
  }
  else{
    document.getElementById("lname-error").innerHTML = "";
  }

  // Email
  if(email == ""){
    document.getElementById("email-error").innerHTML = " Blank";
    status = false;
  }
  else if(!(validEmail.test(email))){
    document.getElementById("email-error").innerHTML = " Invalid";
    status = false;
  }
  else{
    document.getElementById("email-error").innerHTML = "";
  }

  // Mobile
  if(mobile == ""){
    document.getElementById("mobile-error").innerHTML = " Blank";
    status = false;
  }
  else if(!(validMobile.test(mobile)) || mobile.length != 10){
    document.getElementById("mobile-error").innerHTML = " Invalid";
    status = false;
  }
  else{
    document.getElementById("mobile-error").innerHTML = "";
  }

  // Password
  if(password == ""){
    document.getElementById("password-error").innerHTML = " Blank";
    status = false;
  }
  else{
    document.getElementById("password-error").innerHTML = "";
  }

  // Retype Password
  if(repassword == ""){
    document.getElementById("repassword-error").innerHTML = " Blank";
    status = false;
  }
  else{
    document.getElementById("repassword-error").innerHTML = "";
  }

  // Checking password and retyped password
  if(password != "" && repassword != "" && password != repassword){
    document.getElementById("repassword-error").innerHTML = " Password Mismatch";
    status = false;
  }
  else if(password != "" && repassword != "" && password == repassword){
    document.getElementById("repassword-error").innerHTML = "";
  }

  return status;
}
