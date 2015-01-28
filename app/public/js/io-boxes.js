/*
IO Boxes module
 */
require([
  '/socket.io/socket.io.js',
  'jquery',
  'moment'
], function(io, $, moment) {
  var socket = io();

  // update status on box update
  socket.on('box update', function(box) {
    var statusHtml = '<i class="glyphicon glyphicon-ok-circle text-success"></i>&nbsp;Livre';
    var $line = $('#box-list tr[data-id="' + box.id + '"][data-drone-id="' + box.droneId + '"]');

    $line.toggleClass('text-muted', box.occupied);

    if (box.occupied) {
      statusHtml = '<i class="glyphicon glyphicon-ban-circle"></i>&nbsp;Ocupado';
    }

    $line.find('[data-binding="occupied"]').html(statusHtml);
    $line.find('[data-binding="updated"]').html( moment(box.updated).format("DD/MM/YYYY hh:mm:ss") );
  });
});
