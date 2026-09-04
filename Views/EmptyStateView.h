//
//  EmptyStateView.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmptyStateView : UIView

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, copy) NSString *iconName;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message iconName:(NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
