//
//  BCHTTPRequestSanitizer.m
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 6/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

#import "BCHTTPRequestSantizer.h"

@implementation BCHTTPRequestSantizer

- (NSURLRequest *)sanitizeRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *result = [request mutableCopy];
    result.allHTTPHeaderFields = [self sanitizeHeaders:result.allHTTPHeaderFields];
    return result;
}

@end
