//
//  KCDocumentUI.h
//  CodeThingy
//
//  Created by Kevin on 10/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCDocument.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSAlert+Popover.h"

@protocol KCDocuemntUIExports <JSExport>

- (void)log:(NSString *)string;
- (void)alert;

- (NSString *)defaultTheme;
- (NSString *)defaultMode;
- (NSString *)getReadBuffer;

- (void)ready;
- (void)shareReady;


@end

@interface KCDocumentUI : NSObject <KCDocuemntUIExports, NSSharingServicePickerDelegate>

@property (weak) IBOutlet NSPopover *sharingPopover;
@property (weak) IBOutlet NSTextField *shareUID;
@property (weak) IBOutlet NSTextField *shareURL;
@property (weak) IBOutlet NSButton *shareButton;

@property (weak) IBOutlet NSPopover *settingsPopover;
@property (weak) IBOutlet KCDocument *model;

@property (weak) IBOutlet NSPopover *cloudOpenPopover;
@property (weak) IBOutlet NSTextField *cloudOpenUID;
- (IBAction)openFromCloud:(id)sender;

- (IBAction)share:(NSButton *)sender;
- (IBAction)disableShare:(id)sender;
- (IBAction)shareLink:(id)sender;

- (IBAction)settings:(id)sender;
- (IBAction)cloudOpen:(id)sender;

@property (weak) IBOutlet NSPopUpButton *modeDropdown;
- (IBAction)setMode:(NSPopUpButton *)sender;

@property (weak) IBOutlet NSPopUpButton *themeDropdown;
- (IBAction)setTheme:(NSPopUpButton *)sender;

@end


