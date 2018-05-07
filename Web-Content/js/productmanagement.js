$(document).ready(function(){
  $('.modal').modal();
});
$(".button-collapse").sideNav();

var opTyp, proTyp, isUploaded = false, isReloaded = true, clickIDforModal = "blank-id";
proTyp = document.getElementById("hidden-info-id").value;

var product_name, product_img_file, product_img_name, qty, unit, price, wght, qty2, unit2;
var desc, nutri, shelf_life, storage, disclaimer;
var product_img_file_type, product_img_file_size;
var form_status;

var validUnit = /^(gm\.)|(kg\.)|(piece)$/;

// add field values of modal (for a particular product) to FireBase
function addToFireBase(){
  product_name = document.product_detail_form.product_name.value;
  product_img_name = document.product_detail_form.product_img_name.value;
  qty = document.product_detail_form.qty.value;
  unit = document.product_detail_form.unit.value;
  price = document.product_detail_form.price.value;
  wght = document.product_detail_form.wght.value;
  qty2 = document.product_detail_form.qty2.value;
  unit2 = document.product_detail_form.unit2.value;

  desc = document.product_detail_form.desc.value;
  nutri = document.product_detail_form.nutri.value;
  shelf_life = document.product_detail_form.shelf_life.value;
  storage = document.product_detail_form.storage.value;
  disclaimer = document.product_detail_form.disclaimer.value;
}

function setProductDetail (Pro_id){
  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "productmanagement",
      Type: proTyp,
      ID: Pro_id
    },
    function(ProductDetail){
      $("#product-name-id").val(ProductDetail.product_name);
      $("#product-img-name-id").val(ProductDetail.product_img_name);
      $("#qty-id").val(ProductDetail.qty);
      $("#unit-id").val(ProductDetail.unit);
      $("#price-id").val(ProductDetail.price);
      $("#wght-id").val(ProductDetail.wght);
      $("#qty2-id").val(ProductDetail.qty2);
      $("#unit2-id").val(ProductDetail.unit2);

      $("#desc-id").val(ProductDetail.desc);
      $("#nutri-id").val(ProductDetail.nutri);
      $("#shelf-life-id").val(ProductDetail.shelf_life);
      $("#storage-id").val(ProductDetail.storage);
      $("#disclaimer-id").val(ProductDetail.disclaimer);

      if (ProductDetail.wght != "")
        document.getElementById("wght-id").disabled = false;
    }
  );
}

function modalSetting(){
  if (this.id == "add-product-icon-id"){
    $("#modal-heading-id").text("Add Product");
    document.getElementById("hidden-info-id").value = proTyp + " add";
    opTyp = "add";
  }
  else{
    $("#modal-heading-id").text("Edit Product");
    document.getElementById("hidden-info-id").value = proTyp + " edit " + this.id;
    opTyp = "edit";
  }

  if (this.id != clickIDforModal){
    $("#product-img-file-id").val('');
    isUploaded = false;
    $("#product-name-err-id").html('');
    $("#product-img-name-err-id").html('');
    $("#qty-err-id").html('');
    $("#unit-err-id").html('');
    $("#price-err-id").html('');
    $("#wght-err-id").html('');
    $("#qty2-err-id").html('');
    $("#unit2-err-id").html('');

    $("#desc-err-id").html('');
    $("#nutri-err-id").html('');
    $("#shelf-life-err-id").html('');
    $("#storage-err-id").html('');
    $("#disclaimer-id").html('');
    document.getElementById("wght-id").disabled = true;

    if (opTyp == "add"){
      $("#product-name-id").val('');
      $("#product-img-name-id").val('');
      $("#qty-id").val('');
      $("#unit-id").val('');
      $("#price-id").val('');
      $("#wght-id").val('');
      $("#qty2-id").val('');
      $("#unit2-id").val('');

      $("#desc-id").val('');
      $("#nutri-id").val('');
      $("#shelf-life-id").val('');
      $("#storage-id").val('');
      $("#disclaimer-id").val('');

      document.getElementById("firebase-button-id").disabled = true;
    }
    else{
      setProductDetail (this.id);
      document.getElementById("firebase-button-id").disabled = false;
    }
  }
  clickIDforModal = this.id;
}

