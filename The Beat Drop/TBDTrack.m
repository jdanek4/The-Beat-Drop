//
//  TBDTrack.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/15/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDTrack.h"
#import "NSDictionary+ExceptionHandling.h"
#import "TBDReachability.h"

// Soundclound JSON Key Values
NSString *const kSoundcloudKeySongTitle = @"title";
NSString *const kSoundcloudKeySongID = @"id";
NSString *const kSoundcloudKeySongArtist = @"user.username";
NSString *const kSoundcloudKeySongStream = @"stream_url";
NSString *const kSoundcloudKeySongWaveform = @"waveform_url";
NSString *const kSoundcloudKeySongArtwork = @"artwork_url";
NSString *const kSoundcloudKeySongDuration = @"duration";
NSString *const kSoundcloudKeySongStreamable = @"streamable";

// Soundcloud Image Values
NSString *const kSoundcloudImageDefault = @"large";
NSString *const kSoundcloudImageLarge = @"t500x500";
NSString *const kSoundcloudImageMedium = @"t300x300";
NSString *const kSoundcloudImageSmall = @"badge";

// Soundcloud Request Client Suffix
NSString *const kSoundCloudStreamSuffix = @"?client_id=Ebtg4XFMDZpkPf017RXzZrN5Lxcb0rEa";


@implementation TBDTrack

#pragma mark - Inits

+(id) trackFromDictionary:(NSDictionary *)trackInfo {
	
	TBDTrack *track = [[TBDTrack alloc] init];
	if(track){
		track.name = [trackInfo GetValueForKeyPath:kSoundcloudKeySongTitle];
		track.artist = [trackInfo GetValueForKeyPath:kSoundcloudKeySongArtist];
		track.trackID = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongID] intValue];
		track.streamable = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongStreamable] boolValue];
		
		NSString *tempStreamURL = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongStream] stringByAppendingString:kSoundCloudStreamSuffix]; // Append Client ID For Stream Requests
		track.streamURL = [NSURL URLWithString:tempStreamURL];
		track.soundwaveURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongWaveform];
		track.artworkURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongArtwork];
		
		track.duration = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongDuration] doubleValue];

	}
	return track;
}

#pragma mark - Advanced Getters

-(NSURL *) getSamllArtworkURL {
	NSString *urlString = [[self.artworkURL absoluteString] stringByReplacingOccurrencesOfString:kSoundcloudImageDefault withString:kSoundcloudImageSmall];
	return [NSURL URLWithString:urlString];
}
-(NSURL *) getArtworkURL {
	__block NSString *artworkURL = NULL;
	[TBDReachability PerformBlockWithNetworkConsideration:^(NSInteger status) {
		switch (status) {
			case 0: // Network Unreachable
				artworkURL = NULL;
				break;
			case 1: // Med Quality
				artworkURL = [[self.artworkURL absoluteString] stringByReplacingOccurrencesOfString:kSoundcloudImageDefault withString:kSoundcloudImageMedium];
				break;
			case 2: // High Quality
				artworkURL = [[self.artworkURL absoluteString] stringByReplacingOccurrencesOfString:kSoundcloudImageDefault withString:kSoundcloudImageLarge];
				break;
		}
	}];
	return [NSURL URLWithString:artworkURL];
}


#pragma mark - Overrides

-(NSString *) description {
	return [NSString stringWithFormat:@"%@-%@", self.name, self.artist];
}

@end
