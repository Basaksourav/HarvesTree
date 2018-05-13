$(document).ready(function(){
  $(".button-collapse").sideNav();
  $('.modal').modal();
})

var totalPrice = 0;
var deliveryCharge = 0;
var amountPayable = 0;

function operation (Pro_id, Cust_id, opTyp, Qty, OrderLimit){
  var returnValue;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "cart",
      Pro_id: Pro_id,
      Cust_id: Cust_id,
      opTyp: opTyp,
      Qty: Qty,
      OrderLimit: OrderLimit
    },
    function(data){
      returnValue = data;
    }
  );

  return returnValue;
}

function calculateTotalPrice(){
  var isCartEmpty = document.getElementById ("cart-status").value;
  var cartCount = document.getElementById ("cart-count").value;

  if (cartCount > 1)
    document.getElementById ("count-items-id").innerHTML = "Price (" + cartCount + " items)";
  else
    document.getElementById ("count-items-id").innerHTML = "Price (" + cartCount + " item)";

  if (isCartEmpty == "false"){
    totalPrice = 0;
    var prices = document.getElementsByClassName ("price");

    for (i = 0; i < prices.length; i++){
      var wholeString = prices[i].innerHTML;
      totalPrice += parseInt (wholeString.substring(2,wholeString.indexOf(" <")));
    }

    document.getElementById ('total-price-id').innerHTML = "&#8377; " + totalPrice;

    if (totalPrice < 500 && totalPrice > 0)
      deliveryCharge = 30;
    else
      deliveryCharge = 0;

    document.getElementById ('delivery-charge-id').innerHTML = "&#8377; " +deliveryCharge;

    amountPayable = totalPrice + deliveryCharge;
    document.getElementById ('amount-payable-id').innerHTML = "&#8377; " + amountPayable;
  }
}

function calledOnLoad(){
  calculateTotalPrice();

  var isCartEmpty = document.getElementById ("cart-status").value;

  if (isCartEmpty == "false"){
    var counters = document.getElementsByClassName ("counters");
    var Pro_id, inCart, OrderLimit;

    for (i = 0; i < counters.length; i++){
      Pro_id = counters[i].id.substring(3);
      inCart = document.getElementById ("qty"+Pro_id).innerHTML;
      inCart = parseInt(inCart);
      OrderLimit = document.getElementById ("limit"+Pro_id).value;

      if (counters[i].id.indexOf("add")==0 && inCart<OrderLimit)
        enable (counters[i]);
      else if (counters[i].id.indexOf("sub")==0 && inCart>1)
        enable (counters[i]);
      else
        disable (counters[i]);
    }
  }
}

function disable (element){
  element.style.cursor = "default";
  element.classList.remove('orange-text');
  element.classList.add('grey-text');
  element.removeEventListener("click", perform);
}

function enable (element){
  element.style.cursor = "pointer";
  element.classList.remove('grey-text');
  element.classList.add('orange-text');
  element.addEventListener("click", perform);
}

function perform(){
  var button = this.id;
  var loggedInID = document.getElementById ("hidden-logged-in-id").value;
  var Pro_id = button.substring(3);
  var inCart = document.getElementById ("qty"+Pro_id).innerHTML;
  var OrderLimit = document.getElementById ("limit"+Pro_id).value;

  var resultPriceQty = "";

  if (button.indexOf("add") == 0){
    var resultPriceQty = operation (Pro_id, loggedInID, "add", inCart, OrderLimit);
    var results = resultPriceQty.split("-");
    inCart = parseInt(inCart) + 1;
    document.getElementById ("qty"+Pro_id).innerHTML = inCart;
    document.getElementById ("price"+Pro_id).innerHTML = "&#8377; " + results[0] + " <span class='text-muted'>for " + results[1] + " " + results[2] + "</span>";

    if (inCart == OrderLimit)
      disable (this);
    if (inCart > 1)
      enable (document.getElementById("sub"+Pro_id));
  }
  else if (button.indexOf("sub") == 0){
    var resultPriceQty = operation (Pro_id, loggedInID, "sub", inCart, OrderLimit);
    var results = resultPriceQty.split("-");
    inCart = parseInt(inCart) - 1;
    document.getElementById ("qty"+Pro_id).innerHTML = inCart;
    document.getElementById ("price"+Pro_id).innerHTML = "&#8377; " + results[0] + " <span class='text-muted'>for " + results[1] + " " + results[2] + "</span>";

    if (inCart == 1)
      disable (this);
    if (inCart < OrderLimit)
      enable (document.getElementById("add"+Pro_id));
  }
  else if (button.indexOf("del") == 0){
    var returnValue = operation (Pro_id, loggedInID, "del", inCart, OrderLimit);
    //document.getElementById ("row"+Pro_id).innerHTML = "";
    window.location.reload(true);
  }
  calculateTotalPrice();
}