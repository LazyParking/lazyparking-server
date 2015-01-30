/*
IO Boxes module
 */
require([
  '/socket.io/socket.io.js',
  'jquery',
], function(io, $) {
  var socket = io();

  var panelClasses = {
    "half" : "panel-warning",
    "full" : "panel-danger",
    "empty": "panel-success"
  };

  // update count on box update
  socket.on('sector count', function(data) {
    var $panel  = $('#sector-dashboard [data-id="' + data._id + '"]');
    var $status = $panel.find('[data-binding="status"]');

    // update panel class
    $panel
      .removeClass('panel-warning', 'panel-danger', 'panel-success')
      .addClass(panelClasses[data.status]);

    // update available counter
    $status
      .removeClass('full', 'half', 'empty')
      .addClass(data.status)
      .text(data.available);
  });
});
