//
//  SoundcloudSearchTableViewController.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "SoundcloudSearchTableViewController.h"
#import "TBDTrack.h"
#import "TrackTableViewCell.h"
#import "TBDSoundcloud.h"
#import "TBDHTTPRequest.h"
#import "HomeTableViewController.h"

@interface SoundcloudSearchTableViewController (){
	NSMutableArray *trackArray;
}

@end

NSString *const cellIdentifier = @"trackCell";

@implementation SoundcloudSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	trackArray = [NSMutableArray array];

	// Setup SearchController Object and Set User Interface settings
	self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
	self.searchController.searchResultsUpdater = self;
	self.searchController.searchBar.placeholder = nil;
	[self.searchController.searchBar sizeToFit];
	self.tableView.tableHeaderView = self.searchController.searchBar;
	self.searchController.delegate = self;
	self.searchController.dimsBackgroundDuringPresentation = YES;
	self.searchController.searchBar.delegate = self;
	self.definesPresentationContext = YES;
	
	// Register Custom TableViewCell to be used as Reuseable cell
	[self.tableView registerNib:[UINib nibWithNibName:@"TrackTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
	
	// TODO: Implement Featured Track List
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
	
	TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

	// Get Pointer for Track associated with Specific Cell
	TBDTrack *track = [trackArray objectAtIndex:indexPath.row];
	
	// Set Cell's Labels and image to track data
	cell.trackTitle.text = [track name];
	cell.trackArtist.text = [track artist];
	
	// Request Track's artwork from soundcloud. Leave image blank until request returns a value
	cell.trackArtwork.image = NULL;
	
	[TBDHTTPRequest GetRequestForImageFromURL:[track getSamllArtworkURL] CompletionHandler:^(UIImage *image) {
		if(image.size.width > 0){
			// Image received
			cell.trackArtwork.image = image;
		}else {
			// Image not received
			// Usually due to no artwork on soundcloud
			// Set to TBD placeholder
			
		}
	}];
	
	
	return cell;
}

#pragma mark - SearchBar

-(void) updateSearchResultsForSearchController:(UISearchController *)searchController{
	
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"Searchbar: Search Button Clicked");
	// Todo: move space encoding to HTTPRequest Class
	[self performSelectorInBackground:@selector(searchRequestWithKeyword:) withObject:[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
}
-(void) searchBarTextDidEndEditing:(UISearchBar *)searchBar {
	NSLog(@"Searchbar: Text Did End Editing");
}

#pragma mark - Search Methods

-(void) searchRequestWithKeyword:(NSString *)keyword {
	[TBDSoundcloud GetSearchResultsForQuery:keyword OnCompletion:^(NSArray *array) {
		[self performSelectorOnMainThread:@selector(updateTableDataWith:) withObject:array waitUntilDone:NO];
	}];
}

#pragma mark - User Interface Updates

-(void) updateTableDataWith:(NSArray *)newData {
	// Replace Current Table Data with Newly Recived Search Data
	trackArray = [newData copy];
	
	// Reload TableView will new Data
	[self.tableView reloadData];
	
	// Dismiss Search Controller
	self.searchController.active = false;
}

#pragma mark - Navigation

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Song Selected
	
	__block TBDTrack *selectedTrack = [trackArray objectAtIndex:indexPath.row];
	
	[self.navigationController dismissViewControllerAnimated:YES completion:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"selectedSoundCloudtrack" object:selectedTrack];
	}];
	
}

- (IBAction)cancelButtonPressed:(id)sender {
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
@end
