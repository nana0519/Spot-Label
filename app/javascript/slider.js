/* global $*/
import $ from "jquery"
import "slick-carousel"

// リロードしないと動かなくなるため
document.addEventListener("turbolinks:load", function () {
  $('.slider').slick({
    arrows: true
  });
});
// キャッシュされる前にスライダーを元のDOMに戻す
document.addEventListener("turbolinks:before-cache",function (){
    $('.slider').slick('unslick');
});