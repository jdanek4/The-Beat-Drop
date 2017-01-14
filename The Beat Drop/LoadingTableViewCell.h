//
//  LoadingTableViewCell.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/13/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *noResultsFoundLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;\
@end
