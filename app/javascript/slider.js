/* global $*/
import $ from "jquery"
import "slick-carousel"

// リロードしないと動かなくなるため
document.addEventListener("turbolinks:load", function () {
  $('.slider').slick({
    arrows: true
  });
});