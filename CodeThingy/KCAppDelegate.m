//
//  KCAppDelegate.m
//  CodeThingy
//
//  Created by Kevin on 12/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "KCAppDelegate.h"

@implementation KCAppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        //KCDocumentController *documentController = [[KCDocumentController alloc] init]; if (documentController) {}
    }
    return self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    NSString *dateKey    = @"timestamp";
    NSDate *lastRead    = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];

    if (lastRead == nil)     // App first run: set up user defaults.
    {
        NSDictionary *appDefaults  = @{dateKey           : [NSDate date],
                                       @"last_theme"     : @"idle_fingers",
                                       @"last_mode"      : @"javascript"};
        
        // sync the defaults to disk
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    
}

- (NSArray *)getAvailableModes {
    
    // Replace with dynamically generated list from file system. <<
    return @[@"abap", @"actionscript", @"ada", @"asciidoc", @"assembly_x86", @"autohotkey", @"batchfile", @"c9search", @"c_cpp", @"clojure", @"cobol", @"coffee", @"coldfusion", @"csharp", @"css", @"curly", @"d", @"dart", @"diff", @"django", @"dot", @"ejs", @"erlang", @"forth", @"ftl", @"glsl", @"golang", @"groovy", @"haml", @"handlebars", @"haskell", @"haxe", @"html", @"html_ruby", @"ini", @"jack", @"jade", @"java", @"javascript", @"json", @"jsoniq", @"jsp", @"jsx", @"julia", @"latex", @"less", @"liquid", @"lisp", @"livescript", @"logiql", @"lsl", @"lua", @"luapage", @"lucene", @"makefile", @"markdown", @"matlab", @"mushcode", @"mushcode_high_rules", @"mysql", @"nix", @"objectivec", @"ocaml", @"pascal", @"perl", @"pgsql", @"php", @"plain_text", @"powershell", @"prolog", @"properties", @"protobuf", @"python", @"r", @"rdoc", @"rhtml", @"ruby", @"rust", @"sass", @"scad", @"scala", @"scheme", @"scss", @"sh", @"sjs", @"snippets", @"soy_template", @"space", @"sql", @"stylus", @"svg", @"tcl", @"tex", @"text", @"textile", @"toml", @"twig", @"typescript", @"vbscript", @"velocity", @"verilog", @"vhdl", @"xml", @"xquery", @"yaml"];
}

- (NSArray *)getAvailableThemes {
    return @[@"ambiance", @"chaos", @"chrome", @"clouds", @"clouds_midnight", @"cobalt", @"crimson_editor", @"dawn", @"dreamweaver", @"eclipse", @"github", @"idle_fingers", @"kr", @"merbivore", @"merbivore_soft", @"mono_industrial", @"monokai", @"pastel_on_dark", @"solarized_dark", @"solarized_light", @"terminal", @"textmate", @"tomorrow", @"tomorrow_night", @"tomorrow_night_blue", @"tomorrow_night_bright", @"tomorrow_night_eighties", @"twilight", @"vibrant_ink", @"xcode"];
}

- (NSDictionary *)getSupportedExtensionTypeDictionary
{
    // Replace with dinamically generated list from the filesystem
    return @{
             @"abap"  :  @"abap",
             @"as"  :  @"actionscript",
             @"ada"  :  @"ada",
             @"asciidoc"  :  @"asciidoc",
             @"assembly_x86"  :  @"assembly_x86",
             @"autohotkey"  :  @"autohotkey",
             @"batchfile"  :  @"batchfile",
             @"c9search"  :  @"c9search",
             @"c"  :  @"c_cpp",
             @"h"  :  @"c_cpp",
             @"cpp"  :  @"c_cpp",
             @"clojure"  :  @"clojure",
             @"cobol"  :  @"cobol",
             @"coffee"  :  @"coffee",
             @"coldfusion"  :  @"coldfusion",
             @"csharp"  :  @"csharp",
             @"css"  :  @"css",
             @"curly"  :  @"curly",
             @"d"  :  @"d",
             @"dart"  :  @"dart",
             @"diff"  :  @"diff",
             @"django"  :  @"django",
             @"dot"  :  @"dot",
             @"ejs"  :  @"ejs",
             @"erlang"  :  @"erlang",
             @"forth"  :  @"forth",
             @"ftl"  :  @"ftl",
             @"glsl"  :  @"glsl",
             @"go"  :  @"golang",
             @"groovy"  :  @"groovy",
             @"haml"  :  @"haml",
             @"handlebars"  :  @"handlebars",
             @"haskell"  :  @"haskell",
             @"haxe"  :  @"haxe",
             @"html"  :  @"html",
             @"html_ruby"  :  @"html_ruby",
             @"ini"  :  @"ini",
             @"jack"  :  @"jack",
             @"jade"  :  @"jade",
             @"java"  :  @"java",
             @"js"  :  @"javascript",
             @"json"  :  @"json",
             @"jq"  :  @"jsoniq",
             @"jqy"  :  @"jsoniq",
             @"jsp"  :  @"jsp",
             @"jsx"  :  @"jsx",
             @"julia"  :  @"julia",
             @"latex"  :  @"latex",
             @"less"  :  @"less",
             @"liquid"  :  @"liquid",
             @"lisp"  :  @"lisp",
             @"livescript"  :  @"livescript",
             @"logiql"  :  @"logiql",
             @"lsl"  :  @"lsl",
             @"lua"  :  @"lua",
             @"luapage"  :  @"luapage",
             @"lucene"  :  @"lucene",
             @"makefile"  :  @"makefile",
             @"md"  :  @"markdown",
             @"matlab"  :  @"matlab",
             @"mushcode"  :  @"mushcode",
             @"mushcode_high_rules"  :  @"mushcode_high_rules",
             @"mysql"  :  @"mysql",
             @"nix"  :  @"nix",
             @"m"  :  @"objectivec",
             @"ocaml"  :  @"ocaml",
             @"pascal"  :  @"pascal",
             @"perl"  :  @"perl",
             @"pgsql"  :  @"pgsql",
             @"php"  :  @"php",
             @"txt"  :  @"plain_text",
             @"powershell"  :  @"powershell",
             @"prolog"  :  @"prolog",
             @"properties"  :  @"properties",
             @"protobuf"  :  @"protobuf",
             @"py"  :  @"python",
             @"r"  :  @"r",
             @"rdoc"  :  @"rdoc",
             @"rhtml"  :  @"rhtml",
             @"ruby"  :  @"ruby",
             @"rust"  :  @"rust",
             @"sass"  :  @"sass",
             @"scad"  :  @"scad",
             @"scala"  :  @"scala",
             @"scheme"  :  @"scheme",
             @"scss"  :  @"scss",
             @"sh"  :  @"sh",
             @"sjs"  :  @"sjs",
             @"snippets"  :  @"snippets",
             @"soy_template"  :  @"soy_template",
             @"space"  :  @"space",
             @"sql"  :  @"sql",
             @"stylus"  :  @"stylus",
             @"svg"  :  @"svg",
             @"tcl"  :  @"tcl",
             @"tex"  :  @"tex",
             @"text"  :  @"text",
             @"textile"  :  @"textile",
             @"toml"  :  @"toml",
             @"twig"  :  @"twig",
             @"typescript"  :  @"typescript",
             @"vbscript"  :  @"vbscript",
             @"velocity"  :  @"velocity",
             @"verilog"  :  @"verilog",
             @"vhdl"  :  @"vhdl",
             @"xml"  :  @"xml",
             @"xquery"  :  @"xquery",
             @"yaml"  :  @"yaml"
             };
}

@end
