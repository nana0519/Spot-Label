/* global $*/

// リロードしないと動かなくなるため
document.addEventListener("turbolinks:load", function () {
  $(function(){
    $(".hm__trigger").on('click', function(event){
      $(this).toggleClass("active");
      $(".hm__nav").fadeToggle();
      event.preventDefault();
    });
  });
});