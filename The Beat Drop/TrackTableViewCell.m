//
//  TrackTableViewCell.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 11/15/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TrackTableViewCell.h"

@implementation TrackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	
    // Initialization Long Press Gesture Recognizer
	self.longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
	[self addGestureRecognizer:self.longPressGesture];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)sender {
	[self.delegate trackTableViewCell:self didReceiveLongPress:sender];
}

@end
