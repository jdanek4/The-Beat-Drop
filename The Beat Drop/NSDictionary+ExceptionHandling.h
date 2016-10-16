//
//  NSDictionary+ExceptionHandling.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/15/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ExceptionHandling)

-(NSURL *) GetURLForKeyPath:(NSString *)path;
-(NSString *) GetValueForKeyPath:(NSString *)path;

@end
