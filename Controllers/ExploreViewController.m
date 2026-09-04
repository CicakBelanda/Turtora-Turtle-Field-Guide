//
//  ExploreViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "ExploreViewController.h"
#import "DataManager.h"
#import "SpeciesDetailViewController.h"
#import "FamilyListViewController.h"
#import "TaxonomyExplorerViewController.h"
#import "FeaturedSpeciesCell.h"
#import "HabitatCardView.h"
#import "FamilyRowView.h"
#import "RecentSpeciesView.h"
#import "SectionHeaderView.h"
#import "Constants.h"

@interface ExploreViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UICollectionView *featuredCollectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIStackView *habitatStackView;
@property (nonatomic, strong) UIStackView *familyStackView;
@property (nonatomic, strong) UIScrollView *recentScrollView;
@property (nonatomic, strong) UIStackView *recentStackView;

@property (nonatomic, strong) NSArray *featuredSpecies;
@property (nonatomic, strong) NSArray *families;
@property (nonatomic, strong) NSArray *recentSpecies;

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Explore";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupNavigationBar];
    [self setupScrollView];
    [self setupSearchBar];
    [self setupFeaturedSection];
    [self setupHabitatSection];
    [self setupFamilySection];
    [self setupTaxonomySection];
    [self setupRecentSection];
    [self loadData];
}

#pragma mark - Setup

- (void)setupNavigationBar {
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"ellipsis.circle"] style:UIBarButtonItemStylePlain target:self action:@selector(menuTapped)];
    self.navigationItem.rightBarButtonItem = menuButton;
}

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

- (void)setupSearchBar {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search species, family, genus...";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    // Add microphone button
    UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
    if (searchField) {
        UIButton *micButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [micButton setImage:[UIImage systemImageNamed:@"mic.fill"] forState:UIControlStateNormal];
        micButton.tintColor = [UIColor systemGreenColor];
        micButton.frame = CGRectMake(0, 0, 24, 24);
        searchField.rightView = micButton;
        searchField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    UIView *searchContainer = [[UIView alloc] init];
    searchContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [searchContainer addSubview:self.searchController.searchBar];
    self.searchController.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.searchController.searchBar.topAnchor constraintEqualToAnchor:searchContainer.topAnchor],
        [self.searchController.searchBar.leadingAnchor constraintEqualToAnchor:searchContainer.leadingAnchor],
        [self.searchController.searchBar.trailingAnchor constraintEqualToAnchor:searchContainer.trailingAnchor],
        [self.searchController.searchBar.bottomAnchor constraintEqualToAnchor:searchContainer.bottomAnchor],
        [searchContainer.heightAnchor constraintEqualToConstant:56]
    ]];
    
    [self.stackView addArrangedSubview:searchContainer];
}

- (void)setupFeaturedSection {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithTitle:@"Featured Species"];
    [self.stackView addArrangedSubview:headerView];
    
    // Collection view layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(280, 200);
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.featuredCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.featuredCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.featuredCollectionView.dataSource = self;
    self.featuredCollectionView.delegate = self;
    self.featuredCollectionView.showsHorizontalScrollIndicator = NO;
    self.featuredCollectionView.backgroundColor = [UIColor clearColor];
    [self.featuredCollectionView registerClass:[FeaturedSpeciesCell class] forCellWithReuseIdentifier:@"FeaturedCell"];
    [self.stackView addArrangedSubview:self.featuredCollectionView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.featuredCollectionView.heightAnchor constraintEqualToConstant:200]
    ]];
    
    // Page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.currentPageIndicatorTintColor = [UIColor systemGreenColor];
    self.pageControl.pageIndicatorTintColor = [UIColor systemGray3Color];
    self.pageControl.hidesForSinglePage = YES;
    [self.stackView addArrangedSubview:self.pageControl];
}

- (void)setupHabitatSection {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithTitle:@"Browse by Habitat"];
    [self.stackView addArrangedSubview:headerView];
    
    self.habitatStackView = [[UIStackView alloc] init];
    self.habitatStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.habitatStackView.axis = UILayoutConstraintAxisHorizontal;
    self.habitatStackView.distribution = UIStackViewDistributionFillEqually;
    self.habitatStackView.spacing = 12;
    [self.stackView addArrangedSubview:self.habitatStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.habitatStackView.heightAnchor constraintEqualToConstant:100]
    ]];
}

- (void)setupFamilySection {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithTitle:@"Browse by Family"];
    [self.stackView addArrangedSubview:headerView];
    
    self.familyStackView = [[UIStackView alloc] init];
    self.familyStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.familyStackView.axis = UILayoutConstraintAxisVertical;
    self.familyStackView.spacing = 8;
    [self.stackView addArrangedSubview:self.familyStackView];
}

