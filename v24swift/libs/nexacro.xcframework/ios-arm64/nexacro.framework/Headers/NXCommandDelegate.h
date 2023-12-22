
#import "NXInvokedUrlCommand.h"
#import "NXPluginResult.h"

@class NXPlugin;

typedef NSURL* (^ UrlTransformerBlock)(NSURL*);

@protocol NXCommandDelegate <NSObject>

@property (nonatomic, readonly) NSDictionary* settings;
@property (nonatomic, copy) UrlTransformerBlock urlTransformer;

- (NSString *)pathForResource:(NSString *)resourcepath;
- (id)getCommandInstance:(NXInvokedUrlCommand *)command;
- (id)getPluginInstance:(NSString *)strKey;


- (void)sendPluginResult:(NXPluginResult *)pluginResult;
- (void)sendPluginResultString:(NSString *)pluginResultStr;

// Evaluates the given JS. This is thread-safe.
- (void)evalJs:(NSString*)js;
// Can be used to evaluate JS right away instead of scheduling it on the run-loop.
// This is required for dispatch resign and pause events, but should not be used
// without reason. Without the run-loop delay, alerts used in JS callbacks may result
// in dead-lock. This method must be called from the UI thread.
- (void)evalJs:(NSString*)js scheduledOnRunLoop:(BOOL)scheduledOnRunLoop;
// Runs the given block on a background thread using a shared thread-pool.
- (void)runInBackground:(void (^)(void))block;

@end

