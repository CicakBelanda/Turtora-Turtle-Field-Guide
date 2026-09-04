//
//  TaxonomyLevelCell.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "TaxonomyLevelCell.h"

@interface TaxonomyLevelCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *chevronView;

@end

@implementation TaxonomyLevelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Card container - follows HIG: rounded corners, subtle background
    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.cardView.layer.cornerRadius = 12;
    [self.contentView addSubview:self.cardView];
    
    // Icon - uses SF Symbols (HIG compliant)
    self.iconView = [[UIImageView alloc] init];
    self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
    self.iconView.tintColor = [UIColor systemGreenColor];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.cardView addSubview:self.iconView];
    
    // Title - dynamic type support (HIG)
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.titleLabel.adjustsFontForContentSizeCategory = YES;
    self.titleLabel.textColor = [UIColor labelColor];
    [self.cardView addSubview:self.titleLabel];
    
    // Subtitle
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.subtitleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.subtitleLabel.adjustsFontForContentSizeCategory = YES;
    self.subtitleLabel.textColor = [UIColor secondaryLabelColor];
    [self.cardView addSubview:self.subtitleLabel];
    
    // Count
    self.countLabel = [[UILabel alloc] init];
    self.countLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.countLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    self.countLabel.adjustsFontForContentSizeCategory = YES;
    self.countLabel.textColor = [UIColor tertiaryLabelColor];
    [self.cardView addSubview:self.countLabel];
    
    // Chevron - standard iOS disclosure indicator pattern
    self.chevronView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
    self.chevronView.translatesAutoresizingMaskIntoConstraints = NO;
    self.chevronView.tintColor = [UIColor systemGray3Color];
    [self.cardView addSubview:self.chevronView];
    
    [NSLayoutConstraint activateConstraints:@[
        // Card - follows HIG padding margins
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:4],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-4],
        [self.cardView.heightAnchor constraintGreaterThanOrEqualToConstant:56],
        
        // Icon
        [self.iconView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:16],
        [self.iconView.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.iconView.widthAnchor constraintEqualToConstant:24],
        [self.iconView.heightAnchor constraintEqualToConstant:24],
        
        // Title
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:10],
        [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:12],
        [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.chevronView.leadingAnchor constant:-12],
        
        // Subtitle
        [self.subtitleLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:2],
        [self.subtitleLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:12],
        [self.subtitleLabel.trailingAnchor constraintEqualToAnchor:self.chevronView.leadingAnchor constant:-12],
        
        // Count
        [self.countLabel.topAnchor constraintEqualToAnchor:self.subtitleLabel.bottomAnchor constant:2],
        [self.countLabel.leadingAnchor constraintEqualToAnchor:self.iconView.trailingAnchor constant:12],
        [self.countLabel.trailingAnchor constraintEqualToAnchor:self.chevronView.leadingAnchor constant:-12],
        [self.countLabel.bottomAnchor constraintEqualToAnchor:self.cardView.bottomAnchor constant:-10],
        
        // Chevron
        [self.chevronView.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-16],
        [self.chevronView.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.chevronView.widthAnchor constraintEqualToConstant:12],
        [self.chevronView.heightAnchor constraintEqualToConstant:12]
    ]];
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}

- (void)setSubtitleText:(NSString *)subtitleText {
    _subtitleText = subtitleText;
    self.subtitleLabel.text = subtitleText;
}

- (void)setCountText:(NSString *)countText {
    _countText = countText;
    self.countLabel.text = countText;
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    self.iconView.image = [UIImage systemImageNamed:iconName];
}

@end
