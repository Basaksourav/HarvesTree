package javaPackage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Cart{

  public static synchronized void addProduct (int Cust_id, int Pro_id, int OrderLimit){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      ps = con.prepareStatement ("SELECT * FROM Cart WHERE Cust_id = ? and Pro_id = ?");
      ps.setInt (1, Cust_id);
      ps.setInt (2, Pro_id);
      rs = ps.executeQuery();

      if (rs.next()){
        //updateCart (Cust_id, Pro_id, 1);
      }
      else{
        ps = con.prepareStatement ("INSERT Into Cart values (?, ?, ?, ?)");
        ps.setInt (1, Cust_id);
        ps.setInt (2, Pro_id);
        ps.setInt (3, 1);
        ps.setInt (4, OrderLimit);

        int j = ps.executeUpdate();
        int change = -1;
        updateProductInDB (Pro_id, change);
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }

  public static synchronized void updateProductInDB (int Pro_id, int change){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      ps = con.prepareStatement ("SELECT BaseQty, BaseUnit, MaxQty, MaxUnit FROM Product WHERE Pro_id = ?");
      ps.setInt (1, Pro_id);
      rs = ps.executeQuery();
      rs.next();
      int BaseQty = rs.getInt ("BaseQty");
      String BaseUnit = rs.getString ("BaseUnit");
      float MaxQty = rs.getFloat ("MaxQty");
      String MaxUnit = rs.getString ("MaxUnit");

      float changeQty = change * BaseQty;

      if (!BaseUnit.equals(MaxUnit))
        changeQty /= 1000;

      float changedQty = MaxQty + changeQty;
      ps = con.prepareStatement ("UPDATE Product SET MaxQty = ? WHERE Pro_id = ?");
      ps.setFloat (1, changedQty);
      ps.setInt (2, Pro_id);
      int j = ps.executeUpdate();
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }

  public static synchronized void deleteProduct (int Cust_id, int Pro_id){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();
    int qty = 0;

    try{
      ps = con.prepareStatement ("SELECT Qty FROM Cart WHERE Cust_id = ? and Pro_id = ?");
      ps.setInt (1, Cust_id);
      ps.setInt (2, Pro_id);
      rs = ps.executeQuery();
      if (rs.next())
        qty = rs.getInt ("Qty");

      ps = con.prepareStatement ("DELETE FROM Cart WHERE Cust_id = ? and Pro_id = ?");
      ps.setInt (1, Cust_id);
      ps.setInt (2, Pro_id);
      int j = ps.executeUpdate();

      if (qty != 0)
        updateProductInDB (Pro_id, qty);
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }
}