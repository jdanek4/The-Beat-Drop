//
//  TBDWaveformView.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 12/30/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBDAudioPlayer.h"

@interface TBDWaveformView : UIImageView{
	CGPoint currentPoint;
}

// Properties

@property(nonatomic, weak) TBDAudioPlayer *audioplayer;

// Functions

-(void) updateWaveFormViewLocation;


@end
