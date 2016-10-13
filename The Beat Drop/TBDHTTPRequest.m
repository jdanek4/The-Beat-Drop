//
//  TBDHTTPRequest.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/12/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDHTTPRequest.h"

@implementation TBDHTTPRequest


# pragma mark - Get Requests

+(void) GetRequestForStringFromURL:(NSURL *)url CompletionHandler:(void (^)(NSString *response))handler {
	
	NSHTTPURLResponse *responseCode = nil;
	NSMutableURLRequest *request = [self buildGetURLRequestForURL:url];
	
	NSError *error = [[NSError alloc] init];
	
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
	#pragma clang diagnostic pop
	
	if([responseCode statusCode] != 200){
		handler(NULL);
		return;
	}
	
	handler([[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
}

+(void) GetRequestForJSONFromURL:(NSURL *)url CompletionHandler:(void (^)(NSDictionary *response))handler {
	NSHTTPURLResponse *responseCode = nil;
	NSMutableURLRequest *request = [self buildGetURLRequestForURL:url];
	
	NSError *error = [[NSError alloc] init];
	
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
	#pragma clang diagnostic pop
	
	if([responseCode statusCode] != 200){
		handler(NULL);
		return;
	}
	
	handler([NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil]);
}

+(void) GetRequestForImageFromURL:(NSURL *)url CompletionHandler:(void (^)(UIImage *image))handler {
	NSHTTPURLResponse *responseCode = nil;
	NSMutableURLRequest *request = [self buildGetURLRequestForURL:url];
	
	NSError *error = [[NSError alloc] init];
	
	#pragma clang diagnostic push
	#pragma clang diagnostic ignored "-Wdeprecated-declarations"
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
	#pragma clang diagnostic pop
	
	if([responseCode statusCode] != 200){
		handler(NULL);
		return;
	}
	
	handler([UIImage imageWithData:responseData]);
}


#pragma mark - Object Builder

+(NSMutableURLRequest *) buildGetURLRequestForURL:(NSURL *)url {
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setHTTPMethod:@"GET"];
	[request setURL:url];
	return request;
}




@end