function validatorInstant(){

  if (this.id == "product-name-id"){
    product_name = document.getElementById(this.id).value;

    if (product_name == "")
      document.getElementById("product-name-err-id").innerHTML = " Blank";
    else
      document.getElementById("product-name-err-id").innerHTML = "";
  }
  else if (this.id == "qty-id"){
    qty = document.getElementById(this.id).value;

    if (qty == "")
      document.getElementById("qty-err-id").innerHTML = " Blank";
    else if (isNaN(qty))
      document.getElementById("qty-err-id").innerHTML = " Not numeric";
    else
      document.getElementById("qty-err-id").innerHTML = "";
  }
  else if (this.id == "unit-id"){
    unit =  document.getElementById(this.id).value;

    if (unit == "")
      document.getElementById("unit-err-id").innerHTML = " Blank";
    else if (!validUnit.test(unit))
      document.getElementById("unit-err-id").innerHTML = " Invalid";
    else{
      document.getElementById("unit-err-id").innerHTML = "";
      
      if (proTyp=="flo" && unit!="piece")
        document.getElementById("unit-err-id").innerHTML = " Invalid";
      
      if (unit=="piece" && proTyp!="flo"){
        document.getElementById("wght-id").disabled = false;
        wght = document.getElementById("wght-id").value;
        if (wght == "")
          document.getElementById("wght-err-id").innerHTML = " Blank";
      }
    }
    if (unit != "piece"){
      if (unit=="gm." || unit=="kg.")
        $("#wght-id").val('');
      document.getElementById("wght-id").disabled = true;
      document.getElementById("wght-err-id").innerHTML = "";
    }
  }
  else if (this.id == "price-id"){
    price = document.getElementById(this.id).value;

    if (price == "")
      document.getElementById("price-err-id").innerHTML = " Blank";
    else if (isNaN(price))
      document.getElementById("price-err-id").innerHTML = " Not numeric";
    else
      document.getElementById("price-err-id").innerHTML = "";
  }
  else if (this.id == "wght-id"){
    wght = document.getElementById(this.id).value;

    if (wght == "")
      document.getElementById("wght-err-id").innerHTML = " Blank";
    else
      document.getElementById("wght-err-id").innerHTML = "";
  }
  else if (this.id == "qty2-id"){
    qty2 = document.getElementById(this.id).value;

    if (qty2 == "")
      document.getElementById("qty2-err-id").innerHTML = " Blank";
    else if (isNaN(qty2))
      document.getElementById("qty2-err-id").innerHTML = " Not numeric";
    else{
      document.getElementById("qty2-err-id").innerHTML = "";
      qty = document.getElementById("qty-id").value;
      unit =  document.getElementById("unit-id").value;
      unit2 =  document.getElementById("unit2-id").value;
      if (unit == unit2){
        if (parseInt(qty) >= parseInt(qty2))
          document.getElementById("qty2-err-id").innerHTML = " Invalid";
        else
          document.getElementById("qty2-err-id").innerHTML = "";
      }
    }
  }
  else if (this.id == "unit2-id"){
    unit2 =  document.getElementById(this.id).value;

    if (unit2 == "")
      document.getElementById("unit2-err-id").innerHTML = " Blank";
    else if (!validUnit.test(unit2))
      document.getElementById("unit2-err-id").innerHTML = " Invalid";
    else{
      document.getElementById("unit2-err-id").innerHTML = "";
      
      if (proTyp=="flo"){
        if (unit2!="piece")
          document.getElementById("unit2-err-id").innerHTML = " Invalid";
        else
          document.getElementById("unit2-err-id").innerHTML = "";
      }

      if (unit=="piece"){
        if (unit2!="piece")
          document.getElementById("unit2-err-id").innerHTML = " Invalid";
        else
          document.getElementById("unit2-err-id").innerHTML = "";
      }
      if (unit=="kg."){
        if (unit2!="kg.")
          document.getElementById("unit2-err-id").innerHTML = " Invalid";
        else
          document.getElementById("unit2-err-id").innerHTML = "";
      }
      if (unit=="gm."){
        if (unit2=="piece")
          document.getElementById("unit2-err-id").innerHTML = " Invalid";
        else
          document.getElementById("unit2-err-id").innerHTML = "";
      }
    }
  }
  else if (this.id == "desc-id"){
    desc = document.getElementById(this.id).value;

    if (desc == "")
      document.getElementById("desc-err-id").innerHTML = " Blank";
    else
      document.getElementById("desc-err-id").innerHTML = "";
  }
  else if (this.id == "nutri-id"){
    nutri = document.getElementById(this.id).value;

    if (nutri == "")
      document.getElementById("nutri-err-id").innerHTML = " Blank";
    else
      document.getElementById("nutri-err-id").innerHTML = "";
  }
  else if (this.id == "shelf-life-id"){
    shelf_life = document.getElementById(this.id).value;

    if (shelf_life == "")
      document.getElementById("shelf-life-err-id").innerHTML = " Blank";
    else
      document.getElementById("shelf-life-err-id").innerHTML = "";
  }
  else if (this.id == "storage-id"){
    storage = document.getElementById(this.id).value;

    if (storage == "")
      document.getElementById("storage-err-id").innerHTML = " Blank";
    else
      document.getElementById("storage-err-id").innerHTML = "";
  }
  else if (this.id == "disclaimer-id"){
    disclaimer = document.getElementById(this.id).value;

    if (disclaimer == "")
      document.getElementById("disclaimer-err-id").innerHTML = " Blank";
    else
      document.getElementById("disclaimer-err-id").innerHTML = "";
  }
}

