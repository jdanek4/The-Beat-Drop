//
//  TBDReachability.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 12/23/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "TBDReachability.h"
#import "Reachability.h"
#import "TBDUserDefaults.h"

@implementation TBDReachability

static int kQualityOverride = 0;

/// Block Handler used to differentiate between different network statuses
+(void) PerformBlockWithNetworkConsideration:(void (^)(NSInteger status))handler {
	
	// Check if High Quality Setting is Enabled
	if ([TBDUserDefaults GetEnforceHiResImageSetting]) {
		kQualityOverride = 1;
	}
	
	//
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [reachability currentReachabilityStatus];
	
	
	switch (networkStatus) {
		case NotReachable:
			handler(0);
			break;
		case ReachableViaWWAN:
			handler(1+kQualityOverride);
			break;
		case ReachableViaWiFi:
			handler(2);
			break;
	default:
			handler(1);
			break;
	}
	
}

@end
