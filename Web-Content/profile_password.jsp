<%@ page import="javaPackage.Database, java.sql.*, javaPackage.Cart"%>

<!DOCTYPE html>
<html lang="en-US">
  <%!
    String isCustomerLoggedIn = new String();
    String loggedInIDS = new String();
    int loggedInID;
    String loggedInName = new String();

    PreparedStatement ps;
    ResultSet rs, rs1;
    Connection con = new Database().connect();
  %>

  <%
    isCustomerLoggedIn = (String)session.getAttribute ("isCustomerLoggedIn");
    if ("true".equals(isCustomerLoggedIn))
      loggedInName = (String)session.getAttribute ("loggedInName");
    else
      session.setAttribute ("loggedInID", "0");
    loggedInIDS = (String)session.getAttribute ("loggedInID");
    loggedInID = Integer.parseInt (loggedInIDS);
  %>

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>My Profile</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link rel="stylesheet" type="text/css" href="css/profile.css">
  </head>

  <body>
    <%
      if ("true".equals(isCustomerLoggedIn)){
    %>
    <!-- Nav Bar -->
    <nav class="nav-extended orange">
      <div class="container">
        <div class="nav-wrapper">
          <!-- Nav Bar when Logged In -->
          <ul id="dropdown-large-screen" class="dropdown-content">
            <li><a href="order.jsp"><i class="material-icons">style</i>Orders</a></li>
            <li class="divider"></li>
            <li><a href="LoginServlet?source=index.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
          </ul>
          <ul id="dropdown-small-screen" class="dropdown-content">
            <li><a href="order.jsp"><i class="material-icons">style</i>Orders</a></li>
            <li class="divider"></li>
            <li><a href="LoginServlet?source=index.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
          </ul>
          <a href="index.jsp" class="brand-logo">HarvesTree</a>
          <a href="#" data-activates="mobile-demo-logged-in" class="button-collapse"><i class="material-icons">menu</i></a>
          <ul class="right hide-on-med-and-down">
            <li><a class="dropdown-button" href="#!" data-activates="dropdown-large-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
            <li><a href="productlist.jsp">Products</a></li>
            <li><a href="cart.jsp"><i class="material-icons">shopping_cart</i></a></li>
          </ul>
          <ul class="side-nav" id="mobile-demo-logged-in">
            <li><a class="dropdown-button" href="#!" data-activates="dropdown-small-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
            <li><a href="productlist.jsp">Products</a></li>
            <li><a href="cart.jsp"><i class="material-icons">shopping_cart</i></a></li>
          </ul>
        </div>

        <!-- Search Bar -->
        <div class="nav-content">
          <form>
            <div class="input-field search-bar">
              <input id="search" type="search" placeholder="Search for fresh fruits, flowers and vegetables" required>
            </div>
          </form>
        </div>
      </div>
    </nav>

    <!-- Main Area -->
    <div class="container">
      <div class="row">
        <div class="col m4 s12">
          <div class="collection">
            <a href="#!" class="collection-item">Hello,<br><h5><%= loggedInName %></h5></a>
            <a href="profile_personal.jsp" class="collection-item">Personal Details<i class="secondary-content material-icons">chevron_right</i></a>
            <a href="#!" class="collection-item active">Reset Password<i class="secondary-content material-icons">chevron_right</i></a>
            <!-- <a href="profile_payment.html" class="collection-item">Payment Options<i class="secondary-content material-icons">chevron_right</i></a> -->
          </div>
        </div>

        <div class="col m8 s12">
          <div class="card">
            <form name="profile_password_form" action="ResetPasswordServlet" method="post" onsubmit="return validatorSubmitPassword()">
              <input type="hidden" id="cust-id" name="cust_id_name" value="<%= loggedInID %>">
              <div class="card-content">
                <!-- Password and retype password -->
                <div class="row">
                  <div class="input-field col s12">
                    <i class="material-icons prefix">lock</i>
                    <input id="old-passwd-id" type="password" name="old_passwd" oninput="javascript:validatorInstantPassword.call(this)">
                    <label for="old-passwd-id">Old Password<span id="old-passwd-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col s12">
                    <i class="material-icons prefix"></i>
                    <input id="new-passwd-id" type="password" name="new_passwd" oninput="javascript:validatorInstantPassword.call(this)">
                    <label for="new-passwd-id">New Password<span id="new-passwd-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col s12">
                    <i class="material-icons prefix"></i>
                    <input id="re-new-passwd-id" type="password" name="re_new_passwd" oninput="javascript:validatorInstantPassword.call(this)">
                    <label for="re-new-passwd-id">Retype New Password<span id="re-new-passwd-err-id" class="error-color"></span></label>
                  </div>
                </div>
              </div>

              <div class="card-action">
                <input type="submit" id="apply-changes-id" class="btn waves-effect waves-light" value="Apply Changes">
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer class="orange page-footer">
      <div class="container">
        <div class="row">
          <div class="col l6 s12">
            <h5 class="white-text">Registered Office Address:</h5>
            <p class="grey-text text-lighten-4">
              Pradip Kumar Das,<br>
              Baro Khejuria,<br>
              Post - Adcconagar,<br>
              District - Hoogly,<br>
              West Bengal - 712121
            </p>
          </div>
          <div class="col l4 offset-l2 s12">
            Telephone - 1800 1200 300<br>
            Email - helpdesk@harvestree.in
            <h5 class="white-text">Products:</h5>
            <ul>
              <li><a class="grey-text text-lighten-3" href="#!">Fruits</a></li>
              <li><a class="grey-text text-lighten-3" href="#!">Flowers</a></li>
              <li><a class="grey-text text-lighten-3" href="#!">Vegetables</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div class="footer-copyright">
        <div class="container">
        &copy; 2017-2018 HarvesTree
        </div>
      </div>
    </footer>
    <%
      }
      else{
        response.sendRedirect ("/Harvestree/Web-Content/index.jsp");
      }
    %>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/profile.js"></script>
  </body>
</html>