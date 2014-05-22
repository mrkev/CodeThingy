//
//  KCAppDelegate.h
//  CodeThingy
//
//  Created by Kevin on 12/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KCDocumentController.h"

@interface KCAppDelegate : NSObject <NSApplicationDelegate>

- (NSArray *)getAvailableModes;
- (NSArray *)getAvailableThemes;
- (NSDictionary *)getSupportedExtensionTypeDictionary;

@end
