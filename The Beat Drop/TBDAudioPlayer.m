//
//  TBDAudioPlayer.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/19/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDAudioPlayer.h"

@interface TBDAudioPlayer ()



@end

@implementation TBDAudioPlayer

-(id) initWithTrack:(TBDTrack *)track {
	if(self = [super init]){
		
		
		
	}
	return self;
}

#pragma mark - Stream URL Redirect

-(void) getHTTPRedirectWithURL:(NSURL *)url {
	NSURLSessionConfiguration *sessionConfig =
	[NSURLSessionConfiguration defaultSessionConfiguration];
	
	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
	
	[[session dataTaskWithURL:url
			completionHandler:^(NSData *data,
								NSURLResponse *response,
								NSError *error) {
				
			}] resume];
}

-(void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
	
	// Recieved redirection Audio URL
	[self. track setStreamURL:request.URL];
	self.player = [AVPlayer playerWithURL:[self.track streamURL]];
	
}


@end
