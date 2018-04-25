package servletPackage;

import java.io.PrintWriter;
import java.io.IOException;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javaPackage.Admin;

@WebServlet("/Web-Content/AdminLoginServlet")

public class AdminLoginServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");
    HttpSession session = request.getSession();

    //receive field values of adminlogin form
    String uname = request.getParameter ("uname");
    String passwd = request.getParameter ("passwd");

    boolean adminLogin = false;

    session.setAttribute ("unameErrMsg", "");
    session.setAttribute ("passwdErrMsg", "");
    session.setAttribute ("uname", uname);
    session.setAttribute ("passwd", "");

    //If username is blank
    if (uname.equals(""))
      session.setAttribute ("unameErrMsg", " Blank");
    //If username is not blank but invalid
    else if ("true".equals(Admin.checkInvalidity("uname", uname)))
      session.setAttribute ("unameErrMsg", " Doesn't Exist");
    //If username is valid and password is blank
    else if (passwd.equals(""))
      session.setAttribute ("passwdErrMsg", " Blank");
    //If username is valid and password is not blank but invalid
    else if ("true".equals(Admin.checkInvalidity("uname,passwd", uname+","+passwd))){
      session.setAttribute ("passwdErrMsg", " Incorrect");
      session.setAttribute ("passwd", passwd);    //Only if password is invalid, retain password value in the field
    }
    //Both username and password are not blank and they are valid
    else{
      session.setAttribute ("isAdminLoggedIn", "true");

      //Take admin to product-management page
      response.sendRedirect ("/Harvestree/Web-Content/productmanagement.html");
      adminLogin = true;    //login is successful
    }

    //If login is unsuccessful
    if (!adminLogin){
      if (passwd.equals(""))
        session.setAttribute ("passwdErrMsg", " Blank");

      session.setAttribute ("isAdminLoginErr", "true");

      //Send admin back to the adminlogin page
      response.sendRedirect ("/Harvestree/Web-Content/adminlogin.jsp"); 
    }
  }
}