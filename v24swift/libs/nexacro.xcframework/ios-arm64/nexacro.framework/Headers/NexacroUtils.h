
#import <Foundation/Foundation.h>

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBA_X [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1] //[UIColor colorWithRed:187/255.0 green:68/255.0 blue:98/255.0 alpha:1]
#define ARGB(a, r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0]

@class NXInvokedUrlCommand;

@interface NexacroUtils : NSObject {}

+ (NSString*)defaultLanguage;

+ (void)evaluateJavaScript:(NSString *)javaScriptString target:(id)webView completionHandler:(void (^)(id, NSError *error))completionHandler;

+ (NSString *)runJavaScriptFuncion:(id)webView script:(NSString *)script;
+ (NSString *)runJavaScriptFuncion:(id)webView script:(NSString *)script waitingCallback:(BOOL)waitingCallback;

+ (NSString *)convertToFullPath:(NSString *)path;
+ (NSString *)convertToFullPath:(NSString *)path userAppPath:(NSString *)userAppPath;

+ (BOOL) extractWithSource:(NSData*) source target:(NSMutableData*) target;

+ (NSString *)sketchCommand:(NXInvokedUrlCommand *)command;

+ (NSString*)getClipboard;
+ (void)setClipboard:(NSString*)text;
+ (void)clearClipboard;

//+ (UIColor *)convertHexToUIColor:(NSString*)hexColor;

@end
