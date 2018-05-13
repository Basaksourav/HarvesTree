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

@WebServlet("/Web-Content/LoginServlet")

public class LoginServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    HttpSession session = request.getSession();

    session.setAttribute ("isCustomerLoggedIn", "false");
    session.removeAttribute ("loggedInID");
    session.removeAttribute ("loggedInName");
    
    String source = request.getParameter ("source");

    if (source.equals("productlist.jsp")){
      String proTyp = request.getParameter ("type");
      response.sendRedirect ("/Harvestree/Web-Content/productlist.jsp?type=" + proTyp);
    }
    else if (source.equals("product.jsp")){
      String proTyp = request.getParameter ("product");
      response.sendRedirect ("/Harvestree/Web-Content/product.jsp?product=" + proTyp);
    }
    else
      response.sendRedirect ("/Harvestree/Web-Content/" + source);
  }

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");

    HttpSession session = request.getSession();

    String email = request.getParameter ("email");
    String passwd = request.getParameter ("passwd");
    String source = request.getParameter ("source");

    boolean login = true;

    if (email.equals(""))
      login = false;
    else{
      if ("true".equals(Customer.checkInvalidity("email",email)))
        login = false;
      else{
        if (passwd.equals(""))
          login = false;
        else if ("true".equals(Customer.checkInvalidity("email,passwd", email+","+passwd)))
          login = false;
      }
    }
    if (passwd.equals(""))
      login = false;

    if (login){
      String Cust_detail = Customer.doLogin (email);
      String[] Cust = Cust_detail.split (",");
      session.setAttribute ("isCustomerLoggedIn", "true");
      session.setAttribute ("loggedInID", Cust[0]);
      session.setAttribute ("loggedInName", Cust[1]);
    }

    if (source.equals("productlist.jsp")){
      String proTyp = request.getParameter ("type");
      response.sendRedirect ("/Harvestree/Web-Content/productlist.jsp?type=" + proTyp);
    }
    else if (source.equals("product.jsp")){
      String proTyp = request.getParameter ("product");
      response.sendRedirect ("/Harvestree/Web-Content/product.jsp?product=" + proTyp);
    }
    else
      response.sendRedirect ("/Harvestree/Web-Content/" + source);
  }
}