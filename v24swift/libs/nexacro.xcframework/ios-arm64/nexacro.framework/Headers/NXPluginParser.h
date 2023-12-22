
#import <Foundation/Foundation.h>

@interface NXPluginParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *pluginsMap;
@property (nonatomic, strong) NSMutableDictionary *settings;
@property (nonatomic, strong) NSMutableArray *startupPluginNames;

- (instancetype)initWithXMLFile:(NSString *)filePath;

@end


@interface NXPluginObject : NSObject

@property (nonatomic, strong) NSString *service;
@property (nonatomic, strong) NSString *classname;
@property (nonatomic, assign) BOOL onload;

@end
