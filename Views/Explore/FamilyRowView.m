//
//  FamilyRowView.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "FamilyRowView.h"
#import "Constants.h"

@interface FamilyRowView ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *chevronView;

@end

@implementation FamilyRowView

- (instancetype)initWithFamilyName:(NSString *)name count:(NSInteger)count {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _familyName = name;
        _speciesCountText = [NSString stringWithFormat:@"%ld", (long)count];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    self.layer.cornerRadius = TURTORA_RADIUS_SMALL;
    
    // Icon
    self.iconView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"tortoise.fill"]];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.tintColor = TURTORA_PRIMARY_GREEN;
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconView];
    
    // Name
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.text = self.familyName;
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.adjustsFontForContentSizeCategory = YES;
    self.nameLabel.textColor = TURTORA_PRIMARY_TEXT;
    [self addSubview:self.nameLabel];
    
    // Count
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.countLabel.text = self.speciesCountText;
    self.countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.countLabel.adjustsFontForContentSizeCategory = YES;
    self.countLabel.textColor = TURTORA_SECONDARY_TEXT;
    [self addSubview:self.countLabel];
    
    // Chevron
    self.chevronView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
    self.chevronView.translatesAutoresizingMaskIntoConstraints = NO;
    self.chevronView.tintColor = [UIColor systemGray3Color];
    [self addSubview:self.chevronView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.heightAnchor constraintEqualToConstant:48],
        
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:TURTORA_SPACING_LARGE],
        [self.iconView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.iconView.widthAnchor constraintEqualToConstant:20],
        [self.iconView.heightAnchor constraintEqualToConstant:20],
        
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:TURTORA_SPACING_MEDIUM],
        [self.nameLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        
        [self.countLabel.trailingAnchor constraintEqualToAnchor:self.chevronView.leadingAnchor constant:-TURTORA_SPACING_MEDIUM],
        [self.countLabel.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        
        [self.chevronView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-TURTORA_SPACING_LARGE],
        [self.chevronView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [self.chevronView.widthAnchor constraintEqualToConstant:12],
        [self.chevronView.heightAnchor constraintEqualToConstant:12]
    ]];
}

@end
