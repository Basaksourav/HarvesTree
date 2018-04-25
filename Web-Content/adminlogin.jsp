<%@ page %>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Portal Login</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link type="text/css" rel="stylesheet" href="css/adminlogin.css"/>
  </head>

  <body>
    <%!
      //Declare string variables
      //to capture session attribute values
      //to retain in the adminlogin form
      //in case the user is pushed back to the adminlogin page due to some error
      String isAdminLoginErr = new String();
      
      String uname = new String();
      String passwd = new String();
      
      String unameErrMsg = new String();
      String passwdErrMsg = new String();
    %>

    <%
      isAdminLoginErr = (String)session.getAttribute ("isAdminLoginErr");

      //If the user is pushed back to this page due to some error
      if ("true".equals(isAdminLoginErr)){

        uname = (String)session.getAttribute ("uname");
        passwd = (String)session.getAttribute ("passwd");

        unameErrMsg = (String)session.getAttribute ("unameErrMsg");
        passwdErrMsg = (String)session.getAttribute ("passwdErrMsg");
      }

      session.setAttribute ("isAdminLoginErr", "false");
    %>
    <div class="row" id="page-center">
      <form class="col" name="adminlogin_form" action="AdminLoginServlet" method="post" onsubmit="return validatorSubmit()">

        <div class="card hoverable">
          <div class="card-content">

            <!-- Brand Logo -->
            <div class="col s12 center">
              <h3><a href="index.html" class="brand-logo">HarvesTree</a></h3>
              <h6>Admin Portal Login</h6>
            </div>

            <div class="row">
              <!-- Username -->
              <div class="input-field col s12">
                <i class="material-icons prefix">account_circle</i>
                <input id="uname-id" type="text" name="uname" value="<%= uname %>" oninput="javascript:validatorInstant.call(this)">
                <label for="uname-id">User Name<span id="uname-err-id" class="error-color"><%= unameErrMsg %></span></label>
              </div>

              <!-- Password -->
              <div class="input-field col s12">
                <i class="material-icons prefix">lock</i>
                <input id="passwd-id" type="password" name="passwd" value="<%= passwd %>" oninput="javascript:validatorInstant.call(this)">
                <label for="passwd-id">Password<span id="passwd-err-id" class="error-color"><%= passwdErrMsg %></span></label>
              </div>
            </div>
          </div>

          <div class="card-action">
            <input type="submit" class="btn waves-effect waves-light" value="Login">
          </div>
        </div>
      </form>
    </div>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/adminlogin.js"></script>

    <%
      uname = "";
      passwd = "";

      unameErrMsg = "";
      passwdErrMsg = "";
    %>
  </body>
</html>