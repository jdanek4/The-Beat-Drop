//
//  TrackTableGestureDelegate.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/10/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TrackTableGestureDelegate <NSObject>

@required

@optional
-(void) trackTableViewCell:(id)track didReceiveLongPress:(UILongPressGestureRecognizer *)gesture;

@end
