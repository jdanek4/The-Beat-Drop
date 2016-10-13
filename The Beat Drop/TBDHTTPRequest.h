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

+(void) GetRequestForStringFromURL:(NSURL *)url CompletionHandler:(void (^)(NSString *response))handler;
+(void) GetRequestForJSONFromURL:(NSURL *)url CompletionHandler:(void (^)(NSDictionary *response))handler;
+(void) GetRequestForImageFromURL:(NSURL *)url CompletionHandler:(void (^)(UIImage *image))handler;

@end
