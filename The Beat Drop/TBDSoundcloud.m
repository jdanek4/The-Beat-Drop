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
NSString *const kSoundcloudPrefix =				@"https://api.soundcloud.com/";
NSString *const kSoundcloudSuffix =				@"?client_id=Ebtg4XFMDZpkPf017RXzZrN5Lxcb0rEa";
NSString *const kSoundcloudSearchLimit =		@"&limit=20";						// After kSoundcloudSuffix
NSString *const kSoundcloudSearchString =		@"&q=";								// After kSoundcloudSuffix
NSString *const kSoundcloudTrack =				@"tracks";							// Followed by track id or suffix and search parameters
NSString *const kSoundcloudUser =				@"users/";							// Followed by user id or suffix and search parameters
NSString *const kSoundcloudStreamableFilter =	@"&filter=streamable";
NSString *const kSoundcloudFormatJSON =			@"&format=json";					// Request Respones in JSON format

@implementation TBDSoundcloud

#pragma mark - Request - Specific

+(void) GetTrackInfoFromID:(int)trackID OnCompletion:(void (^)(TBDTrack *track))handler {
	NSURL *requestURL = [self URLToRequestInfoForTrack:trackID];
	
	__block NSDictionary *trackInfo = nil;
	
	[TBDHTTPRequest GetRequestForJSONFromURL:requestURL CompletionHandler:^(NSDictionary *response) {
		trackInfo = response;
	}];
	
	handler([TBDTrack trackFromDictionary:trackInfo]);
}

/// TODO: Implement Method
+(void) GetUserInfoFromID:(int)userID OnCompletion:(void (^)(TBDUser *user))handler{

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
		[trackArray addObject:[TBDTrack trackFromDictionary:track]];
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

+(NSURL *) URLToRequestInfoForTrack:(int)trackID {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%i%@", kSoundcloudPrefix,kSoundcloudTrack,trackID,kSoundcloudSuffix]];
}
+(NSURL *) URLToRequestSearchQuery:(NSString *)search {
	return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@", kSoundcloudPrefix,kSoundcloudTrack,kSoundcloudSuffix,kSoundcloudSearchString,search,kSoundcloudSearchLimit,kSoundcloudStreamableFilter,kSoundcloudFormatJSON]];
}


@end