function fileUpload(){
  product_img_file = document.product_detail_form.product_img_file.files[0];
  product_img_name = document.product_detail_form.product_img_name.value;

  if (product_img_name != ""){
    document.getElementById("product-img-name-err-id").innerHTML = "";
    isUploaded = true;

    product_img_file_type = product_img_file.type;
    product_img_file_size = product_img_file.size;

    if (product_img_file_type.indexOf("image")==-1 && product_img_file_size>=1000000)
      document.getElementById("product-img-name-err-id").innerHTML = " Invalid file & Too large";
    else if (product_img_file_type.indexOf("image") == -1)
      document.getElementById("product-img-name-err-id").innerHTML = " Invalid file";
    else if (product_img_file_size >= 1000000)
      document.getElementById("product-img-name-err-id").innerHTML += " Too large";
    else
      document.getElementById("product-img-name-err-id").innerHTML = "";
  }
  else{
    if (opTyp == "add")
      document.getElementById("product-img-name-err-id").innerHTML = " Not uploaded";
    isUploaded = false;
  }
}

function validatorSubmit(){
  product_name = document.product_detail_form.product_name.value;
  product_img_file = document.product_detail_form.product_img_file.files[0];
  product_img_name = document.product_detail_form.product_img_name.value;
  qty = document.product_detail_form.qty.value;
  unit = document.product_detail_form.unit.value;
  price = document.product_detail_form.price.value;
  wght = document.product_detail_form.wght.value;
  qty2 = document.product_detail_form.qty2.value;
  unit2 = document.product_detail_form.unit2.value;

  desc = document.product_detail_form.desc.value;
  nutri = document.product_detail_form.nutri.value;
  shelf_life = document.product_detail_form.shelf_life.value;
  storage = document.product_detail_form.storage.value;
  disclaimer = document.product_detail_form.disclaimer.value;

  form_status = true;

  if (product_name == ""){
    document.getElementById("product-name-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("product-name-err-id").innerHTML = "";

  if (isUploaded){
    document.getElementById("product-img-name-err-id").innerHTML = "";
    product_img_file_type = product_img_file.type;
    product_img_file_size = product_img_file.size;

    if (product_img_file_type.indexOf("image")==-1 && product_img_file_size>=1000000){
      document.getElementById("product-img-name-err-id").innerHTML = " Invalid file & Too large";
      form_status = false;
    }
    else if (product_img_file_type.indexOf("image") == -1){
      document.getElementById("product-img-name-err-id").innerHTML = " Invalid file";
      form_status = false;
    }
    else if (product_img_file_size >= 1000000){
      document.getElementById("product-img-name-err-id").innerHTML += " Too large";
      form_status = false;
    }
    else
      document.getElementById("product-img-name-err-id").innerHTML = "";
  }
  else if (opTyp == "add"){
    document.getElementById("product-img-name-err-id").innerHTML = " Not uploaded";
    form_status = false;
  }

  if (qty == ""){
    document.getElementById("qty-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if (isNaN(qty)){
    document.getElementById("qty-err-id").innerHTML = " Not numeric";
    form_status = false;
  }
  else
    document.getElementById("qty-err-id").innerHTML = "";

  if (unit == ""){
    document.getElementById("unit-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if (!validUnit.test(unit)){
    document.getElementById("unit-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else{
    document.getElementById("unit-err-id").innerHTML = "";

    if (qty != "" && !isNaN(qty)){
      if (unit == "gm."){
        if (parseInt(qty)>=25 && parseInt(qty)<=500 && qty.indexOf(".")==-1)
          document.getElementById("qty-err-id").innerHTML = "";
        else{
          document.getElementById("qty-err-id").innerHTML = " Invalid with chosen unit";
          form_status = false;
        }
      }
      else{
        if (parseInt(qty)>=1 && parseInt(qty)<=6 && qty.indexOf(".")==-1)
          document.getElementById("qty-err-id").innerHTML = "";
        else{
          document.getElementById("qty-err-id").innerHTML = " Invalid with chosen unit";
          form_status = false;
        }
      }
    }

    if (proTyp=="flo" && unit!="piece"){
      document.getElementById("unit-err-id").innerHTML = " Invalid";
      form_status = false;
    }
  }

  if (price == ""){
    document.getElementById("price-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if (isNaN(price)){
    document.getElementById("price-err-id").innerHTML = " Not numeric";
    form_status = false;
  }
  else
    document.getElementById("price-err-id").innerHTML = "";

  if (document.getElementById("wght-id").disabled == false){
    if (wght == ""){
      document.getElementById("wght-err-id").innerHTML = " Blank";
      form_status = false;
    }
    else
      document.getElementById("wght-err-id").innerHTML = "";
  }

  if (qty2 == ""){
    document.getElementById("qty2-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if (isNaN(qty2)){
    document.getElementById("qty2-err-id").innerHTML = " Not numeric";
    form_status = false;
  }
  else{
    document.getElementById("qty2-err-id").innerHTML = "";
    if (unit == unit2){
      if (parseInt(qty) >= parseInt(qty2)){
        document.getElementById("qty2-err-id").innerHTML = " Invalid";
        form_status = false;
      }
      else
        document.getElementById("qty2-err-id").innerHTML = "";
    }
  }

  if (unit2 == ""){
    document.getElementById("unit2-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else if (!validUnit.test(unit2)){
    document.getElementById("unit2-err-id").innerHTML = " Invalid";
    form_status = false;
  }
  else{
    document.getElementById("unit2-err-id").innerHTML = "";
    
    if (proTyp=="flo"){
      if (unit2!="piece"){
        document.getElementById("unit2-err-id").innerHTML = " Invalid";
        form_status = false;
      }
      else
        document.getElementById("unit2-err-id").innerHTML = "";
    }

    if (unit=="piece"){
      if (unit2!="piece"){
        document.getElementById("unit2-err-id").innerHTML = " Invalid";
        form_status = false;
      }
      else
        document.getElementById("unit2-err-id").innerHTML = "";
    }
    if (unit=="kg."){
      if (unit2!="kg."){
        document.getElementById("unit2-err-id").innerHTML = " Invalid";
        form_status = false;
      }
      else
        document.getElementById("unit2-err-id").innerHTML = "";
    }
    if (unit=="gm."){
      if (unit2=="piece"){
        document.getElementById("unit2-err-id").innerHTML = " Invalid";
        form_status = false;
      }
      else
        document.getElementById("unit2-err-id").innerHTML = "";
    }
  }

  if (desc == ""){
    document.getElementById("desc-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("desc-err-id").innerHTML = "";

  if (proTyp != "flo"){
    if (nutri == ""){
      document.getElementById("nutri-err-id").innerHTML = " Blank";
      form_status = false;
    }
    else
      document.getElementById("nutri-err-id").innerHTML = "";
  }

  if (shelf_life == ""){
    document.getElementById("shelf-life-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("shelf-life-err-id").innerHTML = "";

  if (storage == ""){
    document.getElementById("storage-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("storage-err-id").innerHTML = "";

  if (disclaimer == ""){
    document.getElementById("disclaimer-err-id").innerHTML = " Blank";
    form_status = false;
  }
  else
    document.getElementById("disclaimer-err-id").innerHTML = "";

  if (form_status && !isUploaded)
    $("#product-img-name-id").val('');

  return form_status;
}