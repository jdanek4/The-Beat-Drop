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
	[self.player seekToTime:CMTimeMake(time, 1000)];
}

#pragma mark - Boolean Checks

-(BOOL) isPlaying {
	return (self.player.rate != 0) && (self.player.error == nil);
}

-(BOOL) isDoneLoading {
	
	// Check if AVPlayer thinks its ready
	//		Not A Completely Viable Solution as AVPlayer thinks its ready before actually being able to play the item.
	//		Good as a quick check before more taxing check
	
	if (self.player.status != AVPlayerStatusReadyToPlay) {
		return false;
	}
	
	// Get many seconds of the song has been loaded
	double playableDuration = [self playableDuration];
	
	// Ensure Load Time at least 1/10 + the position of the drop
	//		or 5/10 of the song if drop position is null
	bool playable = false;
	
	if ([self.track dropTime] == 0) {
		playable = (playableDuration > (self.track.duration / 1000.0) * 0.5) ? true : false;
	}else {
		playable = (playableDuration > self.track.dropTime + ((self.track.duration / 1000.0) * 0.1)) ? true : false;
	}
	
	return playable;
}

- (NSTimeInterval) playableDuration
{
	AVPlayerItem * item = self.player.currentItem;
	double loadedLength = 0;
	if (item.status == AVPlayerItemStatusReadyToPlay) {
		NSArray * timeRangeArray = item.loadedTimeRanges;
		
		for (int i = 0; i < [timeRangeArray count]; i++) {
			CMTimeRange aTimeRange = [[timeRangeArray objectAtIndex:i] CMTimeRangeValue];
			
			double startTime = CMTimeGetSeconds(aTimeRange.start);
			double loadedDuration = CMTimeGetSeconds(aTimeRange.duration);
			
			loadedLength += (NSTimeInterval)(startTime + loadedDuration);
		}
		
		return (loadedLength);
	}
	else
	{
		return(CMTimeGetSeconds(kCMTimeInvalid));
	}
}

#pragma mark - Stream URL Redirect

-(void) getHTTPRedirectWithURL:(NSURL *)url {
	NSURLSessionConfiguration *sessionConfig =
	[NSURLSessionConfiguration defaultSessionConfiguration];
	
	NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
	
	// Perform Get request to URL to retrieve URL of audio data
	[[session dataTaskWithURL:url
			completionHandler:^(NSData *data,
								NSURLResponse *response,
								NSError *error) {
				// Repsonded with Audio Data URL
				[self setupPlayerForTrackURL:response.URL];
			}] resume];
}

-(void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
	// Request Returned with a New URL to request again
	// Method makes second request and returns value
	
	[self setupPlayerForTrackURL:request.URL];

}

-(void) setupPlayerForTrackURL:(NSURL *)url {
	[self.track setStreamURL:url];
	self.player = [[AVPlayer alloc] initWithURL:self.track.streamURL];
}


@end
