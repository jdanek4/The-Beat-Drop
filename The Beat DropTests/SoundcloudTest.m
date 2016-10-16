//
//  SoundcloudTest.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/13/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TBDSoundcloud.h"

@interface SoundcloudTest : XCTestCase

+(BOOL) testTrackObject:(TBDTrack *)track;

@end

@implementation SoundcloudTest

-(void) setUp {
	[super setUp];
}

-(void) tearDown {
	[super tearDown];
}

-(void) testGetTrackInfoFromID {
	[TBDSoundcloud GetTrackInfoFromID:13158665 OnCompletion:^(TBDTrack *track) {
		XCTAssert([SoundcloudTest testTrackObject:track]);
	}];
}

-(void) testGetSearchQueryResults {
	[TBDSoundcloud GetSearchResultsForQuery:@"grady" OnCompletion:^(NSArray *array) {
		for (TBDTrack *track in array) {
			XCTAssert([SoundcloudTest testTrackObject:track]);
		}
	}];
}

+(BOOL) testTrackObject:(TBDTrack *)track {
	if(track.trackID > 0 && track.artist != NULL && track.soundwaveURL != NULL && track.duration > 0 && track.soundwaveURL != NULL){
		return true;
	}
	return false;
}

@end
