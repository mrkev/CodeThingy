function b64_to_utf8( str ) {
    return decodeURIComponent(escape(window.atob( str )));
}
    //var userGUID = "BROWSER" + (1+Math.random())*0x10000).toString();
