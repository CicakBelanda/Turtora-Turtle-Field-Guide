//
//  HabitatCardView.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "HabitatCardView.h"
#import "Constants.h"

@interface HabitatCardView ()

@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;

@end

@implementation HabitatCardView

- (instancetype)initWithTitle:(NSString *)title count:(NSInteger)count iconName:(NSString *)iconName {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _title = title;
        _speciesCountText = [NSString stringWithFormat:@"%ld species", (long)count];
        _iconName = iconName;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.layer.cornerRadius = TURTORA_RADIUS_MEDIUM;
    
    self.stackView = [[UIStackView alloc] init];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 4;
    [self addSubview:self.stackView];
    
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:self.iconName]];
    self.iconView.tintColor = TURTORA_PRIMARY_GREEN;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.stackView addArrangedSubview:self.iconView];
    [self.iconView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = self.title;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.textColor = TURTORA_PRIMARY_TEXT;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.stackView addArrangedSubview:self.titleLabel];
    
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.text = self.speciesCountText;
    self.countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    self.countLabel.adjustsFontForContentSizeCategory = YES;
    self.countLabel.textColor = TURTORA_SECONDARY_TEXT;
    [self.stackView addArrangedSubview:self.countLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.stackView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [self.stackView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.iconView.widthAnchor constraintEqualToConstant:28],
        [self.iconView.heightAnchor constraintEqualToConstant:28]
    ]];
}

@end
