<%@ page import="java.sql.*, javaPackage.*" %>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Product Management</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link type="text/css" rel="stylesheet" href="css/productmanagement.css">
  </head>

  <body>
    <%!
      String isAdminLoggedIn = new String();

      String proTyp = new String();
      String[] proTypParamS = {"fru", "flo", "veg"};
      String[] proTypNameS = {"Fruit", "Flower", "Vegetable"};
      int proTypNo = 3;

      PreparedStatement ps;
      ResultSet rs;
      Connection con = new Database().connect();
    %>

    <%
      isAdminLoggedIn = (String)session.getAttribute ("isAdminLoggedIn");

      if ("true".equals(isAdminLoggedIn)){

        proTyp = request.getParameter ("type");
    %>
        <!-- Nav Bar -->
        <nav class="nav-extended orange">
          <div class="container">
            <div class="nav-wrapper">
              <a href="#" class="brand-logo">HarvesTree</a>
              <a href="#" data-activates="mobile-demo" class="button-collapse"><i class="material-icons">menu</i></a>
              <ul id="nav-mobile" class="right hide-on-med-and-down">
                <li><a href="ProductManagementServlet?logout=true" class="waves-effect waves-light btn">Logout</a></li>
              </ul>
              <ul class="side-nav" id="mobile-demo">
                <li><a class="waves-effect waves-light btn">Logout</a></li>
              </ul>
            </div>
            <div class="navbar-fixed row">
              <ul class="center hide-on-med-and-down">
                <%
                  for (int i = 0; i < 3; i++){
                    if (proTyp.equals(proTypParamS[i])){
                %>
                      <li class="tab col m4"><strong><a class="active" style="color:black" href="productmanagement.jsp?type=<%= proTypParamS[i] %>"><%= proTypNameS[i] %>s</a></strong></li>
                <%
                    proTypNo = i;
                    }
                    else{
                %>
                      <li class="tab col m4"><a href="productmanagement.jsp?type=<%= proTypParamS[i] %>"><%= proTypNameS[i] %>s</a></li>
                <%
                    }
                  }
                %>
              </ul>
            </div>
          </div>
        </nav>

        <%
          ps = con.prepareStatement ("SELECT Pro_id, ProName, ProImage FROM Product WHERE Type = ?");
          ps.setString (1, proTyp);
          rs = ps.executeQuery();
        %>

        <!-- Product List -->
        <div class="container">
          <ul class="collection with-header">
            <li class="collection-header"><h4>List of <%= proTypNameS[proTypNo] %>s</h4></li>
            <%
              while (rs.next()){
                int Pro_id = rs.getInt ("Pro_id");
                String ProName = rs.getString ("ProName");
                String ProImage = rs.getString ("ProImage");
            %>
                <li class="collection-item">
                  <div class="row">
                    <div class="col m3">
                      <img width="40%" src="<%= ProImage %>">
                    </div>

                    <div class="col m5">
                      <h5><%= ProName %></h5>
                    </div>

                    <div class="col m2">
                      <a href="#product-modal-id" class="secondary-content tooltipped modal-trigger" data-position="bottom" data-delay="50" data-tooltip="Edit Product Details">
                        <i class="material-icons" id="<%= Pro_id %>" onclick="javascript:modalSetting.call(this)">create</i>
                      </a>
                    </div>

                    <div class="col m2">
                      <a href="ProductManagementServlet?type=<%= proTyp %>&proID=<%= Pro_id %>" class="secondary-content tooltipped" data-position="bottom" data-delay="50" data-tooltip="Delete Product">
                        <i class="material-icons" id="<%= Pro_id %>">delete</i>
                      </a>
                    </div>
                  </div>
                </li>
            <%
              }
            %>
          </ul>
        </div>

        <!-- Add/Edit Product Modal -->
        <div id="product-modal-id" class="modal modal-fixed-footer">
          <!-- Click here to push product details into FireBase -->
          <button id="firebase-button-id" disabled  onclick="javascript:addToFireBase.call(this)">FireBase</button>
          <form name="product_detail_form" action="ProductManagementServlet" method="post"  enctype="Multipart/form-data" onsubmit="return validatorSubmit()">
            <div class="modal-content">
              <h4 id="modal-heading-id"></h4>

              <div class="row">
                <div class="input-field col m6">
                  <input id="product-name-id" name="product_name" type="text" oninput="javascript:validatorInstant.call(this)">
                  <label for="product-name-id">Product Name<span id="product-name-err-id" class="error-color"></span></label>
                </div>
                <div class="file-field input-field col m6">
                  <div class="btn">
                    <span><i class="material-icons">file_upload</i></span>
                    <input type="file" id="product-img-file-id" name="product_img_file">
                  </div>
                  <div class="file-path-wrapper">
                    <input class="file-path validate" id="product-img-name-id" name="product_img_name" type="text" onchange="javascript:fileUpload.call(this)">
                    <label for="product-img-name-id"><span id="product-img-name-err-id" class="error-color" style="padding-left:7.5em"></span></label>
                  </div>
                </div>
              </div>

              <div class="row">
                <div class="input-field col m6">
                  <input id="qty-id" name="qty" type="text" oninput="javascript:validatorInstant.call(this)">
                  <label for="qty-id">Base Quantity (value)<span id="qty-err-id" class="error-color"></span></label>
                </div>
                <div class="input-field col m6">
                  <input id="unit-id" name="unit" type="text" oninput="javascript:validatorInstant.call(this)">
                  <%
                    if (proTyp.equals("flo")){
                  %>
                      <label for="unit-id">Base Quanity (unit) [piece]<span id="unit-err-id" class="error-color"></span></label>
                  <%
                    }
                    else{
                  %>
                      <label for="unit-id">Base Quanity (unit) [gm./kg./piece]<span id="unit-err-id" class="error-color"></span></label>
                  <%
                    }
                  %>
                </div>
              </div>

              <div class="row">
                <div class="input-field col m6">
                  <input id="price-id" name="price" type="text" oninput="javascript:validatorInstant.call(this)">
                  <label for="price-id">Price (for base quantity) [in Rupees]<span id="price-err-id" class="error-color"></span></label>
                </div>
                <div class="input-field col m6">
                  <input id="wght-id" name="wght" type="text" disabled oninput="javascript:validatorInstant.call(this)">
                  <label for="wght-id">Avg. Weight (per piece)<span id="wght-err-id" class="error-color"></span></label>
                </div>
              </div>

              <div class="row">
                <div class="input-field col m6">
                  <input id="qty2-id" name="qty2" type="text" oninput="javascript:validatorInstant.call(this)">
                  <label for="qty2-id">Maximum Quantity (value)<span id="qty2-err-id" class="error-color"></span></label>
                </div>
                <div class="input-field col m6">
                  <input id="unit2-id" name="unit2" type="text" oninput="javascript:validatorInstant.call(this)">
                  <%
                    if (proTyp.equals("flo")){
                  %>
                      <label for="unit2-id">Maximum Quanity (unit) [piece]<span id="unit2-err-id" class="error-color"></span></label>
                  <%
                    }
                    else{
                  %>
                      <label for="unit2-id">Maximum Quanity (unit) [gm./kg./piece]<span id="unit2-err-id" class="error-color"></span></label>
                  <%
                    }
                  %>
                </div>
              </div>

              <ul class="collection with-header">
                <li class="collection-header"><h4>About the Product</h4></li>
                <li class="collection-item">
                  <div class="input-field col s12">
                    <textarea id="desc-id" name="desc" class="materialize-textarea" oninput="javascript:validatorInstant.call(this)"></textarea>
                    <label for="desc-id">Description<span id="desc-err-id" class="error-color"></span></label>
                  </div>
                </li>
                <li class="collection-item">
                  <div class="input-field col s12">
                    <%
                      if (proTyp.equals("flo")){
                    %>
                        <textarea id="nutri-id" name="nutri" class="materialize-textarea" disabled oninput="javascript:validatorInstant.call(this)"></textarea>
                    <%
                      }
                      else{
                    %>
                        <textarea id="nutri-id" name="nutri" class="materialize-textarea" oninput="javascript:validatorInstant.call(this)"></textarea>
                    <%
                      }
                    %>
                    <label for="nutri-id">Nutrient Value & Benefits<span id="nutri-err-id" class="error-color"></span></label>
                  </div>
                </li>
                <li class="collection-item">
                  <div class="input-field col s12">
                    <textarea id="shelf-life-id" name="shelf_life" class="materialize-textarea" oninput="javascript:validatorInstant.call(this)"></textarea>
                    <label for="shelf-life-id">Shelf Life<span id="shelf-life-err-id" class="error-color"></span></label>
                  </div>
                </li>
                <li class="collection-item">
                  <div class="input-field col s12">
                    <textarea id="storage-id" name="storage" class="materialize-textarea" oninput="javascript:validatorInstant.call(this)"></textarea>
                    <label for="storage-id">Storage Tips<span id="storage-err-id" class="error-color"></span></label>
                  </div>
                </li>
                <li class="collection-item">
                  <div class="input-field col s12">
                    <textarea id="disclaimer-id" name="disclaimer" class="materialize-textarea" oninput="javascript:validatorInstant.call(this)"></textarea>
                    <label for="disclaimer-id">Disclaimer<span id="disclaimer-err-id" class="error-color"></span></label>
                  </div>
                </li>
              </ul>
            </div>

            <div class="modal-footer">
              <!-- <a href="#!" class="modal-action modal-close waves-effect waves-green btn-flat">Save</a> -->
              <input id="hidden-info-id" name="hidden_info" type="hidden" value="<%= proTyp %>">
              <input type="submit" class="btn waves-effect waves-light" value="Save">
            </div>
          </form>
        </div>

        <!-- Add New Product Button -->
        <div class="fixed-action-btn">
          <a href="#product-modal-id" class="btn-floating btn-large tooltipped red pulse modal-trigger" data-position="top" data-delay="50" data-tooltip="Add New <%= proTypNameS[proTypNo] %>">
            <i class="large material-icons" id="add-product-icon-id" onclick="javascript:modalSetting.call(this)">add</i>
          </a>
        </div>

        <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
        <script type="text/javascript" src="js/materialize.js"></script>
        <script type="text/javascript" src="js/productmanagement.js"></script>
    <%
      }
      else{
    %>
        <h4>not Logged-In</h4>
    <%
      }
    %>
  </body>
</html>