//
//  ComparisonView.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "ComparisonView.h"
#import "UIImage+Species.h"
#import "Constants.h"

@interface ComparisonView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *speciesAHeaderView;
@property (nonatomic, strong) UIView *speciesBHeaderView;
@property (nonatomic, strong) UILabel *speciesANameLabel;
@property (nonatomic, strong) UILabel *speciesBNameLabel;
@property (nonatomic, strong) UILabel *speciesAScientificLabel;
@property (nonatomic, strong) UILabel *speciesBScientificLabel;
@property (nonatomic, strong) UIImageView *speciesAImageView;
@property (nonatomic, strong) UIImageView *speciesBImageView;

@end

@implementation ComparisonView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
    
    self.stackView = [[UIStackView alloc] init];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 12;
    self.stackView.layoutMargins = UIEdgeInsetsMake(0, 0, 16, 0);
    self.stackView.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.stackView];
    
    // Headers container
    UIStackView *headersStack = [[UIStackView alloc] init];
    headersStack.translatesAutoresizingMaskIntoConstraints = NO;
    headersStack.axis = UILayoutConstraintAxisHorizontal;
    headersStack.distribution = UIStackViewDistributionFillEqually;
    headersStack.spacing = 12;
    [self.stackView addArrangedSubview:headersStack];
    
    // Species A header
    self.speciesAHeaderView = [self createSpeciesHeaderView];
    [headersStack addArrangedSubview:self.speciesAHeaderView];
    self.speciesAImageView = [self.speciesAHeaderView viewWithTag:100];
    self.speciesANameLabel = [self.speciesAHeaderView viewWithTag:101];
    self.speciesAScientificLabel = [self.speciesAHeaderView viewWithTag:102];
    
    // Species B header
    self.speciesBHeaderView = [self createSpeciesHeaderView];
    [headersStack addArrangedSubview:self.speciesBHeaderView];
    self.speciesBImageView = [self.speciesBHeaderView viewWithTag:100];
    self.speciesBNameLabel = [self.speciesBHeaderView viewWithTag:101];
    self.speciesBScientificLabel = [self.speciesBHeaderView viewWithTag:102];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor],
        
        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
        
        [headersStack.heightAnchor constraintEqualToConstant:100]
    ]];
}

- (UIView *)createSpeciesHeaderView {
    UIView *headerView = [[UIView alloc] init];
    headerView.translatesAutoresizingMaskIntoConstraints = NO;
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.layer.cornerRadius = TURTORA_RADIUS_MEDIUM;
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor;
    headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    headerView.layer.shadowOffset = CGSizeMake(0, 1);
    headerView.layer.shadowRadius = 3;
    headerView.layer.shadowOpacity = 0.05;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.backgroundColor = TURTORA_LIGHT_GREEN;
    imageView.image = [UIImage systemImageNamed:@"tortoise.fill"];
    imageView.tintColor = TURTORA_PRIMARY_GREEN;
    imageView.layer.cornerRadius = TURTORA_RADIUS_SMALL;
    imageView.tag = 100;
    [headerView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    nameLabel.textColor = TURTORA_PRIMARY_TEXT;
    nameLabel.numberOfLines = 2;
    nameLabel.tag = 101;
    [headerView addSubview:nameLabel];
    
    UILabel *scientificLabel = [[UILabel alloc] init];
    scientificLabel.translatesAutoresizingMaskIntoConstraints = NO;
    scientificLabel.font = [UIFont italicSystemFontOfSize:11];
    scientificLabel.textColor = TURTORA_MUTED;
    scientificLabel.numberOfLines = 2;
    scientificLabel.tag = 102;
    [headerView addSubview:scientificLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintEqualToAnchor:headerView.topAnchor constant:10],
        [imageView.leadingAnchor constraintEqualToAnchor:headerView.leadingAnchor constant:10],
        [imageView.bottomAnchor constraintEqualToAnchor:headerView.bottomAnchor constant:-10],
        [imageView.widthAnchor constraintEqualToConstant:80],
        
        [nameLabel.topAnchor constraintEqualToAnchor:headerView.topAnchor constant:10],
        [nameLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:10],
        [nameLabel.trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor constant:-10],
        
        [scientificLabel.topAnchor constraintEqualToAnchor:nameLabel.bottomAnchor constant:4],
        [scientificLabel.leadingAnchor constraintEqualToAnchor:imageView.trailingAnchor constant:10],
        [scientificLabel.trailingAnchor constraintEqualToAnchor:headerView.trailingAnchor constant:-10]
    ]];
    
    return headerView;
}

