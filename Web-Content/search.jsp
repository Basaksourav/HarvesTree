<%@ page import="javaPackage.Database, java.sql.*"%>

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
    int count = 0;
    String[] Pro_id_set;

    int Pro_id, BaseQty, BasePrice, OrderLimit, i;
    float LimitQty, MaxQty;
    String ProName, BaseUnit, MaxUnit, LimitQtyS, ProImage, results, proTyp;
    boolean calcAgain = false;
    boolean changed = false;
    boolean anonymouslyAdded = false;
  %>

  <%
    results = request.getParameter ("results");
    if (results == null)
      response.sendRedirect ("/Harvestree/Web-Content/productlist.jsp");
    else{
      Pro_id_set = results.split("-");
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
    <title>Search Results on HarvesTree</title>

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
                <li><a href="profile_personal.jsp"><i class="material-icons">account_circle</i>Profile</a></li>
                <li><a href="order.jsp"><i class="material-icons">style</i>Orders</a></li>
                <li class="divider"></li>
                <li><a href="LoginServlet?source=search.jsp&results=<%= results %>"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <ul id="dropdown-small-screen" class="dropdown-content">
                <li><a href="profile_personal.jsp"><i class="material-icons">account_circle</i>Profile</a></li>
                <li><a href="order.jsp"><i class="material-icons">style</i>Orders</a></li>
                <li class="divider"></li>
                <li><a href="LoginServlet?source=productlist.jsp&results=<%= results %>"><i class="material-icons">settings_power</i>Logout</a></li>
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
          <form action="SearchServlet">
            <div class="input-field search-bar">
              <input id="search" type="search" name="key" placeholder="Search for fresh fruits, flowers and vegetables" required>
            </div>
          </form>
        </div>
      </div>
    </nav>

    <!-- Product List -->
        <div class="container" id="product-list-id">
          <div class='row'>

    <%
      try{
        if (results != null){
        for (String s : Pro_id_set){
          Pro_id = Integer.parseInt (s);
          ps = con.prepareStatement ("SELECT Type, ProName, BaseQty, BaseUnit, BasePrice, MaxQty, MaxUnit, OrderLimit, ProImage FROM Product WHERE Pro_id = ?");
          ps.setInt (1, Pro_id);
          rs = ps.executeQuery();
          rs.next();

          ProName = rs.getString("ProName");
          i = ProName.indexOf('(');
          if (i != -1)
            ProName = ProName.substring (0, i).trim();

          proTyp = rs.getString ("Type");
          BaseQty = rs.getInt ("BaseQty");
          BaseUnit = rs.getString ("BaseUnit");
          BasePrice = rs.getInt("BasePrice");
          MaxQty = rs.getFloat ("MaxQty");
          MaxUnit = rs.getString ("MaxUnit");
          OrderLimit = rs.getInt ("OrderLimit");
          ProImage = rs.getString("ProImage");

          if ("true".equals(isCustomerLoggedIn)){
            ps = con.prepareStatement ("SELECT * FROM Cart WHERE Cust_id = ? and Pro_id = ?");
            ps.setInt (1, loggedInID);
            ps.setInt (2, Pro_id);
            rs1 = ps.executeQuery();

            if (rs1.next()){
              int inCart = rs1.getInt ("Qty");
              int qtyInCart = BaseQty*inCart;
              OrderLimit = rs1.getInt ("OrderLimit");
              LimitQty = BaseQty*OrderLimit;
              float qtyPerOrder = MaxQty;
              if (!BaseUnit.equals(MaxUnit))
                qtyPerOrder *= 1000;
              if (LimitQty > qtyPerOrder){
                if (qtyInCart > qtyPerOrder)
                  qtyPerOrder = qtyInCart;
                OrderLimit = Math.round (qtyPerOrder / BaseQty);
                ps = con.prepareStatement ("UPDATE Cart SET OrderLimit = ? WHERE Cust_id = ? and Pro_id = ?");
                ps.setInt (1, OrderLimit);
                ps.setInt (2, loggedInID);
                ps.setInt (3, Pro_id);
                int x = ps.executeUpdate();
                changed = true;
              }
            }
            else
              calcAgain = true;
          }
          else{
            String anonymousCart = (String)session.getAttribute ("anonymousCart");
            if (anonymousCart != null){
              String Pro_idS = Integer.toString (Pro_id);
              int indx = anonymousCart.indexOf (","+Pro_idS+"-");
              if (indx != -1){
                anonymouslyAdded = true;
                String inCartS = anonymousCart.substring (indx+Pro_idS.length()+2, anonymousCart.indexOf("-",indx+Pro_idS.length()+2));
                int inCart = Integer.parseInt (inCartS);
                int qtyInCart = BaseQty*inCart;
                String limitS = anonymousCart.substring (anonymousCart.indexOf("-",indx+Pro_idS.length()+2)+1, anonymousCart.indexOf(",",indx+1));
                OrderLimit = Integer.parseInt (limitS);
                LimitQty = BaseQty*OrderLimit;
                float qtyPerOrder = MaxQty;
                if (!BaseUnit.equals(MaxUnit))
                  qtyPerOrder *= 1000;
                if (LimitQty > qtyPerOrder){
                  if (qtyInCart > qtyPerOrder)
                    qtyPerOrder = qtyInCart;
                  OrderLimit = Math.round (qtyPerOrder / BaseQty);
                  limitS = Integer.toString (OrderLimit);
                  StringBuffer sb = new StringBuffer (anonymousCart);
                  sb.replace (anonymousCart.indexOf("-",indx+Pro_idS.length()+2)+1, anonymousCart.indexOf(",",indx+1), limitS);
                  anonymousCart = sb.toString();
                  session.setAttribute ("anonymousCart", anonymousCart);
                  changed = true;
                }
              }
              else{
                indx = anonymousCart.indexOf (Pro_idS+"-");
                if (indx == 0){
                  anonymouslyAdded = true;
                  String inCartS = anonymousCart.substring (Pro_idS.length()+1, anonymousCart.indexOf("-",Pro_idS.length()+1));
                  int inCart = Integer.parseInt (inCartS);
                  int qtyInCart = BaseQty*inCart;
                  String limitS = anonymousCart.substring (anonymousCart.indexOf("-",Pro_idS.length()+1)+1, anonymousCart.indexOf(","));
                  OrderLimit = Integer.parseInt (limitS);
                  LimitQty = BaseQty*OrderLimit;
                  float qtyPerOrder = MaxQty;
                  if (!BaseUnit.equals(MaxUnit))
                    qtyPerOrder *= 1000;
                  if (LimitQty > qtyPerOrder){
                    if (qtyInCart > qtyPerOrder)
                      qtyPerOrder = qtyInCart;
                    OrderLimit = Math.round (qtyPerOrder / BaseQty);
                    limitS = Integer.toString (OrderLimit);
                    StringBuffer sb = new StringBuffer (anonymousCart);
                    sb.replace (anonymousCart.indexOf("-",Pro_idS.length()+1)+1, anonymousCart.indexOf(","), limitS);
                    anonymousCart = sb.toString();
                    session.setAttribute ("anonymousCart", anonymousCart);
                    changed = true;
                  }
                }
                else
                  calcAgain = true;
              }
            }
            else
              calcAgain = true;
          }

          if (calcAgain){
            LimitQty = BaseQty*OrderLimit;

            float qtyPerOrder = MaxQty * (float)0.2;
            if (!BaseUnit.equals(MaxUnit))
              qtyPerOrder *= 1000;
            if (LimitQty > qtyPerOrder)
              OrderLimit = Math.round (qtyPerOrder / BaseQty);
            if (OrderLimit==0 && MaxQty>BaseQty)
              OrderLimit = 1;
          }

          if (BaseUnit.equals("piece") && BaseQty>1)
            BaseUnit += "s";

          if ("true".equals(isCustomerLoggedIn)){
            ps = con.prepareStatement ("SELECT * FROM Cart WHERE Cust_id = ? and Pro_id = ?");
            ps.setInt (1, loggedInID);
            ps.setInt (2, Pro_id);
            rs1 = ps.executeQuery();
          }
    %>
    <div class="col s12 m4">
      <a href="product.jsp?product=<%= proTyp+Pro_id %>">
        <div class="card z-depth-3">
          <div class="card-image">
            <img src="<%= ProImage %>">
            <span class="card-title"><%= ProName %></span>

            <%
              if ("true".equals(isCustomerLoggedIn)){
                if (rs1.next()){
            %>
            <!-- Delete from cart button -->
            <a href="CartServlet?source=search.jsp&results=<%= results %>&Pro_id=<%= Pro_id %>&op=delete" class="btn-floating btn-large tooltipped halfway-fab waves-effect waves-light red" data-position="bottom" data-delay="50" data-tooltip="Delete from cart">
              <i class="large material-icons">delete_forever</i>
            </a>
            <%
                }
                else{
            %>
            <!-- Add to cart button -->
            <a href="CartServlet?source=search.jsp&results=<%= results %>&Pro_id=<%= Pro_id %>&OrderLimit=<%= OrderLimit %>&op=add" class="btn-floating btn-large tooltipped halfway-fab waves-effect waves-light teal" onclick="Materialize.toast('Product added to cart', 3000)" data-position="bottom" data-delay="50" data-tooltip="Add to cart">
              <i id="<%= proTyp+Pro_id %>" class="large material-icons">add_shopping_cart</i>
            </a>
            <%
                }
              }
              else{
                if (anonymouslyAdded){
            %>
            <!-- Delete from cart button -->
            <a href="CartServlet?source=search.jsp&results=<%= results %>&Pro_id=<%= Pro_id %>&op=delete" class="btn-floating btn-large tooltipped halfway-fab waves-effect waves-light red" data-position="bottom" data-delay="50" data-tooltip="Delete from cart">
              <i class="large material-icons">delete_forever</i>
            </a>
            <%
                }
                else{
            %>
            <!-- Add to cart button -->
            <a href="CartServlet?source=search.jsp&results=<%= results %>&Pro_id=<%= Pro_id %>&OrderLimit=<%= OrderLimit %>&op=add" class="btn-floating btn-large tooltipped halfway-fab waves-effect waves-light teal" onclick="Materialize.toast('Product added to cart', 3000)" data-position="bottom" data-delay="50" data-tooltip="Add to cart">
              <i id="<%= proTyp+Pro_id %>" class="large material-icons">add_shopping_cart</i>
            </a>
            <%
                }
              }
            %>

          </div>
          <div class="card-content">
            <p class="price">&#8377;<%= BasePrice %> <span class="text-muted">per <%= BaseQty+" "+BaseUnit %></span></p>
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
        anonymouslyAdded = false;
        calcAgain = false;
        changed = false;
        }//for
      }//if
      }//try
      catch (SQLException e){
        e.printStackTrace();
      }
      count = 0;
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
              Post - Aedconagar,<br>
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
      <form name="login_form" action="LoginServlet?source=search.jsp&results=<%= results %>" method="post" onsubmit="return validatorSubmit()">
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
          <a href="signup.jsp?source=search.jsp&results=<%= results %>" class="modal-action modal-close waves-effect waves-light btn-flat">Signup</a>
          <input type="submit" class="btn waves-effect waves-light orange" value="Login">
        </div>
      </form>
    </div>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/productlist.js"></script>
    <script type="text/javascript" src="js/login.js"></script>
</html>