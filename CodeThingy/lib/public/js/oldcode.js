var code_thingy = code_thingy || {

  // Defaults
  _theme       : 'textmate',
  _mode        : 'javascript',
  container_id : 'c_thingy',

  on_native   : false,
  debugging   : true,
  read_buffer : '',

  _firepad          : null,
  _editor           : null, 
  _firebase_session : null,

  _userID   : null,

  _phud     : new HUDOverlay(),

  disconnect : function () {
    // Show warning. Have been disconnected.
  },

  createEditorViewWithFirepad : function(firepad) {
    var self = this; 
    var hud = new HUDOverlay();
    hud.show()

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
            this.getFirebaseSession(self.getHash()),
            this.makeEditor(self.container_id),
            {userId: this._userID});
      
      // Copy from previous _editor if it has contents.
      self._firepad.on('ready', function() {
        if (self._firepad.getText() != '' && self.read_buffer != '')
          console.log('BOTH THINGS HAVE TEXT OMG ERROR LOOOOLLZZZ!');

        if (self._firepad.getText() == '')  // Give preference to online text?
          self._firepad.setText(self.read_buffer);

        // if (self.read_buffer != '')         // Or to local text? hmmmmmmm...
        //   self._firepad.setText(self.read_buffer);
        if (window.app) {app.shareReady(); hud.hide();}
      });}



    //// Create ACE Only

    else {
      window.location.hash = '';
      self._editor = self.makeEditor(self.container_id);
      console.log('adding' + self.read_buffer);
      self._editor.getSession().setValue(self.read_buffer);
      hud.hide();
    };

      //if (window.app) app.noShareReady();

  },

  makeEditor : function (div_id) {
    /* Returns a new editor using the default theme with a new session using the 
       default mode on div with id 'div_id'. */
    
       _e = ace.edit(div_id);
    _e.setTheme("ace/theme/" + this._theme);
    _e.setShowPrintMargin(false);

      _s = _e.getSession();
    _s.setUseWrapMode(true);
    _s.setUseWorker(false);
    _s.setMode("ace/mode/" + this._mode);

    return _e },
  
  //// Returns or creates instance of ACE
  getEditor : function () {
    if (this._editor) return this._editor;

    this._editor = this.makeEditor(this.container)

    return this._editor; },

  // Returns or creates firebase session. 
  getFirebaseSession : function (hash) {
    if (this._firebase_session) return this._firebase_session;

    // Connect to default firebase server
    var base = new Firebase('https://code-thingy.firebaseio.com');

    // Use existing location hash or create a new one and add it to the URL
    if (hash) { base = base.child(hash); } else {
      base = base.push();
      window.location = window.location + '#' + base.name();
    }

    var auth = new FirebaseSimpleLogin(base, function(error, user) {
      this._userID = user.uid;
    });

    auth.login('anonymous');

    base.onDisconnect().set('');
    var connectedRef = Firebase

    return base; 
  },


  /*

  // Returns the document's text content.
  getText : function () {
    return (this._firepad != null) ? this._firepad.getText() 
                                   : this.getEditor().getSession().getValue();
  },

  // Set's the documents contents
  setText : function (text) {
    console.log('SETTING TEXT')
    if (this._firepad != null) {
      this._firepad.setText(text);
    } else {
      e = this.getEditor().getSession().setValue(text)
    }
  },

  // Returns the document's content as b64 data.
  setData : function (data) {this.setText(b64_to_utf8(data))},


  // Sets Ace's mode.
  setMode : function (mode) {
    this.getEditor().getSession().setMode("ace/mode/" + mode);
    this._mode = mode;
  },

  // Sets Ace's theme
  setTheme : function (theme) {
    this.getEditor().setTheme("ace/theme/" + theme);
    this._theme = theme;
  },*/
}