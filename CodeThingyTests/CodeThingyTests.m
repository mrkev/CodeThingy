//
//  CodeThingyTests.m
//  CodeThingyTests
//
//  Created by Kevin on 10/11/13.
//  Copyright (c) 2013 Kevin. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface CodeThingyTests : XCTestCase

@end


// Test KCDocument.h
#import "KCDocument.h"

@implementation CodeThingyTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

//- (void)testExample
//{
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
//}

- (void)testOpen
{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"example-helper" ofType:@"js"]];
    NSError *error;
    KCDocument *document = [[KCDocument alloc] initForURL:url withContentsOfURL:url ofType:@"com.netscape.javascript-source" error:&error];
    
    XCTAssertNotNil([[document uiWebView] stringByEvaluatingJavaScriptFromString:@"web_ui.getText()"] , @"Document not loaded.");
}

@end
