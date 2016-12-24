//
//  HomeTableViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "HomeTableViewController.h"
#import "TBDTrack.h"
#import "TrackTableViewCell.h"
#import "TBDHTTPRequest.h"
#import "DropPlayerViewController.h"

NSString *const kDropPlayerStoryboardName = @"DropPlayerViewController";

@interface HomeTableViewController (){
	NSArray *trackArray;
}

@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// Setup Notification Center Selector To Respond to SoundCloud Search/Selection Table View
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedSoundCloudtrack:) name:@"selectedSoundCloudtrack" object:nil];
	
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
    return [trackArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
	
	// Get Pointer for Track associated with Specific Cell
	TBDTrack *track = [trackArray objectAtIndex:indexPath.row];
	
	// Set Cell's Labels and image to track data
	cell.trackTitle.text = [track name];
	cell.trackArtist.text = [track artist];
	
	// Request Track's artwork from soundcloud. Leave image blank until request returns a value
	cell.trackArtwork.image = NULL;
	[TBDHTTPRequest GetRequestForImageFromURL:[track artworkURL] CompletionHandler:^(UIImage *image) {
		if(image.size.width > 0){
			// Image received
			cell.trackArtwork.image = image;
		}else {
			// Image not received
			// Usually due to no artwork on soundcloud
			// Set to placeholder image
			
		}
	}];
	
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/




#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Data Interface

-(void) giveTrackData:(NSArray *)tracks {
	
}


// Selector for Notifcation To Add Track to Drop List
//		Must Open Music Player to select drop location
//		Then add track to tracklist
-(void) selectedSoundCloudtrack:(NSNotification *)notis {
	NSLog(@"%@", notis.object);
	
	DropPlayerViewController *dropPlayer = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:kDropPlayerStoryboardName];
	
	
	[self.navigationController presentViewController:dropPlayer animated:YES completion:^{
		// On Completion
		[dropPlayer giveTrackForEditing:notis.object];
	}];
	
	
}

@end
