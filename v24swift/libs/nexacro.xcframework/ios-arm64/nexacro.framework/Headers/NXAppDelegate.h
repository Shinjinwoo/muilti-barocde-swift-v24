#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

#import "NXViewController.h"

@interface NXAppDelegate : NSObject <UIApplicationDelegate, UNUserNotificationCenterDelegate>{}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet NXViewController *viewController;

@end
