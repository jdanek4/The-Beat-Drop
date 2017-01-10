//
//  HomeTableViewController.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/21/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrackTableViewCell.h"

typedef enum DropTableStatus {
	ERROR_NO_DROP_SELECTED = 1,
	ERROR_TIMEOUT,
	ERROR_UNEXPLAINED,
	SUCCESS_DROP_SELECTED,
	SUCCESS_DROP_PLAYED,
	OPTION_PREV_TRACK,
	OPTION_NEXT_TRACK
} DropTableStatus;

@interface HomeTableViewController : UITableViewController <TrackTableGestureDelegate>


-(void) giveTrackData:(NSArray *)tracks;

-(void) giveTrack:(id)track withStatusCode:(DropTableStatus)statusCode;

@end
