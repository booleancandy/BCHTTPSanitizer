# BCHTTPSanitizer

`BCHTTPSanitizer` is a library for redacting sensitive data such as
usernames, passwords and authentication tokens from JSON data.  Once
data has been redacted it can be stored or transmitted safely without
revealing the specified sensitive data.

## Usage

### Sanitizing URL requests and responses

Example of logging sanitized headers and body of a `NSURLRequest`:

``` objective-c
- (void)logRequest:(NSURLRequest *)request body:(NSData *)body
{
    BCHTTPRequestSantizer *sanitizer = [[BCHTTPRequestSantizer alloc] init];
    
    [sanitizer redactValueForHeader:@"X-Auth-Token"];
    [sanitizer redactJSONKeyPath:@"auth.passwordCredentials.password"];
    [sanitizer redactJSONKeyPath:@"auth.passwordCredentials.username"];
    [sanitizer redactJSONKeyPath:@"auth.tenantName"];

    NSURLRequest *cleanRequest = [sanitizer sanitizeRequest:request];
    NSData *cleanBody = [sanitizer sanitizeBody:body];

    NSLog(@"request headers: %@", [cleanRequest allHTTPHeaderFields]);
    NSLog(@"request body: %@", [[NSString alloc] initWithData:cleanBody encoding:NSUTF8StringEncoding]);
}
```

which produces the following output:

```
2014-05-08 20:05:14.197 MyApp[16739:303] request headers: {
    "Content-Type" = "application/json";
}
2014-05-08 20:05:14.197 MyApp[16739:303] request body: {"auth":{"passwordCredentials":{"username":"REDACTED","password":"REDACTED"},"tenantName":"REDACTED"}}
```

Example of logging sanitized headers and body of a `NSURLResponse`:

``` objective-c
- (void)logResponse:(NSHTTPURLResponse *)response body:(NSData *)body
{
    BCHTTPResponseSantizer *sanitizer = [[BCHTTPResponseSantizer alloc] init];
    
    [sanitizer redactJSONKeyPath:@"access.token.id"];
    [sanitizer redactJSONKeyPath:@"access.token.tenant.id"];
    [sanitizer redactJSONKeyPath:@"access.token.tenant.name"];
    
    NSHTTPURLResponse *cleanResponse = [sanitizer sanitizeResponse:response];
    NSData *cleanBody = [sanitizer sanitizeBody:body];

    NSLog(@"response headers: %@", [cleanResponse allHTTPHeaderFields]);
    NSLog(@"response body: %@", [[NSString alloc] initWithData:cleanBody encoding:NSUTF8StringEncoding]);
}
```

which produces the following output:

```
2014-05-08 20:15:01.423 MyApp[16858:303] response headers: {
    "Cache-Control" = "no-cache";
    "Content-Length" = 9135;
    "Content-Type" = "application/json";
    Date = "Thu, 08 May 2014 10:15:01 GMT";
    Expires = "-1";
    Pragma = "no-cache";
    Server = "HP-CS-Server";
}
2014-05-08 20:15:01.423 MyApp[16858:303] response body: {"access":{"token":{"expires":"2014-05-08T22:15:01.798Z","id":"REDACTED","tenant":{"id":"REDACTED","name":"REDACTED"}}, ... }}
```

### Sanitizing NSData and NSDictionary values

Sanitizing values outside of `NSURLRequest` and `NSURLResponse` is
also possible using the `sanitizeBody:` and `sanitizeHeaders:` methods of
`BCHTTPRequestSanitizer` and `BCHTTPResponseSanitizer`.

## Contact

Tim Potter

- tpot@booleancandy.com.au

## License

`BCHTTPSanitizer` is available under the MIT license. See the LICENSE
file for more info.
