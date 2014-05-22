//
//  KCDocumentUI.m
//  CodeThingy
//
//  Created by Kevin on 10/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "KCDocumentUI.h"
#import "KCJavaScripts.h"


@implementation KCDocumentUI

- (IBAction)share:(id)sender {
    [_sharingPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
    [_shareUID setStringValue:_model.uid];
    [_shareURL setStringValue:_model.url];
}

- (IBAction)settings:(id)sender {
    [_settingsPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}

- (IBAction)cloudOpen:(id)sender {
    [_cloudOpenPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
}

- (IBAction)openFromCloud:(id)sender {
    //KCDocument *new = [[KCDocument alloc] init]
    if (true) {
        NSString *script = [NSString stringWithFormat:kSetLocationScriptG, [_cloudOpenUID stringValue]];
        [[_model uiWebView] stringByEvaluatingJavaScriptFromString:script];
    }
}


- (IBAction)setMode:(NSPopUpButton *)sender {
    [[_model uiWebView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:kSetModeScriptG, [[sender selectedItem] title]]];
    [[NSUserDefaults standardUserDefaults] setObject:[[sender selectedItem] title] forKey:@"last_mode"];

}

- (IBAction)setTheme:(id)sender {
    [[_model uiWebView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:kSetThemeScriptG, [[sender selectedItem] title]]];
    [[NSUserDefaults standardUserDefaults] setObject:[[sender selectedItem] title] forKey:@"last_theme"];

}

- (void)webView:(WebView *)webView didCreateJavaScriptContext:(JSContext *)context forFrame:(WebFrame *)frame
{
    if (frame == [[_model uiWebView] mainFrame]) {
        context[@"app"] = self;
        //context[@"model"] = _model;
    }
}

- (NSArray *)getAvailableModes {
    // Replace with dynamically generated list from file system. <<
    return @[@"abap", @"actionscript", @"ada", @"asciidoc", @"assembly_x86", @"autohotkey", @"batchfile", @"c9search", @"c_cpp", @"clojure", @"cobol", @"coffee", @"coldfusion", @"csharp", @"css", @"curly", @"d", @"dart", @"diff", @"django", @"dot", @"ejs", @"erlang", @"forth", @"ftl", @"glsl", @"golang", @"groovy", @"haml", @"handlebars", @"haskell", @"haxe", @"html", @"html_ruby", @"ini", @"jack", @"jade", @"java", @"javascript", @"json", @"jsoniq", @"jsp", @"jsx", @"julia", @"latex", @"less", @"liquid", @"lisp", @"livescript", @"logiql", @"lsl", @"lua", @"luapage", @"lucene", @"makefile", @"markdown", @"matlab", @"mushcode", @"mushcode_high_rules", @"mysql", @"nix", @"objectivec", @"ocaml", @"pascal", @"perl", @"pgsql", @"php", @"plain_text", @"powershell", @"prolog", @"properties", @"protobuf", @"python", @"r", @"rdoc", @"rhtml", @"ruby", @"rust", @"sass", @"scad", @"scala", @"scheme", @"scss", @"sh", @"sjs", @"snippets", @"soy_template", @"space", @"sql", @"stylus", @"svg", @"tcl", @"tex", @"text", @"textile", @"toml", @"twig", @"typescript", @"vbscript", @"velocity", @"verilog", @"vhdl", @"xml", @"xquery", @"yaml"];
}

- (NSArray *)getAvailableThemes {
    return @[@"ambiance", @"chaos", @"chrome", @"clouds", @"clouds_midnight", @"cobalt", @"crimson_editor", @"dawn", @"dreamweaver", @"eclipse", @"github", @"idle_fingers", @"kr", @"merbivore", @"merbivore_soft", @"mono_industrial", @"monokai", @"pastel_on_dark", @"solarized_dark", @"solarized_light", @"terminal", @"textmate", @"tomorrow", @"tomorrow_night", @"tomorrow_night_blue", @"tomorrow_night_bright", @"tomorrow_night_eighties", @"twilight", @"vibrant_ink", @"xcode"];
}


//
//
// Accessible from Javascript
//
//

- (void)log:(NSString *)string {
    NSLog(@"WEB_UI: %@", string);
}

- (void)alert { NSBeep(); }

- (NSString *)defaultTheme {return [[NSUserDefaults standardUserDefaults] objectForKey:@"last_theme"];}
- (NSString *)defaultMode  {return [[NSUserDefaults standardUserDefaults] objectForKey:@"last_mode"] ;}
- (NSString *)getReadBuffer {
    //return [[_model readBuffer] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    NSLog(@"GETTING READ BUFER");
    return [[NSString alloc] initWithData:[_model readBuffer] encoding:NSUTF8StringEncoding];
}

@end
