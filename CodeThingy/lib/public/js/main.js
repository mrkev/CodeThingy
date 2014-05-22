


window.onload = function() {
  var self = this;

  if (code_thingy.debugging) {
    document.getElementById('debug_menu').className = ''
  };

  if (code_thingy.getHash()) {
    code_thingy.createEditorViewWithFirepad(true);
  } else {
    code_thingy.createEditorViewWithFirepad(false);
  };

  if (window.app) {
    app.ready();
    code_thingy.setText(app.getReadBuffer())
  };
};


/*
  Hack to run selectors on OSX.
  Creates iframe and uses it to call URL 'app.run:*'
  OSX intercpets this URL and runs specified selector.
*/

var osx = {
  run  : function (sel) {
    var iframe = document.createElement('iframe');
    iframe.setAttribute('src', 'app.run:' + sel);
    document.documentElement.appendChild(iframe);
    iframe.parentNode.removeChild(iframe);
    iframe = null;
  },
}


//function setLocation () {window.location.href = url;}



// Helper function. Logs.
function log(string) { if (typeof console !== 'undefined') console.log(string);}

// Heper function. Creates UIDs
function guid() {
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +
         s4() + '-' + s4() + s4() + s4();}

function s4() {
  return Math.floor((1 + Math.random()) * 0x10000)
             .toString(16)
             .substring(1);};





