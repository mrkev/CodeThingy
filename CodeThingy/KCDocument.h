//
//  KCDocument.h
//  CodeThingy
//
//  Created by Kevin on 10/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface KCDocument : NSDocument <WebPolicyDecisionListener> {
    NSString *_uid;
}

- (NSString *)uid;
- (void)setUID:(NSString *)value;

@property NSString *url;
@property (weak) IBOutlet WebView *uiWebView;

@property (readonly) NSData *readBuffer;
@property (readonly) NSURL *webURL;

- (IBAction)tst:(id)sender;

@end
