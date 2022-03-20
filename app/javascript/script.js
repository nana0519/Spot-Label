/* global $*/
$(function(){
  $(".hm__trigger").on('click', function(event){
    $(this).toggleClass("active");
    $(".hm__nav").fadeToggle();
    event.preventDefault();
  });
});