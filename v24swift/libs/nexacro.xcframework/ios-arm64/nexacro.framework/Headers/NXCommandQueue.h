#import <Foundation/Foundation.h>

@class CDVInvokedUrlCommand;

// Javascript 를 통해 WKWebView 로 들어온 이벤트를 수행하기 위한 클래스
//

@class NXViewController;
@class NXInvokedUrlCommand;

@interface NXCommandQueue : NSObject

@property (nonatomic, readwrite) NSString* _Nullable lastErrorMsg;
@property (nonatomic, readwrite, strong) NXViewController * _Nonnull viewController;

// 생성자
- (id _Nonnull )initWithViewController:(NXViewController *_Nonnull)viewController;

- (void)execute:(NXInvokedUrlCommand *_Nonnull)command completionHandler:(void (^_Nullable)(NSString * __nullable result))completionHandler;

// cordova 이벤트를 수행하는 함수
- (BOOL)execCordovaCommand:(CDVInvokedUrlCommand * _Nonnull)command;

@end
