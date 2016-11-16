//
//  TBDFileIO.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 11/2/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDFileIO.h"
#import "TBDSoundcloud.h"

@implementation TBDFileIO

NSString *const kTrackNameKey = @"TrackName";
NSString *const kTrackArtistKey = @"TrackArtist";
NSString *const kTrackDropTimeKey = @"DropTime";
NSString *const kTrackIDKey = @"TrackID";


+(void)SaveObjectsToFile:(NSArray *)objects{
	
	//Create an NSArray of NSDictionaries
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSMutableDictionary *tempDict;
	
	// Load TBDTrack data into NSDictionary before adding it to the NSArray
	for (TBDTrack *temp in objects) {
		tempDict = [[NSMutableDictionary alloc] init];
		[tempDict setObject:temp.name forKey:kTrackNameKey];
		[tempDict setObject:temp.artist forKey:kTrackArtistKey];
		[tempDict setValue:[[NSNumber numberWithInt:temp.trackID] stringValue] forKey:kTrackIDKey];
		[tempDict setObject:[[NSNumber numberWithDouble:temp.dropTime] stringValue] forKey:kTrackDropTimeKey];
		
		[array addObject:tempDict];
	}
	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
	
	// Write NSArray of NSDictionaries to Disk
	
	if([data writeToFile:[TBDFileIO getFilePath] atomically:YES]){
		// Successfuly wrote data to file
	}else {
		// Error writing data to file
	}
	
}

+(NSArray *)GetObjectsFromFile {
	
	// Load PList File into NSArray and iterate through array gathering data of each track
	NSArray *dropFileArray = [NSKeyedUnarchiver unarchiveObjectWithFile:[TBDFileIO getFilePath]];
	
	NSMutableArray *trackArray = [NSMutableArray array];
	
	TBDTrack *temp;
	for (NSDictionary *dropData in dropFileArray) {
		temp = [[TBDTrack alloc] init];
		temp.name = [dropData objectForKey:kTrackNameKey];
		temp.artist = [dropData objectForKey:kTrackArtistKey];
		temp.trackID = [[dropData objectForKey:kTrackIDKey] intValue];
		temp.dropTime = [[dropData objectForKey:kTrackDropTimeKey] doubleValue];
		
		[trackArray addObject:temp];
		
		// Request Track from Soundcloud and then verify saved data matches received data to ensure consistancy
		
		[TBDSoundcloud GetTrackInfoFromID:[[dropData objectForKey:kTrackIDKey] intValue] OnCompletion:^(TBDTrack *track) {
			if([TBDFileIO  testSavedData:dropData ToSoundcloudData:track]){
				// Data Parity Consistent - Add Track to Array after setting Drop Time of Saved Value
				[track setDropTime:temp.dropTime];
				[trackArray addObject:track];
			}else {
				// Data Parity Non-Consistent - Set Drop Time to -1.0f and add track to array.
				// Setting Drop time to -1.0f will be used in the HomeTableViewController
				// to alert user their track will be unplayable and removed from list.
				// -1.0f was used as drop time should never be -1.0f
				
				[track setDropTime:-1.0f];
				[trackArray addObject:track];
				
			}
		}];
		
	}
	
	return trackArray;
}

+(BOOL) DoesFileExist {
	return [[NSFileManager defaultManager] fileExistsAtPath:[TBDFileIO getFilePath]];
}

+(NSString *)getFilePath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString *path = [paths objectAtIndex:0];
	path = [path stringByAppendingPathComponent:@"drops.plist"];
	return path;
}

+(BOOL) testSavedData:(NSDictionary *)savedData ToSoundcloudData:(TBDTrack *)requestedData {
	
	// Track Title Check
	if(![[savedData objectForKey:kTrackNameKey] isEqualToString:requestedData.name]){
		return false;
	}
	// Track Artist Check
	else if(![[savedData objectForKey:kTrackArtistKey] isEqualToString:requestedData.artist]){
		return false;
	}
	// Track ID Check
	else if(!([[savedData objectForKey:kTrackIDKey] intValue] == requestedData.trackID)){
		return false;
	}
	
	return true;

}

@end
