//
//  TBDWaveformView.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 12/30/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDWaveformView.h"

@interface TBDWaveformView ()

@property (nonatomic, assign) bool wasPlaying;
@property (nonatomic, assign) double refreshRate;

@end

@implementation TBDWaveformView


- (void) touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
		
	currentPoint = [[touches anyObject] locationInView:self];
	self.wasPlaying = [self.audioplayer isPlaying];
	[self.audioplayer pause];
	
}
-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
	CGPoint activePoint = [[touches anyObject] locationInView:self];
 
	CGPoint newPoint = CGPointMake(self.center.x + (activePoint.x - currentPoint.x), self.center.y);
	
	int superViewWidth = self.superview.bounds.size.width / 2;
	
	if ((newPoint.x - superViewWidth) > self.bounds.size.width/2) {
		// Out of Bounds - Set to Max Left Position
		newPoint = CGPointMake(superViewWidth + self.bounds.size.width/2, newPoint.y);
		
	}else if((newPoint.x + self.bounds.size.width/2) < superViewWidth){
		// Out of Bounds - Set to Max Right Position
		newPoint = CGPointMake(superViewWidth - self.bounds.size.width/2, newPoint.y);
	}
	
	self.center = newPoint;
	
	
}
-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
	
	[self.audioplayer setToTime:[self getWaveformPosition]];
	if (self.wasPlaying) {
		[self.audioplayer play];
		[self performSelector:@selector(updateWaveFormViewLocation) withObject:nil afterDelay:0.01f]; // Fixes Soundwave Stutter on Touch Release
	}
}

-(double) getWaveformPosition {
	
	CGPoint origin = [self convertPoint:self.bounds.origin toView:self.superview];
	int superViewMiddle = self.superview.bounds.size.width / 2.0f;

	double distToCenter = superViewMiddle - origin.x;
	
	return (distToCenter / self.bounds.size.width) * (self.audioplayer.track.duration);
}

-(void) updateWaveFormViewLocation {
	
	// Match up waveform location to audioplayer location
	double percentOfSong = CMTimeGetSeconds(self.audioplayer.player.currentTime)*1000.0 / self.audioplayer.track.duration;
	CGPoint currentPosition = CGPointMake((self.frame.size.width/2.0f)+(self.superview.frame.size.width/2.0f)-self.frame.size.width*percentOfSong, self.center.y);
	
	self.center = currentPosition;
	
	if([self.audioplayer isPlaying]){
		// TODO: PerformSelector With Delay (Delay is fixed rate per song calculated from the length of the song)
		[self performSelector:@selector(updateWaveFormViewLocation) withObject:nil afterDelay:[self getRefreshTimeForTrack]];
	}
}

-(double) getRefreshTimeForTrack {
	if (self.refreshRate == 0) {
		self.refreshRate = 1 / ((self.frame.size.width / (self.audioplayer.track.duration / 1000.0f)) * 2);
		if(self.refreshRate < 0.01){ // Dont refresh faster than 100 times per second - Theoretical max refresh rate of ios screen is 60
			self.refreshRate = 0.01f;
		}
	}
	return self.refreshRate;
}

@end
