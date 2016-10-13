//
//  TBDHTTPRequest.h
//  The Beat Drop
//
//  Created by Jonathan Danek on 10/12/16.
//  Copyright © 2016 Jonathan Danek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBDHTTPRequest : NSObject

/// Sends HTTP Get request and parses response to an NSString
+(void) GetRequestForStringFromURL:(NSURL *)url CompletionHandler:(void (^)(NSString *response))handler;

/// Sends HTTP Get request and parses response to an NSDictionary
+(void) GetRequestForJSONFromURL:(NSURL *)url CompletionHandler:(void (^)(NSDictionary *response))handler;

/// Sends HTTP Get request and parses response to a UIImage
+(void) GetRequestForImageFromURL:(NSURL *)url CompletionHandler:(void (^)(UIImage *image))handler;

/// Sends HTTP Get request and returns unaltered NSData
+(void) GetRequestForDataFromURL:(NSURL *)url CompletionHandler:(void (^)(NSData *data))handler;

@end
