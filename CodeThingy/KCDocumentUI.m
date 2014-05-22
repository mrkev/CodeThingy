//
//  KCDocumentUI.m
//  CodeThingy
//
//  Created by Kevin on 10/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "KCDocumentUI.h"
#import "KCJavaScripts.h"

@implementation KCDocumentUI {
    NSViewController *progressViewController;
}

- (IBAction)share:(NSButton *)sender {
    
    // Sharing was turned on
    if ([_shareButton state] == NSOnState) {
        
        NSString *scrt = [NSString stringWithFormat:kShareDocumentEnableScript, ([_shareButton state] == 1) ? @"true" : @"false"];
        [[_model uiWebView] stringByEvaluatingJavaScriptFromString:scrt];
        [sender setState:NSOnState];
    
    
    // Keep sharing on.
    } else {
        [_shareButton setState:NSOnState];
        [self shareReady];
    }
    
    
    /*if ([sender state] == 1 && false) {
        NSAlert *alert =
        [NSAlert alertWithMessageText:@"Do you want to create a new document for the imported text?"
                        defaultButton:@"Create New"
                      alternateButton:@"Cancel"
                          otherButton:@"Replace current"
            informativeTextWithFormat:@"Replacing the current document will delete all the contents of this document. Creating a new document will import the online version onto a new file."];

        [alert runAsPopoverForView:sender preferredEdge:NSMaxXEdge withCompletionBlock:^(NSInteger result) {
            NSLog(@"%li", (long)result);
        }];
    }*/
    
}

- (IBAction)disableShare:(id)sender {
    NSString *scrt = [NSString stringWithFormat:kShareDocumentEnableScript, @"false"];
    [[_model uiWebView] stringByEvaluatingJavaScriptFromString:scrt];
    [_shareButton setState:NSOffState];
    [_sharingPopover close];
}

- (IBAction)shareLink:(id)sender {
    NSSharingServicePicker *sharePicker = [[NSSharingServicePicker alloc] initWithItems:@[_shareURL.stringValue]];
    [sharePicker setDelegate:self];
    [sharePicker showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
}

- (void)shareReady {
    [_sharingPopover showRelativeToRect:[_shareButton bounds] ofView:_shareButton preferredEdge:NSMaxXEdge];

    [_shareUID setStringValue:_model.uid];
    [_shareURL setStringValue:_model.url];
}


- (IBAction)settings:(id)sender {
    [_settingsPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];}
- (IBAction)cloudOpen:(id)sender {
    [_cloudOpenPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];}



- (IBAction)openFromCloud:(id)sender {
    /* NSString *url = ([[_cloudOpenUID stringValue] hasPrefix:@"http://"]
                     || [[_cloudOpenUID stringValue] hasPrefix:@"https://"]) ? [_cloudOpenUID stringValue] : [NSString stringWithFormat:@"http://codethingy-mrkev.rhcloud.com/#%@", [_cloudOpenUID stringValue]]; */
    
    NSURL *url = [NSURL URLWithString:[_cloudOpenUID stringValue]];
    
    // Only accept code hosted at codethingy at the moment.
    if ([[url host] isEqualToString:@"codethingy-mrkev.rhcloud.com"]) {
        //KCDocument *newdoc = [[KCDocument alloc] initWithContentsOfURL:url ofType:@"public.text" error:&error];
        //[newdoc makeWindowControllers];
        //[newdoc showWindows];
        
        [[NSDocumentController sharedDocumentController] openDocumentWithContentsOfURL:url display:YES completionHandler:^(NSDocument *document, BOOL documentWasAlreadyOpen, NSError *error) {
            if (!documentWasAlreadyOpen) [document makeWindowControllers];
            [document showWindows];
        }];
    }
    
    
    else {
        NSLog(@"Cant open url %@", url);}
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
        //NSLog(kObjectFormatString, [context evaluateScript:@"code_thingy.getEditor()"]);
        //codet[@"read_buffer"] = [[NSString alloc] initWithData:_model.readBuffer encoding:NSUTF8StringEncoding];
        //codet[@"theme"]       = [self defaultTheme];
        //JSValue *val = [JSValue valueWithBool:YES inContext:context];
        //[codet setValue:@"a" forProperty:@"on_native"];
        //NSLog(kObjectFormatString, theme);
        //[context evaluateScript:[NSString stringWithFormat:kSetThemeScriptG, self.defaultTheme]];
        //[context evaluateScript:[NSString stringWithFormat:kSetModeScriptG, self.defaultMode]];
    }
}

//
//
// Accessible from Javascript
//
//

- (void)log:(NSString *)string {
    NSLog(@"WEB_UI: %@", string);}

- (void)alert { NSBeep(); }

- (NSString *)defaultTheme {return [[NSUserDefaults standardUserDefaults] objectForKey:@"last_theme"];}
- (NSString *)defaultMode  {return [[NSUserDefaults standardUserDefaults] objectForKey:@"last_mode"] ;}
- (NSString *)getReadBuffer {
    //return [[_model readBuffer] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return [[NSString alloc] initWithData:[_model readBuffer] encoding:NSUTF8StringEncoding];
}

- (void)ready {
    [[_model uiWebView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:kSetThemeScriptG, [self defaultTheme]] ];
    [[_model uiWebView] stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:kSetModeScriptG, [self defaultMode]] ];

}

@end
