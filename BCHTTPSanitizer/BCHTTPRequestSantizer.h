//
//  BCHTTPRequestSanitizer.h
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 6/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

//
// Classes to encapsulate sanitising sensitive information from HTTP requests
// and responses so they can be safely logged or otherwise distributed.
//

#import "BCHTTPSanitizer.h"

@interface BCHTTPRequestSantizer : BCHTTPSanitizer

- (NSURLRequest *)sanitizeRequest:(NSURLRequest *)request;

@end
