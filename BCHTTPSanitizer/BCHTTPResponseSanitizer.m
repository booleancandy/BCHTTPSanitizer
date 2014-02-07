//
//  BCHTTPResponseSanitizer.m
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 6/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

#import "BCHTTPResponseSanitizer.h"

@interface BCHTTPResponseSanitizer()
@property (nonatomic,strong) NSMutableArray *redactedHeaderNames;
@property (nonatomic,strong) NSMutableArray *redactedJSONKeyPaths;
@end

@implementation BCHTTPResponseSanitizer

- (NSHTTPURLResponse *)sanitizeResponse:(NSHTTPURLResponse *)response
{
    return [[NSHTTPURLResponse alloc] initWithURL:response.URL
                                       statusCode:response.statusCode
                                      HTTPVersion:@"HTTP/1.1" // No accessor for this property???
                                     headerFields:[self sanitizeHeaders:response.allHeaderFields]];
}

@end
