//
//  TBDFeaturedTracks.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/14/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBDFeaturedTracks : NSObject

+(void) GetFeaturedTracksAndOnCompletion:(void (^)(NSArray *array))handler;
+(void) LogTrackPlay:(int)trackID;

@end
