//==============================================================================
//
//  TOBESOFT Co., Ltd.
//  Copyright 2017 TOBESOFT Co., Ltd.
//  All Rights Reserved.
//
//  NOTICE: TOBESOFT permits you to use, modify, and distribute this file 
//          in accordance with the terms of the license agreement accompanying it.
//
//  Readme URL: http://www.nexacro.co.kr/legal/nexacro17-public-license-readme-1.0.html    
//
//==============================================================================

#import <Foundation/Foundation.h>

@class NXNotificationManagerHandler;
@class NXConfigParser;

@interface NXNotificationManager : NSObject {
    NXNotificationManagerHandler *handler;
    NSString *registrationId;
}

@property (readonly,strong) NXNotificationManagerHandler *handler;
@property (readwrite,retain) NSString *registrationId;
@property (readonly, strong) NXConfigParser *nofificationConfigs;

+ (void)createInstance;
+ (NXNotificationManager *)getInstance;

- (void)setUserNotificationHandler:(NSString *)handlerName;

- (void)initializeRemoteNotificationWithDelegate:(id)delegate;

- (void)fireErrorEvent:(NSError *)error andTarget:(id)webview;
- (void)fireRegisterEvent:(NSData *)deviceToken andTarget:(id)webview;
- (void)fireNotificationEvent:(NSDictionary *)message andTarget:(id)webview;

@end


@interface NXNotificationManagerHandler : NSObject

-(void)handleError:(NSError *)error;
-(void)handleRegister:(NSString *)registrationId;
-(void)handleReceiveMessage:(NSDictionary *)messages;

@end
