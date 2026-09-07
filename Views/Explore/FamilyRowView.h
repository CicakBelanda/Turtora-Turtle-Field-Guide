//
//  FamilyRowView.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FamilyRowView : UIControl

@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, copy) NSString *speciesCountText;

- (instancetype)initWithFamilyName:(NSString *)name count:(NSInteger)count;

@end

NS_ASSUME_NONNULL_END
