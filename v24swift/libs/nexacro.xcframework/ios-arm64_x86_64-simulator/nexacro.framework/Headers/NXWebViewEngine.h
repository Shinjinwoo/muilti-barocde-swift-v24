
#import <WebKit/WebKit.h>

#import "NXWebViewEngineProtocol.h"

@interface NXWebViewEngine : NSObject <NXWebViewEngineProtocol, WKNavigationDelegate, WKScriptMessageHandler, WKHTTPCookieStoreObserver>

@property (nonatomic, weak) UIViewController* viewController;
@property (nonatomic, strong, readonly) id <WKUIDelegate> uiDelegate;

@end
