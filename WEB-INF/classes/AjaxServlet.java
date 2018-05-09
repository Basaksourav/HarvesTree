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
          out.print ("<div class='card'>");
          out.print ("<div class='card-image'>");
          out.print ("<img src='"+rs.getString("ProImage")+"'>");
          out.print ("<span class='card-title'>"+ProName+"</span>");
          out.print ("<a href='cart.jsp' class='btn-floating btn-large tooltipped halfway-fab waves-effect waves-light red' data-position='bottom' data-delay='50' data-tooltip='Add to cart'><i id='"+Type+Integer.toString(rs.getInt("Pro_id"))+"' class='large material-icons'>add_shopping_cart</i></a>");
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
  }
}