
#import <WebKit/WebKit.h>

@protocol NXWebViewEngineProtocol <NSObject>

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, readonly) UIView* engineWebView;

- (void)setNXViewController:(UIViewController *)viewController;

- (id)loadRequest:(NSURLRequest*)request;
- (id)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL;

- (nullable instancetype)initWithFrame:(CGRect)frame;
- (nullable instancetype)initWithFrame:(CGRect)frame userConfiguration:(nullable WKWebViewConfiguration *)userConfiguration;

- (void)evaluateJavaScript:(NSString*)javaScriptString completionHandler:(void (^)(id, NSError*))completionHandler;

NS_ASSUME_NONNULL_END

@end
