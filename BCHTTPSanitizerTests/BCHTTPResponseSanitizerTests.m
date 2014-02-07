//
//  BCHTTPResponseSanitizerTests.m
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 6/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCHTTPResponseSanitizer.h"

@interface BCHTTPResponseSanitizerTests : XCTestCase
@property (nonatomic,strong) BCHTTPResponseSanitizer *sanitizer;
@end

@implementation BCHTTPResponseSanitizerTests

#pragma mark - Setup and teardown

- (void)setUp
{
    self.sanitizer = [[BCHTTPResponseSanitizer alloc] init];
}

#pragma mark - Tests

- (void)testPassThroughResponse
{
    NSURL *url = [NSURL URLWithString:@"http://localhost"];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{}];
    
    NSHTTPURLResponse *result = [self.sanitizer sanitizeResponse:response];
    
    // NSHTTPURLResponse#isEqual doesn't seem to work
    XCTAssertEqualObjects(response.URL, result.URL, @"Response URL was different");
    XCTAssertEqual(response.statusCode, result.statusCode, @"Response status code was different");
    XCTAssertEqualObjects(response.allHeaderFields, result.allHeaderFields, @"Response headers were different");
}

- (void)testRedactResponseWithHeaders
{
    NSURL *url = [NSURL URLWithString:@"http://localhost"];
    NSString *headerName = @"Secret-Token";
    NSDictionary *headers = @{headerName: @"secret"};
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url statusCode:200 HTTPVersion:@"1.1" headerFields:headers];
    
    [self.sanitizer redactValueForHeader:headerName];
    NSHTTPURLResponse *result = [self.sanitizer sanitizeResponse:response];
    
    XCTAssertEqualObjects([result.allHeaderFields valueForKey:headerName], @"REDACTED", @"Header field not redacted");
}

@end
