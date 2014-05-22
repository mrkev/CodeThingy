var HUDOverlay = function () {
  var _hud;
  HUDOverlay.prototype.show = function () {
    _hud = document.createElement('div');
    _hud.className = 'progress_hud';

    var progress = document.createElement('img');
    progress.setAttribute('src', './img/fancybox_loading@2x.gif')

    _hud.appendChild(progress);
    document.getElementsByTagName("body")[0].appendChild(_hud);
  }

  HUDOverlay.prototype.hide = function () {
    _hud.parentNode.removeChild(_hud)
  }}

var code_thingy = (function (self) {

  self._hud = new HUDOverlay();

  self.createEditorViewWithFirepad = function(firepad) {
    var self = this; 
    self._hud.show()

    //// Safe clear
    if (self._editor) self.read_buffer = self.getText();
    var prevedit = document.getElementById(self.container_id);
    prevedit.parentNode.removeChild(prevedit);
    _firepad = _editor = _firebase_session = null;
    // Firepad creates a wrapper for some reason. Ugh.
    var fp = document.getElementsByClassName('firepad')
    for (var i = fp.length - 1; i >= 0; i--) {
      fp[i].parentNode.removeChild(fp[i]);};

    //// Create element
    var shedit = document.createElement('div');
    shedit.setAttribute('id', self.container_id);
    shedit.className = 'code_thingy';
    document.getElementsByTagName("body")[0].appendChild(shedit);
    shedit = null;

    //// Create firepad

    if (firepad) {
      self._firepad = Firepad.fromACE(
              this.getFirebaseSession(self.getHash())
            , this.makeEditor(self.container_id)
            //, {userId: this._userID}
            );
      
      self._firepad.on('ready', self.firepadReady);
    }



    //// Create ACE Only

    else {
      window.location.hash = '';
      self._editor = self.makeEditor(self.container_id);
      self._editor.getSession().setValue(self.read_buffer);
      self._hud.hide();
    };

      //if (window.app) app.noShareReady();

  }

  self.makeEditor = function (div_id) {
    /* Returns a new editor using the default theme with a new session using the 
       default mode on div with id 'div_id'. */
    
       _e = ace.edit(div_id);
    _e.setTheme("ace/theme/" + this._theme);
    _e.setShowPrintMargin(false);

      _s = _e.getSession();
    _s.setUseWrapMode(true);
    _s.setUseWorker(false);
    _s.setMode("ace/mode/" + this._mode);

    return _e }
  
  //// Returns or creates instance of ACE
  self.getEditor = function () {
    if (this._editor) return this._editor;

    this._editor = this.makeEditor(this.container)

    return this._editor;

  }

  // Returns or creates firebase session. 
  self.getFirebaseSession = function (hash) {
    if (this._firebase_session) return this._firebase_session;

    // Connect to default firebase server
    var base = new Firebase('https://code-thingy.firebaseio.com');

    // Use existing location hash or create a new one and add it to the URL
    if (hash) { base = base.child(hash); } else {
      base = base.push();
      window.location = window.location + '#' + base.name();
    }

    var auth = new FirebaseSimpleLogin(base, function(error, user) {
      console.log('logged in as' + user.uid);
      self._firepad.setUserId(user.uid);
    });

    auth.login('anonymous');

    console.log('moving on');

    base.onDisconnect().set('');
    var connectedRef = Firebase

    return base; 
  }


  // -----------------------------
  // Firepad Events
  //

  self.firepadDisconnected  = function () {}
  self.firepadLoggedIn      = function () {}



  //// Firepad Ready

  self.firepadReady = function () {
    /* Populates the firepad with the contents of the
       read buffer. 
    */
    if (self._firepad.getText() != '' && self.read_buffer != '')
      console.log('BOTH THINGS HAVE TEXT OMG ERROR LOOOOLLZZZ!');

    if (self._firepad.getText() == '')  // Give preference to online text?
      self._firepad.setText(self.read_buffer);

    // if (self.read_buffer != '')         // Or to local text? hmmmmmmm...
    //   self._firepad.setText(self.read_buffer);
    if (window.app) {app.shareReady(); self._hud.hide();}
  }

  return self;
}(code_thingy || {}));