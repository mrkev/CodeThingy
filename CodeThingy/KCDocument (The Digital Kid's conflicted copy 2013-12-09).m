//
//  KCDocument.m
//  CodeThingy
//
//  Created by Kevin on 10/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "KCDocument.h"
#import "NSString+TokenReplace.h"
#import "KCDocumentUI.h"
#import "KCJavaScripts.h"

@interface KCDocument()

@end

@implementation KCDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"KCDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {return NO;}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
    NSLog(@"typename: %@", typeName);
    NSData *data = [[self runWebScript:kGetDocumentStringScript] dataUsingEncoding:NSUTF8StringEncoding];
    
    //WebScriptObject *win = [_uiWebView windowScriptObject];
    //NSString *text = [win valueForKey:@"web_ui.getText"];
    //NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!data && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:nil];
    }
    
    NSLog(@"%@", data);
    
    return data;
    
    //NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    //@throw exception;
}

/*- (BOOL)writeToURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSLog(typeName);
    BOOL result;
    result = [[self runWebScript:@"web_ui.getText()"] writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:outError];
    return result;

}*/

/*- (BOOL)revertToContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    return YES;
}*/


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"Type name: %@", typeName);
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    
    if ([typeName compare:@"public.python-script"]) {
        NSBeep();
    }
    _readBuffer = data;
    NSLog(@"%@", _readBuffer);
    
    //NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
    //NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    //@throw exception;
    return YES;
}

- (void)awakeFromNib
{
    [_uiWebView setPolicyDelegate:self];
    [_uiWebView setCustomUserAgent:@"Codethingy/0.1 (OSX) AppleWebKit/534.46"];
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"public"]];
        
    [[_uiWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    //[[_uiWebView mainFrame] loadHTMLString:[NSString stringWithUTF8String:[data bytes]] baseURL:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
    
}

- (NSString *)uid {
    NSLog(@"UID: %@", _uid);
    if (_uid == nil) {
        NSString *url = [[[[[_uiWebView mainFrame] dataSource] request] URL] absoluteString];
        _uid = [[url componentsSeparatedByString:@"#"] objectAtIndex:1];
        _url = [NSString stringWithFormat:@"%@/#%@", @"http://codethingy-mrkev.rhcloud.com", _uid];
    }
    return _uid;
}

- (void)setUID:(NSString *)value {
    _uid = value;
}

- (IBAction)tst:(id)sender {
    //WebScriptObject *win = [_uiWebView windowScriptObject];
    //id location = [win valueForKey:@"location"];
    //NSString *href = [location valueForKey:@"href"];
    //NSLog(href);
    
    
    //[self browseDocumentVersions:sender];
    
    
    [self runWebScript:@""];
}




//+ (BOOL)preservesVersions { return YES; }

# pragma mark - Web Talk Helpers

// Obj-C to Javascript FTW! //

- (NSString *)runWebScript:(NSString *)script
{
    return [_uiWebView stringByEvaluatingJavaScriptFromString:script];
}

// Javascript to Objective-C! //

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id<WebPolicyDecisionListener>)listener
{
    NSArray *callarray = [[[request URL] absoluteString] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    
    // Structure: app.run:SELECTOR:ARG1:ARG2:ARG3...
    if ([[callarray objectAtIndex:0] isEqualToString:@"app.run"]) {
        NSLog(@"Function Caught: %@", [request URL]);
        [listener ignore];
        
        NSMutableArray *args = [NSMutableArray arrayWithArray:callarray];
        if ([callarray count] > 2) {[args removeObjectAtIndex:0];[args removeObjectAtIndex:0];}
        
        //
        // Call translation
        //
        
        if ([callarray[1] isEqualToString:@"log"]) {
            NSString *log = [args[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"web_ui says : %@", log);
        }
        
        if ([callarray[1] isEqualToString:@"first_change"]) {
            NSLog(@"touch document");
            [self updateChangeCount:NSChangeDone];
        }
        
    } else { [listener use];}
}


- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message {
	NSLog(@"%@ received %@ with '%@'", self, NSStringFromSelector(_cmd), message);
    // Will be called whenever "alert(message)" is called through javascript
}

@end
