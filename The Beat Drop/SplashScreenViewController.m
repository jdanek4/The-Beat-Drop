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

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	
	if([TBDFileIO DoesFileExist]){
		// Ensure Playability of Saved Songs
		NSArray *tracks = [TBDFileIO GetObjectsFromFile];
		[self performSelector:@selector(advanceToHomeTableViewWithArray:) withObject:tracks afterDelay:0.2f];
	}else {
		// First time opening app or never added a track to their list
		[self performSelector:@selector(advanceToHomeTableViewWithArray:) withObject:[NSArray array] afterDelay:0.2f];
	}
}

-(void) viewDidAppear:(BOOL)animated{
	// Play Logo Animation
	
	// Play Loading Animation
	
	// Maybe Opt-In Button for iCloud Drop Sync
	
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

	}
	
}

-(void) advanceToHomeTableViewWithArray:(NSArray *)array {
	[self performSegueWithIdentifier:@"SplashScreenDone" sender:array];
}



@end
