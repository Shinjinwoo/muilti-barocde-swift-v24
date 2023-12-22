
#import <Foundation/Foundation.h>

@interface NXPluginResult : NSObject

@property (nonatomic, readonly) NSInteger callbackId;
@property (nonatomic, copy, readonly) NSString *eventName;
@property (nonatomic, copy, readonly) NSDictionary *parameters;

- (instancetype)initWithCallbackId:(NSInteger)callbackId
                         eventName:(NSString *)eventName
                        parameters:(NSDictionary *)parameters;

- (NSString *)getEncodeAsJs;

@end
