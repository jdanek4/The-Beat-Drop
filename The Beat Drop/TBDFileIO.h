//
//  TBDFileIO.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 11/2/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBDFileIO : NSObject

/// Saves NSArray of TBDTracks to PList File
+(void) SaveObjectsToFile:(NSArray *)objects;
/// Returns NSArray of TBDTracks loaded from Plist File
+(NSArray *) GetObjectsFromFile;
/// Checks if Data File Exists. Doesn't exist if first opening of app.
+(bool) DoesFileExist;

@end
