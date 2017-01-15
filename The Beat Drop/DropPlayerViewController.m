//
//  DropPlayerViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "DropPlayerViewController.h"
#import "HomeTableViewController.h"
#import "TBDTrack.h"
#import "TBDAudioPlayer.h"
#import "TBDHTTPRequest.h"
#import "TBDWaveformView.h"
#import "TBDUserDefaults.h"
#import "TBDFeaturedTracks.h"

#import <MediaPlayer/MediaPlayer.h>

NSString *const kplayButtonAssetName = @"PlayButton";
NSString *const kPauseButtonAssetName = @"PauseButton";


@interface DropPlayerViewController ()

@property(nonatomic, retain) TBDAudioPlayer *audioPlayer;
@property(nonatomic, retain) TBDWaveformView *soundWaveImageView;
@property(nonatomic, assign) BOOL editingMode;
@property(nonatomic, assign) int timeout;

@end


@implementation DropPlayerViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) viewDidAppear:(BOOL)animated {
	self.timeout = 0;
	[self performSelectorOnMainThread:@selector(loadingBegan) withObject:nil waitUntilDone:YES];
}

-(void) viewDidDisappear:(BOOL)animated {
	// Release Background Controls
	[[UIApplication sharedApplication] endReceivingRemoteControlEvents];
	
	[self resignFirstResponder];
	
	// Continue Disappearing View
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) giveTrackForEditing:(TBDTrack *)track {
	self.editingMode = true;
	[self setupUIForTrack:track andOnCompletion:^{
		
	}];
}

