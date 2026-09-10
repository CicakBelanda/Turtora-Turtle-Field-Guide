//
//  SpeciesCardCell.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "SpeciesCardCell.h"
#import "Constants.h"
#import "UIImage+Species.h"

@interface SpeciesCardCell ()

@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIImageView *speciesImageView;
@property (nonatomic, strong) UILabel *commonNameLabel;
@property (nonatomic, strong) UILabel *scientificNameLabel;
@property (nonatomic, strong) UILabel *categoryLabel;

@end

@implementation SpeciesCardCell

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
    
    // Card container
    self.cardView = [[UIView alloc] init];
    self.cardView.translatesAutoresizingMaskIntoConstraints = NO;
    self.cardView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.cardView.layer.cornerRadius = TURTORA_RADIUS_MEDIUM;
    [self.contentView addSubview:self.cardView];
    
    // Image
    self.speciesImageView = [[UIImageView alloc] init];
    self.speciesImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.speciesImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.speciesImageView.clipsToBounds = YES;
    self.speciesImageView.backgroundColor = TURTORA_LIGHT_GREEN;
    self.speciesImageView.image = [UIImage systemImageNamed:@"tortoise.fill"];
    self.speciesImageView.tintColor = TURTORA_PRIMARY_GREEN;
    self.speciesImageView.layer.cornerRadius = TURTORA_RADIUS_SMALL;
    self.speciesImageView.accessibilityIdentifier = @"SpeciesImage";
    [self.cardView addSubview:self.speciesImageView];
    
    // Common name
    self.commonNameLabel = [[UILabel alloc] init];
    self.commonNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.commonNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.commonNameLabel.adjustsFontForContentSizeCategory = YES;
    self.commonNameLabel.textColor = TURTORA_PRIMARY_TEXT;
    self.commonNameLabel.accessibilityIdentifier = @"CommonName";
    [self.cardView addSubview:self.commonNameLabel];
    
    // Scientific name
    self.scientificNameLabel = [[UILabel alloc] init];
    self.scientificNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.scientificNameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    self.scientificNameLabel.adjustsFontForContentSizeCategory = YES;
    self.scientificNameLabel.textColor = TURTORA_SECONDARY_TEXT;
    self.scientificNameLabel.accessibilityIdentifier = @"ScientificName";
    [self.cardView addSubview:self.scientificNameLabel];
    
    // Category
    self.categoryLabel = [[UILabel alloc] init];
    self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    self.categoryLabel.adjustsFontForContentSizeCategory = YES;
    self.categoryLabel.textColor = TURTORA_PRIMARY_GREEN;
    self.categoryLabel.accessibilityIdentifier = @"Category";
    [self.cardView addSubview:self.categoryLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.cardView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:6],
        [self.cardView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:TURTORA_SPACING_LARGE],
        [self.cardView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-TURTORA_SPACING_LARGE],
        [self.cardView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-6],
        
        [self.speciesImageView.leadingAnchor constraintEqualToAnchor:self.cardView.leadingAnchor constant:TURTORA_SPACING_MEDIUM],
        [self.speciesImageView.centerYAnchor constraintEqualToAnchor:self.cardView.centerYAnchor],
        [self.speciesImageView.widthAnchor constraintEqualToConstant:56],
        [self.speciesImageView.heightAnchor constraintEqualToConstant:56],
        
        [self.commonNameLabel.topAnchor constraintEqualToAnchor:self.cardView.topAnchor constant:TURTORA_SPACING_MEDIUM],
        [self.commonNameLabel.leadingAnchor constraintEqualToAnchor:self.speciesImageView.trailingAnchor constant:TURTORA_SPACING_MEDIUM],
        [self.commonNameLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-TURTORA_SPACING_MEDIUM],
        
        [self.scientificNameLabel.topAnchor constraintEqualToAnchor:self.commonNameLabel.bottomAnchor constant:2],
        [self.scientificNameLabel.leadingAnchor constraintEqualToAnchor:self.speciesImageView.trailingAnchor constant:TURTORA_SPACING_MEDIUM],
        [self.scientificNameLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-TURTORA_SPACING_MEDIUM],
        
        [self.categoryLabel.topAnchor constraintEqualToAnchor:self.scientificNameLabel.bottomAnchor constant:4],
        [self.categoryLabel.leadingAnchor constraintEqualToAnchor:self.speciesImageView.trailingAnchor constant:TURTORA_SPACING_MEDIUM],
        [self.categoryLabel.trailingAnchor constraintEqualToAnchor:self.cardView.trailingAnchor constant:-TURTORA_SPACING_MEDIUM],
        [self.categoryLabel.bottomAnchor constraintLessThanOrEqualToAnchor:self.cardView.bottomAnchor constant:-TURTORA_SPACING_MEDIUM]
    ]];
}

- (void)configureWithSpecies:(NSManagedObject *)species {
    self.commonNameLabel.text = [species valueForKey:@"commonName"];
    self.scientificNameLabel.text = [species valueForKey:@"scientificName"];
    self.categoryLabel.text = [species valueForKey:@"category"];
    
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
    self.accessibilityLabel = [NSString stringWithFormat:@"%@, %@, %@", [species valueForKey:@"commonName"], [species valueForKey:@"scientificName"], [species valueForKey:@"category"]];
    self.accessibilityHint = @"Double tap to view species details";
    self.isAccessibilityElement = YES;
}

@end
