//
//  TBDTrack.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/15/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDTrack.h"
#import "NSDictionary+ExceptionHandling.h"


// Soundclound JSON Key Values
NSString *const kSoundcloudKeySongTitle = @"title";
NSString *const kSoundcloudKeySongID = @"id";
NSString *const kSoundcloudKeySongArtist = @"user.username";
NSString *const kSoundcloudKeySongSteam = @"stream_url";
NSString *const kSoundcloudKeySongWaveform = @"waveform_url";
NSString *const kSoundcloudKeySongArtwork = @"artwork_url";
NSString *const kSoundcloudKeySongDuration = @"duration";
NSString *const kSoundcloudKeySongStreamable = @"streamable";

@implementation TBDTrack

+(id) trackFromDictionary:(NSDictionary *)trackInfo {
	
	TBDTrack *track = [[TBDTrack alloc] init];
	if(track){
		track.name = [trackInfo GetValueForKeyPath:kSoundcloudKeySongTitle];
		track.artist = [trackInfo GetValueForKeyPath:kSoundcloudKeySongArtist];
		track.trackID = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongID] intValue];
		track.streamable = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongStreamable] boolValue];
		
		track.streamURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongWaveform];
		track.soundwaveURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongWaveform];
		track.artworkURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongArtwork];
		
		track.duration = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongDuration] intValue];

	}
	return track;
}

@end
