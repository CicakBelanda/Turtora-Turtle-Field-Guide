//
//  FeaturedSpeciesCell.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "FeaturedSpeciesCell.h"
#import "Constants.h"
#import "UIImage+Species.h"

@interface FeaturedSpeciesCell ()

@property (nonatomic, strong) UIImageView *speciesImageView;
@property (nonatomic, strong) UIView *gradientOverlay;
@property (nonatomic, strong) UILabel *featuredTagLabel;
@property (nonatomic, strong) UILabel *commonNameLabel;
@property (nonatomic, strong) UILabel *scientificNameLabel;

@end

@implementation FeaturedSpeciesCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.contentView.layer.cornerRadius = TURTORA_RADIUS_LARGE;
    self.contentView.clipsToBounds = YES;
    
    // Image - fills entire card
    self.speciesImageView = [[UIImageView alloc] init];
    self.speciesImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.speciesImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.speciesImageView.clipsToBounds = YES;
    self.speciesImageView.backgroundColor = [UIColor systemGray5Color];
    self.speciesImageView.image = [UIImage systemImageNamed:@"tortoise.fill"];
    self.speciesImageView.tintColor = TURTORA_PRIMARY_GREEN;
    self.speciesImageView.accessibilityIdentifier = @"SpeciesImage";
    [self.contentView addSubview:self.speciesImageView];
    
    // Gradient overlay at bottom for text readability
    self.gradientOverlay = [[UIView alloc] init];
    self.gradientOverlay.translatesAutoresizingMaskIntoConstraints = NO;
    self.gradientOverlay.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.contentView addSubview:self.gradientOverlay];
    
    // Featured tag
    self.featuredTagLabel = [[UILabel alloc] init];
    self.featuredTagLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.featuredTagLabel.text = @"FEATURED";
    self.featuredTagLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    self.featuredTagLabel.textColor = [UIColor whiteColor];
    self.featuredTagLabel.backgroundColor = TURTORA_PRIMARY_GREEN;
    self.featuredTagLabel.textAlignment = NSTextAlignmentCenter;
    self.featuredTagLabel.layer.cornerRadius = 4;
    self.featuredTagLabel.clipsToBounds = YES;
    self.featuredTagLabel.accessibilityIdentifier = @"FeaturedTag";
    [self.contentView addSubview:self.featuredTagLabel];
    
    // Common name - overlaid on image
    self.commonNameLabel = [[UILabel alloc] init];
    self.commonNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.commonNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.commonNameLabel.adjustsFontForContentSizeCategory = YES;
    self.commonNameLabel.textColor = [UIColor whiteColor];
    self.commonNameLabel.accessibilityIdentifier = @"CommonName";
    [self.contentView addSubview:self.commonNameLabel];
    
    // Scientific name - overlaid on image
    self.scientificNameLabel = [[UILabel alloc] init];
    self.scientificNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.scientificNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.scientificNameLabel.adjustsFontForContentSizeCategory = YES;
    self.scientificNameLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.scientificNameLabel.accessibilityIdentifier = @"ScientificName";
    [self.contentView addSubview:self.scientificNameLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        // Image - fills entire card
        [self.speciesImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
        [self.speciesImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.speciesImageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.speciesImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        
        // Gradient overlay - bottom portion
        [self.gradientOverlay.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.gradientOverlay.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.gradientOverlay.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [self.gradientOverlay.heightAnchor constraintEqualToAnchor:self.contentView.heightAnchor multiplier:0.4],
        
        // Featured tag
        [self.featuredTagLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12],
        [self.featuredTagLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:12],
        [self.featuredTagLabel.widthAnchor constraintEqualToConstant:60],
        [self.featuredTagLabel.heightAnchor constraintEqualToConstant:20],
        
        // Common name - bottom left, overlaid on image
        [self.commonNameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.commonNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.commonNameLabel.bottomAnchor constraintEqualToAnchor:self.scientificNameLabel.topAnchor constant:-4],
        
        // Scientific name - bottom left, overlaid on image
        [self.scientificNameLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.scientificNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16],
        [self.scientificNameLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-16]
    ]];
}

- (void)configureWithSpecies:(NSManagedObject *)species {
    self.commonNameLabel.text = [species valueForKey:@"commonName"];
    self.scientificNameLabel.text = [species valueForKey:@"scientificName"];
    
    // Load real photo if available
    NSString *imageName = [species valueForKey:@"imageName"];
    UIImage *photo = [UIImage speciesImageForImageName:imageName];
    if (photo) {
        self.speciesImageView.image = photo;
        self.speciesImageView.tintColor = nil;
    } else {
        self.speciesImageView.image = [UIImage systemImageNamed:@"tortoise.fill"];
        self.speciesImageView.tintColor = TURTORA_PRIMARY_GREEN;
    }
    
    // Accessibility
    self.accessibilityLabel = [NSString stringWithFormat:@"%@, %@", [species valueForKey:@"commonName"], [species valueForKey:@"scientificName"]];
    self.accessibilityHint = @"Double tap to view species details";
    self.isAccessibilityElement = YES;
}

@end
