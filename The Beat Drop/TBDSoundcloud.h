//
//  TBDSoundcloud.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/13/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBDTrack.h"
#import "TBDUser.h"

@interface TBDSoundcloud : NSObject

+(void) GetTrackInfoFromID:(int)trackID OnCompletion:(void (^)(TBDTrack *track))handler;
+(void) GetSearchResultsForQuery:(NSString *)search OnCompletion:(void (^)(NSArray *array))handler;

@end
