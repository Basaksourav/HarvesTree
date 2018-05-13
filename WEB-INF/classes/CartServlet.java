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

@WebServlet("/Web-Content/CartServlet")

public class CartServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    HttpSession session = request.getSession();

    String loggedInIDS = (String)session.getAttribute ("loggedInID");
    int loggedInID = Integer.parseInt (loggedInIDS);

    String source = request.getParameter ("source");
    String Pro_idS = request.getParameter ("Pro_id");
    int Pro_id = Integer.parseInt (Pro_idS);

    String op = request.getParameter ("op");

    if (op.equals("add")){
      String OrderLimitS = request.getParameter ("OrderLimit");
      int OrderLimit = Integer.parseInt (OrderLimitS);

      if (loggedInID == 0){
        String anonymousCart = (String)session.getAttribute ("anonymousCart");
        String qtyS;
        int qty = 1;

        System.out.println (anonymousCart);

        if (anonymousCart == null)
          anonymousCart = Pro_idS+"-1-"+OrderLimitS+",";
        else{
          int indx = anonymousCart.indexOf(","+Pro_idS+"-");
          if (indx != -1){
            qtyS = anonymousCart.substring (indx+Pro_idS.length()+2, anonymousCart.indexOf("-",indx+Pro_idS.length()+2));
            int len = qtyS.length();
            qty = Integer.parseInt (qtyS) + 1;
            qtyS = Integer.toString (qty);
            StringBuffer sb = new StringBuffer (anonymousCart);
            sb.replace (indx+Pro_idS.length()+2, indx+Pro_idS.length()+2+len, qtyS);
            anonymousCart = sb.toString();
          }
          else{
            indx = anonymousCart.indexOf(Pro_idS+"-");
            if (indx == 0){
              qtyS = anonymousCart.substring (Pro_idS.length()+1, anonymousCart.indexOf("-",Pro_idS.length()+1));
              int len = qtyS.length();
              qty = Integer.parseInt (qtyS) + 1;
              qtyS = Integer.toString (qty);
              StringBuffer sb = new StringBuffer (anonymousCart);
              sb.replace (Pro_idS.length()+1, Pro_idS.length()+1+len, qtyS);
              anonymousCart = sb.toString();
            }
            else{
              qtyS = Integer.toString (qty);
              anonymousCart += Pro_idS+"-1-"+OrderLimitS+",";    
            }
          }
        }
        int change = -1;
        //Cart.updateProductInDB (Pro_id, change);
        System.out.println (anonymousCart);
        session.setAttribute ("anonymousCart", anonymousCart);
        //session.removeAttribute ("anonymousCart");
      }
      else
        Cart.addProduct (loggedInID, Pro_id, OrderLimit);
    }
    else{
      if (loggedInID == 0){
        String anonymousCart = (String)session.getAttribute ("anonymousCart");
        String qtyS;
        int qty = 1;

        if (anonymousCart != null){
          int indx = anonymousCart.indexOf(","+Pro_idS+"-");
          System.out.println ("comma-id index = " + indx);
          if (indx != -1){
            qtyS = anonymousCart.substring (indx+Pro_idS.length()+2, anonymousCart.indexOf("-",indx+Pro_idS.length()+2));
            qty = Integer.parseInt (qtyS);
            StringBuffer sb = new StringBuffer (anonymousCart);
            sb.replace (indx, anonymousCart.indexOf(",", indx+1), "");
            anonymousCart = sb.toString();
          }
          else{
            indx = anonymousCart.indexOf(Pro_idS+"-");
            System.out.println ("start-id index = " + indx);
            if (indx == 0){
              qtyS = anonymousCart.substring (Pro_idS.length()+1, anonymousCart.indexOf("-",Pro_idS.length()+1));
              qty = Integer.parseInt (qtyS);
              StringBuffer sb = new StringBuffer (anonymousCart);
              sb.replace (0, anonymousCart.indexOf(",")+1, "");
              anonymousCart = sb.toString();
            }
          }
          int change = qty;
          //Cart.updateProductInDB (Pro_id, change);
          System.out.println (anonymousCart);
          if (anonymousCart.equals(""))
            session.removeAttribute ("anonymousCart");
          else
            session.setAttribute ("anonymousCart", anonymousCart);
        }
      }
      else
        Cart.deleteProduct (loggedInID, Pro_id);
    }

    // response.setHeader("Cache-Control", "private, no-store, no-cache, must-revalidate");
    // response.setHeader("Pragma", "no-cache");

    if (source.equals("productlist.jsp")){
      String proTyp = request.getParameter ("type");
      System.out.println (proTyp);
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