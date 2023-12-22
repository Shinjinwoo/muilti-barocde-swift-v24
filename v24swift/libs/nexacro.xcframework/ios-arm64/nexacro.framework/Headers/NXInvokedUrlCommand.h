
#import <Foundation/Foundation.h>

@interface NXInvokedUrlCommand : NSObject

@property (nonatomic, readonly) NSString *simple;

@property (nonatomic, readonly) NSDictionary *params;
@property (nonatomic, readonly) NSString *callbackId;
@property (nonatomic, readonly) NSString *className;
@property (nonatomic, readonly) NSString *methodName;
@property (nonatomic, readwrite, getter=isExtAPI) BOOL extAPI;

+ (NXInvokedUrlCommand *)commandFromBody:(NSString *)body;
+ (NXInvokedUrlCommand *)commandFromExtAPIBody:(NSString *)body;

- (id)initWithParams:(NSDictionary*)params
          callbackId:(NSString*)callbackId
           className:(NSString*)className
          methodName:(NSString*)methodName;

- (id)initFromJson:(NSString *)jsonEntry;
- (id)initFromString:(NSString *)string;

@end
