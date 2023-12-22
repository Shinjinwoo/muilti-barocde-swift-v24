//
//  NXExtendedAPI.h
//  nexacro
//
//  Created by TOBESOFT NRE on 2023/09/07.
//
#import "NXPlugin.h"
@interface NXExtendedAPI : NXPlugin
@property NSString *pluginHandle;
@property (nonatomic, readwrite) NSInteger refCount;
@property (nonatomic, readwrite) NSString* adaptorType;

- (NXExtendedAPI *)initWithWebView:(id)theWebView;
// nexacro.Device. 의 callback을 호출하기 위한 메서드.
- (NSString *)writeJavascript:(NSString *)javascript;

// nexacro.system 의 callback을 호출하기 위한 메서드.
- (NSString *)writeJavascriptEx:(NSString *)javascript;

// 리턴 데이터 중 js에서 문제 있는 character 치환
- (NSString *)getReplacedStringXML:(NSString *)javascript;
- (NSString *)getReplacedStringSSVCSV:(NSString *)javascript;
- (NSString *)getReplacedString:(NSString *)javascript;
- (NSString *)getReturnReplacedString:(NSString *)javascript;
- (void) callback:(NSArray *)array;
@end
