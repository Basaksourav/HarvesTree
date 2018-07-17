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

@WebServlet("/Web-Content/SearchServlet")

public class SearchServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();

    String key = request.getParameter ("key");
    System.out.println (key);
    String results = new String("");

    PreparedStatement ps;
    ResultSet rs;
    Connection con = new Database().connect();

    try{
      if (key.length() < 3)
        ps = con.prepareStatement ("SELECT Pro_id, Type, ProName FROM Product WHERE ProName like '"+key+"%' Order By Type");
      else
        ps = con.prepareStatement ("SELECT Pro_id, Type, ProName FROM Product WHERE ProName like '%"+key+"%' Order By Type");

      rs = ps.executeQuery();

      while (rs.next()){
        int Pro_id = rs.getInt ("Pro_id");
        results += Pro_id + "-";
      }
    }
    catch (SQLException e){
      e.printStackTrace();
    }

    response.sendRedirect ("/Harvestree/Web-Content/search.jsp?results=" + results);
  }

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}
}