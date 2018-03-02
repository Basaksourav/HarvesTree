<%@ page import="java.util.Date, java.text.DateFormat, java.text.SimpleDateFormat, javaPackage.Database, java.sql.*"%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Sign Up</title>

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Kaushan+Script" rel="stylesheet">
    <link type="text/css" rel="stylesheet" href="css/materialize.css"  media="screen,projection"/>
    <link type="text/css" rel="stylesheet" href="css/signup.css"/>
  </head>

  <body>
    <%!
      //Declare string variables
      //to capture session attribute values
      //to retain in the signup form
      //in case the user is pushed back to the signup page due to some error
      String isSignUpError = new String();

      String fname = new String();
      String mname = new String();
      String lname = new String();

      String email = new String();
      String phn = new String();

      String add_line1 = new String();
      String add_line2 = new String();
      String city = new String();
      String state = new String();
      String pin = new String();

      String emailErrorMessage = new String();
      String phnErrorMessage = new String();

      String pay_method = new String();

      String card_no = new String();
      String month = new String();
      String year = new String();
      String cardHolder = new String();

      String bank_idS = new String();

      String wallet_idS = new String();
      String wallet_phn = new String();

      //Declare Database access variables
      //to enlist bank-names and mobile wallet names
      PreparedStatement ps;
      ResultSet rs;
      Connection con = new Database().connect();
    %>

    <%
      isSignUpError = (String)session.getAttribute ("isSignUpError");

      //If the user is pushed back to this page due to some error
      if (isSignUpError == "true"){

        fname = (String)session.getAttribute ("fname");
        mname = (String)session.getAttribute ("mname");
        lname = (String)session.getAttribute ("lname");

        email = (String)session.getAttribute ("email");
        phn = (String)session.getAttribute ("phn");

        add_line1 = (String)session.getAttribute ("add_line1");
        add_line2 = (String)session.getAttribute ("add_line2");
        city = (String)session.getAttribute ("city");
        state = (String)session.getAttribute ("state");
        pin = (String)session.getAttribute ("pin");

        emailErrorMessage = (String)session.getAttribute ("emailErrorMessage");
        phnErrorMessage = (String)session.getAttribute ("phnErrorMessage");

        pay_method = (String)session.getAttribute ("pay_method");

        //If some pay-method was chosen previously
        //dc-card
        if (pay_method.equals("Card")){
          card_no = (String)session.getAttribute ("card_no");
          month = (String)session.getAttribute ("month");
          year = (String)session.getAttribute ("year");
          cardHolder = (String)session.getAttribute ("cardholder");
        }
        //net-b
        else if (pay_method.equals("NetB")){
          bank_idS = (String)session.getAttribute ("bank_id");
        }
        //m-wallet
        else if (pay_method.equals("mWallet")){
          wallet_idS = (String)session.getAttribute ("wallet_id");
          wallet_phn = (String)session.getAttribute ("wallet_phn");
        }
      }

      session.invalidate();
    %>

    <!-- Main form -->
    <div class="row section">
      <form class="col" name="signup_form" action="SignupServlet" method="post" onsubmit="return validator()">

        <div class="card hoverable">
          <div class="card-content">

            <!-- Brand Logo -->
            <div class="col s12 center">
              <h3><a href="index.html" class="brand-logo">HarvesTree</a></h3>
            </div>

            <!-- First, middle and last name -->
            <div class="row">
                <div class="input-field col m4 s12">
                  <i class="material-icons prefix">supervisor_account</i>
                  <input id="fname-id" type="text" name="fname" value="<%= fname %>">
                  <label for="fname-id">First Name<span id="fname-err-id" class="error-color"></span></label>
                </div>

                <div class="input-field col m4 s12">
                  <input id="mname-id" type="text" name="mname" value="<%= mname %>">
                  <label for="mname-id">Middle Name (Optional)<span id="mname-err-id" class="error-color"></span></label>
                </div>

                <div class="input-field col m4 s12">
                  <input id="lname-id" type="text" name="lname" value="<%= lname %>">
                  <label for="lname-id">Last Name<span id="lname-err-id" class="error-color"></span></label>
                </div>
            </div>

            <!-- Email and Mobile number -->
            <div class="row">
              <div class="input-field col m6 s12">
                <i class="material-icons prefix">email</i>
                <input id="email-id" type="text" name="email" value="<%= email %>">
                <label for="email-id">Email<span id="email-err-id" class="error-color"><%= emailErrorMessage %></span></label>
              </div>

              <div class="input-field col m6 s12">
                <i class="material-icons prefix">phone</i>
                <input id="phn-id" type="text" name="phn" value="<%= phn %>">
                <label for="phn-id">Phone Number<span id="phn-err-id" class="error-color"><%= phnErrorMessage %></span></label>
              </div>
            </div>

            <!-- Address -->
            <div class="row">
              <div class="input-field col m6 s12">
                <i class="material-icons prefix">room</i>
                <input id="add-line1-id" type="text" name="add_line1" value="<%= add_line1 %>">
                <label for="add-line1-id">Address Line 1<span id="add-line1-err-id" class="error-color"></span></label>
              </div>

              <div class="input-field col m6 s12">
                <input id="add-line2-id" type="text" name="add_line2" value="<%= add_line2 %>">
                <label for="add-line2-id">Address Line 2 (Optional)</label>
              </div>
            </div>

            <div class="row">
              <div class="input-field col m4 s12">
                <input id="city-id" type="text" name="city" value="<%= city %>">
                <label for="city-id">City<span id="city-err-id" class="error-color"></span></label>
              </div>

              <div class="input-field col m4 s12">
                <input id="state-id" type="text" name="state" value="<%= state %>">
                <label for="state-id">State<span id="state-err-id" class="error-color"></span></label>
              </div>

              <div class="input-field col m4 s12">
                <input id="pin-id" type="text" name="pin" value="<%= pin %>">
                <label for="pin-id">Pincode<span id="pin-err-id" class="error-color"></span></label>
              </div>
            </div>

            <!-- Password and retype password -->
            <div class="row">
                <div class="input-field col m6 s12">
                  <i class="material-icons prefix">lock</i>
                  <input id="passwd-id" type="password" name="passwd">
                  <label for="passwd-id">Password<span id="passwd-err-id" class="error-color"></span></label>
                </div>

                <div class="input-field col m6 s12">
                  <input id="re-passwd-id" type="password" name="re_passwd">
                  <label for="re-passwd-id">Retype Password<span id="re-passwd-err-id" class="error-color"></span></label>
                </div>
            </div>

            <!-- Payment options -->
            <h5 class="fade-text">Select a payment method</h5>
            <ul class="collapsible">
              <!-- Debit/Credit Card -->
              <li>
                <div id="dc-card-id" class="collapsible-header" onclick="javascript:getPaymentMethod.call(this)">
                  Debit/Credit Card
                  <span id="dc-card-tick-id">
                    <%
                      //dc-card was chosen previously
                      if (pay_method.equals("Card")){
                    %>
                        <!-- Place the green tick beside dc-card -->
                        <img src='assets/images/green-tick.png' height='20' width='20' style='margin-left:5px'>
                    <%
                      }
                    %>
                  </span>
                  <span id="dc-card-err-id" class="error-color"></span>
                </div>
                <div class="collapsible-body">
                  <div class="row">
                    <div class="input-field col s12">
                      <input id="card-no-id" type="text" name="card_no" value="<%= card_no %>">
                      <label for="card-no-id">Card No.<span id="card-no-err-id" class="error-color"></span></label>
                    </div>
                  </div>

                  <div class="row">
                    <div class="input-field col m6 s12">
                      <select name="month_list" id="month-list-id">
                        <%
                          //Month value is not being retained from previous form
                          if (month.equals("")){
                        %>
                            <!-- "Select Month" heading is shown by default -->
                            <option value="" disabled selected>Select Month</option>
                        <%
                          }
                          else{
                        %>
                            <!-- "Select Month" heading is present but not shown by default -->
                            <option value="" disabled>Select Month</option>
                        <%
                          }
                          //Create month numbers
                          for (int i = 1; i <= 12; i++){
                            String m = Integer.toString(i);
                            if (i < 10)
                              m = "0" + m; //Pad a '0' before single digit month numbers
                            if (month.equals(m)){
                        %>
                              <!-- Show the previuosly chosen month value by default -->
                              <option value="<%= m %>" selected><%= m %></option>
                        <%
                            }
                            else{
                        %>
                              <!-- Do not show any month value by default other than the previuosly chosen month value -->
                              <option value="<%= m %>"><%= m %></option>
                        <%
                            }
                          }
                        %>
                      </select>
                      <label for="month-list-id">Month<span id="month-list-err-id" class="error-color"></span></label>
                    </div>

                    <div class="input-field col m6 s12">
                      <select name="year_list" id="year-list-id">
                        <%
                          //Year value is not being retained from previous form
                          if (year.equals("")){
                        %>
                            <!-- "Select Year" heading is shown by default -->
                            <option value="" disabled selected>Select Year</option>
                        <%
                          }
                          else{
                        %>
                            <!-- "Select Year" heading is present but not shown by default -->
                            <option value="" disabled>Select Year</option>
                        <%
                          }
                          DateFormat dF = new SimpleDateFormat ("yyyy");
                          String y = dF.format(new Date()); //Get current year

                          //Create year numbers
                          for (int i = Integer.parseInt(y); i <= 2050; i++){
                            y = Integer.toString(i);
                            if (year.equals(y)){
                        %>
                              <!-- Show the previuosly chosen year value by default -->
                              <option value="<%= y %>" selected><%= y %></option>
                        <%
                            }
                            else{
                        %>
                              <!-- Do not show any year value by default other than the previuosly chosen year value -->
                              <option value="<%= y %>"><%= y %></option>
                        <%
                            }
                          }
                        %>
                      </select>
                      <label for="year-list-id">Year<span id="year-list-err-id" class="error-color"></span></label>
                    </div>
                  </div>

                  <div class="row">
                    <div class="input-field col s12">
                      <input id="cardholder-id" type="text" name="cardholder" value="<%= cardHolder %>">
                      <label for="cardholder-id">Cardholder's Name<span id="cardholder-err-id" class="error-color"></span></label>
                    </div>
                  </div>
                </div>
              </li>

              <!-- Net Banking -->
              <li>
                <div id="net-b-id" class="collapsible-header" onclick="javascript:getPaymentMethod.call(this)">
                  Net Banking
                  <span id="net-b-tick-id">
                    <%
                      //net-b was chosen previously
                      if (pay_method.equals ("NetB")){
                    %>
                        <!-- Place the green tick beside net-b -->
                        <img src='assets/images/green-tick.png' height='20' width='20' style='margin-left:5px'>
                    <%
                      }
                    %>
                  </span>
                  <span id="net-b-err-id" class="error-color"></span>
                </div>
                <div class="collapsible-body">
                  <div class="row">
                    <div class="input-field col s12">
                      <select name="bank_list" id="bank-list-id">
                        <%
                          //Bank-name value is not being retained from previous form
                          if (bank_idS.equals("")){
                        %>
                            <!-- "Select Bank" heading is shown by default -->
                            <option value="" disabled selected>Select Bank</option>
                        <%
                          }
                          else{
                        %>
                            <!-- "Select Bank" heading is present but not shown by default -->
                            <option value="" disabled>Select Bank</option>
                        <%
                          }
                          //Get bank-names from Database
                          ps = con.prepareStatement ("SELECT * FROM Bank_List"); //Write Query
                          rs = ps.executeQuery();                                //Execute Query
                          while (rs.next()){
                            int bank_id = rs.getInt ("Bank_id");
                            String bank_name = rs.getString ("Bank_name");
                            String b = Integer.toString (bank_id);
                            if (bank_idS.equals(b)){
                        %>
                              <!-- Show the previuosly chosen bank-name value by default -->
                              <option value="<%= b %>" selected><%= bank_name %></option>
                        <%
                            }
                            else{
                        %>
                              <!-- Do not show any bank-name value by default other than the previuosly chosen bank-name value -->
                              <option value="<%= b %>"><%= bank_name %></option>
                        <%
                            }
                          }
                        %>
                      </select>
                      <label for="bank-list-id">Name of Bank<span id="bank-list-err-id" class="error-color"></span></label>
                    </div>
                  </div>
                </div>
              </li>

              <!-- Mobile Wallets -->
              <li>
                <div id="m-wallet-id" class="collapsible-header" onclick="javascript:getPaymentMethod.call(this)">
                  Mobile Wallets
                  <span id="m-wallet-tick-id">
                    <%
                      //m-wallet was chosen previously
                      if (pay_method.equals ("mWallet")){
                    %>
                        <!-- Place the green tick beside m-wallet -->
                        <img src='assets/images/green-tick.png' height='20' width='20' style='margin-left:5px'>
                    <%
                      }
                    %>
                  </span>
                  <span id="m-wallet-err-id" class="error-color"></span>
                </div>
                <div class="collapsible-body">
                  <div class="row">
                    <div class="input-field col m6 s12">
                      <select name="wallet_list" id="wallet-list-id">
                        <%
                          //Mobile wallet name value is not being retained from previous form
                          if (wallet_idS.equals("")){
                        %>
                            <!-- "Select Wallet" heading is shown by default -->
                            <option value="" disabled selected>Select Wallet</option>
                        <%
                          }
                          else{
                        %>
                            <!-- "Select Wallet" heading is present but not shown by default -->
                            <option value="" disabled>Select Wallet</option>
                        <%
                          }
                          //Get mobile wallet names from Database
                          ps = con.prepareStatement ("SELECT * FROM mWallet_List"); //Write Query
                          rs = ps.executeQuery();                                   //Execute Query
                          while (rs.next()){
                            int wallet_id = rs.getInt ("Wallet_id");
                            String wallet_name = rs.getString ("Wallet_name");
                            String w = Integer.toString (wallet_id);
                            if (wallet_idS.equals(w)){
                        %>
                              <!-- Show the previuosly chosen mobile wallet name value by default -->
                              <option value="<%= w %>" selected><%= wallet_name %></option>
                        <%
                            }
                            else{
                        %>
                              <!-- Do not show any mobile wallet name value by default other than the previuosly chosen bank-name value -->
                              <option value="<%= w %>"><%= wallet_name %></option>
                        <%
                            }
                          }
                        %>
                      </select>
                      <label for="wallet-list-id">Name of Wallet<span id="wallet-list-err-id" class="error-color"></span></label>
                    </div>

                    <div class="input-field col m6 s12">
                      <input id="wallet-phn-id" type="text" name="wallet_phn" value="<%= wallet_phn %>">
                      <label for="wallet-phn-id">Wallet Phone Number<span id="wallet-phn-err-id" class="error-color"></span></label>
                    </div>
                  </div>
                </div>
              </li>
            </ul>

            <!-- Checkbox -->
            <p>
              <input id="filled-in-box-id" type="checkbox" class="filled-in" onclick="javascript:noPayment.call(this)"/>
              <label for="filled-in-box-id">I don't want to specify any payment options<span id="filled-in-box-err-id" class="error-color"></span></label>
            </p>
          </div>

          <div class="card-action">
            <input type="hidden" name="pay_method" id="pay-method-id" value="">
            <input type="submit" class="btn waves-effect waves-light" value="Sign Up">
          </div>
        </div>
      </form>
    </div>

    <script type="text/javascript" src="js/jquery-3.2.1.js"></script>
    <script type="text/javascript" src="js/materialize.js"></script>
    <script type="text/javascript" src="js/signup.js"></script>

    <%
      fname = "";
      mname = "";
      lname = "";

      email = "";
      phn = "";

      add_line1 = "";
      add_line2 = "";
      city = "";
      state = "";
      pin = "";

      emailErrorMessage = "";
      phnErrorMessage = "";

      pay_method = "";

      card_no = "";
      month = "";
      year = "";
      cardHolder = "";

      bank_idS = "";

      wallet_idS = "";
      wallet_phn = "";
    %>
  </body>
</html>