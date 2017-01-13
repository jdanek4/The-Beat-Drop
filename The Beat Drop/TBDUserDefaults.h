//
//  TBDUserDefaults.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/12/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBDUserDefaults : NSObject

+(BOOL) IsFirstTimeLaunching;

+(int) GetDropBuildUpTime;
+(void) SetDropBuildupTime:(int)time;

+(BOOL) GetEnforceHiResImageSetting;
+(void) SetEnforceHiResImageSetting:(BOOL)setting;

@end
