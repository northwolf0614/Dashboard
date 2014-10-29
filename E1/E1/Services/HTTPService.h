
#import <Foundation/Foundation.h>

@class HTTPService;

@protocol HTTPServiceDelegate <NSObject>
- (void)requestSucceed:(NSData*)receivedData;
- (void)requestFail:(NSError*)error;
@end

@interface HTTPService : NSObject <NSURLConnectionDelegate>

@property (nonatomic, weak) id<HTTPServiceDelegate> delegate;
@property (nonatomic, strong) NSString* requestUrlString;
@property (nonatomic, strong) NSString* requestBody;

- (id)initWithDelegate:(id<HTTPServiceDelegate>)delegate;
//post request
- (void)postRequestWithURL:(NSString*)url postBody:(NSString*)s userName:(NSString*)userName password:(NSString*)password;
//cancel the service
- (void)cancelService;
//used to identify the service is ok
- (BOOL)isOK;
// used to indentify the server error
- (BOOL)isServerReturnedErrror;
// used to indentify  network failure
- (BOOL)isNetworkFailure;
//used to identify user cancellation
- (BOOL)isUserCancelled;

@end
