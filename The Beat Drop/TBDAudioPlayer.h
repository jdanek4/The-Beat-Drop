//
//  TBDAudioPlayer.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/19/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBDTrack.h"

@import AVFoundation;

@interface TBDAudioPlayer : NSObject <NSURLSessionTaskDelegate>

@property(strong, nonatomic) AVPlayer *player;
@property(strong, nonatomic) TBDTrack *track;

-(id) initWithTrack:(TBDTrack *)track;
-(void) play;
-(void) pause;
-(void) setToTime:(double)time;
-(void) adjustTimeByDelta:(double) time;

-(BOOL) isPlaying;

@end

