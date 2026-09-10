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
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search species, family, genus...";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    self.definesPresentationContext = YES;
    
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
    //    ScrollView(.horizontal) {
    //        LazyHStack { ForEach(cards) { CardView($0) } }
    //    }
    //    .scrollTargetBehavior(.viewAligned)
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat collectionViewWidth = screenWidth - 32; // stack view 16px margins each side
    CGFloat cardWidth = collectionViewWidth - 40; // 20px peeking on each side when centered
    CGFloat sideInset = 20;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(cardWidth, cardWidth * 0.6);
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(0, sideInset, 0, sideInset);
    
    self.featuredCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.featuredCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.featuredCollectionView.dataSource = self;
    self.featuredCollectionView.delegate = self;
    self.featuredCollectionView.showsHorizontalScrollIndicator = NO;
    self.featuredCollectionView.backgroundColor = [UIColor clearColor];
    self.featuredCollectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    [self.featuredCollectionView registerClass:[FeaturedSpeciesCell class] forCellWithReuseIdentifier:@"FeaturedCell"];
    [self.stackView addArrangedSubview:self.featuredCollectionView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.featuredCollectionView.heightAnchor constraintEqualToConstant:cardWidth * 0.6]
    ]];
    
    // Page control
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    self.pageControl.currentPageIndicatorTintColor = [UIColor systemGreenColor];
    self.pageControl.pageIndicatorTintColor = [UIColor systemGray3Color];
    self.pageControl.hidesForSinglePage = YES;
    [self.stackView addArrangedSubview:self.pageControl];
    [self.pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)pageControlChanged:(UIPageControl *)sender {
    CGFloat cardWidth = (self.view.frame.size.width - 32) - 40;
    CGFloat itemWidth = cardWidth + 12;
    CGFloat x = sender.currentPage * itemWidth;
    [self.featuredCollectionView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.featuredCollectionView) {
        CGFloat cardWidth = (self.view.frame.size.width - 32) - 40;
        CGFloat itemWidth = cardWidth + 12;
        NSInteger page = round(scrollView.contentOffset.x / itemWidth);
        self.pageControl.currentPage = page;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (scrollView == self.featuredCollectionView) {
        CGFloat cardWidth = (self.view.frame.size.width - 32) - 40;
        CGFloat itemWidth = cardWidth + 12;
        CGFloat targetX = targetContentOffset->x;
        NSInteger page = round(targetX / itemWidth);
        targetContentOffset->x = page * itemWidth;
    }
}

- (void)setupHabitatSection {
    SectionHeaderView *headerView = [[SectionHeaderView alloc] initWithTitle:@"Browse by Habitat"];
    [self.stackView addArrangedSubview:headerView];
    
    // Horizontal scroll view for habitat cards
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.stackView addArrangedSubview:scrollView];
    
    self.habitatStackView = [[UIStackView alloc] init];
    self.habitatStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.habitatStackView.axis = UILayoutConstraintAxisHorizontal;
    self.habitatStackView.spacing = 12;
    [scrollView addSubview:self.habitatStackView];
    
    [NSLayoutConstraint activateConstraints:@[
        [scrollView.heightAnchor constraintEqualToConstant:100],
        [self.habitatStackView.topAnchor constraintEqualToAnchor:scrollView.topAnchor],
        [self.habitatStackView.leadingAnchor constraintEqualToAnchor:scrollView.leadingAnchor],
        [self.habitatStackView.trailingAnchor constraintEqualToAnchor:scrollView.trailingAnchor],
        [self.habitatStackView.bottomAnchor constraintEqualToAnchor:scrollView.bottomAnchor],
        [self.habitatStackView.heightAnchor constraintEqualToAnchor:scrollView.heightAnchor]
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
    
    NSArray *categories = @[@"Sea Turtle", @"Freshwater Turtle", @"Tortoise", @"Softshell Turtle"];
    NSDictionary *icons = @{
        @"Sea Turtle": @"water.waves",
        @"Freshwater Turtle": @"drop.fill",
        @"Tortoise": @"leaf.fill",
        @"Softshell Turtle": @"tortoise.fill"
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

- (void)habitatTapped:(HabitatCardView *)sender {
    NSString *category = sender.title;
    
    FamilyListViewController *listVC = [[FamilyListViewController alloc] init];
    listVC.title = category;
    listVC.categoryFilter = category;
    [self.navigationController pushViewController:listVC animated:YES];
}

- (void)familyTapped:(FamilyRowView *)sender {
    NSManagedObject *family = self.families[sender.tag];
    NSString *familyName = [family valueForKey:@"name"];
    
    TaxonomyExplorerViewController *taxonomyVC = [[TaxonomyExplorerViewController alloc] init];
    taxonomyVC.currentLevel = TaxonomyLevelGenus;
    taxonomyVC.parentObject = family;
    taxonomyVC.title = familyName;
    [self.navigationController pushViewController:taxonomyVC animated:YES];
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
