//
//  BCHTTPSanitizer.m
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 7/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

#import "BCHTTPSanitizer.h"

@interface BCHTTPSanitizer()
@property (nonatomic,strong) NSMutableArray *redactedHeaderNames;
@property (nonatomic,strong) NSMutableArray *redactedJSONKeyPaths;
@end

@implementation BCHTTPSanitizer

- (id)init
{
    self = [super init];
    
    if (self) {
        self.redactedHeaderNames = [NSMutableArray array];
        self.redactedJSONKeyPaths = [NSMutableArray array];
    }
    
    return self;
}

- (void)redactValueForHeader:(NSString *)headerName
{
    [self.redactedHeaderNames addObject:headerName];
}

- (void)redactJSONKeyPath:(NSString *)keyPath
{
    [self.redactedJSONKeyPaths addObject:keyPath];
}

- (NSDictionary *)sanitizeHeaders:(NSDictionary *)headers
{
    NSMutableDictionary *result = [headers mutableCopy];
    
    for (NSString *headerName in self.redactedHeaderNames) {
        if ([headers objectForKey:headerName])
            [result setValue:@"REDACTED" forKey:headerName];
    }
    
    return result;
}

- (id)sanitizeObject:(id)object
{
    object = [object mutableCopy];

    for (NSString *keyPath in self.redactedJSONKeyPaths) {

        // KVC expresses unhappiness at non-compliance by throwing an exception

        @try {
            if ([object valueForKeyPath:keyPath])
                [object setValue:@"REDACTED" forKeyPath:keyPath];
        }
        @catch (NSException *exception) {
        }
    }

    return object;
}

- (NSData *)sanitizeBody:(NSData *)body
{
    if (!body)
        return body;
    
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    
    if (error)
        return body;

    result = [self sanitizeObject:result];
    
    return [NSJSONSerialization dataWithJSONObject:result options:0 error:nil];
}

@end