- (void)setupTaxonomySection {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithTitle:@"Browse Taxonomy"];
    [self.stackView addArrangedSubview:headerView];
    
    UIButton *taxonomyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    taxonomyButton.translatesAutoresizingMaskIntoConstraints = NO;
    taxonomyButton.backgroundColor = [UIColor tertiarySystemBackgroundColor];
    taxonomyButton.layer.cornerRadius = 8;
    taxonomyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    taxonomyButton.contentEdgeInsets = UIEdgeInsetsMake(12, 16, 12, 16);
    taxonomyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);
    
    // Icon
    UIImage *icon = [UIImage systemImageNamed:@"list.bullet.indent"];
    [taxonomyButton setImage:icon forState:UIControlStateNormal];
    taxonomyButton.tintColor = [UIColor systemGreenColor];
    
    // Title
    [taxonomyButton setTitle:@"Explore Classification" forState:UIControlStateNormal];
    [taxonomyButton setTitleColor:[UIColor labelColor] forState:UIControlStateNormal];
    taxonomyButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    
    // Subtitle
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"Order → Family → Genus → Species";
    subtitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    subtitleLabel.textColor = [UIColor secondaryLabelColor];
    subtitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [taxonomyButton addSubview:subtitleLabel];
    [NSLayoutConstraint activateConstraints:@[
        [subtitleLabel.leadingAnchor constraintEqualToAnchor:taxonomyButton.leadingAnchor constant:52],
        [subtitleLabel.bottomAnchor constraintEqualToAnchor:taxonomyButton.bottomAnchor constant:-8]
    ]];
    
    // Chevron
    UIImageView *chevron = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"chevron.right"]];
    chevron.tintColor = [UIColor systemGray3Color];
    chevron.translatesAutoresizingMaskIntoConstraints = NO;
    [taxonomyButton addSubview:chevron];
    [NSLayoutConstraint activateConstraints:@[
        [chevron.centerYAnchor constraintEqualToAnchor:taxonomyButton.centerYAnchor],
        [chevron.trailingAnchor constraintEqualToAnchor:taxonomyButton.trailingAnchor constant:-16],
        [chevron.widthAnchor constraintEqualToConstant:12],
        [chevron.heightAnchor constraintEqualToConstant:12]
    ]];
    
    [taxonomyButton addTarget:self action:@selector(taxonomyTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addArrangedSubview:taxonomyButton];
    [taxonomyButton.heightAnchor constraintEqualToConstant:60].active = YES;
}

- (void)setupRecentSection {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithTitle:@"Recently Viewed"];
    [self.stackView addArrangedSubview:headerView];
    
    self.recentScrollView = [[UIScrollView alloc] init];
    self.recentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.recentScrollView.showsHorizontalScrollIndicator = NO;
    [self.stackView addArrangedSubview:self.recentScrollView];
    
    self.recentStackView = [[UIStackView alloc] init];
    self.recentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.recentStackView.axis = UILayoutConstraintAxisHorizontal;
    self.recentStackView.spacing = 12;
    [self.recentScrollView addSubview:self.recentStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.recentScrollView.heightAnchor constraintEqualToConstant:80],
        [self.recentStackView.topAnchor constraintEqualToAnchor:self.recentScrollView.topAnchor],
        [self.recentStackView.leadingAnchor constraintEqualToAnchor:self.recentScrollView.leadingAnchor],
        [self.recentStackView.trailingAnchor constraintEqualToAnchor:self.recentScrollView.trailingAnchor],
        [self.recentStackView.bottomAnchor constraintEqualToAnchor:self.recentScrollView.bottomAnchor],
        [self.recentStackView.heightAnchor constraintEqualToAnchor:self.recentScrollView.heightAnchor]
    ]];
}

#pragma mark - Data Loading

- (void)loadData {
    DataManager *dataManager = [DataManager sharedManager];
    
    // Featured species (first 5)
    NSArray *allSpecies = [dataManager fetchAllSpecies];
    self.featuredSpecies = [allSpecies subarrayWithRange:NSMakeRange(0, MIN(5, allSpecies.count))];
    self.pageControl.numberOfPages = self.featuredSpecies.count;
    [self.featuredCollectionView reloadData];
    
    // Families
    self.families = [dataManager fetchFamilies];
    [self setupFamilyRows];
    
    // Recent
    self.recentSpecies = [dataManager fetchRecentSpecies:10];
    [self setupRecentViews];
    
    // Habitat counts
    [self setupHabitatCards];
}

