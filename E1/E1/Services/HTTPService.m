#import "HTTPService.h"
#import "Definations.h"
@interface HTTPService ()
@property (nonatomic, strong) NSURLConnection* urlConnection;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, strong) NSMutableData* mutableData;

@end

@implementation HTTPService

- (id)initWithDelegate:(id<HTTPServiceDelegate>)delegate;

{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }

    return self;
}

- (BOOL)isOK
{
    return self.code == kcRequestComplete;
}

- (BOOL)isServerReturnedErrror
{
    return self.code > kcRequestComplete && self.code < kcExtentionCommandTooLong;
}

- (BOOL)isNetworkFailure
{
    return self.code >= kcExtentionCommandTooLong && self.code < kcUserCancel;
}

- (BOOL)isUserCancelled
{
    return self.code == kcUserCancel;
}

- (void)postRequestWithURL:(NSString*)url postBody:(NSString*)s userName:(NSString*)userName password:(NSString*)password;
{
    self.requestUrlString = url;
    self.requestBody = s;
    //NSLog(@"Post request: request address:%@\n request body:%@", url, s);
    NSData* postBody = [self.requestBody dataUsingEncoding:NSUTF8StringEncoding];
    NSString* postLength = [NSString stringWithFormat:@"%lu", (unsigned long)postBody.length];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postBody];
    [request setValue:@"text/plain;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    NSString* authStr = [NSString stringWithFormat:@"%@:%@", userName, password];
    NSData* authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    
    //NSString* authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    NSString* authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    self.mutableData = [NSMutableData data];
    self.urlConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.urlConnection start];
}

- (void)cancelService
{
    [self.urlConnection cancel];
    [self.mutableData setLength:0];
    //self.urlConnection = nil;
}
#pragma NSURLConnectionDelegate

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    self.code = httpResponse.statusCode;
    //NSLog(@"the response is %ld",(long)self.code);
    if (self.code != kcRequestComplete) {
        [self.mutableData setLength:0];
    }

    //_totalBytes += [[[httpResponse allHeaderFields] objectForKey:@"Content-Length"] integerValue];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [self.mutableData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestSucceed:)])
        [self.delegate requestSucceed:self.mutableData];
    [self.delegate requestSucceed:self.mutableData];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Connection failed! Error - %@", [error localizedDescription]);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(requestFail:)])
        [self.delegate requestFail:error];
}
@end
