var uname, passwd;
var form_status;

// Check if username and password are
// Valid or not, without page reload [AJAX]
function isInvalid(fieldName, fieldValue){
  var returnValue = false;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "adminlogin",
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
  // User Name
  if(this.id == "uname-id"){
    uname = document.getElementById(this.id).value;

    if(uname == "")
      document.getElementById("uname-err-id").innerHTML = " Blank";
    else
      document.getElementById("uname-err-id").innerHTML = "";
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
  uname = document.adminlogin_form.uname.value;
  passwd = document.adminlogin_form.passwd.value;

  form_status = true;

  // User Name
  if(uname == ""){
    document.getElementById("uname-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("uname-err-id").innerHTML = "";

  // Password
  if(passwd == ""){
    document.getElementById("passwd-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("passwd-err-id").innerHTML = "";

  if(uname != ""){

    // Check if username does not exist
    if(isInvalid("uname", uname)){
      document.getElementById("uname-err-id").innerHTML = " Doesn't exist";
      form_status = false;
    }
    // Check if password is incorrect, when user name exists
    else if(passwd != ""){
      if(isInvalid("uname,passwd", uname+","+passwd)){
        document.getElementById("passwd-err-id").innerHTML = " Incorrect";
        form_status = false;
      }
    }
  }

  return form_status;
}