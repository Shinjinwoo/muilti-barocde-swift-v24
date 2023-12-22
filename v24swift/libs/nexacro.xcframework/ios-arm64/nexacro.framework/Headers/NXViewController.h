
#import <UIKit/UIKit.h>
#import "NXWebViewEngineProtocol.h"
#import "NXSplashScreenProtocol.h"
#import "NXCommandDelegate.h"
#import "NXCommandQueue.h"
#import "NXConfigParser.h"
#import "NXPluginParser.h"

@protocol NXWebViewEngineConfigurationDelegate <NSObject>

@optional
/// Provides a fully configured WKWebViewConfiguration which will be overriden with
/// any related settings you add to config.xml (e.g., `PreferredContentMode`).
/// Useful for more complex configuration, including websiteDataStore.
///
/// Example usage:
///
/// extension CDVViewController: CDVWebViewEngineConfigurationDelegate {
///     public func configuration() -> WKWebViewConfiguration {
///         // return your config here
///     }
/// }
- (nonnull WKWebViewConfiguration *)configuration;

@end

@interface NXViewController : UIViewController
{
}

NS_ASSUME_NONNULL_BEGIN

@property(nonatomic, readonly, weak) IBOutlet UIView *webView;

@property(nonatomic, strong) NXConfigParser *configs;
@property(nonatomic, strong) NXPluginParser *pluginParser;

@property(nonatomic, readonly, strong) NSMutableDictionary *pluginObjects;
@property(nonatomic, readonly, strong) NSMutableArray *errorMsgs;

@property(nonatomic, readwrite, strong) NXCommandQueue *nxCommandQueue;
@property(nonatomic, readwrite, strong) id<NXSplashScreenProtocol> splashScreen;
@property(nonatomic, readwrite, strong) id<NXWebViewEngineProtocol> webViewEngine;
@property(nonatomic, readonly, strong) id<NXCommandDelegate> nxCommandDelegate;
@property(nonatomic, readwrite, strong) NSString *projectUrl;
@property(nonatomic, readwrite, strong) NSString *bootstrapUrl;

// In-App Browser
@property(nonatomic, readwrite, weak) WKWebView *inAppBrowser;

@property(nonatomic, readwrite, getter=isPreventCache) BOOL preventCache;
@property(nonatomic, readwrite, getter=isPreventCookie) BOOL preventCookie;

// cordova 인터페이스를 맞추기 위해 추가
@property(nonatomic, readwrite, copy) NSString *wwwFolderName;
@property(nonatomic, readonly, strong) NSMutableDictionary *settings;

- (UIView *)newNexacroViewWithFrame:(CGRect)bounds;

- (void)onWebViewPageDidLoad:(NSNotification *)notification;
- (void)showSplashScreen:(BOOL)visible;

- (id)getOthersCommandInstance;
- (id)getCommandInstance:(NXInvokedUrlCommand *)command;
- (id)getPluginInstance:(NSString *)strKey;
- (void)removeCommandInstance:(NXInvokedUrlCommand *)command;

- (void)recvDataFromExtAPI:(NSString *)recvData;

// cordova
- (id _Nonnull)getCordovaPluginInstance:(NSString *_Nullable)pluginName;

NS_ASSUME_NONNULL_END

@end
