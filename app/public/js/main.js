// require.js configuration
require.config({
    shim : {
      'bootstrap' : { 'deps' :['jquery'] }
    },
    paths: {
      'jquery'   : '/lib/jquery/dist/jquery',
      'bootstrap': '/lib/bootstrap/dist/js/bootstrap'
    }
});

require([
  'jquery',
  'bootstrap',
  '/js/io-boxes.js'
], function($) {
  //do nothing
});
