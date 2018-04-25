$(document).ready(function() {
  $('select').material_select();
  $('.modal').modal();
});

$(function(){
  $('#filled-in-box-id').change(function(){
    $('.collapsible').slideToggle(500);
  });
});

var methods = ["dc-card-id", "net-b-id", "m-wallet-id", ""];
var tables = ["Card", "NetB", "mWallet", ""];
var tickSpans = ["dc-card-tick-id", "net-b-tick-id", "m-wallet-tick-id"];
var errSpans = ["dc-card-err-id", "net-b-err-id", "m-wallet-err-id"];
var j = 3;
function getPaymentMethod(){
  for(i = 0 ; i < 3 ; i++){
    if(this.id == methods[i]){
      document.getElementById(tickSpans[i]).innerHTML = "<img src='assets/images/green-tick.png' height='20' width='20' style='margin-left:5px'>";
      document.getElementById("pay-method-id").value = tables[i];
      j = i;  
    }
    else {
      document.getElementById(tickSpans[i]).innerHTML = "";
      document.getElementById(errSpans[i]).innerHTML = "";
    }
  }
  document.getElementById("filled-in-box-id").checked = false;
  document.getElementById("filled-in-box-err-id").innerHTML = "";
}

function noPayment(){
  if(this.checked == true){
    document.getElementById("pay-method-id").value = "";
    document.getElementById("filled-in-box-err-id").innerHTML = "";
  }
  else
    document.getElementById("pay-method-id").value = tables[j];
}

function validMonth(chosenMonth, chosenYear){
  var d = new Date();
  var currMonth = d.getMonth() + 1;

  if(chosenYear==1 && chosenMonth>0 && chosenMonth<currMonth)
    document.getElementById("month-list-err-id").innerHTML = " Month already passed";
  else if(chosenMonth > 0)
    document.getElementById("month-list-err-id").innerHTML = "";
}

//Regular Expressions for pattern matching
var validName = /^[A-Z]{1}([A-Z]*|[a-z]*)$/;
var validFullName = /^[A-Z]{1}([A-Z]*|[a-z]*)( [A-Z]{1}([A-Z]*|[a-z]*))*$/;
var validEmail = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
var validPhn = /^(0|\+91)?\d{10}$/;
var validCity = /^[A-Za-z]+([\s|-]{1}[A-Za-z]+)*$/;
var validPin = /^[1-9]{1}[0-9]{5}$/;
var validPasswd = /^.{8,40}$/;
var validCardNo = /^([0-9]{12,16}|[0-9]{18,19})$/;

var fname, mname, lname, email, phn, add_line1, city, state, pin, passwd, re_passwd;
var card_no, cardholder, wallet_phn;

