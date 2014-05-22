//
//  KCDocumentController.m
//  CodeThingy
//
//  Created by Kevin on 20/12/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import "KCDocumentController.h"

@implementation KCDocumentController

- (id)init
{
    self = [super init];
    if (self) {
        
    } return self;
}

- (NSString *)typeForContentsOfURL:(NSURL *)url error:(NSError *__autoreleasing *)outError
{
    NSLog(@"TEXT");
    return @"public.txt";
}

@end
