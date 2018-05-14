$(document).ready(function(){
  $(".button-collapse").sideNav();
})

// Check if email or phone already exists or not
// Without page reload [AJAX]
function isDuplicate(fieldName, fieldValue, Cust_id){
  var returnValue;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "profile_personal",
      attribute: fieldName,
      data: fieldValue,
      Cust_id: Cust_id
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

function isIncorrect(fieldName, fieldValue, Cust_id){
  var returnValue;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "profile_password",
      attribute: fieldName,
      data: fieldValue,
      Cust_id: Cust_id
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

//Regular Expressions for pattern matching
var validName = /^[A-Z]{1}([A-Z]*|[a-z]*)$/;
var validFullName = /^[A-Z]{1}([A-Z]*|[a-z]*)( [A-Z]{1}([A-Z]*|[a-z]*))*$/;
var validEmail = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
var validPhn = /^(0|\+91)?\d{10}$/;
var validCity = /^[A-Za-z]+([\s|-]{1}[A-Za-z]+)*$/;
var validPin = /^[1-9]{1}[0-9]{5}$/;
var validPasswd = /^.{8,40}$/;

var fname, mname, lname, email, phn, add_line1, city, state, pin, old_passwd, new_passwd, re_new_passwd;
var form_status;

function editPersonalInfo(){
  $("#fname-id").prop ('disabled', false);
  $("#mname-id").prop ('disabled', false);
  $("#lname-id").prop ('disabled', false);
  $("#email-id").prop ('disabled', false);
  $("#phn-id").prop ('disabled', false);
  $("#add-line1-id").prop ('disabled', false);
  $("#add-line2-id").prop ('disabled', false);
  $("#city-id").prop ('disabled', false);
  $("#state-id").prop ('disabled', false);
  $("#pin-id").prop ('disabled', false);
  $("#apply-changes-id").prop ('disabled', false);
}

// Perform individual input field validation, one at a time, on change of its input value
function validatorInstantPersonal(){
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
}

// Perform whole form validation on Submit button click
function validatorSubmitPersonal(){
  Cust_id = document.profile_personal_form.cust_id_name.value;
  fname = document.profile_personal_form.fname.value;
  mname = document.profile_personal_form.mname.value;
  lname = document.profile_personal_form.lname.value;
  email = document.profile_personal_form.email.value;
  phn = document.profile_personal_form.phn.value;
  add_line1 = document.profile_personal_form.add_line1.value;
  city = document.profile_personal_form.city.value;
  state = document.profile_personal_form.state.value;
  pin = document.profile_personal_form.pin.value;

  form_status = true;

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
  else if(isDuplicate("email", email, Cust_id)){
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
  else if(isDuplicate("Phone", phn, Cust_id)){
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

  return form_status;
}

function validatorInstantPassword(){
  // Old Password
  if(this.id == "old-passwd-id"){
    old_passwd = document.getElementById(this.id).value;

    if(old_passwd == "")
      document.getElementById("old-passwd-err-id").innerHTML = " Blank";
    else if(!(validPasswd.test(old_passwd)))
      document.getElementById("old-passwd-err-id").innerHTML = " 8 to 40 characters";
    else
      document.getElementById("old-passwd-err-id").innerHTML = "";
  }
  // New Password
  else if(this.id == "new-passwd-id"){
    new_passwd = document.getElementById(this.id).value;
    re_new_passwd = document.getElementById("re-new-passwd-id").value;

    if(new_passwd == "")
      document.getElementById("new-passwd-err-id").innerHTML = " Blank";
    else if(!(validPasswd.test(new_passwd)))
      document.getElementById("new-passwd-err-id").innerHTML = " 8 to 40 characters";
    else
      document.getElementById("new-passwd-err-id").innerHTML = "";

    if(re_new_passwd != ""){
      if(new_passwd != re_new_passwd)
        document.getElementById("re-new-passwd-err-id").innerHTML = " Mismatch";
      else
        document.getElementById("re-new-passwd-err-id").innerHTML = "";
    }
  }
  // Retype New Password
  else if(this.id == "re-new-passwd-id"){
    re_new_passwd = document.getElementById(this.id).value;
    new_passwd = document.getElementById("new-passwd-id").value;

    if(re_new_passwd == "")
      document.getElementById("re-new-passwd-err-id").innerHTML = " Blank";
    else{
      if(new_passwd != re_new_passwd)
        document.getElementById("re-new-passwd-err-id").innerHTML = " Mismatch";
      else
        document.getElementById("re-new-passwd-err-id").innerHTML = "";
      if(new_passwd == "")
        document.getElementById("new-passwd-err-id").innerHTML = " Blank";
    }
  }
}

function validatorSubmitPassword(){
  Cust_id = document.profile_password_form.cust_id_name.value;
  old_passwd = document.profile_password_form.old_passwd.value;
  new_passwd = document.profile_password_form.new_passwd.value;
  re_new_passwd = document.profile_password_form.re_new_passwd.value;

  form_status = true;

  // Old Password
  if(old_passwd == ""){
    document.getElementById("old-passwd-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validPasswd.test(old_passwd))){
    document.getElementById("old-passwd-err-id").innerHTML = "  8 to 40 characters";
    form_status = false;
  }
  else if(isIncorrect("passwd", old_passwd, Cust_id)){
    document.getElementById("old-passwd-err-id").innerHTML = " Incorrect";
    form_status = false;
  }
  else
    document.getElementById("old-passwd-err-id").innerHTML = "";

  // New Password
  if(new_passwd == ""){
    document.getElementById("new-passwd-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if(!(validPasswd.test(new_passwd))){
    document.getElementById("new-passwd-err-id").innerHTML = "  8 to 40 characters";
    form_status = false;
  }
  else
    document.getElementById("new-passwd-err-id").innerHTML = "";

  // Retype New Password
  if(re_new_passwd == ""){
    document.getElementById("re-new-passwd-err-id").innerHTML = " Blank";
    form_status = false;
  }
  // Matching  new password and retyped new password
  else if(new_passwd != re_new_passwd){
    document.getElementById("re-new-passwd-err-id").innerHTML = " Mismatch";
    form_status = false;
  }
  else
    document.getElementById("re-new-passwd-err-id").innerHTML = "";

  return form_status;
}