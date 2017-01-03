//
//  DropPlayerViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "DropPlayerViewController.h"
#import "TBDTrack.h"
#import "TBDAudioPlayer.h"
#import "TBDHTTPRequest.h"
#import "TBDWaveformView.h"

#import <MediaPlayer/MediaPlayer.h>

NSString *const kplayButtonAssetName = @"PlayButton";
NSString *const kPauseButtonAsswerName = @"PauseButton";

@interface DropPlayerViewController ()


@property(nonatomic, retain) TBDAudioPlayer *audioPlayer;
@property(nonatomic, retain) TBDWaveformView *soundWaveImageView;
@property(nonatomic, assign) BOOL editingMode;

@end


@implementation DropPlayerViewController


- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Setup Background Controls
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
}

-(void) viewDidAppear:(BOOL)animated {
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
	NSLog(@"Editing: %@", track);
	self.editingMode = true;
	[self setupUIForTrack:track andOnCompletion:^{
		
	}];
}

-(void) giveTrackForPlaying:(TBDTrack *)track {
	NSLog(@"Playing: %@", track);
	self.editingMode = false;
	[self setupUIForTrack:track andOnCompletion:^{
		// Set Player to Drop Position minus constant
		// Todo: Settings page with setting to adjust pre-drop timing
		
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
		[self.audioPlayer pause];
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
		[self.playPauseButton setImage:[UIImage imageNamed:kPauseButtonAsswerName] forState:UIControlStateNormal];
		// Play Music
		[self.audioPlayer play];
		// Begin WaveformAnimation
		[self.soundWaveImageView updateWaveFormViewLocation];
	}
}

#pragma mark - Audio Methods

-(void) setupAudioPlayerWithTrack:(TBDTrack *)track {
	self.audioPlayer = [[TBDAudioPlayer alloc] initWithTrack:track];
}

#pragma mark - Background Control Handlers

-(void) setupNowPlayingInfo {
	MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
	infoCenter.nowPlayingInfo =
	[NSDictionary dictionaryWithObjectsAndKeys:self.trackTitleLabel.text, MPMediaItemPropertyTitle,
	 self.trackArtistLabel.text, MPMediaItemPropertyArtist,
	 nil];

}

-(void) remoteControlReceivedWithEvent:(UIEvent *)event {
	if (event.type == UIEventTypeRemoteControl) {
		switch (event.subtype) {
			case UIEventSubtypeRemoteControlPlay:
				NSLog(@"Play Pressed!");
				[self.audioPlayer play];
				break;
			case UIEventSubtypeRemoteControlPause:
				NSLog(@"Pause Pressed!");
				[self.audioPlayer pause];
				break;
			case UIEventSubtypeRemoteControlNextTrack:
				NSLog(@"Next Track Pressed!");
				break;
			case UIEventSubtypeRemoteControlPreviousTrack:
				NSLog(@"Previous Track Pressed!");
				break;
				
			default:
				break;
		}
	}
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
}

static int timeout = 0;
-(void) waitUntilLoadingCompleted {
	timeout += 1;
	if(self.trackArtWorkImageView.image.size.width > 0 && [self.audioPlayer isDoneLoading]){
		// All Done Loading
		[self performSelectorOnMainThread:@selector(loadingEnded) withObject:nil waitUntilDone:false];
	}else {
		if(timeout >= 100){
			// 10 Seconds has gone by and still not done loading
			// Probable Connection Issues
			// Revert to Home Screen and Display Error
			
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
}

-(void) setupArtworkViewsFromURL:(NSURL *) url {
	[TBDHTTPRequest GetRequestForImageFromURL:url CompletionHandler:^(UIImage *image) {
		if (image.size.width > 0){
			// Artwork Received Successfully
			
			self.backgroundArtworkImageView.image = [image copy];
			self.trackArtWorkImageView.image = [image copy];
		}else {
			// Artwork Not Found - Display TBD Default Placeholder
			
			
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


@end
