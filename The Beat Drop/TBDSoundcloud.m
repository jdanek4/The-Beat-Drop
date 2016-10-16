//
//  TBDSoundcloud.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/13/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDSoundcloud.h"
#import "TBDHTTPRequest.h"
#import "NSDictionary+ExceptionHandling.h"

/*
 Constants
*/

// Web Request Strings
NSString *const kSoundcloudPrefix = @"https://api.soundcloud.com/";
NSString *const kSoundcloudSuffix = @"?client_id=ef95044ef892046510fa005fad793c12";
NSString *const kSoundcloudSearchLimit = @"&limit=40";// After kSoundcloudSuffix
NSString *const kSoundcloudSearchString = @"&q=";	// After kSoundcloudSuffix
NSString *const kSoundcloudTrack = @"tracks/";		// Followed by track id or suffix and search parameters
NSString *const kSoundcloudUser = @"users/";		// Followed by user id or suffix and search parameters
NSString *const kSoundcloudStreamableFilter = @"&filter=streamable";
NSString *const kSoundcloud = @"";

// Soundclound JSON Key Values
NSString *const kSoundcloudKeySongTitle = @"title";
NSString *const kSoundcloudKeySongID = @"id";
NSString *const kSoundcloudKeySongArtist = @"user.username";
NSString *const kSoundcloudKeySongSteam = @"stream_url";
NSString *const kSoundcloudKeySongWaveform = @"waveform_url";
NSString *const kSoundcloudKeySongArtwork = @"artwork_url";
NSString *const kSoundcloudKeySongDuration = @"duration";
NSString *const kSoundcloudKeySongStreamable = @"streamable";

@implementation TBDSoundcloud

#pragma mark - Request - Specific

+(void) GetTrackInfoFromID:(int)trackID OnCompletion:(void (^)(TBDTrack *track))handler {
	NSURL *requestURL = [self URLToRequestInfoForTrack:trackID];
	
	__block NSDictionary *trackInfo = nil;
	
	[TBDHTTPRequest GetRequestForJSONFromURL:requestURL CompletionHandler:^(NSDictionary *response) {
		trackInfo = response;
	}];
	
	handler([self TrackFromDictionary:trackInfo]);
}

+(void) GetUserInfoFromID:(int)userID OnCompletion:(void (^)(TBDUser *user))handler{
	// Todo
}

#pragma mark - Request - Search

+(void) GetSearchResultsForQuery:(NSString *)search OnCompletion:(void (^)(NSArray *array))handler{
	NSURL *requestURL = [self URLToRequestSearchQuery:search];
	
	__block NSDictionary *arrayInfo = nil;
	
	[TBDHTTPRequest GetRequestForJSONFromURL:requestURL CompletionHandler:^(NSDictionary *response) {
		
		arrayInfo = response;
		
	}];
	
	NSMutableArray *trackArray = [NSMutableArray array];
	
	for (NSDictionary *track in arrayInfo) {
		[trackArray addObject:[self TrackFromDictionary:track]];
	}
	
	handler(trackArray);
	
}

#pragma mark - Utilities

+(BOOL) EnsurePlayabilityForTrack:(int)trackID {
	__block BOOL returnBool = false;
	
	[self GetTrackInfoFromID:trackID OnCompletion:^(TBDTrack *track) {
		returnBool = [track streamable];
	}];
	
	return returnBool;
}

+(TBDTrack *) TrackFromDictionary:(NSDictionary *)trackInfo{
	
	TBDTrack *track = [[TBDTrack alloc] init];
	
	track.name = [trackInfo GetValueForKeyPath:kSoundcloudKeySongTitle];
	track.artist = [trackInfo GetValueForKeyPath:kSoundcloudKeySongArtist];
	track.trackID = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongID] intValue];
	track.streamable = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongStreamable] boolValue];
	
	track.streamURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongWaveform];
	track.soundwaveURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongWaveform];
	track.artworkURL = [trackInfo GetURLForKeyPath:kSoundcloudKeySongArtwork];
	
	track.duration = [[trackInfo GetValueForKeyPath:kSoundcloudKeySongDuration] intValue];
	
	return track;
}

/*
 Soundcloud API Reference:
 
 Get Specific Track info:	api.soundcloud.com/tracks/TRACK_ID?client_id=YOUR_CLIENT_ID
 Get Specific User info:	api.soundcloud.com/users/USER_ID?client_id=YOUR_CLIENT_ID
 
 Search for tracks:			api.soundcloud.com/tracks/?client_id=YOUR_CLIENT_ID&q=SEARCH_STRING&limit=NUM_OF_RESULTS
 Search for users:			api.soundcloud.com/users/?client_id=YOUR_CLIENT_ID&q=SEARCH_STRING&limit=NUM_OF_RESULTS
 
 */
+(NSURL *) URLToRequestInfoForTrack:(int)trackID {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%i%@", kSoundcloudPrefix,kSoundcloudTrack,trackID,kSoundcloudSuffix]];
}
+(NSURL *) URLToRequestSearchQuery:(NSString *)search {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@", kSoundcloudPrefix,kSoundcloudTrack,kSoundcloudSuffix,kSoundcloudSearchLimit,search,kSoundcloudSearchLimit,kSoundcloudStreamableFilter]];
}


@end
