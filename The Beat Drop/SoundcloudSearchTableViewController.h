//
//  SoundcloudSearchTableViewController.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SoundcloudSearchTableViewController : UITableViewController <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;

- (IBAction)cancelButtonPressed:(id)sender;

@end
