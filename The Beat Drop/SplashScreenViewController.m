//
//  SplashScreenViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "TBDFileIO.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Play Logo Animation
	
	if([TBDFileIO DoesFileExist]){
		// Ensure Playability of Saved Songs
		
	}else {
		// First time opening app or never added a track to their list
		
	}
}

-(void) viewDidAppear:(BOOL)animated{
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	
}

-(void) advanceToHomeTableView {
	[self performSegueWithIdentifier:@"SplashScreenDone" sender:self];
}



@end
