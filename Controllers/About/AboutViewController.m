//
//  AboutViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 10/09/26.
//

#import "AboutViewController.h"
#import "Constants.h"

@interface AboutViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *dataLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupScrollView];
    [self setupContent];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    self.stackView = [[UIStackView alloc] init];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = 24;
    self.stackView.layoutMargins = UIEdgeInsetsMake(32, 24, 32, 24);
    self.stackView.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.stackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        
        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor]
    ]];
}

- (void)setupContent {
    // Logo
    self.logoImageView = [[UIImageView alloc] init];
    self.logoImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImageView.backgroundColor = TURTORA_LIGHT_GREEN;
    self.logoImageView.layer.cornerRadius = 24;
    self.logoImageView.clipsToBounds = YES;
    
    // Use system icon as placeholder (replace with your logo)
    UIImage *logoImage = [UIImage systemImageNamed:@"tortoise.fill"];
    self.logoImageView.image = logoImage;
    self.logoImageView.tintColor = TURTORA_PRIMARY_GREEN;
    
    [self.stackView addArrangedSubview:self.logoImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.logoImageView.widthAnchor constraintEqualToConstant:100],
        [self.logoImageView.heightAnchor constraintEqualToConstant:100]
    ]];
    
    // App Name
    self.appNameLabel = [[UILabel alloc] init];
    self.appNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.appNameLabel.text = @"Turtora";
    self.appNameLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
    self.appNameLabel.textColor = TURTORA_PRIMARY_TEXT;
    [self.stackView addArrangedSubview:self.appNameLabel];
    
    // Version
    self.versionLabel = [[UILabel alloc] init];
    self.versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.versionLabel.text = @"Version 1.0.0";
    self.versionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.versionLabel.adjustsFontForContentSizeCategory = YES;
    self.versionLabel.textColor = TURTORA_SECONDARY_TEXT;
    [self.stackView addArrangedSubview:self.versionLabel];
    
    // Description
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descriptionLabel.text = @"A beautifully minimalist field guide to Indonesia's turtles and tortoises, featuring 43 species with stunning photography, intuitive comparison tools, and smart search — your pocket naturalist for the archipelago's shelled wonders.";
    self.descriptionLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.descriptionLabel.adjustsFontForContentSizeCategory = YES;
    self.descriptionLabel.textColor = TURTORA_PRIMARY_TEXT;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.stackView addArrangedSubview:self.descriptionLabel];
    
    // Author
    self.authorLabel = [[UILabel alloc] init];
    self.authorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.authorLabel.text = @"Created by Kevin Joseph Handoyo";
    self.authorLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.authorLabel.adjustsFontForContentSizeCategory = YES;
    self.authorLabel.textColor = TURTORA_MUTED;
    [self.stackView addArrangedSubview:self.authorLabel];
    
    // Data Source
    self.dataLabel = [[UILabel alloc] init];
    self.dataLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dataLabel.text = @"Species data sourced from Wikipedia and IUCN Red List.";
    self.dataLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    self.dataLabel.adjustsFontForContentSizeCategory = YES;
    self.dataLabel.textColor = TURTORA_MUTED;
    self.dataLabel.numberOfLines = 0;
    self.dataLabel.textAlignment = NSTextAlignmentCenter;
    [self.stackView addArrangedSubview:self.dataLabel];
}

@end
