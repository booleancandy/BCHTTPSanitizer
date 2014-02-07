//
//  BCHTTPSanitizer.h
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 7/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

//
// Classes to encapsulate sanitising sensitive information from HTTP requests
// and responses so they can be safely logged or otherwise distributed.
//

@interface BCHTTPSanitizer : NSObject

- (void)redactValueForHeader:(NSString *)headerName;
- (void)redactJSONKeyPath:(NSString *)keyPath;

- (NSData *)sanitizeBody:(NSData *)body;
- (NSDictionary *)sanitizeHeaders:(NSDictionary *)headers;

@end
