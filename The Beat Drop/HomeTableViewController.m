//
//  HomeTableViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "HomeTableViewController.h"
#import "TBDTrack.h"
#import "TBDHTTPRequest.h"
#import "DropPlayerViewController.h"
#import "TBDFileIO.h"

// Storyboard Constants
NSString *const kDropPlayerStoryboardName = @"DropPlayerViewController";
NSString *const kCellIdentifier = @"trackCell";

// User Interface Constants
NSString *const kDropPlayerTimeOutErrorTitle = @"Connection Timed Out";
NSString *const kDropPlayerTimeOutErrorBody = @"You may not have a good connection to the internet, or the song you are trying to play is too large.";

NSString *const kDropPlayerUnexplainedErrorTitle = @"Unexpected Error";
NSString *const kDropPlayerUnexplainedErrorBody = @"Something went wrong. If this error persists try removing the track and adding it again.";

NSString *const kDropPlayerNoDropSelectedErrorTitle = @"You Didnt Select a Drop!";
NSString *const kDropPlayerNoDropSelectedErrorBody = @"Make sure you click the \"Select Drop\" button once you are at the drop position!";


@interface HomeTableViewController ()

@property(nonatomic, retain) NSArray *trackArray;

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Setup Notification Center Selector To Respond to SoundCloud Search/Selection Table View
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedSoundCloudtrack:) name:@"selectedSoundCloudtrack" object:nil];
	
	
	// Register Custom TableViewCell to be used as Reuseable cell
	[self.tableView registerNib:[UINib nibWithNibName:@"TrackTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
	
	// Allow View to Control Presented Views
	self.definesPresentationContext = true;
	
	// Allow selection while in editing mode - This is an easy way to disable editing mode
	self.tableView.allowsSelectionDuringEditing = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trackArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
	
	// Get Pointer for Track associated with Specific Cell
	TBDTrack *track = [self.trackArray objectAtIndex:indexPath.row];
	
	// Set Cell's Labels and image to track data
	cell.trackTitle.text = [track name];
	cell.trackArtist.text = [track artist];
	
	// Set Cell's Delegate to self to ensure customg gesture selectors are called when applicable
	cell.delegate = self;
	
	// Request Track's artwork from soundcloud. Leave image blank until request returns a value
	cell.trackArtwork.image = nil;
	[TBDHTTPRequest GetRequestForImageFromURL:[track artworkURL] CompletionHandler:^(UIImage *image) {
		if(image.size.width > 0){
			// Image received
			cell.trackArtwork.image = image;
		}else {
			// Image not received
			// Usually due to no artwork on soundcloud
			// Set to placeholder image
			cell.trackArtwork.image = [UIImage imageNamed:@"Artwork"];
		}
	}];
	
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	DropPlayerViewController *dropPlayer = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kDropPlayerStoryboardName];

	[self.navigationController presentViewController:dropPlayer animated:YES completion:^{
		// Add extra elemenets such as waveform and cancel all loading animations
		[dropPlayer giveTrackForPlaying:[self.trackArray objectAtIndex:indexPath.row]];
		dropPlayer.homeTableViewCallback = self;
	}];
}

-(void) trackTableViewCell:(TrackTableViewCell *)track didReceiveLongPress:(UILongPressGestureRecognizer *)gesture {
	// Long Pressed Recognized for cell
	UIAlertController *trackOptions = [UIAlertController alertControllerWithTitle:@"Track Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		// Delete Track Called
		NSIndexPath* pathOfCell = [self.tableView indexPathForCell:track];
		[self removeTrackFromArray:[self.trackArray objectAtIndex:pathOfCell.row]];
	}];
	UIAlertAction *moveAction = [UIAlertAction actionWithTitle:@"Move" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		// Move Track Called
		[self.tableView setEditing:true];
	}];
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

	[trackOptions addAction:deleteAction];
	[trackOptions addAction:moveAction];
	[trackOptions addAction:cancelAction];
	
	[trackOptions setModalPresentationStyle:UIModalPresentationFormSheet];
	
	[self presentViewController:trackOptions animated:YES completion:^{
		// Did Present Track Options Menu
		
	}];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	TBDTrack *from  = [self.trackArray objectAtIndex:fromIndexPath.row];
	
	NSMutableArray *trackArray = [self.trackArray mutableCopy];
	
	[trackArray replaceObjectAtIndex:fromIndexPath.row withObject:[self.trackArray objectAtIndex:toIndexPath.row]];
	[trackArray replaceObjectAtIndex:toIndexPath.row withObject:from];
	
	self.trackArray = trackArray;
	
	// Save New Data To Disk
	[TBDFileIO SaveObjectsToFile:self.trackArray];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Data Interface

