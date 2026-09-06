//
//  CompareViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "CompareViewController.h"
#import "SpeciesSelectionViewController.h"
#import "ComparisonView.h"
#import "DataManager.h"

@interface CompareViewController () <SpeciesSelectionDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *selectionAreaA;
@property (nonatomic, strong) UIView *selectionAreaB;
@property (nonatomic, strong) UILabel *speciesANameLabel;
@property (nonatomic, strong) UILabel *speciesBNameLabel;
@property (nonatomic, strong) UIButton *selectAButton;
@property (nonatomic, strong) UIButton *selectBButton;
@property (nonatomic, strong) ComparisonView *comparisonView;
@property (nonatomic, strong) UILabel *vsLabel;
@property (nonatomic, strong) UIButton *compareButton;

@property (nonatomic, strong) NSManagedObject *speciesA;
@property (nonatomic, strong) NSManagedObject *speciesB;
@property (nonatomic, assign) NSInteger selectedSide;

@end

@implementation CompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Compare";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupScrollView];
    [self setupSelectionAreas];
    [self setupComparisonView];
    [self updateUI];
}

#pragma mark - Setup

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.stackView = [[UIStackView alloc] init];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 24;
    self.stackView.layoutMargins = UIEdgeInsetsMake(16, 16, 32, 16);
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

- (void)setupSelectionAreas {
    // Header
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"Select Two Species";
    headerLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    headerLabel.textColor = [UIColor labelColor];
    [self.stackView addArrangedSubview:headerLabel];
    
    // Selection areas container
    UIStackView *selectionStack = [[UIStackView alloc] init];
    selectionStack.translatesAutoresizingMaskIntoConstraints = NO;
    selectionStack.axis = UILayoutConstraintAxisHorizontal;
    selectionStack.distribution = UIStackViewDistributionFillEqually;
    selectionStack.spacing = 12;
    [self.stackView addArrangedSubview:selectionStack];
    
    // Species A selection
    self.selectionAreaA = [self createSelectionAreaWithTitle:@"Species A" side:@"A"];
    [selectionStack addArrangedSubview:self.selectionAreaA];
    self.speciesANameLabel = [self.selectionAreaA viewWithTag:100];
    self.selectAButton = [self.selectionAreaA viewWithTag:101];
    
    // VS label
    self.vsLabel = [[UILabel alloc] init];
    self.vsLabel.text = @"VS";
    self.vsLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
    self.vsLabel.textColor = [UIColor systemGray3Color];
    self.vsLabel.textAlignment = NSTextAlignmentCenter;
    [selectionStack addArrangedSubview:self.vsLabel];
    
    // Species B selection
    self.selectionAreaB = [self createSelectionAreaWithTitle:@"Species B" side:@"B"];
    [selectionStack addArrangedSubview:self.selectionAreaB];
    self.speciesBNameLabel = [self.selectionAreaB viewWithTag:100];
    self.selectBButton = [self.selectionAreaB viewWithTag:101];
    
    [NSLayoutConstraint activateConstraints:@[
        [selectionStack.heightAnchor constraintEqualToConstant:120]
    ]];
    
    // Compare button
    self.compareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.compareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.compareButton setTitle:@"Compare" forState:UIControlStateNormal];
    self.compareButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    self.compareButton.backgroundColor = [UIColor systemGreenColor];
    [self.compareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.compareButton.layer.cornerRadius = 12;
    self.compareButton.enabled = NO;
    self.compareButton.alpha = 0.5;
    [self.compareButton addTarget:self action:@selector(compareTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addArrangedSubview:self.compareButton];
    [self.compareButton.heightAnchor constraintEqualToConstant:50].active = YES;
}

- (UIView *)createSelectionAreaWithTitle:(NSString *)title side:(NSString *)side {
    UIView *areaView = [[UIView alloc] init];
    areaView.translatesAutoresizingMaskIntoConstraints = NO;
    areaView.backgroundColor = [UIColor secondarySystemBackgroundColor];
    areaView.layer.cornerRadius = 12;
    areaView.layer.borderWidth = 1;
    areaView.layer.borderColor = [UIColor systemGray4Color].CGColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    titleLabel.textColor = [UIColor secondaryLabelColor];
    [areaView addSubview:titleLabel];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    nameLabel.text = @"Not selected";
    nameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor tertiaryLabelColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.numberOfLines = 2;
    nameLabel.tag = 100;
    [areaView addSubview:nameLabel];
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    selectButton.translatesAutoresizingMaskIntoConstraints = NO;
    [selectButton setTitle:@"Select" forState:UIControlStateNormal];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    selectButton.tintColor = [UIColor systemGreenColor];
    selectButton.tag = 101;
    [selectButton addTarget:self action:@selector(selectButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [areaView addSubview:selectButton];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.topAnchor constraintEqualToAnchor:areaView.topAnchor constant:8],
        [titleLabel.leadingAnchor constraintEqualToAnchor:areaView.leadingAnchor constant:12],
        [titleLabel.trailingAnchor constraintEqualToAnchor:areaView.trailingAnchor constant:-12],
        
        [nameLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:8],
        [nameLabel.leadingAnchor constraintEqualToAnchor:areaView.leadingAnchor constant:8],
        [nameLabel.trailingAnchor constraintEqualToAnchor:areaView.trailingAnchor constant:-8],
        
        [selectButton.bottomAnchor constraintEqualToAnchor:areaView.bottomAnchor constant:-8],
        [selectButton.centerXAnchor constraintEqualToAnchor:areaView.centerXAnchor]
    ]];
    
    return areaView;
}

