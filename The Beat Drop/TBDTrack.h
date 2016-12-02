//
//  TBDTrack.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/15/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBDTrack : NSObject

@property(strong, nonatomic) NSString*	name;
@property(strong, nonatomic) NSString*	artist;
@property(strong, nonatomic) NSURL*		artworkURL;
@property(strong, nonatomic) NSURL*		streamURL;
@property(strong, nonatomic) NSURL*		soundwaveURL;

@property(assign, nonatomic) unsigned int trackID;
@property(assign, nonatomic) unsigned int duration;
@property(assign, nonatomic) double		dropTime;
@property(assign, nonatomic) BOOL		streamable;


+(id) trackFromDictionary:(NSDictionary *)trackInfo;

-(NSURL *) getSamllArtworkURL;

@end
