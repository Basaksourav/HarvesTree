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

@WebServlet("/Web-Content/SignupServlet")

public class SignupServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");
    HttpSession session = request.getSession();

    //receive all the field values of signup form (before pay-method section)
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
    String passwd = request.getParameter ("passwd");
    String pay_method = request.getParameter ("pay_method");

    String source = request.getParameter ("source");
    String proTyp = "", product = "";

    if (source.equals ("productlist.jsp"))
      proTyp = request.getParameter ("type");
    else if (source.equals ("product.jsp"))
      product = request.getParameter ("product");

    //receive all the field values of signup form (at pay-method section)
    String card_noS = "", monthS = "", yearS = "", cardHolder = "", bank_idS = "", wallet_idS = "", wallet_phnS = "";

    //dc-card
    if (pay_method.equals("Card")){

      //receive all the field values from dc-card section
      card_noS = request.getParameter ("card_no");
      monthS = request.getParameter ("month_list");
      yearS = request.getParameter ("year_list");
      cardHolder = request.getParameter ("cardholder");
    }
    //net-b
    else if (pay_method.equals("NetB")){

      //receive bank name
      bank_idS = request.getParameter ("bank_list");
    }
    //m-wallet
    else if (pay_method.equals("mWallet")){

      //receive all the field values from m-wallet section
      wallet_idS = request.getParameter ("wallet_list");
      wallet_phnS = request.getParameter ("wallet_phn");
    }

    //pass the customer details to store into the database and receive the status value
    int status = Customer.addCustomer (fname, mname, lname, email, phn, add_line1, add_line2, city, state, pin, passwd, pay_method);

    //if customer details are stored successfully
    if (status == 1){

      //dc-card
      if (pay_method.equals("Card")){

        //peform required data-type conversion
        long card_no = Long.parseLong (card_noS);
        int month = Integer.parseInt (monthS);
        int year = Integer.parseInt (yearS);

        //pass the dc-card details to store into database
        Customer.addCard (card_no, month, year, cardHolder, phn);
      }
      //net-b
      else if (pay_method.equals("NetB")){

        //peform required data-type conversion
        int bank_id = Integer.parseInt (bank_idS);

        //pass the bank name to store into database
        Customer.addNetB (bank_id, phn);
      }
      //m-wallet
      else if (pay_method.equals("mWallet")){

        //peform required data-type conversion
        int wallet_id = Integer.parseInt (wallet_idS);
        long wallet_phn = Long.parseLong (wallet_phnS);

        //pass the m-wallet details to store into database
        Customer.addmWallet (wallet_id, wallet_phn, phn);
      }
      System.out.println (source);
      //send user back to the source page
      if (source.equals ("productlist.jsp"))
        response.sendRedirect ("/Harvestree/Web-Content/productlist.jsp?type=" + proTyp);
      else if (source.equals ("product.jsp"))
        response.sendRedirect ("/Harvestree/Web-Content/product.jsp?product=" + product);
      else
        response.sendRedirect ("/Harvestree/Web-Content/" + source);
    }
    else{

      //pass the field values through session attributes to retain in the signup form
      session.setAttribute ("isSignUpErr", "true");

      session.setAttribute ("fname", fname);
      session.setAttribute ("mname", mname);
      session.setAttribute ("lname", lname);

      session.setAttribute ("email", email);
      session.setAttribute ("phn", phnS);

      session.setAttribute ("add_line1", add_line1);
      session.setAttribute ("add_line2", add_line2);
      session.setAttribute ("city", city);
      session.setAttribute ("state", state);
      session.setAttribute ("pin", pinS);

      if (status == -1){
        session.setAttribute ("emailErrMsg", " Already exists");
        session.setAttribute ("phnErrMsg", "");
      }
      else if (status == -2){
        session.setAttribute ("emailErrMsg", "");
        session.setAttribute ("phnErrMsg", " Already exists");
      }
      else{
        session.setAttribute ("emailErrMsg", " Already exists");
        session.setAttribute ("phnErrMsg", " Already exists");
      }

      session.setAttribute ("pay_method", pay_method);

      if (pay_method.equals("Card")){
        session.setAttribute ("card_no", card_noS);
        session.setAttribute ("month", monthS);
        session.setAttribute ("year", yearS);
        session.setAttribute ("cardholder", cardHolder);
      }
      else if (pay_method.equals("NetB")){
        session.setAttribute ("bank_id", bank_idS);
      }
      else if (pay_method.equals("mWallet")){
        session.setAttribute ("wallet_id", wallet_idS);
        session.setAttribute ("wallet_phn", wallet_phnS);
      }

      session.setAttribute ("submitBtnErrMsg", " Error");

      //send user back to the signup form
      if (source.equals ("productlist.jsp"))
        response.sendRedirect ("/Harvestree/Web-Content/signup.jsp?source=productlist.jsp&type=" + proTyp);
      else if (source.equals ("product.jsp"))
        response.sendRedirect ("/Harvestree/Web-Content/signup.jsp?source=product.jsp&product=" + product);
    }
  }
}