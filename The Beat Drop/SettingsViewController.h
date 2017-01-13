//
//  SettingsViewController.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/12/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIStepper *dropBuilduptimeStepper;
@property (weak, nonatomic) IBOutlet UILabel *dropBuildupTimeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *enforceHiResArtworkButton;

@end
