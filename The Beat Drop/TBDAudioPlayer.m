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
		
		// Set Track Property
		self.track = track;
		
		// Get Redirected Stream URL
		[self getHTTPRedirectWithURL:track.streamURL];
		
	}
	return self;
}

#pragma mark - Audio Player Controls

-(void) play {
	[self.player play];
}

-(void) pause {
	[self.player pause];
}

-(void) adjustTimeByDelta:(double) time {
	[self setToTime:CMTimeGetSeconds(self.player.currentTime)+time];
}

-(void) setToTime:(double)time {
	[self pause];
	[self.player seekToTime:CMTimeMake(time, 1)];
}

#pragma mark - Boolean Checks

-(BOOL) isPlaying {
	return (self.player.rate != 0) && (self.player.error == nil);
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
	[self.track setStreamURL:request.URL];
	self.player = [[AVPlayer alloc] initWithURL:self.track.streamURL];

}


@end
