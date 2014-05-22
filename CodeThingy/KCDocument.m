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
#import "KCAppDelegate.h"

@interface KCDocument()

@end

@implementation KCDocument

// NSDocument configuration

+ (BOOL)autosavesInPlace {return NO;}
+ (BOOL)preservesVersions { return YES; }
- (NSString *)windowNibName
{   // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"KCDocument";
}

// -----------------------------------
// Initialization
//

- (id)init
{   self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        NSLog(@"DOC INIT");
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    
    //// Set up the WebView
    
    //[_uiWebView setPolicyDelegate:self];
    [_uiWebView setCustomUserAgent:@"Codethingy/0.1 (OSX) AppleWebKit/534.46"];
    
    // Add url fragment if opening from online location
    NSURL *url;
    if (_webURL && [[_webURL host] isEqualToString:@"codethingy-mrkev.rhcloud.com"] && [_webURL fragment]) {
        NSLog(kObjectFormatString, [_webURL fragment]);
        NSURL *base = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"public"]];
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/#%@", [base absoluteString], [_webURL fragment]]];
    } else {
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"public"]];
    }
    
    // Load webview if nothing is loaded on it.
    if (_uiWebView.mainFrame.dataSource == nil) {
        [[_uiWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:url]];
    }
    
    // Enable console if debugging.
#ifdef DEBUG
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"WebKitDeveloperExtras"];
#endif

}

// -----------------------------------
// Document I/O
//


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    
    NSLog(@"typename: %@", typeName);
    NSData *data = [[self runWebScript:kGetDocumentStringScript] dataUsingEncoding:NSUTF8StringEncoding];
    
    if (!data && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:nil];
        return nil;
    }
    
    return data;
    
    //NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    //@throw exception;
}

- (BOOL)revertToContentsOfURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSData *data = [NSData dataWithContentsOfURL:url];
    _readBuffer = data;
    [self runWebScript:[NSString stringWithFormat:kSetDocumentDataScriptG, _readBuffer]];
    
    return YES;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    //// Opening a local file
    
    if ([url.scheme isEqualToString:@"file"]) {
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        if ([typeName compare:@"public.python-script"]) {
            NSBeep();
        }
        
        _readBuffer = data;
        
        NSString *mode = [[(KCAppDelegate *)[[NSApplication sharedApplication] delegate]
                         getSupportedExtensionTypeDictionary] objectForKey:[url pathExtension]];
        if (mode) {
            [[NSUserDefaults standardUserDefaults] setObject:mode forKey:@"last_mode"];
        }

        NSLog(@"Read Buffer: %@", _readBuffer);
        return YES;}
    
    
    
    //// Opening a remote/shared file
    
    else if ([url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"]) {
        
        NSLog(@"Should open %@", url);
        
        // Only accept files at codethingy
        if ([[url host] isEqualToString:@"codethingy-mrkev.rhcloud.com"]) {
            _webURL = url;
            return YES;
        }
        return NO;
    }
    
    NSLog(@"%@ - %@", url, typeName);
    return NO;
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
    
    NSView *view = [self uiWebView];
    NSSize imgSize = view.bounds.size;
    
    NSBitmapImageRep * bir = [view bitmapImageRepForCachingDisplayInRect:view.bounds];
    [bir setSize:imgSize];
    
    [view cacheDisplayInRect:[view bounds] toBitmapImageRep:bir];
    
    NSImage* image = [[NSImage alloc] initWithSize:imgSize];
    [image addRepresentation:bir];
    
    NSLog(kObjectFormatString, image);
    
    //[self runWebScript:@""];
}

- (void)openFromURL:(NSURL *)url {
    
}



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
    
    NSLog(kObjectFormatString, [request URL]);
    // Structure: app.run:SELECTOR:ARG1:ARG2:ARG3...
    if ([[callarray objectAtIndex:0] isEqualToString:@"app.run"]) {
        NSLog(@"Function Caught: %@", [request URL]);
        [listener ignore];
        
        NSMutableArray *args = [NSMutableArray arrayWithArray:callarray];
        if ([callarray count] > 2) {[args removeObjectAtIndex:0];[args removeObjectAtIndex:0];}
        
        //
        // Call translation
        //
        
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


+ (NSDictionary *)dictOfExtensionTypes {
    return @{@"java": @"java"};
}

@end