-(void) giveTrackForPlaying:(TBDTrack *)track {
	[TBDFeaturedTracks LogTrackPlay:track.trackID];
	self.editingMode = false;
	[self setupUIForTrack:track andOnCompletion:^{
		// Get Remote Control Signals
		[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
		[self becomeFirstResponder];
	}];
}

#pragma mark - Setup 

// Setup track labels, artwork, and waveform
-(void) setupUIForTrack:(TBDTrack *)track andOnCompletion:(void (^)())completion {
	
	// Setup Artwrok and Label Information
	[self performSelectorOnMainThread:@selector(setupArtworkViewsFromURL:) withObject:track.getArtworkURL waitUntilDone:YES];
	[self performSelectorOnMainThread:@selector(setupAudioPlayerWithTrack:) withObject:track waitUntilDone:YES];
	[self performSelector:@selector(setupLabelsForTitle:andArtist:) withObject:track.name withObject:track.artist];
	[self performSelectorOnMainThread:@selector(setupSoundWaveForTrack:) withObject:track waitUntilDone:YES];
	
	[self waitUntilLoadingCompleted];
	
	completion();
}

#pragma mark - UI Actions

- (IBAction)closeButtonPressed:(id)sender {
	
	[self dismissViewControllerAnimated:YES completion:^{
		// On Completion Sent Home View Status
		
		// If Editing Mode Display Error
		if (self.editingMode) {
			[self exitPlayerWithStatus:ERROR_NO_DROP_SELECTED];
		}else{
			[self exitPlayerWithStatus:SUCCESS_DROP_SELECTED];
		}
	}];
	
}
- (IBAction)playPauseButtonPressed:(id)sender {
	if ([self.audioPlayer isPlaying]) {
		// Display Play Button
		[self.playPauseButton setImage:[UIImage imageNamed:kplayButtonAssetName] forState:UIControlStateNormal];
		// Pause Music
		[self.audioPlayer pause];
	}else {
		// Display Pause Button
		[self.playPauseButton setImage:[UIImage imageNamed:kPauseButtonAssetName] forState:UIControlStateNormal];
		// Play Music
		[self.audioPlayer play];
		// Begin WaveformAnimation
		[self.soundWaveImageView updateWaveFormViewLocation];
	}
}

- (IBAction)selectDropButtonPressed:(id)sender {
	// Pause If playing
	[self.audioPlayer pause];
	TBDTrack *track = self.audioPlayer.track;
	
	// Set Track Drop Time to Current Time
	track.dropTime = CMTimeGetSeconds(self.audioPlayer.player.currentTime);
	
	// Pause Audio Player
	[self.audioPlayer pause];

	// Dismiss View Controller and Give Track to Home View
	[self dismissViewControllerAnimated:YES completion:^{
		HomeTableViewController *homeTableView = (HomeTableViewController *)[self homeTableViewCallback];
		[homeTableView giveTrack:track withStatusCode:SUCCESS_DROP_SELECTED];
	}];
}

#pragma mark - Audio Methods

-(void) setupAudioPlayerWithTrack:(TBDTrack *)track {
	self.audioPlayer = [[TBDAudioPlayer alloc] initWithTrack:track];
}

#pragma mark - Background Control Handlers

-(void) setupNowPlayingInfoWithImage:(UIImage *)image {
	MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
	infoCenter.nowPlayingInfo =
	[NSDictionary dictionaryWithObjectsAndKeys:
	 self.audioPlayer.track.name, MPMediaItemPropertyTitle,
	 self.audioPlayer.track.artist, MPMediaItemPropertyArtist,
	 [[MPMediaItemArtwork alloc] initWithBoundsSize:self.trackArtWorkImageView.bounds.size requestHandler:^UIImage * _Nonnull(CGSize size) {
		return self.trackArtWorkImageView.image;
	}], MPMediaItemPropertyArtwork,nil];

}

-(void) remoteControlReceivedWithEvent:(UIEvent *)event {
	if (event.type == UIEventTypeRemoteControl) {
		switch (event.subtype) {
			case UIEventSubtypeRemoteControlPlay:
				NSLog(@"Play Pressed!");
				[self.audioPlayer pause];							// Ensure Audio Player is Paused
				[self playPauseButtonPressed:self.playPauseButton]; // Simulate Play Button Pressed
				break;
			case UIEventSubtypeRemoteControlPause:
				NSLog(@"Pause Pressed!");
				[self.audioPlayer play];							// Ensure Audio Player is Playing
				[self playPauseButtonPressed:self.playPauseButton]; // Simulate Pause Button Pressed
				break;
			case UIEventSubtypeRemoteControlNextTrack:
				NSLog(@"Next Track Pressed!");
				self.editingMode ?  : [self exitPlayerWithStatus:OPTION_NEXT_TRACK]; // If Editing Mode - Do Nothing If Playing Mode Exit Player With StatusCode
				break;
			case UIEventSubtypeRemoteControlPreviousTrack:
				NSLog(@"Previous Track Pressed!");
				self.editingMode ?  : [self exitPlayerWithStatus:OPTION_PREV_TRACK]; // If Editing Mode - Do Nothing If Playing Mode Exit Player With StatusCode
				break;
			default:
				break;
		}
	}
}

-(void) exitPlayerWithStatus:(DropTableStatus)statusCode {
	// Pause Audio Player
	[self.audioPlayer pause];
	
	[self dismissViewControllerAnimated:YES completion:^{
		HomeTableViewController *homeTableView = (HomeTableViewController *)[self homeTableViewCallback];
		[homeTableView giveTrack:nil withStatusCode:statusCode];
	}];
}

#pragma mark - UI Handlers

-(void) loadingBegan {
	// Hide Play/Pause Button
	[self.playPauseButton setHidden:TRUE];
	
	// Display Activity Indicator and begin animating
	[self.activityIndicator setHidden:false];
	[self.activityIndicator startAnimating];
	
	// Disable User Interaction on WaveForm
	[self.soundWaveImageView setUserInteractionEnabled:false];
	
	// Hide Select Drop Button
	[self.selectDropButton setHidden:true];
}

-(void) waitUntilLoadingCompleted {
	self.timeout += 1;
	if(self.trackArtWorkImageView.image.size.width > 0 && [self.audioPlayer isDoneLoading]){
		// All Done Loading
		[self performSelectorOnMainThread:@selector(loadingEnded) withObject:nil waitUntilDone:false];
	}else {
		if(self.timeout >= 150){
			// 15 Seconds has gone by and still not done loading
			// Probable Connection Issues or song too large
			// Revert to Home Screen and Display Error
			[self exitPlayerWithStatus:ERROR_TIMEOUT];
		}else {
			[self performSelector:@selector(waitUntilLoadingCompleted) withObject:nil afterDelay:0.1f];
		}
	}
	
}

-(void) loadingEnded {
	// Stop Activity Indicator and hide
	[self.activityIndicator stopAnimating];
	[self.activityIndicator setHidden:true];
	
	// Show Play/Pause Button
	[self.playPauseButton setImage:[UIImage imageNamed:kplayButtonAssetName] forState:UIControlStateNormal];
	[self.playPauseButton setHidden:false];
	
	// Eanble User Interaction on WaveForm
	[self.soundWaveImageView setUserInteractionEnabled:true];
	
	// Enable Select Drop Button if applicable
	if (self.editingMode) {
		[self.selectDropButton setHidden:false];
	}else {
		// Set Player to Drop Position minus constant
		double bufferedDrop = (self.audioPlayer.track.dropTime - [TBDUserDefaults GetDropBuildUpTime])*1000;
		if (bufferedDrop < 0) bufferedDrop = 0;
		
		[self.audioPlayer setToTime:bufferedDrop];
		[self.soundWaveImageView performSelector:@selector(updateWaveFormViewLocation) withObject:nil afterDelay:0.1f];
	}
	
	// Create Notification to Observe if Audio reached end of track
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidFinishPlaying) name:AVPlayerItemDidPlayToEndTimeNotification object:self.audioPlayer.player.currentItem];

}

