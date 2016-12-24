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


@interface DropPlayerViewController ()

@property(nonatomic, retain) TBDAudioPlayer *audioPlayer;
@property(nonatomic, retain) UIImageView *soundWaveImageView;

@end


@implementation DropPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) giveTrackForEditing:(TBDTrack *)track {
	NSLog(@"Editing: %@", track);
	
	[self basicSetupForTrack:track andOnCompletion:^{
		
	}];
}

-(void) giveTrackForPlaying:(TBDTrack *)track {
	NSLog(@"Playing: %@", track);
	
	[self basicSetupForTrack:track andOnCompletion:^{
		
	}];
}

#pragma mark - Setup 

-(void) basicSetupForTrack:(TBDTrack *)track andOnCompletion:(void (^)())completion {
	[self performSelectorOnMainThread:@selector(loadingBegan) withObject:nil waitUntilDone:YES];
	[self performSelector:@selector(setupLabelsForTitle:andArtist:) withObject:track.name withObject:track.artist];
	[self performSelectorOnMainThread:@selector(setupSoundWaveForTrack:) withObject:track waitUntilDone:YES];
	
	[self performSelectorInBackground:@selector(setupArtworkViewsFromURL:) withObject:track.getArtworkURL];
	[self performSelectorInBackground:@selector(setupAudioPlayerWithTrack:) withObject:track];
}

#pragma mark - UI Actions

- (IBAction)closeButtonPressed:(id)sender {
	
}

#pragma mark - Touch Actions



#pragma mark - Audio Methods

-(void) setupAudioPlayerWithTrack:(TBDTrack *)track {
	self.audioPlayer = [[TBDAudioPlayer alloc] initWithTrack:track];
}

#pragma mark - UI Handlers

-(void) loadingBegan {
	// Hide Play/Pause Button
	[self.playPauseButton setHidden:TRUE];
	
	// Display Activity Indicator and begin animating
	[self.activityIndicator setHidden:false];
	[self.activityIndicator startAnimating];
}

-(void) loadingEnded {
	// Stop Activity Indicator and hide
	[self.activityIndicator stopAnimating];
	[self.activityIndicator setHidden:true];
	
	// Show Play/Pause Button
	[self.playPauseButton setHidden:false];
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
	CGRect newBounds = [self.trackPositionImage convertRect:self.trackPositionImage.bounds toView:self.view];
	self.soundWaveImageView = [[UIImageView alloc] init];
	[self.view addSubview:self.soundWaveImageView];
	[TBDHTTPRequest GetRequestForImageFromURL:track.soundwaveURL CompletionHandler:^(UIImage *image) {
		[self.soundWaveImageView performSelectorOnMainThread:@selector(setImage:) withObject:[self convertToMask:image] waitUntilDone:YES];
		[self.soundWaveImageView setAlpha:0.7f];
		[self.soundWaveImageView setFrame:CGRectMake(newBounds.origin.x, newBounds.origin.y, track.duration/100, newBounds.size.height)];
	}];
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
