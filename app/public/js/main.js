// require.js configuration
require.config({
    config: {
      moment: {
        noGlobal: true
      }
    },
    shim : {
      'bootstrap' : { 'deps' :['jquery'] }
    },
    paths: {
      'jquery'   : '/lib/jquery/dist/jquery',
      'bootstrap': '/lib/bootstrap/dist/js/bootstrap',
      'moment'   : '/lib/moment/moment'
    }
});

require([
  'jquery',
  'bootstrap',
  '/js/io-boxes.js'
], function($) {
  //do nothing
});
