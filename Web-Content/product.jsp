<%@ page import="javaPackage.Database, java.sql.*"%>

<!DOCTYPE html>
<html lang="en-US">
  <%!
    String isCustomerLoggedIn = new String();
    String loggedInIDS = new String();
    int loggedInID;
    String loggedInName = new String();

    String proTyp = new String();

    PreparedStatement ps;
    ResultSet rs, rs1;
    Connection con = new Database().connect();

    int Pro_id, BaseQty, BasePrice, OrderLimit;
    float LimitQty, MaxQty;
    String ProName, BaseUnit, MaxUnit, Weight, LimitQtyS, LimitUnit, Description, Nutrient, Shelf_Life, Storage, Disclaimer, ProImage, ProName2;
    boolean calcAgain = false;
    boolean changed = false;
    boolean anonymouslyAdded = false;
  %>

  <%
    isCustomerLoggedIn = (String)session.getAttribute ("isCustomerLoggedIn");
    if ("true".equals(isCustomerLoggedIn))
      loggedInName = (String)session.getAttribute ("loggedInName");
    else
      session.setAttribute ("loggedInID", "0");
    loggedInIDS = (String)session.getAttribute ("loggedInID");
    loggedInID = Integer.parseInt (loggedInIDS);

    proTyp = request.getParameter ("product");
    if (proTyp == null)
      response.sendRedirect ("productlist.jsp");
    else{
      Pro_id = Integer.parseInt (proTyp.substring(3));
      proTyp = proTyp.substring (0,3);

      try{
        ps = con.prepareStatement ("SELECT * FROM Product WHERE Pro_id = ? and Type = ?");
        ps.setInt (1, Pro_id);
        ps.setString (2, proTyp);
        rs = ps.executeQuery();
        rs.next();

        ProName = rs.getString ("ProName");
        BaseQty = rs.getInt ("BaseQty");
        BaseUnit = rs.getString ("BaseUnit");
        BasePrice = rs.getInt ("BasePrice");
        MaxQty = rs.getFloat ("MaxQty");
        MaxUnit = rs.getString ("MaxUnit");
        OrderLimit = rs.getInt ("OrderLimit");
        Description = rs.getString ("Description");
        Nutrient = rs.getString ("Nutrient");
        Shelf_Life = rs.getString ("Shelf_Life");
        Storage = rs.getString ("Storage");
        Disclaimer = rs.getString ("Disclaimer");
        ProImage = rs.getString ("ProImage");

        int i = ProName.indexOf('(');
        if (i != -1)
          ProName2 = ProName.substring (0, i).trim();
        else
          ProName2 = ProName;

        if (BaseUnit.equals("piece")){
          ps = con.prepareStatement ("SELECT Weight FROM AvgWght WHERE Pro_id = ?");
          ps.setInt (1, Pro_id);
          rs = ps.executeQuery();
          rs.next();
          Weight = rs.getString ("Weight");
          Weight = " (" + Weight + "/piece)";
        }
        else
          Weight = "";

        if ("true".equals(isCustomerLoggedIn)){
          ps = con.prepareStatement ("SELECT * FROM Cart WHERE Cust_id = ? and Pro_id = ?");
          ps.setInt (1, loggedInID);
          ps.setInt (2, Pro_id);
          rs1 = ps.executeQuery();

          if (rs1.next()){
            int inCart = rs1.getInt ("Qty");
            float qtyInCart = BaseQty*inCart;
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
              float qtyInCart = BaseQty*inCart;
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
                float qtyInCart = BaseQty*inCart;
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

        LimitQty = BaseQty*OrderLimit;
        if (BaseUnit.equals("gm.") && LimitQty>=1000){
          LimitQty /= 1000;
          LimitUnit = "kg.";
        }
        else
          LimitUnit = BaseUnit;

        LimitQtyS = Float.toString (LimitQty);
        if (LimitQtyS.indexOf(".0") == LimitQtyS.length()-2)
          LimitQtyS = LimitQtyS.substring (0, LimitQtyS.length()-2);

        if (BaseUnit.equals("piece") && BaseQty>1)
          BaseUnit += "s";
        if (LimitUnit.equals("piece") && LimitQty>1)
          LimitUnit += "s";
      }
      catch (SQLException e){
        e.printStackTrace();
      }
  %>

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title><%= ProName2 %> on HarvesTree</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link rel="stylesheet" type="text/css" href="css/product.css">
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
                <li><a href="LoginServlet?source=product.jsp&product=<%= proTyp+Pro_id %>"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <ul id="dropdown-small-screen" class="dropdown-content">
                <li><a href="#!"><i class="material-icons">account_circle</i>Profile</a></li>
                <li><a href="#!"><i class="material-icons">style</i>Orders</a></li>
                <li class="divider"></li>
                <li><a href="LoginServlet?source=product.jsp&product=<%= proTyp+Pro_id %>"><i class="material-icons">settings_power</i>Logout</a></li>
              </ul>
              <a href="#" class="brand-logo">HarvesTree</a>
              <a href="#" data-activates="mobile-demo-logged-in" class="button-collapse"><i class="material-icons">menu</i></a>
              <ul class="right hide-on-med-and-down">
                <li><a class="dropdown-button" href="#!" data-activates="dropdown-large-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
                <li><a href="productlist.jsp?type=<%= proTyp %>">Products</a></li>
                <li><a href="cart.jsp"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
              <ul class="side-nav" id="mobile-demo-logged-in">
                <li><a class="dropdown-button" href="#!" data-activates="dropdown-small-screen"><%= loggedInName %><i class="material-icons right">expand_more</i></a></li>
                <li><a href="productlist.jsp?type=<%= proTyp %>">Products</a></li>
                <li><a href="cart.jsp"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
          <%
            }
            else{
          %>
              <!-- Nav Bar when not Logged In -->
              <a href="#" class="brand-logo">HarvesTree</a>
              <a href="#" data-activates="mobile-demo-not-logged-in" class="button-collapse"><i class="material-icons">menu</i></a>
              <ul class="right hide-on-med-and-down">
                <li><a href="#login-signup-modal-id" class="modal-trigger">Login &amp; Signup</a></li>
                <li><a href="productlist.jsp?type=<%= proTyp %>">Products</a></li>
                <li><a href="cart.jsp"><i class="material-icons">shopping_cart</i></a></li>
              </ul>
              <ul class="side-nav" id="mobile-demo-not-logged-in">
                <li><a href="#login-signup-modal-id" class="modal-trigger">Login &amp; Signup</a></li>
                <li><a href="productlist.jsp?type=<%= proTyp %>">Products</a></li>
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

    <!-- Main container -->
    <div class="container section">

      <!-- Main image, name, price and quantity slider -->
      <div class="row">
        <div class="col m7 s12"><img class="materialboxed hoverable" width="100%" src="<%= ProImage %>"></div>
        <div class="col m5 s12">
          <h4><%= ProName %></h4>
          <h1>&#8377;<%= BasePrice %></h1>
          <h6 style="color: teal">Available in</h6>
          <div class="chip"><%= BaseQty+" "+BaseUnit %></div><span><%= Weight %></span>
          <p><strong>* Limited to <%= LimitQtyS+" "+LimitUnit %> per order</strong></p>
        </div>
      </div>

      <!-- About Section -->
      <div class="row">
        <h5>About the product</h5>
        <div class="section">
          <h6>Description</h6>
          <p><%= Description %></p>
        </div>

        <div class="divider"></div>

        <div class="section">
          <h6>Nutrient Value &amp; Benefits</h6>
          <p><%= Nutrient %></p>
        </div>

        <div class="divider"></div>

        <div class="section">
          <h6>Shelf Life</h6>
          <p><%= Shelf_Life %></p>
        </div>

        <div class="divider"></div>

        <div class="section">
          <h6>Storage Tips</h6>
          <p>T<%= Storage %></p>
        </div>

        <div class="divider"></div>

        <div class="section">
          <h6>Disclaimer</h6>
          <p>Image shown is a representation and may slightly vary from the actual
            product. Every effort is made to maintain accuracy of all information
            displayed.
          </p>
        </div>
      </div>

      <!-- Ratings and Review Section -->
      <div class="row">

        <!-- Ratings -->
        <div class="col m3 s12">
          <h5>Ratings</h5>
          <h1 class="col s12">4.1</h1>
          <div class="col s12">
            5 stars
            <div class="progress grey lighten-2">
              <div class="determinate green darken-2" style="width: 100%"></div>
            </div>
          </div>
          <div class="col s12">
            4 stars
            <div class="progress grey lighten-2">
              <div class="determinate green darken-2" style="width: 20%"></div>
            </div>
          </div>
          <div class="col s12">
            3 stars
            <div class="progress grey lighten-2">
              <div class="determinate green darken-2" style="width: 20%"></div>
            </div>
          </div>
          <div class="col s12">
            2 stars
            <div class="progress grey lighten-2">
              <div class="determinate amber darken-2" style="width: 5%"></div>
            </div>
          </div>
          <div class="col s12">
            1 star
            <div class="progress grey lighten-2">
              <div class="determinate red darken-2" style="width: 10%"></div>
            </div>
          </div>
        </div>

        <!-- Reviews -->
        <div class="col m9 s12">
          <h5>Reviews</h5>
          <ul class="collection">

            <li class="collection-item">
              <div class="row section">

                <div class="col s12 center">
                  <h6>Write a review</h6>
                </div>

                <div class="input-field col m8 s12">
                  <i class="material-icons prefix">subject</i>
                  <%
                    if ("true".equals(isCustomerLoggedIn)){
                  %>
                  <input id="title-id" type="text" name="title" data-length="60">
                  <%
                    }
                    else{
                  %>
                  <input id="title-id" type="text" name="title" data-length="60" disabled>
                  <%
                    }
                  %>
                  <label for="title-id">Title<span id="title-err-id" class="error-color"></span></label>
                </div>

                <div class="input-field col m4 s12 center">
                  <%
                    for (int i = 1; i <= 5; i++){
                  %>
                  <i class="material-icons rating-star" id="star-<%= i %>-id">star</i>
                  <%
                    }
                  %>
                  <!-- <i class="material-icons rating-star" id="star-1-id">star</i>
                  <i class="material-icons rating-star" id="star-2-id">star</i>
                  <i class="material-icons rating-star" id="star-3-id">star</i>
                  <i class="material-icons rating-star" id="star-4-id">star</i>
                  <i class="material-icons rating-star" id="star-5-id">star</i> -->
                  <input id="rating-id" type="hidden" name="rating" value="0">
                </div>
                <span id="rating-err-id" class="error-color" style="padding-left:65px"></span>

                <div class="input-field col s12">
                  <i class="material-icons prefix">create</i>
                  <%
                    if ("true".equals(isCustomerLoggedIn)){
                  %>
                  <textarea id="comment-id" name="comment" class="materialize-textarea"></textarea>
                  <%
                    }
                    else{
                  %>
                  <textarea id="comment-id" name="comment" class="materialize-textarea" disabled></textarea>
                  <%
                    }
                  %>
                  <label for="desc-id">Description<span id="comment-err-id" class="error-color"></span></label>
                </div>

                <div class="col s12 center">
                  <%
                    if ("true".equals(isCustomerLoggedIn)){
                  %>
                  <input type="submit" id="<%= Pro_id %>" class="btn waves-effect waves-light" onclick="javascript:getReview.call(this)">
                  <%
                    }
                    else{
                  %>
                  <input type="submit" class="btn" disabled>
                  <%
                    }
                  %>
                </div>

              </div>
            </li>

          </ul>
        </div>

      </div>

    </div>

    <div class="fixed-action-btn">
      <%
        if ("true".equals(isCustomerLoggedIn)){
          ps = con.prepareStatement ("SELECT * FROM Cart WHERE Cust_id = ? and Pro_id = ?");
          ps.setInt (1, loggedInID);
          ps.setInt (2, Pro_id);
          rs1 = ps.executeQuery();
          if (rs1.next()){
      %>
      <!-- Delete from cart button -->
      <a href="CartServlet?source=product.jsp&product=<%= proTyp+Pro_id %>&Pro_id=<%= Pro_id %>&op=delete" class="btn-floating btn-large tooltipped red pulse" data-position="top" data-delay="50" data-tooltip="Delete from cart">
        <i class="large material-icons">delete_forever</i>
      </a>
      <%
          }
          else{
      %>
      <!-- Add to cart button -->
      <a href="CartServlet?source=product.jsp&product=<%= proTyp+Pro_id %>&Pro_id=<%= Pro_id %>&OrderLimit=<%= OrderLimit %>&op=add" class="btn-floating btn-large tooltipped teal pulse" data-position="top" data-delay="50" data-tooltip="Add to cart">
        <i class="large material-icons">add_shopping_cart</i>
      </a>
      <%
          }
        }
        else{
          if (anonymouslyAdded){
      %>
      <!-- Delete from cart button -->
      <a href="CartServlet?source=product.jsp&product=<%= proTyp+Pro_id %>&Pro_id=<%= Pro_id %>&op=delete" class="btn-floating btn-large tooltipped red pulse" data-position="top" data-delay="50" data-tooltip="Delete from cart">
        <i class="large material-icons">delete_forever</i>
      </a>
      <%
          }
          else{
      %>
      <!-- Add to cart button -->
      <a href="CartServlet?source=product.jsp&product=<%= proTyp+Pro_id %>&Pro_id=<%= Pro_id %>&OrderLimit=<%= OrderLimit %>&op=add" class="btn-floating btn-large tooltipped teal pulse" data-position="top" data-delay="50" data-tooltip="Add to cart">
        <i class="large material-icons">add_shopping_cart</i>
      </a>
      <%
          }
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
      <form name="login_form" action="LoginServlet?source=product.jsp&product=<%= proTyp+Pro_id %>" method="post" onsubmit="return validatorSubmit()">
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
          <a href="signup.jsp?source=product.jsp&product=<%= proTyp+Pro_id %>" class="modal-action modal-close waves-effect waves-light btn-flat">Signup</a>
          <input type="submit" class="btn waves-effect waves-light orange" value="Login">
        </div>
      </form>
    </div>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/product.js"></script>
    <script type="text/javascript" src="js/login.js"></script>
  </body>

  <%
    }
    calcAgain = false;
    changed = false;
    anonymouslyAdded = false;
  %>
</html>