-(void) setupArtworkViewsFromURL:(NSURL *) url {
	[TBDHTTPRequest GetRequestForImageFromURL:url CompletionHandler:^(UIImage *image) {
		if (image.size.width > 0){
			// Artwork Received Successfully
			
			self.backgroundArtworkImageView.image = [image copy];
			self.trackArtWorkImageView.image = [image copy];
		}else {
			// Artwork Not Found - Display TBD Default Placeholder
			self.backgroundArtworkImageView.image =	[UIImage imageNamed:@"Artwork"];
			self.trackArtWorkImageView.image =	[UIImage imageNamed:@"Artwork"];
			image = [UIImage imageNamed:@"Artwork"];
		}
		if (!self.editingMode) {
			[self performSelectorOnMainThread:@selector(setupNowPlayingInfoWithImage:) withObject:image waitUntilDone:NO]; // Background Controls Information
		}

	}];
}

-(void) setupLabelsForTitle:(NSString *)title andArtist:(NSString *)artist {
	self.trackTitleLabel.text = title;
	self.trackArtistLabel.text = artist;
}

-(void) setupSoundWaveForTrack:(TBDTrack *)track {
	// Create Bounds for Soundwave image
	CGRect newBounds = [self.trackPositionImage convertRect:self.trackPositionImage.bounds toView:self.view];
	
	// Create Soundwave image object and perform setup
	self.soundWaveImageView = [[TBDWaveformView alloc] init];
	self.soundWaveImageView.audioplayer = self.audioPlayer;
	
	// Add to View
	[self.view addSubview:self.soundWaveImageView];
	
	[TBDHTTPRequest GetRequestForImageFromURL:track.soundwaveURL CompletionHandler:^(UIImage *image) {
		if (image.size.width > 0) {
			// Soundwave Recieved Successfully
			[self.soundWaveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[self convertToMask:image] waitUntilDone:YES];
			[self.soundWaveImageView setAlpha:0.625f];
			[self.soundWaveImageView setFrame:CGRectMake(newBounds.origin.x, newBounds.origin.y, image.size.width, newBounds.size.height)];
		}else {
			// Soundwave Not Found - Revert to Home Screen with error
			[self exitPlayerWithStatus:ERROR_UNEXPLAINED];
		}
	}];
}

-(UIStatusBarStyle) preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

# pragma mark - Soundwave Alterations
- (UIImage*)convertToMask: (UIImage *) image
{
	UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
	CGRect imageRect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(ctx, 1.0f, 1.0f, 1.0f, 1.0f);
	CGContextFillRect(ctx, imageRect);
	
	[image drawInRect:imageRect blendMode:kCGBlendModeXOR alpha:1.0f];
	
	UIImage* outImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return outImage;
}

#pragma mark - Notification Observer Selector

-(void) audioPlayerDidFinishPlaying {
	// If editing mode	- Allow
	// If not			- Return to HomeScreen
	if (self.editingMode) {
		// Display Play Button
		[self.playPauseButton setImage:[UIImage imageNamed:kplayButtonAssetName] forState:UIControlStateNormal];
		// Pause Music
		[self.audioPlayer pause];
	}else{
		[self exitPlayerWithStatus:SUCCESS_DROP_PLAYED];
	}
}

@end
