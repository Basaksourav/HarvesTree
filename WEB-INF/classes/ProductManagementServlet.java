package servletPackage;

import java.io.PrintWriter;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletContext;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;

import javaPackage.Admin;

@WebServlet("/Web-Content/ProductManagementServlet")

public class ProductManagementServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");
    HttpSession session = request.getSession();
    boolean adminLogout = false;

    String logout = request.getParameter ("logout");
    if ("true".equals (logout)){
      session.setAttribute ("isAdminLoggedIn", "false");
      response.sendRedirect ("/Harvestree/Web-Content/adminlogin.jsp");
      adminLogout = true;
    }

    if (!adminLogout){
      String Type = request.getParameter ("type");
      String Pro_id = request.getParameter ("proID");

      ServletContext context = getServletContext();
      String primaryPath = context.getRealPath ("/Web-Content");

      Admin.deleteProduct (Type, Pro_id, primaryPath);

      response.sendRedirect ("/Harvestree/Web-Content/productmanagement.jsp?type=" + Type);
    }
  }

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");

    ServletContext context = getServletContext();
    String primaryPath = context.getRealPath ("/Web-Content/assets");
    int status;

    MultipartRequest multiReq = new MultipartRequest (request, primaryPath);

    String product_name = multiReq.getParameter ("product_name");
    String product_img_name = multiReq.getParameter ("product_img_name");
    String qtyS = multiReq.getParameter ("qty");
    int qty = Integer.parseInt (qtyS);
    String unit = multiReq.getParameter ("unit");
    String priceS = multiReq.getParameter ("price");
    int price = Integer.parseInt (priceS);
    String wght = multiReq.getParameter ("wght");
    String qty2S = multiReq.getParameter ("qty2");
    float qty2 = Float.parseFloat (qty2S);
    String unit2 = multiReq.getParameter ("unit2");

    String desc = multiReq.getParameter ("desc");
    String nutri = multiReq.getParameter ("nutri");
    String shelf_life = multiReq.getParameter ("shelf_life");
    String storage = multiReq.getParameter ("storage");
    String disclaimer = multiReq.getParameter ("disclaimer");

    String hidden_info = multiReq.getParameter ("hidden_info");
    String[] info = hidden_info.split(" ");

    String secondaryPath = primaryPath + "/images/" + info[0];
    String finalPath = new String("");
    String relativePath = new String("");

    if (info[0].equals("flo"))
      nutri = new String("");

    if (!product_img_name.equals("")){
      finalPath = Admin.storeImage (primaryPath, secondaryPath, product_img_name, product_name);
      relativePath = finalPath.substring (finalPath.indexOf ("assets"));
    }

    if (info[1].equals ("add"))
      status = Admin.addProduct (info[0], product_name, qty, unit, price, wght, qty2, unit2, desc, nutri, shelf_life, storage, disclaimer, relativePath);
    else if (info[1].equals("edit"))
      status = Admin.editProduct (info[0], info[2], product_name, qty, unit, price, wght, qty2, unit2, desc, nutri, shelf_life, storage, disclaimer, relativePath, secondaryPath);

    response.sendRedirect ("/Harvestree/Web-Content/productmanagement.jsp?type=" + info[0]);
  }
}