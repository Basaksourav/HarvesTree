$(document).ready(function(){
  $(".button-collapse").sideNav();
  $('.modal').modal();
})

function showProducts (){
  var proTyp = this.id;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "productlist",
      Type: proTyp
    },
    function(ProductDetail){
      $("#product-list-id").html(ProductDetail);
    }
  );
}
