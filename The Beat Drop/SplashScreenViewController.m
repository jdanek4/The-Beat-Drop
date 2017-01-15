//
//  SplashScreenViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "HomeTableViewController.h"
#import "TBDFileIO.h"
#import "TBDUserDefaults.h"
#import "TBDFeaturedTracks.h"

@interface SplashScreenViewController (){
	int tutorial;
}

@end

NSString *const kTutorialImageTemplate = @"TBD_Tutorial_";
NSString *const kTutorialLabel[] = {
	@"Press The add track button", @"Search for a specific track", @"Select a track", @"Drag to find the drop", @"Press select drop", @"Thats it!"
};

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Hide all tutorial UI Elements
	[self.tutorialButton setHidden:YES];
	[self.tutorialImageView setHidden:YES];
	[self.tutorialTextLabel setHidden:YES];
	
	// Load Featured Tracks
	[TBDFeaturedTracks GetFeaturedTracksAndOnCompletion:^(NSArray *array) {
		//Tracks Received and Stored as static variable in class
	}];

	
	if ([TBDUserDefaults IsFirstTimeLaunching]) {
		// First Time Launching - Show tutorial Screen
		tutorial = 1;
		[self performSelector:@selector(fadeOutLoadingUI) withObject:nil afterDelay:3.0f];
		return;
	}
	
	if([TBDFileIO DoesFileExist]){
		// Ensure Playability of Saved Songs
		NSArray *tracks = [TBDFileIO GetObjectsFromFile];
		[self performSelector:@selector(advanceToHomeTableViewWithArray:) withObject:tracks afterDelay:0.5f];
	}else {
		// First time opening app or never added a track to their list
		[self performSelector:@selector(advanceToHomeTableViewWithArray:) withObject:[NSArray array] afterDelay:0.5f];
	}
}

-(void) viewDidAppear:(BOOL)animated{
	// Play Logo Animation
	[self.loadingIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:YES];
	// Play Loading Animation
	
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
	// Pass array of tracks retrieved from PList file
	
	if([segue.destinationViewController isKindOfClass:[UINavigationController class]]){
		// Destination View Controller is the UINavigationController that controls the HomeTableViewController
		HomeTableViewController *nextView = [segue.destinationViewController.childViewControllers objectAtIndex:0];
		[nextView giveTrackData:sender];
		
		[self dismissViewControllerAnimated:YES completion:nil];
	}
	
}


-(void) advanceToHomeTableViewWithArray:(NSArray *)array {
	if ([self.tutorialTextLabel isHidden]) {
		[self performSegueWithIdentifier:@"SplashScreenDone" sender:array];
	}
}

#pragma mark - User Actions

-(void) fadeOutLoadingUI {
	
	[self.loadingIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
	
	
	[UIView animateWithDuration:1.0f animations:^{
		[self.titleLabel setAlpha:0.0f];
		[self.madebyLabel setAlpha:0.0f];
		[self.loadingIndicator setAlpha:0.0f];
		[self.loadingDetailLabel setAlpha:0.0f];
		[self fadeInTutorialUI];
	}];
	
}

-(void) fadeInTutorialUI {
	
	[self.tutorialButton setHidden:false];
	[self.tutorialImageView setHidden:false];
	[self.tutorialTextLabel setHidden:false];
	
	[self.tutorialButton setAlpha:0.0f];
	[self.tutorialImageView setAlpha:0.0f];
	[self.tutorialTextLabel setAlpha:1.0f];
	
	[self updateTutorialImageAndText];
	
	[UIView animateWithDuration:1.0f animations:^{
		[self.tutorialButton setAlpha:1.0f];
		[self.tutorialImageView setAlpha:1.0f];
		[self.tutorialTextLabel setAlpha:1.0f];
		
	}];

}

-(void) updateTutorialImageAndText {
	[self.tutorialImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d", kTutorialImageTemplate, tutorial]]];
	
	[self.tutorialTextLabel setText:kTutorialLabel[tutorial-1]];
}

- (IBAction)tutorialButtonPressed:(id)sender {
	if (tutorial < 5) {
		tutorial++;
		[self updateTutorialImageAndText];
	}else if(tutorial == 5){
		[self.tutorialButton setTitle:@"Done" forState:UIControlStateNormal];
		tutorial++;
		[self updateTutorialImageAndText];
	}else {
		[self performSegueWithIdentifier:@"SplashScreenDone" sender:[NSArray array]];
	}
}


@end
