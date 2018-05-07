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

import com.google.gson.Gson;

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
  }
}