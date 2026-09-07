//
//  HabitatCardView.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HabitatCardView : UIControl

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *speciesCountText;
@property (nonatomic, copy) NSString *iconName;

- (instancetype)initWithTitle:(NSString *)title count:(NSInteger)count iconName:(NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
