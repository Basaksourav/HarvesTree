package javaPackage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Admin{

  //Check if username or password during admin-login is invalid or not
  public static synchronized String checkInvalidity (String attribute, String data){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      //Check if username doesn't exist
      if (attribute.equals("uname")){
        ps = con.prepareStatement ("SELECT Admin_id FROM Administrator WHERE UserName = ?"); //write query
        ps.setString (1, data);                                                              //set variable
        rs = ps.executeQuery();                                                              //retrieve

        if (rs.next())
          return "false";
        else
          return "true";
      }
      //Check if password is incorrect, only when username exists
      else{

        //Split data to divide username and password
        String[] parts = data.split(",");

        //Generate hash of password
        parts[1] = new Useful().makeHash (parts[1]);
        
        ps = con.prepareStatement ("SELECT Password FROM Administrator WHERE UserName = ?"); //write query
        ps.setString (1, parts[0]);                                                          //set variable
        rs = ps.executeQuery();                                                              //retrieve

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
}