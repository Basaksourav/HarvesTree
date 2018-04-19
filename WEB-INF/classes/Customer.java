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
}