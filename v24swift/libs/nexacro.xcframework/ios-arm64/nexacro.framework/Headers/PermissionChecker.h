
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PrivacyKey) {
    PrivacyKeyCamera,
    PrivacyKeyCalendar,
    PrivacyKeyReminder,
    PrivacyKeyContact,
    PrivacyKeyPhoto,
    PrivacyKeyBluetoothSharing,
    PrivacyKeyMicrophone,
    PrivacyKeyLocationAlways,
    PrivacyKeyLocationWhenInUse,
    PrivacyKeyHeath,
    PrivacyKeyHomeKit,
    PrivacyKeyMediaLibrary,
    PrivacyKeySpeechRecognition,
    PrivacyKeySiriKit,
    PrivacyKeyPhotoLibraryAdditionsUsage,
    PrivacyKeyPhotoLibraryUsage
};

// 특정 기능을 사용하기 위해 info-plist에 privacy가 선언되어 있는지 확인하기 위한 클래스
//
@interface PermissionChecker : NSObject

+ (BOOL)hasPermission:(PrivacyKey)privacyKey;

@end
