var Bounce = require('bounce.js');

$(document).ready( function () {

// qrcode
var qrnode = document.getElementById("qrcode")
var qrcode = new QRCode(document.getElementById("qrcode"), {

});
var url = $('#qrsource').text()
console.log(url);
qrcode.makeCode( url );

$('#qrcode img' ).attr('style', 'display: inline')

$('#apply').click(function () {

  var bounce = new Bounce()
  bounce.rotate( {
    from: 0,
    to: 45,
  }).scale({
    from: {x: 1, y: 1},
    to: {x: 2.0, y: 1.5}
  }).translate({
    from: {x: -0, y: 100},
    to: {x: 600, y: 200},
    duration: 3000
  })
  // bounce.applyTo($('#health'))
})
})