// Perform individual input field validation, one at a time, on change of its input value
function validatorInstant(){
  // First Name
  if(this.id == "fname-id"){
    fname = document.getElementById(this.id).value;

    if(fname == "")
      document.getElementById("fname-err-id").innerHTML = " Blank";
    else if(!(validName.test(fname)))
      document.getElementById("fname-err-id").innerHTML = " Invalid";
    else
      document.getElementById("fname-err-id").innerHTML = "";
  }
  // Middle Name
  else if(this.id == "mname-id"){
    mname = document.getElementById(this.id).value;

    if(mname != "" && !(validName.test(mname)))
      document.getElementById("mname-err-id").innerHTML = " Invalid";
    else
      document.getElementById("mname-err-id").innerHTML = "";
  }
  // Last Name
  else if(this.id == "lname-id"){
    lname = document.getElementById(this.id).value;

    if(lname == "")
      document.getElementById("lname-err-id").innerHTML = " Blank";
    else if(!(validName.test(lname)))
      document.getElementById("lname-err-id").innerHTML = " Invalid";
    else
      document.getElementById("lname-err-id").innerHTML = "";
  }
  // Email
  else if(this.id == "email-id"){
    email = document.getElementById(this.id).value;

    if(email == "")
      document.getElementById("email-err-id").innerHTML = " Blank";
    else if(!(validEmail.test(email)))
      document.getElementById("email-err-id").innerHTML = " Invalid";
    else
      document.getElementById("email-err-id").innerHTML = "";
  }
  // Phone Number
  else if(this.id == "phn-id"){
    phn = document.getElementById(this.id).value;

    if(phn == "")
      document.getElementById("phn-err-id").innerHTML = " Blank";
    else if(!(validPhn.test(phn)))
      document.getElementById("phn-err-id").innerHTML = " Invalid";
    else
      document.getElementById("phn-err-id").innerHTML = "";
  }
  // Address Line 1
  else if(this.id == "add-line1-id"){
    add_line1 = document.getElementById(this.id).value;

    if(add_line1 == "")
      document.getElementById("add-line1-err-id").innerHTML = " Blank";
    else
      document.getElementById("add-line1-err-id").innerHTML = "";
  }
  // City
  else if(this.id == "city-id"){
    city = document.getElementById(this.id).value;

    if(city == "")
      document.getElementById("city-err-id").innerHTML = " Blank";
    else if(!(validCity.test(city)))
      document.getElementById("city-err-id").innerHTML = " Invalid";
    else
      document.getElementById("city-err-id").innerHTML = "";
  }
  // State
  else if(this.id == "state-id"){
    state = document.getElementById(this.id).value;

    if(state == "")
      document.getElementById("state-err-id").innerHTML = " Blank";
    else if(!(validCity.test(state)))
      document.getElementById("state-err-id").innerHTML = " Invalid";
    else
      document.getElementById("state-err-id").innerHTML = "";
  }
  // Pincode
  else if(this.id == "pin-id"){
    pin = document.getElementById(this.id).value;

    if(pin == "")
      document.getElementById("pin-err-id").innerHTML = " Blank";
    else if(!(validPin.test(pin)))
      document.getElementById("pin-err-id").innerHTML = " Invalid";
    else
      document.getElementById("pin-err-id").innerHTML = "";
  }
  // Password
  else if(this.id == "passwd-id"){
    passwd = document.getElementById(this.id).value;
    re_passwd = document.getElementById("re-passwd-id").value;

    if(passwd == "")
      document.getElementById("passwd-err-id").innerHTML = " Blank";
    else if(!(validPasswd.test(passwd)))
      document.getElementById("passwd-err-id").innerHTML = " 8 to 40 characters";
    else
      document.getElementById("passwd-err-id").innerHTML = "";

    if(re_passwd != ""){
      if(passwd != re_passwd)
        document.getElementById("re-passwd-err-id").innerHTML = " Mismatch";
      else
        document.getElementById("re-passwd-err-id").innerHTML = "";
    }
  }
  // retype Password
  else if(this.id == "re-passwd-id"){
    re_passwd = document.getElementById(this.id).value;
    passwd = document.getElementById("passwd-id").value;

    if(re_passwd == "")
      document.getElementById("re-passwd-err-id").innerHTML = " Blank";
    else{
      if(passwd != re_passwd)
        document.getElementById("re-passwd-err-id").innerHTML = " Mismatch";
      else
        document.getElementById("re-passwd-err-id").innerHTML = "";
      if(passwd == "")
        document.getElementById("passwd-err-id").innerHTML = " Blank";
    }
  }
  // Card No.
  else if(this.id == "card-no-id"){
    card_no = document.getElementById(this.id).value;

    if(card_no == "")
      document.getElementById("card-no-err-id").innerHTML = " Blank";
    else if(!(validCardNo.test(card_no)))
      document.getElementById("card-no-err-id").innerHTML = " Invalid";
    else
      document.getElementById("card-no-err-id").innerHTML = "";
  }
  // Month-list
  else if(this.id == "month-list-id"){
    document.getElementById("month-list-err-id").innerHTML = "";

    var chosenMonth = this.selectedIndex;
    var chosenYear = document.getElementById("year-list-id").selectedIndex;
    //document.getElementById("cardholder-id").value = chosenMonth + " " + chosenYear;
    validMonth(chosenMonth, chosenYear);
  }
  // Year-list
  else if(this.id == "year-list-id"){
    document.getElementById("year-list-err-id").innerHTML = "";

    var chosenMonth = document.getElementById("month-list-id").selectedIndex;
    var chosenYear = this.selectedIndex;
    //document.getElementById("cardholder-id").value = chosenMonth + " " + chosenYear;
    validMonth(chosenMonth, chosenYear);
  }
  // Cardholder's Name
  else if(this.id == "cardholder-id"){
    cardholder = document.getElementById(this.id).value;

    if(cardholder == "")
      document.getElementById("cardholder-err-id").innerHTML = " Blank";
    else if(!(validFullName.test(cardholder)))
      document.getElementById("cardholder-err-id").innerHTML = " Invalid";
    else
      document.getElementById("cardholder-err-id").innerHTML = "";
  }
  // Bank Name-list
  else if(this.id == "bank-list-id")
    document.getElementById("bank-list-err-id").innerHTML = "";
  // Wallet Name-list
  else if(this.id == "wallet-list-id")
    document.getElementById("wallet-list-err-id").innerHTML = "";
  // Wallet Phone Number
  else if(this.id == "wallet-phn-id"){
    wallet_phn = document.getElementById(this.id).value;

    if(wallet_phn == "")
      document.getElementById("wallet-phn-err-id").innerHTML = " Blank";
    else if(!(validPhn.test(wallet_phn)))
      document.getElementById("wallet-phn-err-id").innerHTML = " Invalid";
    else
      document.getElementById("wallet-phn-err-id").innerHTML = "";
  }
}

