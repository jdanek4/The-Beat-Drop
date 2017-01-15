//
//  SplashScreenViewController.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashScreenViewController : UIViewController

// User Interface Components for Loading
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *loadingDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *madebyLabel;

// User Interface Components for Tutorial

@property (weak, nonatomic) IBOutlet UIImageView *tutorialImageView;
@property (weak, nonatomic) IBOutlet UILabel *tutorialTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *tutorialButton;

@end
