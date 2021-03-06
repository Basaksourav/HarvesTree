package javaPackage;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.Date;

import java.text.DateFormat;
import java.text.SimpleDateFormat;

public class Cart{

  public static synchronized void addProduct (int Cust_id, int Pro_id, int Qty, int OrderLimit){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      ps = con.prepareStatement ("SELECT * FROM Cart WHERE Cust_id = ? and Pro_id = ?");
      ps.setInt (1, Cust_id);
      ps.setInt (2, Pro_id);
      rs = ps.executeQuery();

      if (rs.next()){
        int oldQty = rs.getInt ("Qty");
        int oldOrderLimit = rs.getInt ("OrderLimit");
        Qty = (Qty < (oldOrderLimit-oldQty)) ? Qty : (oldOrderLimit-oldQty);
        updateCart (Cust_id, Pro_id, Qty);
      }
      else{
        ps = con.prepareStatement ("INSERT Into Cart values (?, ?, ?, ?)");
        ps.setInt (1, Cust_id);
        ps.setInt (2, Pro_id);
        ps.setInt (3, Qty);
        ps.setInt (4, OrderLimit);

        int j = ps.executeUpdate();
        int change = Qty * (-1);
        updateProductInDB (Pro_id, change);
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }

  public static synchronized void updateCart (int Cust_id, int Pro_id, int change){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      if (change > 0){
        ps = con.prepareStatement ("UPDATE Cart SET Qty = Qty+" + change + " WHERE Cust_id = ? and Pro_id = ?");
        change *= -1;
      }
      else{
        change *= -1;
        ps = con.prepareStatement ("UPDATE Cart SET Qty = Qty-" + change + " WHERE Cust_id = ? and Pro_id = ?");
      }

      ps.setInt (1, Cust_id);
      ps.setInt (2, Pro_id);
      int j = ps.executeUpdate();
      
      updateProductInDB (Pro_id, change);
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

  public static synchronized String obtainForCart (int Pro_id, int Qty){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      ps = con.prepareStatement ("SELECT BaseQty, BaseUnit, BasePrice FROM Product WHERE Pro_id = ?");
      ps.setInt (1, Pro_id);
      rs = ps.executeQuery();
      rs.next();

      int BaseQty = rs.getInt ("BaseQty");
      String BaseUnit = rs.getString ("BaseUnit");
      int BasePrice = rs.getInt ("BasePrice");

      float qtyInCart = BaseQty * Qty;
      int priceInCart = BasePrice * Qty;
      String unitInCart = BaseUnit;

      if (qtyInCart >= 1000 && BaseUnit.equals("gm.")){
        qtyInCart /= 1000;
        unitInCart = "kg.";
      }

      String qtyInCartS = Float.toString (qtyInCart);
      if (qtyInCartS.indexOf(".0") == qtyInCartS.length()-2)
        qtyInCartS = qtyInCartS.substring (0, qtyInCartS.length()-2);

      if (unitInCart.equals("piece") && qtyInCart>1)
        unitInCart = "pieces";

      return (priceInCart + "-" + qtyInCartS + "-" + unitInCart);
    }
    catch (SQLException e){
      e.printStackTrace();
    }
    return "";
  }

  public static synchronized void transferAnonymousCart (String Cust_idS, String anonymousCart){
    int Cust_id = Integer.parseInt (Cust_idS);

    for (String s : anonymousCart.split(",")){
      String[] product = s.split("-");
      int Pro_id = Integer.parseInt (product[0]);
      int Qty = Integer.parseInt (product[1]);
      int OrderLimit = Integer.parseInt (product[2]);

      addProduct (Cust_id, Pro_id, Qty, OrderLimit);
    }
  }

  public static synchronized void placeOrder (int Cust_id, int amount){
    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();
    String Ord_id = "", base = "0000";

    try{
      ps = con.prepareStatement ("SELECT Max(Ord_id) FROM Order_List");
      rs = ps.executeQuery();
      rs.next();
      Ord_id = rs.getString(1);

      if (Ord_id == null)
        Ord_id = "OD0001";
      else{
        int lastID = Integer.parseInt (Ord_id.substring(2));
        lastID++;
        int lengthOfNewID = Integer.toString(lastID).length();
        Ord_id = "OD" + base.substring(lengthOfNewID) + lastID;
      }

      DateFormat dateFormat = new SimpleDateFormat("hh:mm aa | MMMM dd, YYYY");
      String Ord_date = dateFormat.format(new Date());

      ps = con.prepareStatement ("INSERT Into Order_List values (?, ?, ?, ?)");
      ps.setInt (1, Cust_id);
      ps.setString (2, Ord_id);
      ps.setString (3, Ord_date);
      ps.setInt (4, amount);

      int j = ps.executeUpdate();

      ps = con.prepareStatement ("SELECT Cart.Pro_id, Qty, BaseQty, BaseUnit, MaxQty, MaxUnit FROM Cart JOIN Product WHERE Cart.Pro_id = Product.Pro_id and Cust_id = ?");
      ps.setInt (1, Cust_id);
      rs = ps.executeQuery();

      while (rs.next()){
        int Pro_id = rs.getInt ("Pro_id");
        int Qty = rs.getInt ("Qty");
        ps = con.prepareStatement ("INSERT Into Order_Detail values (?, ?, ?)");
        ps.setString (1, Ord_id);
        ps.setInt (2, Pro_id);
        ps.setInt (3, Qty);

        j = ps.executeUpdate();

        int BaseQty = rs.getInt ("BaseQty");
        String BaseUnit = rs.getString ("BaseUnit");
        int MaxQty = rs.getInt ("MaxQty");
        String MaxUnit = rs.getString ("MaxUnit");
        int OrderLimit = Admin.setOrderLimit (BaseQty, BaseUnit, MaxQty, MaxUnit);

        ps = con.prepareStatement ("UPDATE Product SET OrderLimit = ? WHERE Pro_id = ?");
        ps.setInt (1, OrderLimit);
        ps.setInt (2, Pro_id);

        j = ps.executeUpdate();
      }

      ps = con.prepareStatement ("DELETE FROM Cart WHERE Cust_id = ?");
      ps.setInt (1, Cust_id);
      j = ps.executeUpdate();
    }
    catch (SQLException e){
      e.printStackTrace();
    }
  }
}