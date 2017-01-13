//
//  TBDUserDefaults.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 1/12/17.
//  Copyright © 2017 Jonathan Danek. All rights reserved.
//

#import "TBDUserDefaults.h"

NSString *const kFirstTimeLaunching = @"first";
NSString *const kDropBuildupTime = @"drop_buildup";
NSString *const kEnforceHiResArtwork = @"enforce_highres";

static int kDropBuildupTimeDefault = 15;
static BOOL kEnforceHiResArtworkDefault = false;

@implementation TBDUserDefaults

+(BOOL) IsFirstTimeLaunching {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:kFirstTimeLaunching] == NULL) {
		// First Time Launching - Set Default Values
		[[NSUserDefaults standardUserDefaults] setBool:false forKey:kFirstTimeLaunching];
		[[NSUserDefaults standardUserDefaults] setInteger:kDropBuildupTimeDefault forKey:kDropBuildupTime];
		[[NSUserDefaults standardUserDefaults] setInteger:kEnforceHiResArtworkDefault forKey:kEnforceHiResArtwork];
		
		return true;
	}
	
	return false;
}

+(int) GetDropBuildUpTime {
	return (int)[[NSUserDefaults standardUserDefaults] integerForKey:kDropBuildupTime];
}
+(void) SetDropBuildupTime:(int)time {
	[[NSUserDefaults standardUserDefaults] setInteger:time forKey:kDropBuildupTime];
}

+(BOOL) GetEnforceHiResImageSetting {
	return [[NSUserDefaults standardUserDefaults] boolForKey:kEnforceHiResArtwork];
}
+(void) SetEnforceHiResImageSetting:(BOOL)setting {
	[[NSUserDefaults standardUserDefaults] setBool:setting forKey:kEnforceHiResArtwork];
}

@end
