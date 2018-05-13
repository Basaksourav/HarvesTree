<%@ page import="javaPackage.Database, java.sql.*"%>

<!DOCTYPE html>
<html lang="en-US">
  <%!
    String isCustomerLoggedIn = new String();
    String loggedInIDS = new String();
    int loggedInID;
    String loggedInName = new String();
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
    <title>HarvesTree</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link rel="stylesheet" type="text/css" href="css/index.css">
  </head>

  <body>
    <!-- Nav Bar -->
    <nav class="nav-extended orange">
      <div class="container">
        <div class="nav-wrapper">
          <%
            if ("true".equals(isCustomerLoggedIn)){
          %>
              <!-- Nav Bar when Logged In -->
              <ul id="dropdown-large-screen" class="dropdown-content">
                <li><a href="#!"><i class="material-icons">account_circle</i>Profile</a></li>
                <li><a href="#!"><i class="material-icons">style</i>Orders</a></li>
                <li class="divider"></li>
                <li><a href="LoginServlet?source=index.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <ul id="dropdown-small-screen" class="dropdown-content">
                <li><a href="#!"><i class="material-icons">account_circle</i>Profile</a></li>
                <li><a href="#!"><i class="material-icons">style</i>Orders</a></li>
                <li class="divider"></li>
                <li><a href="LoginServlet?source=index.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <a style="cursor:default" class="brand-logo">HarvesTree</a>
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
          <%
            }
            else{
          %>
              <!-- Nav Bar when not Logged In -->
              <a style="cursor:default" class="brand-logo">HarvesTree</a>
              <a href="#" data-activates="mobile-demo-not-logged-in" class="button-collapse"><i class="material-icons">menu</i></a>
              <ul class="right hide-on-med-and-down">
                <li><a href="#login-signup-modal-id" class="modal-trigger">Login &amp; Signup</a></li>
                <li><a href="productlist.jsp">Products</a></li>
                <li><a href="cart.jsp"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
              <ul class="side-nav" id="mobile-demo-not-logged-in">
                <li><a href="#login-signup-modal-id" class="modal-trigger">Login &amp; Signup</a></li>
                <li><a href="productlist.jsp">Products</a></li>
                <li><a href="cart.jsp"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
          <%
            }
          %>
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

    <!-- Main area -->
    <div class="container">
      <!-- Categories -->
      <div class="categories">
        <p class="flow-text center">We at <span style="font-family: 'Kaushan Script', cursive; color: orange;">HarvesTree</span> are dedicated to cater to your desire of freshness</p>
        <p class="center">Pick anything you like from our three categories. </p>
        <div class="row">
          <!-- Fruits -->
          <div class="col s12 m4">
            <a href="productlist.jsp?type=fru">
              <div class="card">
                <div class="card-image">
                  <img src="assets/images/category-fruit.jpg">
                  <span class="card-title">Fruits</span>
                </div>
              </div>
            </a>
          </div>

          <!-- Flowers -->
          <div class="col s12 m4">
            <a href="productlist.jsp?type=flo">
              <div class="card">
                <div class="card-image">
                  <img src="assets/images/category-flower.jpg">
                  <span class="card-title">Flowers</span>
                </div>
              </div>
            </a>
          </div>

          <!-- Vegetables -->
          <div class="col s12 m4">
            <a href="productlist.jsp?type=veg">
              <div class="card">
                <div class="card-image">
                  <img src="assets/images/category-vegetable.jpg">
                  <span class="card-title">Vegetables</span>
                </div>
              </div>
            </a>
          </div>

        </div>
      </div>

      <div class="divider"></div>

      <!-- Offers -->
      <div class="offers">
        <p class="flow-text center">Check out some of our exciting offers</p>
        <a href="#"><img class="z-depth-3 responsive-img" src="assets/images/offers/offer1.png"></a>
        <a href="#"><img class="z-depth-3 responsive-img" src="assets/images/offers/offer2.png"></a>
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

    <!-- Login & Signup modal -->
    <div id="login-signup-modal-id" class="modal">
      <form name="login_form" action="LoginServlet?source=index.jsp" method="post" onsubmit="return validatorSubmit()">
        <div class="modal-content">
          <h5>Login &amp; Signup</h5>
          <div class="row">
            <div class="row">
              <div class="input-field col s12">
                <i class="material-icons prefix">account_circle</i>
                <input type="text" name="email" id="email-id" oninput="javascript:validatorInstant.call(this)">
                <label for="email-id">Enter Email<span id="email-err-id" class="error-color"></span></label>
              </div>
              <div class="input-field col s12">
                <i class="material-icons prefix">lock</i>
                <input type="password" name="passwd" id="passwd-id" oninput="javascript:validatorInstant.call(this)">
                <label for="passwd-id">Enter Password<span id="passwd-err-id" class="error-color"></span></label>
              </div>
            </div>
          </div>
        </div>

        <div class="modal-footer">
          <a href="signup.jsp?source=index.jsp" class="modal-action modal-close waves-effect waves-light btn-flat">Signup</a>
          <input type="submit" class="btn waves-effect waves-light orange" value="Login">
        </div>
      </form>
    </div>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/index.js"></script>
    <script type="text/javascript" src="js/login.js"></script>
  </body>
</html>