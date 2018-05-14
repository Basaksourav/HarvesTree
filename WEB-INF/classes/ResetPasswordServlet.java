package servletPackage;

import java.io.PrintWriter;
import java.io.IOException;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javaPackage.Customer;

@WebServlet("/Web-Content/ResetPasswordServlet")

public class ResetPasswordServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");

    HttpSession session = request.getSession();

    //receive all the field values of signup form (before pay-method section)
    String Cust_idS = request.getParameter ("cust_id_name");
    int cust_id = Integer.parseInt (Cust_idS);
    String newPasswd = request.getParameter ("new_passwd");

    int status = Customer.updatePassword (cust_id, newPasswd);

    session.setAttribute ("isCustomerLoggedIn", "false");
    session.removeAttribute ("loggedInID");
    session.removeAttribute ("loggedInName");

    response.sendRedirect ("/Harvestree/Web-Content/index.jsp");
  }
}