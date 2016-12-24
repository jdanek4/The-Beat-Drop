//
//  DropPlayerViewController.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropPlayerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *trackArtWorkImageView;
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackArtistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *trackPositionImage;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundArtworkImageView;


-(void) giveTrackForEditing:(id)track;
-(void) giveTrackForPlaying:(id)track;

@end
