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
#import "LoadingTableViewCell.h"
#import "TBDFeaturedTracks.h"

@interface SoundcloudSearchTableViewController (){
	NSMutableArray *trackArray;
}

@property (nonatomic,assign) BOOL loading;
@property (nonatomic,assign) BOOL noresults;

@end

NSString *const kTrackCellIdentifier = @"trackCell";
NSString *const kLoadingCellIdentifier = @"loadingCell";

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
	[self.tableView registerNib:[UINib nibWithNibName:@"TrackTableViewCell" bundle:nil] forCellReuseIdentifier:kTrackCellIdentifier];
	[self.tableView registerNib:[UINib nibWithNibName:@"LoadingTableViewCell" bundle:nil] forCellReuseIdentifier:kLoadingCellIdentifier];
	
	// Set property's defualt values
	self.loading = false;
	self.noresults = false;
	
	// Get Featured Track List
	[self performSelectorInBackground:@selector(getFeaturedTracksAndOnCompletion) withObject:nil];
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
	return (self.loading || self.noresults) ? 1 : [trackArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.loading || self.noresults) {
		LoadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLoadingCellIdentifier];
		
		if (self.loading){
			[cell.activityIndicator setHidden:false];
			[cell.activityIndicator performSelectorOnMainThread:@selector(startAnimating) withObject:nil waitUntilDone:NO];
			[cell.noResultsFoundLabel setHidden:true];
		}else {
			[cell.activityIndicator performSelectorOnMainThread:@selector(stopAnimating) withObject:nil waitUntilDone:NO];
			[cell.activityIndicator setHidden:true];
			[cell.noResultsFoundLabel setHidden:false];
		}
		
		return cell;
	}else {
		TrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrackCellIdentifier];
		
		// Get Pointer for Track associated with Specific Cell
		TBDTrack *track = [trackArray objectAtIndex:indexPath.row];
		
		// Set Cell's Labels and image to track data
		cell.trackTitle.text = [track name];
		cell.trackArtist.text = [track artist];
		
		// Request Track's artwork from soundcloud. Leave image blank until request returns a value
		cell.trackArtwork.image = nil;
		
		[TBDHTTPRequest GetRequestForImageFromURL:[track getSamllArtworkURL] CompletionHandler:^(UIImage *image) {
			if(image.size.width > 0){
				// Image received
				cell.trackArtwork.image = image;
			}else {
				// Image not received
				// Usually due to no artwork on soundcloud
				// Set to TBD placeholder
				cell.trackArtwork.image = [UIImage imageNamed:@"Artwork"];
			}
		}];
		return cell;
	}
	
	return NULL;
}

#pragma mark - SearchBar

-(void) updateSearchResultsForSearchController:(UISearchController *)searchController{
	
}
-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	// Todo: move space encoding to HTTPRequest Class
	[self performSelectorInBackground:@selector(searchRequestWithKeyword:) withObject:[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
	
	[self performSelectorOnMainThread:@selector(displayLoadingCell) withObject:nil waitUntilDone:NO];
	
	// Dismiss Search Bar to allow user to cancel to home table view
	self.searchController.active = false;

}

#pragma mark - Search Methods

-(void) searchRequestWithKeyword:(NSString *)keyword {
	[TBDSoundcloud GetSearchResultsForQuery:keyword OnCompletion:^(NSArray *array) {
		[self performSelectorOnMainThread:@selector(updateTableDataWith:) withObject:array waitUntilDone:NO];
	}];
}

#pragma mark - Featured tracks

-(void) getFeaturedTracksAndOnCompletion{
	[TBDFeaturedTracks GetFeaturedTracksAndOnCompletion:^(NSArray *array) {
		if ([trackArray count] == 0) {
			trackArray = [array mutableCopy];
			[self.tableView reloadData];
		}
	}];
}

#pragma mark - User Interface Updates

-(void) updateTableDataWith:(NSArray *)newData {
	// Replace Current Table Data with Newly Recived Search Data
	trackArray = [newData copy];
	
	// If no results dispaly no results found label
	self.loading = false;
	if ([trackArray count] == 0) {
		self.noresults = true;
	}else {
		self.noresults = false;
	}
	// Reload TableView will new Data
	[self.tableView reloadData];
	
}

-(void) displayLoadingCell {
	// Set loading property to true
	self.loading = true;
	
	// Call reload to display loading indicator
	[self.tableView reloadData];
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
