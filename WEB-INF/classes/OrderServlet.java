package servletPackage;

import java.io.PrintWriter;
import java.io.IOException;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import javaPackage.Cart;

@WebServlet("/Web-Content/OrderServlet")

public class OrderServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    HttpSession session = request.getSession();

    String loggedInIDS = (String)session.getAttribute ("loggedInID");
    int loggedInID = Integer.parseInt (loggedInIDS);

    String amountS = request.getParameter ("amount");
    int amount = Integer.parseInt (amountS);

    Cart.placeOrder (loggedInID, amount);

    response.sendRedirect ("/Harvestree/Web-Content/order.jsp");
  }
}