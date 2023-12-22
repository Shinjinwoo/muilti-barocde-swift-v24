
#import <Foundation/Foundation.h>

@interface NXConfigParser : NSObject <NSXMLParserDelegate>

// application config
@property (nonatomic, strong) NSString *dialogPosition;
@property (nonatomic, assign) BOOL fileLogging;
@property (nonatomic, assign) BOOL quiet;

// notification config
@property (nonatomic, assign) BOOL notificationEnabled;
@property (nonatomic, strong) NSString *notificationHandler;

// updator config
@property (nonatomic, assign) BOOL forceUpdate;
@property (nonatomic, assign) BOOL cancelableUpdate;
@property (nonatomic, assign) BOOL showErrorMsg;
@property (nonatomic, assign) BOOL quietUpdate;
@property (nonatomic, assign) BOOL failPass;

// splash config
@property (nonatomic, strong) NSString *scaletype;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic, strong) NSString *splashClassName;

// xpush config
@property (nonatomic, strong) NSString *bundleId;
@property (nonatomic, assign) BOOL requstMissingMessage;

- (instancetype)initWithXMLFile:(NSString *)filePath;

@end
