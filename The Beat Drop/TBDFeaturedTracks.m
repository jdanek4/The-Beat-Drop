//
//  TBDFeaturedTracks.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/14/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import "TBDFeaturedTracks.h"
#import "TBDSoundcloud.h"
#import "TBDHTTPRequest.h"

NSString *const kFeaturedTracksLink = @"https://danek.me/Api/TheBeatDrop/index.php/featured";
NSString *const kTrackLog = @"https://danek.me/Api/TheBeatDrop/index.php/log/";

static NSArray *kFeaturedTracks;

@implementation TBDFeaturedTracks

+(void) GetFeaturedTracksAndOnCompletion:(void (^)(NSArray *array))handler {
	if (kFeaturedTracks != NULL) {
		handler(kFeaturedTracks);
	}
	[TBDHTTPRequest GetRequestForStringFromURL:[NSURL URLWithString:kFeaturedTracksLink] CompletionHandler:^(NSString *response) {
		
		NSArray *trackIDs = [response componentsSeparatedByString:@"<br>"];
		NSMutableArray *tracks = [NSMutableArray array];
		
		for (NSString *tID in trackIDs) {
			if ([tID isEqualToString:@""]) {
				continue;
			}
			[TBDSoundcloud GetTrackInfoFromID:[tID intValue] OnCompletion:^(TBDTrack *track) {
				[tracks addObject:track];
			}];
		}
		kFeaturedTracks = [tracks copy];
		handler(kFeaturedTracks);
	}];
}

+(void) LogTrackPlay:(int)trackID {
	[TBDHTTPRequest GetRequestForDataFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%d", kTrackLog, trackID]] CompletionHandler:^(NSData *data) {
		
	}];
}
@end
