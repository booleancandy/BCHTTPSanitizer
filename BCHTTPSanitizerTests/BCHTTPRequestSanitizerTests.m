//
//  BCHTTPRequestSanitizerTests.m
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 6/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCHTTPRequestSantizer.h"

@interface BCHTTPRequestSanitizerTests : XCTestCase
@property (nonatomic,strong) BCHTTPRequestSantizer *sanitizer;
@end

@implementation BCHTTPRequestSanitizerTests

#pragma mark - Setup and teardown

- (void)setUp
{
    self.sanitizer = [[BCHTTPRequestSantizer alloc] init];
}

#pragma mark - Tests

- (void)testPassThroughRequest
{
    NSURL *url = [NSURL URLWithString:@"http://localhost"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLRequest *result = [self.sanitizer sanitizeRequest:request];
    
    XCTAssertEqualObjects(request, result, @"Sanitised response not unchanged");
}

- (void)testRedactRequestWithHeaders
{
    NSURL *url = [NSURL URLWithString:@"http://localhost"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSString *headerName = @"Secret-Token";
    request.allHTTPHeaderFields = @{headerName: @"secret"};
    
    [self.sanitizer redactValueForHeader:headerName];
    NSURLRequest *result = [self.sanitizer sanitizeRequest:request];
    
    XCTAssertEqualObjects([result.allHTTPHeaderFields valueForKey:headerName], @"REDACTED", @"Header field not redacted");
}

@end
