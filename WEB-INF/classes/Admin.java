package javaPackage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import java.util.HashMap;

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

  public static synchronized String storeImage (String primaryPath, String secondaryPath, String product_img_name, String product_name){
    Useful use = new Useful();
    product_name = product_name.toLowerCase();
    product_name = product_name.replaceAll ("[ -]", "_");
    product_name = product_name.replaceAll ("[()]", "");
    String finalPath = secondaryPath + "/" + product_name + ".jpg";

    try{

      File file = new File (primaryPath + "/" + product_img_name);

      FileInputStream fileInput = new FileInputStream (file);
      FileOutputStream fileOutput = new FileOutputStream (new File(finalPath));

      int j;

      while ((j=fileInput.read()) != -1)
          fileOutput.write ((byte)j);

      fileInput.close();
      fileOutput.close();

      file.delete();
    }
    catch (IOException e){}

    return finalPath;
  }

  public static synchronized int addProduct (String Type, String product_name, int qty, String unit, int price, String wght, int qty2, String unit2,
                                             String desc, String nutri, String shelf_life, String storage, String disclaimer, String relativePath){
    PreparedStatement ps;
    ResultSet rs;
    int id = 0, j = 0;
    Connection con = new Database().connect();
    Useful use = new Useful();

    product_name = use.toTitleCase (product_name);

    try{
      ps = con.prepareStatement ("INSERT into Product values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

      ps.setInt (1, id);
      ps.setString (2, Type);
      ps.setString (3, product_name);
      ps.setInt (4, qty);
      ps.setString (5, unit);
      ps.setInt (6, price);
      ps.setInt (7, qty2);
      ps.setString (8, unit2);
      ps.setString (9, desc);
      ps.setString (10, nutri);
      ps.setString (11, shelf_life);
      ps.setString (12, storage);
      ps.setString (13, disclaimer);
      ps.setString (14, relativePath);

      j = ps.executeUpdate();

      if (j == 1){
        if (unit.equals("piece") && !Type.equals("flo") && wght != null){
          ps = con.prepareStatement ("SELECT Pro_id FROM Product WHERE ProName = ?");
          ps.setString (1, product_name);
          rs = ps.executeQuery();
          rs.next();
          id = rs.getInt ("Pro_id");

          ps = con.prepareStatement ("INSERT into AvgWght values (?, ?)");
          ps.setInt (1, id);
          ps.setString (2, wght);
          j = ps.executeUpdate();
        }
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }
    return j;
  }

  public static synchronized void fetchProductDetail (String Type, String Pro_idS, HashMap<String, String> ProductDetail){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    int Pro_id = Integer.parseInt (Pro_idS);

    try{
      ps = con.prepareStatement ("SELECT * FROM Product WHERE Pro_id = ? and Type = ?");
      ps.setInt (1, Pro_id);
      ps.setString (2, Type);
      rs = ps.executeQuery();

      if (rs.next()){
        String product_name = rs.getString ("ProName");
        int qty = rs.getInt ("BaseQty");
        String qtyS = Integer.toString (qty);
        String unit = rs.getString ("BaseUnit");
        int price = rs.getInt ("BasePrice");
        String priceS = Integer.toString (price);
        int qty2 = rs.getInt ("MaxQty");
        String qty2S = Integer.toString (qty2);
        String unit2 = rs.getString ("MaxUnit");
        String desc = rs.getString ("Description");
        String nutri = rs.getString ("Nutrient");
        String shelf_life = rs.getString ("Shelf_Life");
        String storage = rs.getString ("Storage");
        String disclaimer = rs.getString ("Disclaimer");
        String product_img_name = rs.getString ("ProImage");
        product_img_name = product_img_name.substring (product_img_name.lastIndexOf ("/") + 1);

        String wght = new String("");

        if (unit.equals("piece") && !Type.equals("flo")){
          ps = con.prepareStatement ("SELECT Weight FROM AvgWght WHERE Pro_id = ?");
          ps.setInt (1, Pro_id);
          rs = ps.executeQuery();

          if (rs.next())
            wght = rs.getString ("Weight");
        }

        ProductDetail.put ("product_name", product_name);
        ProductDetail.put ("qty", qtyS);
        ProductDetail.put ("unit", unit);
        ProductDetail.put ("price", priceS);
        ProductDetail.put ("wght", wght);
        ProductDetail.put ("qty2", qty2S);
        ProductDetail.put ("unit2", unit2);
        ProductDetail.put ("desc", desc);
        ProductDetail.put ("nutri", nutri);
        ProductDetail.put ("shelf_life", shelf_life);
        ProductDetail.put ("storage", storage);
        ProductDetail.put ("disclaimer", disclaimer);
        ProductDetail.put ("product_img_name", product_img_name);
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }

  public static synchronized void deleteProduct (String Type, String Pro_idS, String primaryPath){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();
    String unit, relativePath = new String("");

    int Pro_id = Integer.parseInt (Pro_idS);
    int j;

    try{
      ps = con.prepareStatement ("SELECT BaseUnit, ProImage FROM Product WHERE Pro_id = ? and Type = ?");
      ps.setInt (1, Pro_id);
      ps.setString (2, Type);
      rs = ps.executeQuery();

      if (rs.next()){
        unit = rs.getString ("BaseUnit");
        relativePath = rs.getString ("ProImage");

        if (unit.equals("piece")){
          ps = con.prepareStatement ("DELETE FROM AvgWght WHERE Pro_id = ?");
          ps.setInt (1, Pro_id);
          j = ps.executeUpdate();
        }
      }
      ps = con.prepareStatement ("DELETE FROM Product WHERE Pro_id = ? and Type = ?");
      ps.setInt (1, Pro_id);
      ps.setString (2, Type);
      j = ps.executeUpdate();

      File file = new File (primaryPath + "/" + relativePath);
      file.delete();
    }
    catch (SQLException e){
      e.printStackTrace();
    }
    catch (Exception e){
      e.printStackTrace();
    }
  }

  public static synchronized int editProduct (String Type, String Pro_idS, String product_name, int qty, String unit, int price, String wght, int qty2, String unit2,
                                            String desc, String nutri, String shelf_life, String storage, String disclaimer, String relativePath, String secondaryPath){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();
    Useful use = new Useful();

    int Pro_id = Integer.parseInt (Pro_idS);
    int j = 0;
    String oldUnit = "";

    product_name = use.toTitleCase (product_name);

    try{
      ps = con.prepareStatement ("SELECT ProName, BaseUnit, ProImage FROM Product WHERE Pro_id = ? and Type = ?");
      ps.setInt (1, Pro_id);
      ps.setString (2, Type);

      rs = ps.executeQuery();

      if (rs.next()){
        String ProName = rs.getString ("ProName");
        oldUnit = rs.getString ("BaseUnit");

        if (!product_name.equals(ProName)){

          String product_img_name = rs.getString ("ProImage");
          product_img_name = product_img_name.substring (product_img_name.lastIndexOf("/")+1);

          if (relativePath.equals ("")){
            relativePath = storeImage (secondaryPath, secondaryPath, product_img_name, product_name);
            relativePath = relativePath.substring (relativePath.indexOf ("assets"));
          }
          else{
            File file = new File (secondaryPath + "/" + product_img_name);
            file.delete();
          }
        }
      }

      ps = con.prepareStatement ("UPDATE Product SET ProName=?, BaseQty=?, BaseUnit=?, BasePrice=?, MaxQty=?, maxUnit=?, Description=?, Nutrient=?, Shelf_Life=?, Storage=?, Disclaimer=? WHERE Pro_id = ? and Type = ?");
      ps.setString (1, product_name);
      ps.setInt (2, qty);
      ps.setString (3, unit);
      ps.setInt (4, price);
      ps.setInt (5, qty2);
      ps.setString (6, unit2);
      ps.setString (7, desc);
      ps.setString (8, nutri);
      ps.setString (9, shelf_life);
      ps.setString (10, storage);
      ps.setString (11, disclaimer);
      ps.setInt (12, Pro_id);
      ps.setString (13, Type);

      j = ps.executeUpdate();

      if (j == 1){
        if (unit.equals("piece") && !Type.equals("flo") && wght != null){
          if (oldUnit.equals ("piece")){
            ps = con.prepareStatement ("UPDATE AvgWght SET Weight = ? WHERE Pro_id = ?");
            ps.setString (1, wght);
            ps.setInt (2, Pro_id);
          }
          else{
            ps = con.prepareStatement ("INSERT into AvgWght values (?, ?)");
            ps.setInt (1, Pro_id);
            ps.setString (2, wght);
          }

          j = ps.executeUpdate();
        }
        else if (!unit.equals("piece") && !Type.equals("flo")){
          if (oldUnit.equals ("piece")){
            ps = con.prepareStatement ("DELETE From AvgWght WHERE Pro_id = ?");
            ps.setInt (1, Pro_id);
            j = ps.executeUpdate();
          }
        }

        if (!relativePath.equals ("")){
          ps = con.prepareStatement ("UPDATE Product SET ProImage = ? WHERE Pro_id = ?");
          ps.setString (1, relativePath);
          ps.setInt (2, Pro_id);

          j = ps.executeUpdate();
        }
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }
    return j;
  }
}