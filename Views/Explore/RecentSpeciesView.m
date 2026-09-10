//
//  RecentSpeciesView.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "RecentSpeciesView.h"
#import "Constants.h"
#import "UIImage+Species.h"

@interface RecentSpeciesView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation RecentSpeciesView

- (instancetype)initWithSpecies:(NSManagedObject *)species {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _species = species;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.layer.cornerRadius = TURTORA_RADIUS_SMALL;
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.cornerRadius = TURTORA_RADIUS_SMALL;
    self.imageView.backgroundColor = TURTORA_LIGHT_GREEN;
    self.imageView.image = [UIImage systemImageNamed:@"tortoise.fill"];
    self.imageView.tintColor = TURTORA_PRIMARY_GREEN;
    
    // Load real photo if available
    NSString *imageName = [self.species valueForKey:@"imageName"];
    UIImage *photo = [UIImage speciesImageForImageName:imageName];
    if (photo) {
        self.imageView.image = photo;
        self.imageView.tintColor = nil;
    }
    
    [self addSubview:self.imageView];
    
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.nameLabel.text = [self.species valueForKey:@"commonName"];
    self.nameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
    self.nameLabel.adjustsFontForContentSizeCategory = YES;
    self.nameLabel.textColor = TURTORA_PRIMARY_TEXT;
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.numberOfLines = 2;
    [self addSubview:self.nameLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.widthAnchor constraintEqualToConstant:80],
        [self.heightAnchor constraintEqualToConstant:80],
        
        [self.imageView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.imageView.heightAnchor constraintEqualToConstant:60],
        
        [self.nameLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:4],
        [self.nameLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:4],
        [self.nameLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-4],
        [self.nameLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4]
    ]];
}

@end