- (void)setupComparisonView {
    self.comparisonView = [[ComparisonView alloc] initWithFrame:CGRectZero];
    self.comparisonView.translatesAutoresizingMaskIntoConstraints = NO;
    self.comparisonView.hidden = YES;
    [self.stackView addArrangedSubview:self.comparisonView];
    [self.comparisonView.heightAnchor constraintGreaterThanOrEqualToConstant:400].active = YES;
}

#pragma mark - Actions

- (void)selectButtonTapped:(UIButton *)sender {
    SpeciesSelectionViewController *selectionVC = [[SpeciesSelectionViewController alloc] init];
    selectionVC.delegate = self;
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:selectionVC];
    
    if (sender == self.selectAButton) {
        navController.title = @"Select Species A";
        self.selectedSide = 0; // A
    } else {
        navController.title = @"Select Species B";
        self.selectedSide = 1; // B
    }
    
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)compareTapped {
    if (self.speciesA && self.speciesB) {
        [self.comparisonView configureWithSpeciesA:self.speciesA speciesB:self.speciesB];
        self.comparisonView.hidden = NO;
    }
}

- (void)updateUI {
    if (self.speciesA) {
        self.speciesANameLabel.text = [self.speciesA valueForKey:@"commonName"];
        self.speciesANameLabel.textColor = [UIColor labelColor];
        [self.selectAButton setTitle:@"Change" forState:UIControlStateNormal];
    }
    
    if (self.speciesB) {
        self.speciesBNameLabel.text = [self.speciesB valueForKey:@"commonName"];
        self.speciesBNameLabel.textColor = [UIColor labelColor];
        [self.selectBButton setTitle:@"Change" forState:UIControlStateNormal];
    }
    
    BOOL canCompare = self.speciesA != nil && self.speciesB != nil;
    self.compareButton.enabled = canCompare;
    self.compareButton.alpha = canCompare ? 1.0 : 0.5;
}

#pragma mark - SpeciesSelectionDelegate

- (void)speciesSelectionViewController:(SpeciesSelectionViewController *)controller didSelectSpecies:(NSManagedObject *)species {
    // Dismiss the modal first
    [self dismissViewControllerAnimated:YES completion:^{
        // Then update the correct side
        if (self.selectedSide == 0) {
            self.speciesA = species;
        } else {
            self.speciesB = species;
        }
        
        [self updateUI];
    }];
}

@end
