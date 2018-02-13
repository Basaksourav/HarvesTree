package servletPackage;

import java.io.PrintWriter;
import java.io.IOException;

import javax.servlet.ServletException;

import javax.servlet.annotation.WebServlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javaPackage.Customer;

@WebServlet("/Web-Content/SignupServlet")

public class SignupServlet extends HttpServlet{
  protected void doGet (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{}

  protected void doPost (HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    PrintWriter out = response.getWriter();
    response.setContentType ("text/html");

    //receive all the field values of signup form
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

    //pass the customer details to store into the database and receive the status value
    int status = Customer.addCustomer (fname, mname, lname, email, phn, add_line1, add_line2, city, state, pin, passwd, pay_method);

    //if customer details are stored successfully
    if (status == 1){

      //dc-card
      if (pay_method.equals("dc-card-id")){

        //receive all the field values from dc-card section
        String card_noS = request.getParameter ("card_no");
        long card_no = Long.parseLong (card_noS);
        String monthS = request.getParameter ("month_list");
        int month = Integer.parseInt (monthS);
        String yearS = request.getParameter ("year_list");
        int year = Integer.parseInt (yearS);
        String cardHolder = request.getParameter ("cardholder");

        //pass the dc-card details to store into database
        Customer.addCard (card_no, month, year, cardHolder, phn);
      }
      //net-b
      else if (pay_method.equals("net-b-id")){

        //receive bank name
        String bank = request.getParameter ("bank_list");

        //pass the bank name to store into database
        Customer.addNetB (bank, phn);
      }
      //m-wallet
      else if (pay_method.equals("m-wallet-id")){

        //receive all the field values from m-wallet section
        String wallet = request.getParameter ("wallet_list");
        String wallet_phnS = request.getParameter ("wallet_phn");
        long wallet_phn = Long.parseLong (wallet_phnS);

        //pass the m-wallet details to store into database
        Customer.addmWallet (wallet, wallet_phn, phn);
      }
    }
  }
}