//
//  NSDictionary+ExceptionHandling.m
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/15/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import "NSDictionary+ExceptionHandling.h"

@implementation NSDictionary (ExceptionHandling)

-(NSURL *) GetURLForKeyPath:(NSString *)path  {
	NSString *pathValue = [self GetValueForKeyPath:path];
	if (![pathValue isKindOfClass:[NSNull class]]) {
		return [NSURL URLWithString:pathValue];
	}
	return NULL;
}

-(NSString *) GetValueForKeyPath:(NSString *)path  {
	NSString *returnObject = nil;
	@try {
		returnObject = [self valueForKeyPath:path];
	} @catch (NSException *exception) {
		returnObject = NULL;
	} @finally {
		return returnObject;
	}
}

@end
