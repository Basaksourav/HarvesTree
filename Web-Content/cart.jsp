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

    int Pro_id, BaseQty, BasePrice, OrderLimit, inCart, priceInCart, count = 0;
    float LimitQty, MaxQty, qtyInCart;
    String ProName, proTyp, BaseUnit, MaxUnit, Weight, LimitQtyS, LimitUnit, unitInCart, ProImage, anonymousCart, qtyInCartS;
    String[] cart, productInCart;
    boolean calcAgain = false;
    boolean changed = false;
    boolean anonymouslyAdded = false;
    boolean isCartEmpty = false;
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
    <title>Your cart on HarvesTree</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link rel="stylesheet" type="text/css" href="css/cart.css">
  </head>

  <body onload="javascript:calledOnLoad.call()">
    <input type="hidden" value="<%= loggedInID %>" id="hidden-logged-in-id">
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
                <li><a href="LoginServlet?source=cart.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <ul id="dropdown-small-screen" class="dropdown-content">
                <li><a href="#!"><i class="material-icons">account_circle</i>Profile</a></li>
                <li><a href="#!"><i class="material-icons">style</i>Orders</a></li>
                <li class="divider"></li>
                <li><a href="LoginServlet?source=cart.jsp"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <a href="index.jsp" class="brand-logo">HarvesTree</a>
              <a href="#" data-activates="mobile-demo-logged-in" class="button-collapse"><i class="material-icons">menu</i></a>
              <ul class="right hide-on-med-and-down">
                <li><a class="dropdown-button" href="#!" data-activates="dropdown-large-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
                <li><a href="productlist.jsp">Products</a></li>
              </ul>
              <ul class="side-nav" id="mobile-demo-logged-in">
                <li><a class="dropdown-button" href="#!" data-activates="dropdown-small-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
                <li><a href="productlist.jsp">Products</a></li>
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
              </ul>
              <ul class="side-nav" id="mobile-demo-not-logged-in">
                <li><a href="#login-signup-modal-id" class="modal-trigger">Login &amp; Signup</a></li>
                <li><a href="productlist.jsp">Products</a></li>
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

    <%
      if ("true".equals(isCustomerLoggedIn)){
        ps = con.prepareStatement ("SELECT Count(Pro_id) FROM Cart WHERE Cust_id = ?");
        ps.setInt (1, loggedInID);
        rs = ps.executeQuery();
        rs.next();

        if (rs.getInt(1) == 0)
          isCartEmpty = true;
      }//loggged in if end when cart empty checking
      else{
        anonymousCart = (String)session.getAttribute ("anonymousCart");
        if (anonymousCart == null)
          isCartEmpty = true;
        else
          cart = anonymousCart.split (",");
      }//anonymous else end while cart empty checking
    %>

    <%
    if(!isCartEmpty){
    %>

    <!-- Cart is not empty -->
    <div class="row container-custom">
      <!-- Products added in cart -->
      <table class="col m8 s12 card bordered">
        <thead>
          <tr>
            <th>My Cart</th>
          </tr>
        </thead>

        <tbody>

    <%
      if ("true".equals(isCustomerLoggedIn)){
        ps = con.prepareStatement ("SELECT Product.Pro_id, ProName, Type, BaseQty, BaseUnit, BasePrice, MaxQty, MaxUnit, Qty, Cart.OrderLimit, ProImage FROM Product JOIN Cart WHERE Product.Pro_id = Cart.Pro_id and Cust_id = ?");
        ps.setInt (1, loggedInID);
        rs = ps.executeQuery();

        while (rs.next()){
          count++;

          Pro_id = rs.getInt ("Pro_id");
          ProName = rs.getString ("ProName");
          proTyp = rs.getString ("Type");
          BaseQty = rs.getInt ("BaseQty");
          BaseUnit = rs.getString ("BaseUnit");
          BasePrice = rs.getInt ("BasePrice");
          MaxQty = rs.getFloat ("MaxQty");
          MaxUnit = rs.getString ("MaxUnit");
          ProImage = rs.getString ("ProImage");

          int i = ProName.indexOf('(');
          if (i != -1)
            ProName = ProName.substring (0, i).trim();

          inCart = rs.getInt ("Qty");
          qtyInCart = BaseQty*inCart;

          OrderLimit = rs.getInt ("OrderLimit");
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

          if (qtyInCart>=1000 && BaseUnit.equals("gm.")){
            qtyInCart /= 1000;
            unitInCart = "kg.";
          }
          else
            unitInCart = BaseUnit;

          qtyInCartS = Float.toString (qtyInCart);
          if (qtyInCartS.indexOf(".0") == qtyInCartS.length()-2)
            qtyInCartS = qtyInCartS.substring (0, qtyInCartS.length()-2);

          if (unitInCart.equals("piece") && qtyInCart>1)
            unitInCart = "pieces";

          priceInCart = BasePrice * inCart;

    %>
        <tr id="row<%= Pro_id %>">
          <td class="center-align">
            <img src="<%= ProImage %>" alt="" width="100px">
          </td>

          <td class="center-align">
            <a href="product.jsp?product=<%= proTyp+Pro_id %>"><h5><%= ProName %></h5></a>
            <i class="material-icons counters" id="sub<%= Pro_id %>">remove_circle</i>
            <span class="quantity" id="qty<%= Pro_id %>"><%= inCart %></span>
            <i class="material-icons counters" id="add<%= Pro_id %>">add_circle</i>
          </td>

          <td class="center-align">
            <h5 class="price" id="price<%= Pro_id %>">&#8377; <%= priceInCart %> <span class="text-muted">for <%= qtyInCartS %> <%= unitInCart %></span></h5>
            <div>
              <a class="waves-effect btn-flat orange-text" id="del<%= Pro_id %>" onclick="javascript:perform.call(this)">REMOVE ITEM</a>
            </div>
          </td>
          
          <input type="hidden" id="limit<%= Pro_id %>" value="<%= OrderLimit %>">
        </tr>
    <%
        }//while loop end when cart not empty
      }//loggged in if end when cart not empty
      else{
        for (String s : cart){
          productInCart = s.split("-");
          Pro_id = Integer.parseInt (productInCart[0]);
          inCart = Integer.parseInt (productInCart[1]);
          OrderLimit = Integer.parseInt (productInCart[2]);

          ps = con.prepareStatement ("SELECT ProName, Type, BaseQty, BaseUnit, BasePrice, MaxQty, MaxUnit, ProImage FROM Product WHERE Pro_id = ?");
          ps.setInt (1, Pro_id);
          rs = ps.executeQuery();
          rs.next();

          ProName = rs.getString ("ProName");
          proTyp = rs.getString ("Type");
          BaseQty = rs.getInt ("BaseQty");
          BaseUnit = rs.getString ("BaseUnit");
          BasePrice = rs.getInt ("BasePrice");
          MaxQty = rs.getFloat ("MaxQty");
          MaxUnit = rs.getString ("MaxUnit");
          ProImage = rs.getString ("ProImage");

          int i = ProName.indexOf('(');
          if (i != -1)
            ProName = ProName.substring (0, i).trim();

          qtyInCart = BaseQty*inCart;
          LimitQty = BaseQty*OrderLimit;

          float qtyPerOrder = MaxQty;
          if (!BaseUnit.equals(MaxUnit))
            qtyPerOrder *= 1000;

          if (LimitQty > qtyPerOrder){
            if (qtyInCart > qtyPerOrder)
              qtyPerOrder = qtyInCart;
            OrderLimit = Math.round (qtyPerOrder / BaseQty);
            anonymousCart = anonymousCart.replace (Pro_id+"-"+inCart+"-"+OrderLimit, Pro_id+"-"+inCart+"-"+OrderLimit);
            session.setAttribute ("anonymousCart", anonymousCart);
          }

          if (qtyInCart>=1000 && BaseUnit.equals("gm.")){
            qtyInCart /= 1000;
            unitInCart = "kg.";
          }
          else
            unitInCart = BaseUnit;

          qtyInCartS = Float.toString (qtyInCart);
          if (qtyInCartS.indexOf(".0") == qtyInCartS.length()-2)
            qtyInCartS = qtyInCartS.substring (0, qtyInCartS.length()-2);

          if (unitInCart.equals("piece") && qtyInCart>1)
            unitInCart = "pieces";

          priceInCart = BasePrice * inCart;
    %>
        <tr id="row<%= Pro_id %>">
          <td class="center-align">
            <img src="<%= ProImage %>" alt="" width="100px">
          </td>

          <td class="center-align">
            <a href="product.jsp?product=<%= proTyp+Pro_id %>"><h5><%= ProName %></h5></a>
            <i class="material-icons counters" id="sub<%= Pro_id %>">remove_circle</i>
            <span class="quantity" id="qty<%= Pro_id %>"><%= inCart %></span>
            <i class="material-icons counters" id="add<%= Pro_id %>">add_circle</i>
          </td>

          <td class="center-align">
            <h5 class="price" id="price<%= Pro_id %>">&#8377; <%= priceInCart %> <span class="text-muted">for <%= qtyInCartS %> <%= unitInCart %></span></h5>
            <div>
              <a class="waves-effect btn-flat orange-text" id="del<%= Pro_id %>" onclick="javascript:perform.call(this)">REMOVE ITEM</a>
            </div>
          </td>
          
          <input type="hidden" id="limit<%= Pro_id %>" value="<%= OrderLimit %>">
        </tr>
    <%
        }//for loop end when cart not empty
      }//anonymous else end when cart not empty
    %>
        </tbody>
      </table>

      <!-- Final price and place order -->
      <div class="col m4 s12">
        <div class="card">
            <div class="card-content">
              <span class="card-title teal-text">PRICE DETAILS</span>
              <div class="row no-space">
                <p class="col s8" id="count-items-id"></p>
                <p class="col s4" id="total-price-id"></p>
                <p class="col s8">Delivery Charges</p>
                <p class="col s4" id="delivery-charge-id"></p>
              </div>
            </div>

            <div class="card-action">
              <div class="row no-space">
                <p class="col s8">Amount Payable</p>
                <p class="col s4" id="amount-payable-id">&#8377; </p>
              </div>
              <div class="row">
                <a href="#" class="col s12 btn orange">Place Order</a>
              </div>
            </div>
          </div>
      </div>
    </div>
    <%
    }//cart not empty if end
    else{
    %>

      <!-- Cart is empty -->
      <div class="cart-empty">
        <img src="assets/images/empty-basket.png" alt="Image of an empty basket" width="100px">
        <h5>Your Shopping Cart is empty</h5>
        <a href="productlist.jsp"><h5>+ Add items to your cart</h5></a>
      </div>

    <%
    }//cart empty end
    %>
    <input type="hidden" id="cart-status" value="<%= isCartEmpty %>">
    <input type="hidden" id="cart-count" value="<%= count %>">
    <%
    isCartEmpty = false;
    count = 0;
    %>

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
      <form name="login_form" action="LoginServlet?source=cart.jsp" method="post" onsubmit="return validatorSubmit()">
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
          <a href="signup.jsp?source=cart.jsp" class="modal-action modal-close waves-effect waves-light btn-flat">Signup</a>
          <input type="submit" class="btn waves-effect waves-light orange" value="Login">
        </div>
      </form>
    </div>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/cart.js"></script>
    <script type="text/javascript" src="js/login.js"></script>
  </body>
</html>