- (void)setupHabitatCards {
    [self.habitatStackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    DataManager *dataManager = [DataManager sharedManager];
    NSArray *allSpecies = [dataManager fetchAllSpecies];
    
    NSMutableDictionary *counts = [NSMutableDictionary dictionary];
    for (NSManagedObject *species in allSpecies) {
        NSString *category = [species valueForKey:@"category"];
        if (category) {
            counts[category] = @([counts[category] integerValue] + 1);
        }
    }
    
    NSArray *categories = @[@"Marine Turtle", @"Freshwater Turtle", @"Tortoise"];
    NSDictionary *icons = @{
        @"Marine Turtle": @"water.waves",
        @"Freshwater Turtle": @"drop.fill",
        @"Tortoise": @"leaf.fill"
    };
    
    for (NSString *category in categories) {
        NSInteger count = [counts[category] integerValue];
        if (count == 0) continue;
        
        HabitatCardView *card = [[HabitatCardView alloc] initWithTitle:category count:count iconName:icons[category]];
        card.tag = [categories indexOfObject:category];
        [card addTarget:self action:@selector(habitatTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.habitatStackView addArrangedSubview:card];
    }
}

- (void)setupFamilyRows {
    [self.familyStackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    DataManager *dataManager = [DataManager sharedManager];
    
    for (NSManagedObject *family in self.families) {
        NSString *familyName = [family valueForKey:@"name"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"genus.family.name == %@", familyName];
        NSArray *speciesInFamily = [dataManager fetchSpeciesWithPredicate:predicate];
        NSInteger count = speciesInFamily.count;
        
        FamilyRowView *row = [[FamilyRowView alloc] initWithFamilyName:familyName count:count];
        row.tag = [self.families indexOfObject:family];
        [row addTarget:self action:@selector(familyTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.familyStackView addArrangedSubview:row];
    }
}

- (void)setupRecentViews {
    [self.recentStackView.arrangedSubviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (self.recentSpecies.count == 0) {
        UILabel *emptyLabel = [[UILabel alloc] init];
        emptyLabel.text = @"No recently viewed species";
        emptyLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        emptyLabel.textColor = [UIColor secondaryLabelColor];
        [self.recentStackView addArrangedSubview:emptyLabel];
        return;
    }
    
    for (NSManagedObject *species in self.recentSpecies) {
        RecentSpeciesView *thumbView = [[RecentSpeciesView alloc] initWithSpecies:species];
        thumbView.tag = [self.recentSpecies indexOfObject:species];
        [thumbView addTarget:self action:@selector(recentTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.recentStackView addArrangedSubview:thumbView];
    }
}

#pragma mark - Actions

- (void)menuTapped {
    NSLog(@"Menu tapped");
}

- (void)taxonomyTapped {
    TaxonomyExplorerViewController *taxonomyVC = [[TaxonomyExplorerViewController alloc] init];
    taxonomyVC.currentLevel = TaxonomyLevelOrder;
    [self.navigationController pushViewController:taxonomyVC animated:YES];
}

- (void)habitatTapped:(HabitatCardView *)sender {
    NSArray *categories = @[@"Marine Turtle", @"Freshwater Turtle", @"Tortoise"];
    NSString *category = categories[sender.tag];
    
    DataManager *dataManager = [DataManager sharedManager];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", category];
    NSArray *species = [dataManager fetchSpeciesWithPredicate:predicate];
    
    FamilyListViewController *listVC = [[FamilyListViewController alloc] init];
    listVC.title = category;
    listVC.species = species;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)familyTapped:(FamilyRowView *)sender {
    NSManagedObject *family = self.families[sender.tag];
    NSString *familyName = [family valueForKey:@"name"];
    
    DataManager *dataManager = [DataManager sharedManager];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"genus.family.name == %@", familyName];
    NSArray *species = [dataManager fetchSpeciesWithPredicate:predicate];
    
    FamilyListViewController *listVC = [[FamilyListViewController alloc] init];
    listVC.title = familyName;
    listVC.species = species;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)recentTapped:(RecentSpeciesView *)sender {
    [self showSpeciesDetail:sender.species];
}

- (void)showSpeciesDetail:(NSManagedObject *)species {
    SpeciesDetailViewController *detailVC = [[SpeciesDetailViewController alloc] init];
    detailVC.species = species;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.featuredSpecies.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FeaturedSpeciesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeaturedCell" forIndexPath:indexPath];
    [cell configureWithSpecies:self.featuredSpecies[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *species = self.featuredSpecies[indexPath.item];
    [self showSpeciesDetail:species];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    if (searchText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commonName CONTAINS[cd] %@ OR scientificName CONTAINS[cd] %@", searchText, searchText];
        DataManager *dataManager = [DataManager sharedManager];
        NSArray *results = [dataManager fetchSpeciesWithPredicate:predicate];
        
        if (results.count == 0) {
            // Show no results state
            UILabel *noResultsLabel = [[UILabel alloc] initWithFrame:self.view.bounds];
            noResultsLabel.text = [NSString stringWithFormat:@"No Species Found for \"%@\"", searchText];
            noResultsLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
            noResultsLabel.textColor = TURTORA_SECONDARY_TEXT;
            noResultsLabel.textAlignment = NSTextAlignmentCenter;
            noResultsLabel.tag = 999;
            [self.view addSubview:noResultsLabel];
        } else {
            // Remove no results label if exists
            UIView *noResultsLabel = [self.view viewWithTag:999];
            [noResultsLabel removeFromSuperview];
        }
    }
}

@end
