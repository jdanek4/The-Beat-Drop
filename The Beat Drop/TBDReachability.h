//
//  TBDReachability.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 12/23/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBDReachability : NSObject

+(void) PerformBlockWithNetworkConsideration:(void (^)(NSInteger status))handler;

@end
