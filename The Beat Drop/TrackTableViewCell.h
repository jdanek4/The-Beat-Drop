//
//  TrackTableViewCell.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 11/15/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackTableGestureDelegate.h"

@interface TrackTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@property (weak, nonatomic) IBOutlet UILabel *trackTitle;
@property (weak, nonatomic) IBOutlet UILabel *trackArtist;
@property (weak, nonatomic) IBOutlet UIImageView *trackArtwork;
@property(nonatomic, weak) id<TrackTableGestureDelegate> delegate;

@end
