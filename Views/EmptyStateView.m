//
//  EmptyStateView.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "EmptyStateView.h"
#import "Constants.h"

@interface EmptyStateView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation EmptyStateView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message iconName:(NSString *)iconName {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _titleText = title;
        _messageText = message;
        _iconName = iconName;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:self.iconName]];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.tintColor = [UIColor systemGray3Color];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.text = self.titleText;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3];
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.textColor = TURTORA_PRIMARY_TEXT;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.text = self.messageText;
    self.messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.messageLabel.adjustsFontForContentSizeCategory = YES;
    self.messageLabel.textColor = TURTORA_SECONDARY_TEXT;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    [self addSubview:self.messageLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.iconView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.iconView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.iconView.widthAnchor constraintEqualToConstant:60],
        [self.iconView.heightAnchor constraintEqualToConstant:60],
        
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.iconView.bottomAnchor constant:TURTORA_SPACING_LARGE],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:TURTORA_SPACING_XLARGE],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-TURTORA_SPACING_XLARGE],
        
        [self.messageLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:TURTORA_SPACING_SMALL],
        [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:TURTORA_SPACING_XLARGE],
        [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-TURTORA_SPACING_XLARGE],
        [self.messageLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setMessageText:(NSString *)messageText {
    _messageText = messageText;
    self.messageLabel.text = messageText;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    self.iconView.image = [UIImage systemImageNamed:iconName];
}

@end
