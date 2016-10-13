//
//  WebRequestTest.m
//  The Beat Drop
//
//	Unit Tests to ensure the functionality of HTTP Requests working correctly
//
//  Created by Jonathan Danek on 10/12/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.

#import <XCTest/XCTest.h>
#import "TBDHTTPRequest.h"

@interface WebRequestTest : XCTestCase

@end

@implementation WebRequestTest



- (void)testHTTPGetRequestForString {
	__block NSString *responseString;
	[TBDHTTPRequest GetRequestForStringFromURL:[NSURL URLWithString:@"http://pastebin.com/raw/j4iqCgSU"] CompletionHandler:^(NSString *response) {
		responseString = response;
	}];
	XCTAssert([responseString isEqualToString:@"This is a test!"]);
}

- (void)testHTTPGetRequestForJSON {
	__block NSString *responseValue;
	[TBDHTTPRequest GetRequestForJSONFromURL:[NSURL URLWithString:@"http://pastebin.com/raw/w7xiWpZf"] CompletionHandler:^(NSDictionary *response) {
		responseValue = [response objectForKey:@"This is"];
	}];
	XCTAssert([responseValue isEqualToString:@"a test"]);
}

- (void)testHTTPGetRequestForImage {
	__block UIImage *responseImage = nil;
	
	[TBDHTTPRequest GetRequestForImageFromURL:[NSURL URLWithString:@"https://upload.wikimedia.org/wikipedia/commons/c/c4/PM5544_with_non-PAL_signals.png"] CompletionHandler:^(UIImage *image) {
		responseImage = image;
	}];
	XCTAssert(responseImage);
}


@end
