package javaPackage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Customer{

  //store personal details of a customer
  public static synchronized int addCustomer (String fname, String mname, String lname, String email, long phn, String add_line1,
                                            String add_line2, String city, String state, int pin, String passwd, String pay_method){
    PreparedStatement ps;
    ResultSet rs, rs1;
    int id = 0, j = 0;  //id-->primary key; j-->status value
    Useful use = new Useful();
    Connection con = new Database().connect();  //establish database connection

    //convert some strings into title case
    fname = use.toTitleCase (fname);    //first-name

    if (!mname.equals(""))              //if not blank
      mname = use.toTitleCase (mname);  //middle name
    
    lname = use.toTitleCase (lname);    //last name

    add_line1 = use.toTitleCase (add_line1);    //address-line-1

    if (!add_line2.equals(""))                  //if not blank
      add_line2 = use.toTitleCase (add_line2);  //address-line-2
    
    city = use.toTitleCase (city);      //city
    state = use.toTitleCase (state);    //state

    //generate hash of password
    passwd = use.makeHash (passwd);

    try{
      //check if email already exists
      ps = con.prepareStatement ("SELECT Fname FROM Customer WHERE email = ?"); //write query
      ps.setString (1, email);                                                  //set variable
      rs = ps.executeQuery();                                                   //retrieve

      //check if phone already exists
      ps = con.prepareStatement ("SELECT Fname FROM Customer WHERE Phone = ?"); //write query
      ps.setLong (1, phn);                                                      //set variable
      rs1 = ps.executeQuery();                                                  //retrieve

      if (rs.next()){
        j = -1;     //only email exists; status value=-1
        if (rs1.next())
          j = -3;   //email & phone both exists; status value=-3
      }
      else if (rs1.next())
        j = -2;     //only phone exists; status value=-2
      else{
        //no problem in storing customer details
        ps = con.prepareStatement ("INSERT into Customer values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"); //write query

        //set variables
        ps.setInt (1, id);
        ps.setString (2, fname);
        ps.setString (3, mname);
        ps.setString (4, lname);
        ps.setString (5, email);
        ps.setLong (6, phn);
        ps.setString (7, add_line1);
        ps.setString (8, add_line2);
        ps.setString (9, city);
        ps.setString (10, state);
        ps.setInt (11, pin);
        ps.setString (12, passwd);
        ps.setInt (13, id);
        ps.setString (14, pay_method);

        j = ps.executeUpdate(); //store into database; status value=1
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }
    return j; //return status value
  }

  //check if email or phone already exists or not
  public static synchronized String checkDuplication (String attribute, String data){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      //check if email already exists
      if (attribute.equals("email")){
        ps = con.prepareStatement ("SELECT Fname FROM Customer WHERE email = ?"); //write query
        ps.setString (1, data);                                                   //set variable
        rs = ps.executeQuery();                                                   //retrieve
      }
      //check if phone already exists
      else{
        ps = con.prepareStatement ("SELECT Fname FROM Customer WHERE Phone = ?"); //write query
        ps.setLong (1, Long.parseLong (data));                                    //set variable
        rs = ps.executeQuery();                                                   //retrieve
      }

      if (rs.next())
        return "true";
      else
        return "false";
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return "";
  }

  //store debit/credit card details of a customer just registered
  public static synchronized void addCard (long card_no, int month, int year, String cardHolder, long phn){
    PreparedStatement ps;
    ResultSet rs;
    int id = 0;   //id of the needed customer
    Useful use = new Useful();
    Connection con = new Database().connect();  //establish database connection

    cardHolder = use.toTitleCase (cardHolder); //convert cardholder name into title case

    try{
      //retrieve the id of the customer needed
      ps = con.prepareStatement ("SELECT Cust_id FROM Customer WHERE Phone = ?"); //write query
      ps.setLong (1, phn);                                                        //set variable
      rs = ps.executeQuery();                                                     //retrieve
      rs.next();
      id = rs.getInt ("Cust_id");

      ps = con.prepareStatement ("INSERT into Card values (?, ?, ?, ?, ?)");  //write query

      //set variables
      ps.setInt (1, id);
      ps.setLong (2, card_no);
      ps.setInt (3, month);
      ps.setInt (4, year);
      ps.setString (5, cardHolder);

      id = ps.executeUpdate();  //store into database
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }

  //store net banking details of a customer just registered
  public static synchronized void addNetB (int bank_id, long phn){
    PreparedStatement ps;
    ResultSet rs;
    int id = 0;   //id of the needed customer
    Connection con = new Database().connect();  //establish database connection

    try{
      //retrieve the id of the customer needed
      ps = con.prepareStatement ("SELECT Cust_id FROM Customer WHERE Phone = ?"); //write query
      ps.setLong (1, phn);                                                        //set variable
      rs = ps.executeQuery();                                                     //retrieve
      rs.next();
      id = rs.getInt ("Cust_id");

      ps = con.prepareStatement ("INSERT into NetB values (?, ?)"); //write query

      //set variables
      ps.setInt (1, id);
      ps.setInt (2, bank_id);

      id = ps.executeUpdate();  //store into database
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }

  //store mobile wallet details of a customer just registered
  public static synchronized void addmWallet (int wallet_id, long wallet_phn, long phn){
    PreparedStatement ps;
    ResultSet rs;
    int id = 0;   //id of the needed customer
    Connection con = new Database().connect();  //establish database connection

    try{
      //retrieve the id of the customer needed
      ps = con.prepareStatement ("SELECT Cust_id FROM Customer WHERE Phone = ?"); //write query
      ps.setLong (1, phn);                                                        //set variable
      rs = ps.executeQuery();                                                     //retrieve
      rs.next();
      id = rs.getInt ("Cust_id");

      ps = con.prepareStatement ("INSERT into mWallet values (?, ?, ?)"); //write query

      //set variables
      ps.setInt (1, id);
      ps.setInt (2, wallet_id);
      ps.setLong (3, wallet_phn);

      id = ps.executeUpdate();  //store into database
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }

  //Check if email or password during customer-login is invalid or not
  public static synchronized String checkInvalidity (String attribute, String data){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      //Check if email doesn't exist
      if (attribute.equals("email")){
        ps = con.prepareStatement ("SELECT Cust_id FROM Customer WHERE email = ?"); //write query
        ps.setString (1, data);                                                     //set variable
        rs = ps.executeQuery();                                                     //retrieve

        if (rs.next())
          return "false";
        else
          return "true";
      }
      //Check if password is incorrect, only when email exists
      else{

        //Split data to divide email and password
        String[] parts = data.split(",");

        //Generate hash of password
        parts[1] = new Useful().makeHash (parts[1]);
        
        ps = con.prepareStatement ("SELECT Password FROM Customer WHERE email = ?"); //write query
        ps.setString (1, parts[0]);                                                  //set variable
        rs = ps.executeQuery();                                                      //retrieve

        if (rs.next()){
          String passwd = rs.getString ("Password");
          if (passwd.equals(parts[1]))
            return "false";
          else
            return "true";
        }
        else
          return "true";
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return "";
  }

  // Return Customer ID and Name
  public static synchronized String doLogin (String email){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      ps = con.prepareStatement ("SELECT Cust_id, FName, MName, LName FROM Customer WHERE email = ?");
      ps.setString (1, email);
      rs = ps.executeQuery();
      rs.next();

      int Cust_id = rs.getInt ("Cust_id");
      String Cust_idS = Integer.toString (Cust_id);
      String FName = rs.getString ("FName");
      String MName = rs.getString ("MName");
      String LName = rs.getString ("LName");

      if (MName.equals (""))
        return (Cust_idS + "," + FName + " " + LName);
      else
        return (Cust_idS + "," + FName + " " + MName + " " + LName);
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return "";
  }

  public static synchronized int setReview (String title, String comment, int rating, int Pro_id, int Cust_id){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();
    int j = 0;

    try{
      ps = con.prepareStatement ("SELECT Rating from Rating WHERE Cust_id = ? and Pro_id = ?");
      ps.setInt (1, Cust_id);
      ps.setInt (2, Pro_id);
      rs = ps.executeQuery();

      if (rs.next()){
        ps = con.prepareStatement ("UPDATE Rating SET Rating = ? WHERE Cust_id = ? and Pro_id = ?");
        ps.setInt (1, rating);
        ps.setInt (2, Cust_id);
        ps.setInt (3, Pro_id);
        j = ps.executeUpdate();
      }
      else{
        ps = con.prepareStatement ("INSERT Into Rating values (?, ?, ?)");
        ps.setInt (1, Cust_id);
        ps.setInt (2, Pro_id);
        ps.setInt (3, rating);
        j = ps.executeUpdate();
      }

      ps = con.prepareStatement ("SELECT Title from Comment WHERE Cust_id = ? and Pro_id = ?");
      ps.setInt (1, Cust_id);
      ps.setInt (2, Pro_id);
      rs = ps.executeQuery();

      if (rs.next()){
        if (title!="" && comment!=""){
          ps = con.prepareStatement ("UPDATE Comment SET Title = ?, Comment = ? WHERE Cust_id = ? and Pro_id = ?");
          ps.setString (1, title);
          ps.setString (2, comment);
          ps.setInt (3, Cust_id);
          ps.setInt (4, Pro_id);
          j = ps.executeUpdate();
        }
      }
      else{
        if (title!="" && comment!=""){
          ps = con.prepareStatement ("INSERT Into Comment values (?, ?, ?, ?)");
          ps.setInt (1, Cust_id);
          ps.setInt (2, Pro_id);
          ps.setString (3, title);
          ps.setString (4, comment);
          j = ps.executeUpdate();
        }
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return j;
  }

  //check if email or phone already exists or not
  public static synchronized String checkDuplication (String attribute, String data, int Cust_id){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      //check if email already exists
      if (attribute.equals("email")){
        ps = con.prepareStatement ("SELECT Fname FROM Customer WHERE email = ? and Cust_id != ?"); //write query
        ps.setString (1, data); 
        ps.setInt (2, Cust_id);                                                                   //set variable
        rs = ps.executeQuery();                                                                   //retrieve
      }
      //check if phone already exists
      else{
        ps = con.prepareStatement ("SELECT Fname FROM Customer WHERE Phone = ? and Cust_id != ?"); //write query
        ps.setLong (1, Long.parseLong (data));
        ps.setInt (2, Cust_id);                                                                   //set variable
        rs = ps.executeQuery();                                                                   //retrieve
      }

      if (rs.next())
        return "true";
      else
        return "false";
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return "";
  }

  public static synchronized int updateCustomer (int Cust_id, String fname, String mname, String lname, String email, long phn,
                                                    String add_line1, String add_line2, String city, String state, int pin){
    PreparedStatement ps;
    ResultSet rs;
    int j = 0;
    Useful use = new Useful();
    Connection con = new Database().connect();  //establish database connection

    //convert some strings into title case
    fname = use.toTitleCase (fname);    //first-name

    if (!mname.equals(""))              //if not blank
      mname = use.toTitleCase (mname);  //middle name
    
    lname = use.toTitleCase (lname);    //last name

    add_line1 = use.toTitleCase (add_line1);    //address-line-1

    if (!add_line2.equals(""))                  //if not blank
      add_line2 = use.toTitleCase (add_line2);  //address-line-2
    
    city = use.toTitleCase (city);      //city
    state = use.toTitleCase (state);    //state

    try{
      ps = con.prepareStatement ("UPDATE Customer SET FName = ?, MName = ?, LName = ?, email = ?, Phone = ?, Address_line1 = ?, Address_line2 = ?, City = ?, State = ?, Pin = ? WHERE Cust_id = ?");
      ps.setString (1, fname);
      ps.setString (2, mname);
      ps.setString (3, lname);
      ps.setString (4, email);
      ps.setLong (5, phn);
      ps.setString (6, add_line1);
      ps.setString (7, add_line2);
      ps.setString (8, city);
      ps.setString (9, state);
      ps.setLong (10, pin);
      ps.setInt (11, Cust_id);

      j = ps.executeUpdate();
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return j;
  }

  public static synchronized String checkPassword (String enteredPasswd, int Cust_id){
    PreparedStatement ps;
    ResultSet rs;
    Useful use = new Useful();
    Connection con = new Database().connect();  //establish database connection

    //generate hash of password
    enteredPasswd = use.makeHash (enteredPasswd);

    try{
      ps = con.prepareStatement ("SELECT Password from Customer WHERE Cust_id = ?");
      ps.setInt (1, Cust_id);
      rs = ps.executeQuery();
      rs.next();
      String storedPasswd = rs.getString ("Password");

      if (enteredPasswd.equals(storedPasswd))
        return "false";
      else
        return "true";
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return "";
  }

  public static synchronized int updatePassword (int Cust_id, String newPasswd){
    PreparedStatement ps;
    ResultSet rs;
    int j = 0;
    Useful use = new Useful();
    Connection con = new Database().connect();  //establish database connection

    //generate hash of password
    newPasswd = use.makeHash (newPasswd);

    try{
      ps = con.prepareStatement ("UPDATE Customer SET Password = ? WHERE Cust_id = ?");
      ps.setString (1, newPasswd);
      ps.setInt (2, Cust_id);

      j = ps.executeUpdate();
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    return j;
  }
}