var email, passwd;
var form_status;

// Check if email and password are
// Valid or not, without page reload [AJAX]
function isInvalid(fieldName, fieldValue){
  var returnValue = false;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "login",
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

// Perform individual input field validation, one at a time, on change of its input value
function validatorInstant(){
  // Email
  if(this.id == "email-id"){
    email = document.getElementById(this.id).value;

    if(email == "")
      document.getElementById("email-err-id").innerHTML = " Blank";
    else
      document.getElementById("email-err-id").innerHTML = "";
  }

  // Password
  if(this.id == "passwd-id"){
    passwd = document.getElementById(this.id).value;

    if(passwd == "")
      document.getElementById("passwd-err-id").innerHTML = " Blank";
    else
      document.getElementById("passwd-err-id").innerHTML = "";
  }
}

// Perform form validation on Submit button click
function validatorSubmit(){
  email = document.login_form.email.value;
  passwd = document.login_form.passwd.value;

  form_status = true;

  // Email
  if(email == ""){
    document.getElementById("email-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("email-err-id").innerHTML = "";

  // Password
  if(passwd == ""){
    document.getElementById("passwd-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("passwd-err-id").innerHTML = "";

  if(email != ""){

    // Check if email does not exist
    if(isInvalid("email", email)){
      document.getElementById("email-err-id").innerHTML = " Doesn't exist";
      form_status = false;
    }
    // Check if password is incorrect, when email exists
    else if(passwd != ""){
      if(isInvalid("email,passwd", email+","+passwd)){
        document.getElementById("passwd-err-id").innerHTML = " Incorrect";
        form_status = false;
      }
    }
  }

  return form_status;
}