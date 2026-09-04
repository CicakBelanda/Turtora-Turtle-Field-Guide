//
//  SectionHeaderView.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "SectionHeaderView.h"
#import "Constants.h"

@interface SectionHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SectionHeaderView

- (instancetype)initWithTitle:(NSString *)title {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = self.title;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.textColor = TURTORA_PRIMARY_TEXT;
    self.titleLabel.accessibilityIdentifier = @"SectionHeader";
    [self addSubview:self.titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

@end
