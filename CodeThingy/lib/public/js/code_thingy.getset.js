var code_thingy = (function (self) {

	// -----------------------------
	// Utilities
	//

	self.getHash = function () { return window.location.hash.replace(/#/g, '');}

	// -----------------------------
	// File I/O
	//

	// Returns the document's text content.
	self.getText = function () {
	  return (this._firepad != null) ? this._firepad.getText() 
	                                 : this.getEditor().getSession().getValue();
	}

	// Set's the documents contents
	self.setText = function (text) {
	  if (this._firepad != null) {
	    this._firepad.setText(text);
	  } else {
	    e = this.getEditor().getSession().setValue(text)
	  }
	}

	// Returns the document's content as b64 data.
	self.setData = function (data) {this.setText(b64_to_utf8(data))}

	// -----------------------------
	// Graphical User Interface
	//

	// Sets Ace's mode.
	self.setMode = function (mode) {
	  this.getEditor().getSession().setMode("ace/mode/" + mode);
	  this._mode = mode;
	}

	// Sets Ace's theme
	self.setTheme = function (theme) {
	  this.getEditor().setTheme("ace/theme/" + theme);
	  this._theme = theme;
	}

  return self;
}(code_thingy || {}));