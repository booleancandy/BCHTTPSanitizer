//
//  BCHTTPSanitizerTests.m
//  BCHTTPSanitizer
//
//  Created by Tim Potter on 7/02/2014.
//  Copyright (c) 2014 Boolean Candy Pty Ltd. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCHTTPSanitizer.h"

@interface BCHTTPSanitizerTests : XCTestCase
@property (nonatomic,strong) BCHTTPSanitizer *sanitizer;
@end

@implementation BCHTTPSanitizerTests

#pragma mark - Setup and teardown

- (void)setUp
{
    self.sanitizer = [[BCHTTPSanitizer alloc] init];
}

#pragma mark - Test redacting headers

- (void)testRedactHeaderValue
{
    NSString *privateHeaderName = @"Secret-Token";
    NSString *publicHeaderName = @"Not-Secret-Token";
    NSDictionary *headers = @{privateHeaderName: @"secretvalue", publicHeaderName: @"bar"};
    
    [self.sanitizer redactValueForHeader:privateHeaderName];
    NSDictionary *result = [self.sanitizer sanitizeHeaders:headers];
    
    XCTAssertEqualObjects([result objectForKey:privateHeaderName], @"REDACTED", @"Private header value not redacted");
    XCTAssertNotEqualObjects([result objectForKey:publicHeaderName], @"REDACTED", @"Public header value redacted");
}

#pragma mark - Test sanitizing bodies

- (void)testPassThroughBody
{
    NSData *body = [@"foo" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *result = [self.sanitizer sanitizeBody:body];
    XCTAssertEqualObjects(result, body, @"Pass-through body not unchanged");
}

- (void)testPassThroughNullBody
{
    NSData *body = [NSData data];
    NSData *result = [self.sanitizer sanitizeBody:body];
    XCTAssertEqualObjects(result, body, @"Pass-through null body not unchanged");
}

- (void)testRedactBodyNull
{
    NSData *body = [NSData data];
    
    [self.sanitizer redactJSONKeyPath:@"foo.bar"];
    NSData *result = [self.sanitizer sanitizeBody:body];
    
    XCTAssertEqualObjects(body, result, @"Null body redaction failed");
}

- (void)testRedactBodyNotJSON
{
    NSData *body = [@"invalid JSON" dataUsingEncoding:NSUTF8StringEncoding];
    
    [self.sanitizer redactJSONKeyPath:@"foo.bar"];
    NSData *result = [self.sanitizer sanitizeBody:body];
    
    XCTAssertEqualObjects(body, result, @"Non-JSON body redaction failed");
}

- (void)testRedactBodyNil
{
    NSData *body = nil;
    
    NSData *result = [self.sanitizer sanitizeBody:body];
    
    XCTAssertEqualObjects(body, result, @"Nil body redaction failed");
}

- (void)testRedactJSON
{
    NSDictionary *bodyDict = @{@"animal": @"dog"};
    NSData *body = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];
    
    [self.sanitizer redactJSONKeyPath:@"animal"];
    NSData *resultData = [self.sanitizer sanitizeBody:body];
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    XCTAssertEqualObjects([result valueForKeyPath:@"animal"], @"REDACTED", @"Deep keypath redaction failed");
}

- (void)testRedactJSONDeep
{
    NSDictionary *bodyDict = @{@"1": @{@"2": @{@"3": @"dog"}}};
    NSData *body = [NSJSONSerialization dataWithJSONObject:bodyDict options:0 error:nil];
    
    [self.sanitizer redactJSONKeyPath:@"1.2.3"];
    NSData *resultData = [self.sanitizer sanitizeBody:body];
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:resultData options:0 error:nil];
    XCTAssertEqualObjects([result valueForKeyPath:@"1.2.3"], @"REDACTED", @"Deep keypath redaction failed");
}

- (void)testRedactObjectDictionary
{
    NSDictionary *dictionary = @{@"foo": @"bar"};

    [self.sanitizer redactJSONKeyPath:@"foo"];
    NSDictionary *result = [self.sanitizer sanitizeObject:dictionary];
    XCTAssertEqualObjects(result, @{@"foo": @"REDACTED"}, @"Dictionary object redaction failed");
}

@end
