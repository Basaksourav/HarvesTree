<%@ page import="javaPackage.Database, java.sql.*"%>

<!DOCTYPE html>
<html lang="en-US">
  <%!
    String isCustomerLoggedIn = new String();
    String loggedInIDS = new String();
    int loggedInID;
    String loggedInName = new String();

    String proTyp = new String();
    String[] proTypParamS = {"fru", "flo", "veg"};
    String[] proTypNameS = {"Fruit", "Flower", "Vegetable", "Product"};
    int proTypNo = 3;

    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();
    int count = 0;

    int Pro_id, BaseQty, BasePrice, i;
    String ProName, BaseUnit, ProImage;
  %>

  <%
    proTyp = request.getParameter ("type");
    if (proTyp == null)
      proTyp = "fru";
    for (int i = 0; i < 3; i++){
      if (proTypParamS[i].equals(proTyp)){
        proTypNo = i;
      }
    }

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
    <title>Buy <%= proTypNameS[proTypNo] %>s from HarvesTree</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link rel="stylesheet" type="text/css" href="css/productlist.css">
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
                <li><a href="DemoLoginServlet?source=productlist.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <ul id="dropdown-small-screen" class="dropdown-content">
                <li><a href="#!"><i class="material-icons">account_circle</i>Profile</a></li>
                <li><a href="#!"><i class="material-icons">style</i>Orders</a></li>
                <li class="divider"></li>
                <li><a href="DemoLoginServlet?source=productlist.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <a href="#" class="brand-logo">HarvesTree</a>
              <a href="#" data-activates="mobile-demo-logged-in" class="button-collapse"><i class="material-icons">menu</i></a>
              <ul class="right hide-on-med-and-down">
                <li><a class="dropdown-button" href="#!" data-activates="dropdown-large-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
                <li><a href="#"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
              <ul class="side-nav" id="mobile-demo-logged-in">
                <li><a class="dropdown-button" href="#!" data-activates="dropdown-small-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
                <li><a href="#"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
          <%
            }
            else{
          %>
              <!-- Nav Bar when not Logged In -->
              <a href="#" class="brand-logo">HarvesTree</a>
              <a href="#" data-activates="mobile-demo-not-logged-in" class="button-collapse"><i class="material-icons">menu</i></a>
              <ul class="right hide-on-med-and-down">
                <li><a href="#">Login &amp Signup</a></li>
                <li><a href="#"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
              <ul class="side-nav" id="mobile-demo-not-logged-in">
                <li><a href="#">Login &amp Signup</a></li>
                <li><a href="#"><i class="material-icons">shopping_cart</i></a></li>
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

        <!-- Category Tabs -->
        <!-- <div class="nav-content row">
          <ul class="tabs tabs-transparent">
            <%
              for (int i = 0; i < 3; i++){
                if (proTypNo == i){
            %>
                  <li class="tab col m4"><a class="active" id="<%= proTypParamS[i] %>" onclick="javascript:showProducts.call(this)"><%= proTypNameS[i] %>s</a></li>
            <%
                }
                else{
            %>
                  <li class="tab col m4"><a id="<%= proTypParamS[i] %>" onclick="javascript:showProducts.call(this)"><%= proTypNameS[i] %>s</a></li>
            <%
                }
              }
            %>
          </ul>
        </div> -->
        <!-- Category Tabs -->
        <div class="navbar-fixed row">
          <ul class="center hide-on-med-and-down">
            <%
              for (int i = 0; i < 3; i++){
                if (proTypNo == i){
            %>
                  <li class="tab col m4"><strong><a class="active" style="color:black" href="productlist.jsp?type=<%= proTypParamS[i] %>"><%= proTypNameS[i] %>s</a></strong></li>
            <%
                }
                else{
            %>
                  <li class="tab col m4"><a href="productlist.jsp?type=<%= proTypParamS[i] %>"><%= proTypNameS[i] %>s</a></li>
            <%
                }
              }
            %>
          </ul>
        </div>
      </div>
    </nav>

    <%
      try{
        ps = con.prepareStatement ("SELECT Pro_id, ProName, BaseQty, BaseUnit, BasePrice, ProImage FROM Product WHERE Type = ?");
        ps.setString (1, proTyp);
        rs = ps.executeQuery();
    %>
        <!-- Product List -->
        <div class="container" id="product-list-id">
          <div class='row'>
    <%
          while (rs.next()){
            Pro_id = rs.getInt("Pro_id");
            ProName = rs.getString("ProName");
            i = ProName.indexOf('(');
            if (i != -1)
              ProName = ProName.substring (0, i).trim();
            BasePrice = rs.getInt("BasePrice");
            ProImage = rs.getString("ProImage");
    %>
            <div class="col s12 m4">
              <a href="product.jsp?product=<%= proTyp+Pro_id %>">
                <div class="card">
                  <div class="card-image">
                    <img src="<%= ProImage %>">
                    <span class="card-title"><%= ProName %></span>
                    <a href="cart.jsp" class="btn-floating btn-large tooltipped halfway-fab waves-effect waves-light red" data-position="bottom" data-delay="50" data-tooltip="Add to cart"><i id="<%= proTyp+Pro_id %>" class="large material-icons">add_shopping_cart</i></a>
                  </div>
                  <div class="card-content">
                    <p class="price">Rs. <%= BasePrice %></p>
                  </div>
                </div>
              </a>
            </div>
    <%
          count++;
          if (count == 3){
    %>
          </div>
          <div class='row'>
    <%
            count = 0;
          }
        }
      }
      catch (SQLException e){
        e.printStackTrace();
      }
    %>
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
        © 2017-2018 HarvesTree
        </div>
      </div>
    </footer>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/productlist.js"></script>
  </body>
</html>