var form_status;
var pay_method_status;

// Check if email or phone already exists or not
// Without page reload [AJAX]
function isDuplicate(fieldName, fieldValue){
  var returnValue;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "signup",
      attribute: fieldName,
      data: fieldValue
    },
    function(data){
      if(data == "true")
        returnValue = true;
      else
        returnValue = false;
    }
  );
  return returnValue;
}

// Perform whole form validation on Submit button click
function validatorSubmit(){
  fname = document.signup_form.fname.value;
  mname = document.signup_form.mname.value;
  lname = document.signup_form.lname.value;
  email = document.signup_form.email.value;
  phn = document.signup_form.phn.value;
  add_line1 = document.signup_form.add_line1.value;
  city = document.signup_form.city.value;
  state = document.signup_form.state.value;
  pin = document.signup_form.pin.value;
  passwd = document.signup_form.passwd.value;
  re_passwd = document.signup_form.re_passwd.value;

  card_no = document.signup_form.card_no.value;
  month = document.getElementById("month-list-id").options[document.getElementById("month-list-id").selectedIndex].value;
  year = document.getElementById("year-list-id").options[document.getElementById("year-list-id").selectedIndex].value;
  cardholder = document.signup_form.cardholder.value;
  bank = document.getElementById("bank-list-id").options[document.getElementById("bank-list-id").selectedIndex].value;
  wallet = document.getElementById("wallet-list-id").options[document.getElementById("wallet-list-id").selectedIndex].value;
  wallet_phn = document.signup_form.wallet_phn.value;

  form_status = true;
  pay_method_status = true;

  // First Name
  if(fname == ""){
    document.getElementById("fname-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validName.test(fname))){
    document.getElementById("fname-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else
    document.getElementById("fname-err-id").innerHTML = "";

  // Middle Name
  if(mname != "" && !(validName.test(mname))){
    document.getElementById("mname-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else
    document.getElementById("mname-err-id").innerHTML = "";

  // Last Name
  if(lname == ""){
    document.getElementById("lname-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validName.test(lname))){
    document.getElementById("lname-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else
    document.getElementById("lname-err-id").innerHTML = "";

  // Email
  if(email == ""){
    document.getElementById("email-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validEmail.test(email))){
    document.getElementById("email-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else if(isDuplicate("email", email)){
    document.getElementById("email-err-id").innerHTML = " Already exists";
    form_status = false;
  }
  else
    document.getElementById("email-err-id").innerHTML = "";

  // Phone Number
  if(phn == ""){
    document.getElementById("phn-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validPhn.test(phn))){
    document.getElementById("phn-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else if(isDuplicate("Phone", phn)){
    document.getElementById("phn-err-id").innerHTML = " Already exists";
    form_status = false;
  }
  else
    document.getElementById("phn-err-id").innerHTML = "";

  // Address Line 1
  if(add_line1 == ""){
    document.getElementById("add-line1-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("add-line1-err-id").innerHTML = "";

  // City
  if(city == ""){
    document.getElementById("city-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validCity.test(city))){
    document.getElementById("city-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else
    document.getElementById("city-err-id").innerHTML = "";

  // State
  if(state == ""){
    document.getElementById("state-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validCity.test(state))){
    document.getElementById("state-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else
    document.getElementById("state-err-id").innerHTML = "";

  // Pincode
  if(pin == ""){
    document.getElementById("pin-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validPin.test(pin))){
    document.getElementById("pin-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else
    document.getElementById("pin-err-id").innerHTML = "";

  // Password
  if(passwd == ""){
    document.getElementById("passwd-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validPasswd.test(passwd))){
    document.getElementById("passwd-err-id").innerHTML = "  8 to 40 characters";
    form_status = false;
  }
  else
    document.getElementById("passwd-err-id").innerHTML = "";

  // Retype Password
  if(re_passwd == ""){
    document.getElementById("re-passwd-err-id").innerHTML = " Blank";
    form_status = false;
  }
  // Matching password and retyped password
  else if(passwd != re_passwd){
    document.getElementById("re-passwd-err-id").innerHTML = " Mismatch";
    form_status = false;
  }
  else
    document.getElementById("re-passwd-err-id").innerHTML = "";

  // Payment methods

  // Checkbox not checked
  if(document.getElementById("filled-in-box-id").checked == false){

    // Debit/Credit card
    if(document.getElementById("pay-method-id").value == "Card"){

      // Card No.
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

      // Month
      if(month == ""){
        document.getElementById("month-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("month-list-err-id").innerHTML = "";

      // Year
      if(year == ""){
        document.getElementById("year-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("year-list-err-id").innerHTML = "";

      // Valid month-year combination
      var chosenMonth = document.getElementById("month-list-id").selectedIndex;
      var chosenYear = document.getElementById("year-list-id").selectedIndex;
      var d = new Date();
      var currMonth = d.getMonth() + 1;

      if(chosenYear==1 && chosenMonth>0 && chosenMonth<currMonth){
        document.getElementById("month-list-err-id").innerHTML = " Month already passed";
        pay_method_status = false;
      }
      else if(chosenMonth > 0)
        document.getElementById("month-list-err-id").innerHTML = "";

      // Cardholder's Name
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

      // Method Heading
      if(pay_method_status == false)
        document.getElementById("dc-card-err-id").innerHTML = " Error";
      else
        document.getElementById("dc-card-err-id").innerHTML = "";
    }
    // Net Banking
    else if(document.getElementById("pay-method-id").value == "NetB"){

      // Name of Bank
      if(bank == ""){
        document.getElementById("bank-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("bank-list-err-id").innerHTML = "";

      // Method Heading
      if(pay_method_status == false)
        document.getElementById("net-b-err-id").innerHTML = " Error";
      else
        document.getElementById("net-b-err-id").innerHTML = "";
    }
    // Mobile Wallet
    else if(document.getElementById("pay-method-id").value == "mWallet"){

      // Name of Wallet
      if(wallet == ""){
        document.getElementById("wallet-list-err-id").innerHTML = " Not selected";
        pay_method_status = false;
      }
      else
        document.getElementById("wallet-list-err-id").innerHTML = "";

      // Wallet Phone Number
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

      // Method Heading
      if(pay_method_status == false)
        document.getElementById("m-wallet-err-id").innerHTML = " Error";
      else
        document.getElementById("m-wallet-err-id").innerHTML = "";
    }
    // None chosen
    else{
      document.getElementById("filled-in-box-err-id").innerHTML = " Specify a payment method";
      pay_method_status = false;
    }
  }

  if(form_status==false || pay_method_status==false){
    document.getElementById("submit-btn-err-id").innerHTML = " Error";
    return false;
  }
  else{
    document.getElementById("submit-btn-err-id").innerHTML = "";
    return true;
  }
}
