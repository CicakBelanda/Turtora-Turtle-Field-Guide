//
//  SpeciesDetailViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "SpeciesDetailViewController.h"
#import "DataManager.h"
#import "Constants.h"
#import "UIImage+Species.h"

@interface SpeciesDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation SpeciesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self.species valueForKey:@"commonName"];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupNavigationBar];
    [self setupScrollView];
    [self setupContent];
}

- (void)setupNavigationBar {
    UIBarButtonItem *favoriteButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"heart"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleFavorite)];
    self.navigationItem.rightBarButtonItem = favoriteButton;
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.scrollView];
    
    self.stackView = [[UIStackView alloc] init];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = TURTORA_SPACING_XLARGE;
    self.stackView.layoutMargins = UIEdgeInsetsMake(TURTORA_SPACING_LARGE, TURTORA_SPACING_LARGE, TURTORA_SPACING_XLARGE * 2, TURTORA_SPACING_LARGE);
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
    // Image
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = TURTORA_LIGHT_GREEN;
    imageView.image = [UIImage systemImageNamed:@"tortoise.fill"];
    imageView.tintColor = TURTORA_PRIMARY_GREEN;
    imageView.layer.cornerRadius = TURTORA_RADIUS_LARGE;
    imageView.accessibilityIdentifier = @"SpeciesImage";
    
    // Load real photo asynchronously
    NSString *imageName = [self.species valueForKey:@"imageName"];
    if (imageName) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *photo = [UIImage speciesImageForImageName:imageName];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (photo) {
                    imageView.image = photo;
                    imageView.tintColor = nil;
                }
            });
        });
    }
    
    [self.stackView addArrangedSubview:imageView];
    [imageView.heightAnchor constraintEqualToConstant:200].active = YES;
    
    // Scientific name
    UILabel *sciLabel = [[UILabel alloc] init];
    sciLabel.text = [self.species valueForKey:@"scientificName"];
    sciLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    sciLabel.adjustsFontForContentSizeCategory = YES;
    sciLabel.textColor = TURTORA_SECONDARY_TEXT;
    sciLabel.textAlignment = NSTextAlignmentCenter;
    sciLabel.accessibilityIdentifier = @"ScientificName";
    [self.stackView addArrangedSubview:sciLabel];
    
    // Description
    NSString *description = [self.species valueForKey:@"speciesDescription"];
    if (description) {
        UILabel *descLabel = [[UILabel alloc] init];
        descLabel.text = description;
        descLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        descLabel.adjustsFontForContentSizeCategory = YES;
        descLabel.textColor = TURTORA_PRIMARY_TEXT;
        descLabel.numberOfLines = 0;
        descLabel.accessibilityIdentifier = @"SpeciesDescription";
        [self.stackView addArrangedSubview:descLabel];
    }
    
    // Details
    [self addDetailSectionWithTitle:@"Size" value:[self.species valueForKey:@"size"]];
    [self addDetailSectionWithTitle:@"Diet" value:[self.species valueForKey:@"diet"]];
    [self addDetailSectionWithTitle:@"Habitat" value:[self.species valueForKey:@"habitat"]];
    [self addDetailSectionWithTitle:@"Distribution" value:[self.species valueForKey:@"distribution"]];
    [self addDetailSectionWithTitle:@"Lifespan" value:[self.species valueForKey:@"lifespan"]];
    [self addDetailSectionWithTitle:@"Conservation Status" value:[self.species valueForKey:@"conservationStatus"]];
}

- (void)addDetailSectionWithTitle:(NSString *)title value:(NSString *)value {
    if (!value) return;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    titleLabel.adjustsFontForContentSizeCategory = YES;
    titleLabel.textColor = TURTORA_SECONDARY_TEXT;
    [self.stackView addArrangedSubview:titleLabel];
    
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = value;
    valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    valueLabel.adjustsFontForContentSizeCategory = YES;
    valueLabel.textColor = TURTORA_PRIMARY_TEXT;
    valueLabel.numberOfLines = 0;
    [self.stackView addArrangedSubview:valueLabel];
}

- (void)toggleFavorite {
    [[DataManager sharedManager] toggleFavoriteForSpecies:self.species];
    
    // Update icon
    BOOL isFavorite = [[self.species valueForKey:@"isFavorite"] boolValue];
    UIImage *icon = [UIImage systemImageNamed:isFavorite ? @"heart.fill" : @"heart"];
    self.navigationItem.rightBarButtonItem.image = icon;
}

@end
