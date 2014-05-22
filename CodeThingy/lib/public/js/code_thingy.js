var code_thingy = (function (self) {
  // The defaults
  self._theme       = 'textmate';
  self._mode        = 'javascript';

  // The #defines
  self.container_id = 'c_thingy';
  self.debugging    = true;

  // The editor
  self._firepad          = null;
  self._editor           = null; 
  self._firebase_session = null;
  self._userID           = null;

  // The I/O
  self.read_buffer  = '';

  
  return self;
}(code_thingy || {}));