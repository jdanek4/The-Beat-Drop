//
//  TBDHTTPRequest.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/12/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDHTTPRequest.h"

@implementation TBDHTTPRequest


# pragma mark - Get Requests - Specialty Object

+(void) GetRequestForStringFromURL:(NSURL *)url CompletionHandler:(void (^)(NSString *response))handler {
	
	[self GetRequestForDataFromURL:url CompletionHandler:^(NSData *data) {
		handler([[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
	}];
	
}

+(void) GetRequestForJSONFromURL:(NSURL *)url CompletionHandler:(void (^)(NSDictionary *response))handler {

	[self GetRequestForDataFromURL:url CompletionHandler:^(NSData *data) {
		handler([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil]);
	}];
	
}

+(void) GetRequestForImageFromURL:(NSURL *)url CompletionHandler:(void (^)(UIImage *image))handler {
	
	[self GetRequestForDataFromURL:url CompletionHandler:^(NSData *data) {
		handler([UIImage imageWithData:data]);
	}];
	
}
#pragma mark - Get Requests - Generic Data

+(void) GetRequestForDataFromURL:(NSURL *)url CompletionHandler:(void (^)(NSData *data))handler {
	// TODO : Update to NSURLSession
	
	NSHTTPURLResponse *responseCode = nil;
	NSMutableURLRequest *request = [self buildURLForHTTPGetRequestFromURL:url];
	
	NSError *error = nil;
	
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
	#pragma clang diagnostic pop
	
	if([responseCode statusCode] != 200){
		
		handler(NULL);
		
	}else {
		
		handler(responseData);
		
	}
}

#pragma mark - Object Builder

+(NSMutableURLRequest *) buildURLForHTTPGetRequestFromURL:(NSURL *)url {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setHTTPMethod:@"GET"];
	[request setURL:url];
	return request;
}

@end
