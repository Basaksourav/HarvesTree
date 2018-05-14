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

    String FName, MName, LName, FullName, email, Address_line1, Address_line2, City, State;
    int Pin;
    long Phone;
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
        ps = con.prepareStatement ("SELECT FName, MName, LName, email, Phone, Address_line1, Address_line2, City, State, Pin FROM Customer WHERE Cust_id = ?");
        ps.setInt (1, loggedInID);
        rs = ps.executeQuery();
        rs.next();

        FName = rs.getString ("FName");
        MName = rs.getString ("MName");
        LName = rs.getString ("LName");
        email = rs.getString ("email");
        Phone = rs.getLong ("Phone");
        Address_line1 = rs.getString ("Address_line1");
        Address_line2 = rs.getString ("Address_line2");
        City = rs.getString ("City");
        State = rs.getString ("State");
        Pin = rs.getInt ("Pin");

        if (MName.equals(""))
          FullName = FName + " " + LName;
        else
          FullName = FName + " " + MName + " " + LName;
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
            <a href="#!" class="collection-item">Hello,<br><h5><%= FullName %></h5></a>
            <a href="#!" class="collection-item active">Personal Details<i class="secondary-content material-icons">chevron_right</i></a>
            <a href="profile_password.html" class="collection-item">Password<i class="secondary-content material-icons">chevron_right</i></a>
            <a href="profile_payment.html" class="collection-item">Payment Options<i class="secondary-content material-icons">chevron_right</i></a>
          </div>
        </div>

        <div class="col m8 s12">
          <div class="card">
            <form name="profile_personal_form" action="EditProfileServlet" method="post" onsubmit="return validatorSubmitPersonal()">
              <input type="hidden" id="cust-id" name="cust_id_name" value="<%= loggedInID %>">
              <div class="card-content">
                <!-- First, middle and last name -->
                <div class="row">
                  <div class="input-field col m4 s12">
                    <i class="material-icons prefix">supervisor_account</i>
                    <input disabled value="<%= FName %>" id="fname-id" type="text" name="fname" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="fname-id">First Name*<span id="fname-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col m4 s12">
                    <input disabled value="<%= MName %>" id="mname-id" type="text" name="mname" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="mname-id">Middle Name<span id="mname-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col m4 s12">
                    <input disabled value="<%= LName %>" id="lname-id" type="text" name="lname" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="lname-id">Last Name*<span id="lname-err-id" class="error-color"></span></label>
                  </div>
                </div>

                <!-- Email and Mobile number -->
                <div class="row">
                  <div class="input-field col m6 s12">
                    <i class="material-icons prefix">email</i>
                    <input disabled value="<%= email %>" id="email-id" type="text" name="email" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="email-id">Email*<span id="email-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col m6 s12">
                    <i class="material-icons prefix">phone</i>
                    <input disabled value="<%= Phone %>" id="phn-id" type="text" name="phn" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="phn-id">Phone Number*<span id="phn-err-id" class="error-color"></span></label>
                  </div>
                </div>

                <!-- Address -->
                <div class="row">
                  <div class="input-field col m6 s12">
                    <i class="material-icons prefix">room</i>
                    <input disabled value="<%= Address_line1 %>" id="add-line1-id" type="text" name="add_line1" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="add-line1-id">Address Line 1*<span id="add-line1-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col m6 s12">
                    <input disabled value="<%= Address_line2 %>" id="add-line2-id" type="text" name="add_line2" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="add-line2-id">Address Line 2</label>
                  </div>
                </div>

                <div class="row">
                  <div class="input-field col m4 s12">
                    <input disabled value="<%= City %>" id="city-id" type="text" name="city" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="city-id">City*<span id="city-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col m4 s12">
                    <input disabled value="<%= State %>" id="state-id" type="text" name="state" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="state-id">State*<span id="state-err-id" class="error-color"></span></label>
                  </div>

                  <div class="input-field col m4 s12">
                    <input disabled value="<%= Pin %>" id="pin-id" type="text" name="pin" oninput="javascript:validatorInstantPersonal.call(this)">
                    <label for="pin-id">Pincode*<span id="pin-err-id" class="error-color"></span></label>
                  </div>
                </div>
              </div>

              <div class="card-action">
                <input type="button" class="btn waves-effect waves-light" value="Edit Details" onclick="javascript:editPersonalInfo.call(this)">
                <input type="submit" id="apply-changes-id" class="btn waves-effect waves-light" value="Apply Changes" disabled>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
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