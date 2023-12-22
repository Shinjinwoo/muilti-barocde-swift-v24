
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NXWebViewEngineProtocol.h"
#import "NXCommandDelegate.h"
#import "NXConfigParser.h"

extern NSString *const NXPageDidLoadNotification;

extern NSString *const NXViewWillAppearNotification;
extern NSString *const NXViewDidAppearNotification;
extern NSString *const NXViewWillDisappearNotification;
extern NSString *const NXViewDidDisappearNotification;
extern NSString *const NXViewWillLayoutSubviewsNotification;
extern NSString *const NXViewDidLayoutSubviewsNotification;

@class Bootstrap;

@interface NXPlugin : NSObject {}

@property (nonatomic, readonly, weak) UIView *webView;
@property (nonatomic, readonly, weak) id <NXWebViewEngineProtocol> webViewEngine;

@property (nonatomic, weak) UIViewController* viewController;
@property (nonatomic, weak) id <NXCommandDelegate> nxCommandDelegate;

@property (nonatomic, weak) NXConfigParser *configs;
@property (nonatomic, readonly, strong) NSString *userAppPath;

@property (nonatomic, retain) NSDictionary *options;
@property (nonatomic, retain) Bootstrap *bootstrap;

- (void)pluginInitialize;
- (void)pluginRelease;

// nexacro.Device 의 callback을 호출하기 위한 메서드.
- (NSString *)writeJavascript:(NSString *)javascript;

// nexacro.System 의 callback을 호출하기 위한 메서드.
- (NSString *)writeJavascriptEx:(NSString *)javascript;

// 리턴 데이터 중 js에서 문제 있는 character 치환
- (NSString *)getReplacedStringXML:(NSString *)javascript;
- (NSString *)getReplacedStringSSVCSV:(NSString *)javascript;
- (NSString *)getReplacedString:(NSString *)javascript;
- (NSString *)getReturnReplacedString:(NSString *)javascript;

- (id)appDelegate;

// NOTE: for onPause and onResume, calls into JavaScript must not call or trigger any blocking UI, like alerts
- (void)onPause;
- (void)onResume;
- (void)onAppTerminate;

@end
