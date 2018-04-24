$( document ).ready(function(){
  $(".button-collapse").sideNav();
  $(".dropdown-button").dropdown();
});

var star = document.getElementsByClassName("rating-star");

for(i = 0 ; i < star.length ; i++){
  star[i].addEventListener("mouseover", applyColor);
  star[i].addEventListener("mouseout", removeColor);
  star[i].addEventListener("click", getRating);
}

function applyColor(){
  var num = this.id.substring(5,6);

  for(i = 0 ; i < num ; i++){
    star[i].style.color = "orange";
  }
}

function removeColor(){
  var i = document.getElementById("fb-rating-id").value;

  for( ; i < star.length ; i++){
    star[i].style.color = "lightgrey";
  }
}

function getRating(){
  var num = this.id.substring(5,6);
  document.getElementById('fb-rating-id').value = num;
  removeColor();
}
