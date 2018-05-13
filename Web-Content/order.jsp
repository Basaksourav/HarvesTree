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

    String Ord_id, Ord_date, ProName, ProImage, resultPriceQty;
    String[] results;
    int amount, Pro_id, Qty, i;
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
    <title>My Orders</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link rel="stylesheet" type="text/css" href="css/order.css">
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
                <li class="divider"></li>
                <li><a href="LoginServlet?source=index.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <ul id="dropdown-small-screen" class="dropdown-content">
                <li><a href="#!"><i class="material-icons">account_circle</i>Profile</a></li>
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
          <%
            }
            else{
          %>
              <!-- Nav Bar when not Logged In -->
              <a href="index.jsp" class="brand-logo">HarvesTree</a>
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
    <div class="container orders">
    <%
      try{

        if ("true".equals(isCustomerLoggedIn)){
          ps = con.prepareStatement ("SELECT Ord_id, Ord_date, amount FROM Order_List WHERE Cust_id = ? Order By Ord_id desc");
          ps.setInt (1, loggedInID);
          rs = ps.executeQuery();

          while (rs.next()){
            Ord_id = rs.getString ("Ord_id");
            Ord_date = rs.getString ("Ord_date");
            amount = rs.getInt ("amount");
    %>
        <div class="card z-depth-3">
          <div class="order-main-info grey-text">
            <p><%= Ord_id %></p>
            <p><%= Ord_date %></p>
            <p class="right">Order Total <span class="black-text">&#8377;<%= amount %></span></p>
          </div>

          <div class="card-action">
    <%
            ps = con.prepareStatement ("SELECT Product.Pro_id, ProName, ProImage, Qty FROM Order_Detail JOIN Product WHERE Product.Pro_id = Order_Detail.Pro_id and Ord_id = ?");
            ps.setString (1, Ord_id);
            rs1 = ps.executeQuery();
            while (rs1.next()){
              Pro_id = rs1.getInt ("Pro_id");
              ProName = rs1.getString ("ProName");
              ProImage = rs1.getString ("ProImage");
              Qty = rs1.getInt ("Qty");

              i = ProName.indexOf('(');
              if (i != -1)
                ProName = ProName.substring (0, i).trim();

              resultPriceQty = Cart.obtainForCart (Pro_id, Qty);
              results = resultPriceQty.split("-");
    %>
            <div class="row">
              <div class="col s4"><img src="<%= ProImage %>" alt="" width="100px"></div>
              <div class="col s8">
                <div class="row">
                  <div class="col m6 s12 center"><h5><%= ProName %></h5></div>
                  <div class="col m6 s12 center"><h5>&#8377;<%= results[0] %> <span class="text-muted">for <%= results[1] %> <%= results[2] %></span></h5></div>
                </div>
              </div>
            </div>
    <%
            }//Inner while end
    %>
          </div>
        </div>
    <%
          }//Outer while end
        }//Logged-in if end
      }//try block end
      catch (Exception e){
        e.printStackTrace();
      }
    %>
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

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/order.js"></script>
  </body>

</html>