-(void) giveTrackData:(NSArray *)tracks {
	self.trackArray = tracks;
	[self.tableView reloadData];
}

-(void) giveTrack:(id)track withStatusCode:(DropTableStatus)statusCode {
	switch (statusCode) {
		case SUCCESS_DROP_SELECTED:
			// New Drop Selected
			// Add to Track List and Save to Disk
			[self addNewTrackToArray:track];
			break;
		case SUCCESS_DROP_PLAYED:
			// Track Played
			// Do nothing
			break;
		case ERROR_TIMEOUT:
			// Error Loading
			// Display Timed Out Message
			[self displayAlertWithMessageTitle:kDropPlayerTimeOutErrorTitle andbody:kDropPlayerTimeOutErrorBody];
			break;
		case ERROR_NO_DROP_SELECTED:
			// Error User
			// Closed Before
			[self displayAlertWithMessageTitle:kDropPlayerNoDropSelectedErrorTitle andbody:kDropPlayerNoDropSelectedErrorBody];
			break;
		case ERROR_UNEXPLAINED:
			// Something went terrible wrong
			[self displayAlertWithMessageTitle:kDropPlayerUnexplainedErrorTitle andbody:kDropPlayerUnexplainedErrorBody];
			break;
		case OPTION_NEXT_TRACK:
			
			break;
		case OPTION_PREV_TRACK:
			
			break;
		default:
			break;
	}
}

// Selector for Notifcation To Add Track to Drop List
//		Must Open Music Player to select drop location
//		Then add track to tracklist
-(void) selectedSoundCloudtrack:(NSNotification *)notis {
	
	// Create View Controller from Storyboard ID
	DropPlayerViewController *dropPlayer = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kDropPlayerStoryboardName];
	
		// Present View Controller after the information was recieved
	[self.navigationController presentViewController:dropPlayer animated:YES completion:^{
		// Add extra elemenets such as waveform and cancel all loading animations
		[dropPlayer giveTrackForEditing:notis.object];
		dropPlayer.homeTableViewCallback = self;
	}];
	
}

-(void) addNewTrackToArray:(TBDTrack *)newTrack {
	NSMutableArray *trackArrayPlusTrack = [self.trackArray mutableCopy];
	[trackArrayPlusTrack addObject:newTrack];
	self.trackArray = [trackArrayPlusTrack copy];
	
	// Reload TableView
	[self.tableView reloadData];
	
	// Save New Data To Disk
	[TBDFileIO SaveObjectsToFile:self.trackArray];
}

-(void) removeTrackFromArray:(TBDTrack *)track {
	NSMutableArray *trackArrayPlusTrack = [self.trackArray mutableCopy];
	[trackArrayPlusTrack removeObject:track];
	self.trackArray = [trackArrayPlusTrack copy];
	
	// Reload TableView
	[self.tableView reloadData];
	
	// Save Data To Disk
	[TBDFileIO SaveObjectsToFile:self.trackArray];
}

#pragma mark - User Interface

-(void) displayAlertWithMessageTitle:(NSString *)title andbody:(NSString *)body {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:body preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
	
	[alert addAction:dismissAction];
 
	[self presentViewController:alert animated:YES completion:nil];
}

@end
