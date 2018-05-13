$( document ).ready(function(){
  $(".button-collapse").sideNav();
  $(".dropdown-button").dropdown();
  $('.modal').modal();
});

var star = document.getElementsByClassName("rating-star");
var title, comment, desc;

if (document.getElementById("title-id").disabled == false){
  var i = document.getElementById("rating-id").value - 1;
  for ( ; i >= 0 ; i--)
    star[i].style.color = "orange";
}

for(i = 0 ; i < star.length ; i++){
  if (document.getElementById("title-id").disabled == false){
    star[i].addEventListener("mouseover", applyColor);
    star[i].addEventListener("mouseout", removeColor);
    star[i].addEventListener("click", getRating);
  }
  else
    star[i].style.cursor = "default";
}

function applyColor(){
  var num = this.id.substring(5,6);

  for(i = 0 ; i < num ; i++){
    star[i].style.color = "orange";
  }
}

function removeColor(){
  var i = document.getElementById("rating-id").value;

  for( ; i < star.length ; i++){
    star[i].style.color = "lightgrey";
  }
}

function getRating(){
  var num = this.id.substring(5,6);
  document.getElementById('rating-id').value = num;
  removeColor();
}

function setReview(Pro_id){
  var returnValue = false;

  $.ajaxSetup({
    async:false
  });

  $.post(
    "AjaxServlet",
    {
      sourcePage: "review",
      Pro_id: Pro_id,
      title: title,
      comment: comment,
      rating: rating
    },
    function(data){
      if(data == "true")
        returnValue = true;
      else
        returnValue = false;
    }
  );
  return returnValue;
}

function getReview(){
  title = document.getElementById("title-id").value;
  comment = document.getElementById("comment-id").value;
  rating = document.getElementById("rating-id").value;
  var sendStatus = true, returnStatus = false;

  if (parseInt(rating) == 0){
    document.getElementById("rating-err-id").innerHTML = " Rating not given";
    sendStatus = false;
  }
  else
    document.getElementById("rating-err-id").innerHTML = "";

  if (comment!="" && title==""){
    document.getElementById("title-err-id").innerHTML = " Title not given";
    sendStatus = false;
  }
  else
    document.getElementById("title-err-id").innerHTML = "";
  
  if (comment=="" && title!=""){
    document.getElementById("comment-err-id").innerHTML = " Description not given";
    sendStatus = false;
  }
  else
    document.getElementById("comment-err-id").innerHTML = "";

  if (sendStatus == true)
    returnStatus = setReview(this.id);
}