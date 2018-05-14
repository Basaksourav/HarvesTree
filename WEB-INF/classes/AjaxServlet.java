package servletPackage;

import java.io.PrintWriter;
import java.io.IOException;

import java.util.HashMap;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.google.gson.Gson;

import javaPackage.Database;
import javaPackage.Customer;
import javaPackage.Admin;
import javaPackage.Cart;

@WebServlet("/Web-Content/AjaxServlet")

public class AjaxServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();

    String sourcePage = request.getParameter ("sourcePage");

    //AJAX request is from signup page
    //to check if email or phone already exists or not
    if (sourcePage.equals("signup")){
      response.setContentType ("text/plain");
      String attribute = request.getParameter ("attribute");
      String data = request.getParameter ("data");

      out.write (Customer.checkDuplication (attribute, data));
    }
    else if (sourcePage.equals("adminlogin")){
      response.setContentType ("text/plain");
      String attribute = request.getParameter ("attribute");
      String data = request.getParameter ("data");

      out.write (Admin.checkInvalidity (attribute, data));
    }
    else if (sourcePage.equals("login")){
      response.setContentType ("text/plain");
      String attribute = request.getParameter ("attribute");
      String data = request.getParameter ("data");

      out.write (Customer.checkInvalidity (attribute, data));
    }
    else if (sourcePage.equals("productmanagement")){
      response.setContentType ("application/json");
      String Type = request.getParameter ("Type");
      String Pro_id = request.getParameter ("ID");

      HashMap<String, String> ProductDetail = new HashMap<String, String>();
      Admin.fetchProductDetail (Type, Pro_id, ProductDetail);
      out.write (new Gson().toJson (ProductDetail));
    }
    else if (sourcePage.equals("productlist")){
      response.setContentType ("text/plain");
      String Type = request.getParameter ("Type");

      PreparedStatement ps;
      ResultSet rs;
      Connection con = new Database().connect();
      int count = 0;

      try{
        ps = con.prepareStatement ("SELECT Pro_id, ProName, BaseQty, BaseUnit, BasePrice, ProImage FROM Product WHERE Type = ?");
        ps.setString (1, Type);
        rs = ps.executeQuery();

        out.print ("<div class='row'>");
        while (rs.next()){
          String ProName = rs.getString("ProName");
          int i = ProName.indexOf('(');
          if (i != -1)
            ProName = ProName.substring (0, i).trim();
          
          out.print ("<div class='col s12 m4'>");
          out.print ("<a href='product.jsp?product="+Type+Integer.toString(rs.getInt("Pro_id"))+"'>");
          out.print ("<div class='card hoverable'>");
          out.print ("<div class='card-image'>");
          out.print ("<img src='"+rs.getString("ProImage")+"'>");
          out.print ("<span class='card-title'>"+ProName+"</span>");
          out.print ("<a href='cart.jsp' class='btn-floating btn-large tooltipped halfway-fab waves-effect waves-light teal' data-position='bottom' data-delay='50' data-tooltip='Add to cart'><i id='"+Type+Integer.toString(rs.getInt("Pro_id"))+"' class='large material-icons'>add_shopping_cart</i></a>");
          out.print ("</div>");
          out.print ("<div class='card-content'>");
          out.print ("<p class='price'>Rs. "+Integer.toString(rs.getInt("BasePrice"))+"</p>");
          out.print ("</div>");
          out.print ("</div>");
          out.print ("</a>");
          out.print ("</div>");

          count++;
          if (count == 3){
            out.print ("</div>");
            out.print ("<div class='row'>");
            count = 0;
          }
        }
        out.print ("</div>");
      }
      catch (SQLException e){
        e.printStackTrace();
      }
    }
    else if (sourcePage.equals("review")){
      response.setContentType ("text/plain");
      HttpSession session = request.getSession();

      String title = request.getParameter ("title");
      String comment = request.getParameter ("comment");
      String ratingS = request.getParameter ("rating");
      int rating = Integer.parseInt (ratingS);
      int j = 0;

      String Pro_idS = request.getParameter ("Pro_id");
      int Pro_id = Integer.parseInt (Pro_idS);

      String loggedInIDS = (String)session.getAttribute ("loggedInID");
      int loggedInID = Integer.parseInt (loggedInIDS);

      if (loggedInID != 0)
        j = Customer.setReview (title, comment, rating, Pro_id, loggedInID);

      if (j == 1)
        out.write("true");
      else
        out.write ("false");
    }
    else if (sourcePage.equals("cart")){
      response.setContentType ("text/plain");
      HttpSession session = request.getSession();

      String Pro_idS = request.getParameter ("Pro_id");
      int Pro_id = Integer.parseInt (Pro_idS);
      String Cust_idS = request.getParameter ("Cust_id");
      int Cust_id = Integer.parseInt (Cust_idS);
      String opTyp = request.getParameter ("opTyp");
      String QtyS = request.getParameter ("Qty");
      int Qty = Integer.parseInt (QtyS);
      String OrderLimitS = request.getParameter ("OrderLimit");
      int OrderLimit = Integer.parseInt (OrderLimitS);

      String returnValue = "";

      if (Cust_id != 0){
        if (opTyp.equals("add")){
          Cart.updateCart (Cust_id, Pro_id, 1);
          returnValue = Cart.obtainForCart (Pro_id, Qty+1);
          out.write (returnValue);
        }
        else if (opTyp.equals("sub")){
          Cart.updateCart (Cust_id, Pro_id, -1);
          returnValue = Cart.obtainForCart (Pro_id, Qty-1);
          out.write (returnValue);
        }
        else if (opTyp.equals("del")){
          Cart.deleteProduct (Cust_id, Pro_id);
          out.write ("");
        }
      }
      else{
        String anonymousCart = (String)session.getAttribute ("anonymousCart");

        if (opTyp.equals("add")){
          int QtyNew = Qty + 1;
          anonymousCart = anonymousCart.replace (Pro_id+"-"+Qty+"-"+OrderLimit, Pro_id+"-"+QtyNew+"-"+OrderLimit);
          session.setAttribute ("anonymousCart", anonymousCart);
          returnValue = Cart.obtainForCart (Pro_id, QtyNew);
          out.write (returnValue);
        }
        else if (opTyp.equals("sub")){
          int QtyNew = Qty - 1;
          anonymousCart = anonymousCart.replace (Pro_id+"-"+Qty+"-"+OrderLimit, Pro_id+"-"+QtyNew+"-"+OrderLimit);
          session.setAttribute ("anonymousCart", anonymousCart);
          returnValue = Cart.obtainForCart (Pro_id, QtyNew);
          out.write (returnValue);
        }
        else if (opTyp.equals("del")){
          anonymousCart = anonymousCart.replace (Pro_id+"-"+Qty+"-"+OrderLimit+",", "");
          if (anonymousCart.equals(""))
            session.removeAttribute ("anonymousCart");
          else
            session.setAttribute ("anonymousCart", anonymousCart);
          out.write ("");
        }
      }
    }
    else if (sourcePage.equals("profile_personal")){
      response.setContentType ("text/plain");
      String attribute = request.getParameter ("attribute");
      String data = request.getParameter ("data");
      String Cust_idS = request.getParameter ("Cust_id");
      int Cust_id = Integer.parseInt (Cust_idS);

      out.write (Customer.checkDuplication (attribute, data, Cust_id));
    }
    else if (sourcePage.equals("profile_password")){
      response.setContentType ("text/plain");
      String attribute = request.getParameter ("attribute");
      String data = request.getParameter ("data");
      String Cust_idS = request.getParameter ("Cust_id");
      int Cust_id = Integer.parseInt (Cust_idS);

      out.write (Customer.checkPassword (data, Cust_id));
    }
  }
}