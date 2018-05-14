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

@WebServlet("/Web-Content/EditProfileServlet")

public class EditProfileServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");

    //receive all the field values of signup form (before pay-method section)
    String Cust_idS = request.getParameter ("cust_id_name");
    int cust_id = Integer.parseInt (Cust_idS);
    String fname = request.getParameter ("fname");
    String mname = request.getParameter ("mname");
    String lname = request.getParameter ("lname");
    String email = request.getParameter ("email");
    String phnS = request.getParameter ("phn");
    long phn = Long.parseLong (phnS);
    String add_line1 = request.getParameter ("add_line1");
    String add_line2 = request.getParameter ("add_line2");
    String city = request.getParameter ("city");
    String state = request.getParameter ("state");
    String pinS = request.getParameter ("pin");
    int pin = Integer.parseInt (pinS);

    int status = Customer.updateCustomer (cust_id, fname, mname, lname, email, phn, add_line1, add_line2, city, state, pin);

    response.sendRedirect ("/Harvestree/Web-Content/profile_personal.jsp");
  }
}