- (void)configureWithSpeciesA:(NSManagedObject *)speciesA speciesB:(NSManagedObject *)speciesB {
    // Configure headers
    self.speciesANameLabel.text = [speciesA valueForKey:@"commonName"];
    self.speciesAScientificLabel.text = [speciesA valueForKey:@"scientificName"];
    
    // Load real photo for species A
    NSString *imageNameA = [speciesA valueForKey:@"imageName"];
    UIImage *photoA = [UIImage speciesImageForImageName:imageNameA];
    if (photoA) {
        self.speciesAImageView.image = photoA;
        self.speciesAImageView.tintColor = nil;
    }
    
    self.speciesBNameLabel.text = [speciesB valueForKey:@"commonName"];
    self.speciesBScientificLabel.text = [speciesB valueForKey:@"scientificName"];
    
    // Load real photo for species B
    NSString *imageNameB = [speciesB valueForKey:@"imageName"];
    UIImage *photoB = [UIImage speciesImageForImageName:imageNameB];
    if (photoB) {
        self.speciesBImageView.image = photoB;
        self.speciesBImageView.tintColor = nil;
    }
    
    // Remove previous attribute rows
    NSArray *arrangedSubviews = [self.stackView.arrangedSubviews copy];
    for (UIView *view in arrangedSubviews) {
        if (view.tag >= 200) {
            [view removeFromSuperview];
        }
    }
    
    // Add comparison attributes
    [self addComparisonRowWithTitle:@"Size" valueA:[speciesA valueForKey:@"size"] valueB:[speciesB valueForKey:@"size"]];
    [self addComparisonRowWithTitle:@"Diet" valueA:[speciesA valueForKey:@"diet"] valueB:[speciesB valueForKey:@"diet"]];
    [self addComparisonRowWithTitle:@"Habitat" valueA:[speciesA valueForKey:@"habitat"] valueB:[speciesB valueForKey:@"habitat"]];
    [self addComparisonRowWithTitle:@"Distribution" valueA:[speciesA valueForKey:@"distribution"] valueB:[speciesB valueForKey:@"distribution"]];
    [self addComparisonRowWithTitle:@"Lifespan" valueA:[speciesA valueForKey:@"lifespan"] valueB:[speciesB valueForKey:@"lifespan"]];
    [self addComparisonRowWithTitle:@"Conservation Status" valueA:[speciesA valueForKey:@"conservationStatus"] valueB:[speciesB valueForKey:@"conservationStatus"]];
}

- (void)addComparisonRowWithTitle:(NSString *)title valueA:(NSString *)valueA valueB:(NSString *)valueB {
    UIView *rowView = [[UIView alloc] init];
    rowView.translatesAutoresizingMaskIntoConstraints = NO;
    rowView.backgroundColor = [UIColor whiteColor];
    rowView.layer.cornerRadius = TURTORA_RADIUS_SMALL;
    rowView.layer.borderWidth = 0.5;
    rowView.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
    rowView.tag = 200 + [self.stackView.arrangedSubviews count];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold];
    titleLabel.textColor = TURTORA_MUTED;
    [rowView addSubview:titleLabel];
    
    UIStackView *valuesStack = [[UIStackView alloc] init];
    valuesStack.translatesAutoresizingMaskIntoConstraints = NO;
    valuesStack.axis = UILayoutConstraintAxisHorizontal;
    valuesStack.distribution = UIStackViewDistributionFillEqually;
    valuesStack.spacing = 12;
    [rowView addSubview:valuesStack];
    
    UILabel *valueALabel = [[UILabel alloc] init];
    valueALabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    valueALabel.textColor = TURTORA_PRIMARY_TEXT;
    valueALabel.numberOfLines = 0;
    valueALabel.text = valueA ?: @"N/A";
    [valuesStack addArrangedSubview:valueALabel];
    
    UILabel *valueBLabel = [[UILabel alloc] init];
    valueBLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
    valueBLabel.textColor = TURTORA_PRIMARY_TEXT;
    valueBLabel.numberOfLines = 0;
    valueBLabel.text = valueB ?: @"N/A";
    [valuesStack addArrangedSubview:valueBLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:rowView.topAnchor constant:10],
        [titleLabel.leadingAnchor constraintEqualToAnchor:rowView.leadingAnchor constant:12],
        [titleLabel.trailingAnchor constraintEqualToAnchor:rowView.trailingAnchor constant:-12],
        
        [valuesStack.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:6],
        [valuesStack.leadingAnchor constraintEqualToAnchor:rowView.leadingAnchor constant:12],
        [valuesStack.trailingAnchor constraintEqualToAnchor:rowView.trailingAnchor constant:-12],
        [valuesStack.bottomAnchor constraintEqualToAnchor:rowView.bottomAnchor constant:-10]
    ]];
    
    [self.stackView addArrangedSubview:rowView];
}

@end
