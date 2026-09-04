//
//  FavoritesViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "FavoritesViewController.h"
#import "DataManager.h"
#import "SpeciesDetailViewController.h"
#import "SpeciesCardCell.h"
#import "EmptyStateView.h"

@interface FavoritesViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) EmptyStateView *emptyView;
@property (nonatomic, strong) NSArray *favorites;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Favorites";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupTableView];
    [self setupEmptyView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFavorites];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[SpeciesCardCell class] forCellReuseIdentifier:@"SpeciesCardCell"];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)setupEmptyView {
    self.emptyView = [[EmptyStateView alloc] initWithTitle:@"No Favorites Yet"
                                                   message:@"Explore species and save the ones you want to revisit."
                                                  iconName:@"heart"];
    self.emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.emptyView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.emptyView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.emptyView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.emptyView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor]
    ]];
}

- (void)loadFavorites {
    DataManager *dataManager = [DataManager sharedManager];
    self.favorites = [dataManager fetchFavorites];
    
    self.emptyView.hidden = self.favorites.count > 0;
    self.tableView.hidden = self.favorites.count == 0;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favorites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpeciesCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeciesCardCell" forIndexPath:indexPath];
    [cell configureWithSpecies:self.favorites[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSManagedObject *species = self.favorites[indexPath.row];
    
    // Track as recent
    [[DataManager sharedManager] addRecentSpecies:species];
    
    SpeciesDetailViewController *detailVC = [[SpeciesDetailViewController alloc] init];
    detailVC.species = species;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *species = self.favorites[indexPath.row];
        [[DataManager sharedManager] toggleFavoriteForSpecies:species];
        [self loadFavorites];
    }
}

@end
