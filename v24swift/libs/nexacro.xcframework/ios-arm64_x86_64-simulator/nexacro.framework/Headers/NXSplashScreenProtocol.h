//
//  NXSplashScreenProtocol.h
//  Version 1.0.0
//  Created by TOBESOFT
//

// 스플래시 스크린을 구현하고자 할때 준수해야 할 규약 입니다.

#import <UIKit/UIKit.h>

@protocol NXSplashScreenProtocol <NSObject>

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong, readonly) UIView *splashView;
@property (nonatomic, strong, readonly) NSString *dialogPosition;

@required
/**
 * 지정된 임의의 위치에 업데이트 정보가 표시되는 기본 생성자 입니다.
 *
 * @param frame 뷰의 사각형 프레임
 */
- (nullable instancetype)initWithFrame:(CGRect)frame;

/**
 * 업데이트 정보 위치를 지정할수 있는 기본 생성자 입니다.
 *
 * @param frame 뷰의 사각형 프레임
 * @param position 업데이트 정보 위치 (top, center, bottom)
 */
- (nullable instancetype)initWithFrame:(CGRect)frame dialogPosition:(NSString *)position;

/**
 * 진행 정보를 값으로 알 수 있습니다.
 *
 * @param progress 진행률 (값 범위: 0.0 ~ 1.0)
 */
- (void)setProgress:(float)progress;

/**
 * 현재 수행중인 진행 정보를 알 수 있습니다.
 *
 * @param message 진행 정보
 */
- (void)setMessage:(NSString *)message;

NS_ASSUME_NONNULL_END

@end
