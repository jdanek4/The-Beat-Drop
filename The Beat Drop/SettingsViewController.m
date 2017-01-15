//
//  SettingsViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/12/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import "SettingsViewController.h"
#import "TBDUserDefaults.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Set bar button to display Done instead of "The Beat Drop"
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] init];
	backButton.title = @"Done";
	self.navigationController.navigationBar.topItem.backBarButtonItem = backButton;
	
	// Set Settings UI elements to user defaults
	[self.dropBuilduptimeStepper setValue:[TBDUserDefaults GetDropBuildUpTime]];
	[self.dropBuildupTimeLabel setText:[NSString stringWithFormat:@"%d", (int)self.dropBuilduptimeStepper.value]];
	
	[self.enforceHiResArtworkButton setOn:[TBDUserDefaults GetEnforceHiResImageSetting]];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Settings Actions

- (IBAction)enforceHiResArtworkSelected:(id)sender {
	[TBDUserDefaults SetEnforceHiResImageSetting:self.enforceHiResArtworkButton.on];
}
- (IBAction)dropBuildingStepperChanaged:(id)sender {
	[TBDUserDefaults SetDropBuildupTime:(int)self.dropBuilduptimeStepper.value];
	[self.dropBuildupTimeLabel setText:[NSString stringWithFormat:@"%d", (int)self.dropBuilduptimeStepper.value]];
}

#pragma mark - Navigation Actions

- (IBAction)doneButtonPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
