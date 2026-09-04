//
//  SpeciesSelectionViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "SpeciesSelectionViewController.h"
#import "DataManager.h"
#import "TaxonomyLevelCell.h"

@interface SpeciesSelectionViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSArray *allSpecies;
@property (nonatomic, strong) NSArray *filteredSpecies;

@end

@implementation SpeciesSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Select Species";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self setupNavigationBar];
    [self setupTableView];
    [self setupSearchController];
    [self loadData];
}

- (void)setupNavigationBar {
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[TaxonomyLevelCell class] forCellReuseIdentifier:@"TaxonomyLevelCell"];
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)setupSearchController {
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.placeholder = @"Search species...";
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.searchController = self.searchController;
    self.definesPresentationContext = YES;
}

- (void)loadData {
    DataManager *dataManager = [DataManager sharedManager];
    self.allSpecies = [dataManager fetchAllSpecies];
    self.filteredSpecies = self.allSpecies;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredSpecies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaxonomyLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxonomyLevelCell" forIndexPath:indexPath];
    
    NSManagedObject *species = self.filteredSpecies[indexPath.row];
    cell.titleText = [species valueForKey:@"commonName"];
    cell.subtitleText = [species valueForKey:@"scientificName"];
    cell.countText = [species valueForKey:@"category"];
    cell.iconName = @"tortoise.fill";
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSManagedObject *selectedSpecies = self.filteredSpecies[indexPath.row];
    [self.delegate speciesSelectionViewController:self didSelectSpecies:selectedSpecies];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    
    if (searchText.length == 0) {
        self.filteredSpecies = self.allSpecies;
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"commonName CONTAINS[cd] %@ OR scientificName CONTAINS[cd] %@", searchText, searchText];
        self.filteredSpecies = [self.allSpecies filteredArrayUsingPredicate:predicate];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Actions

- (void)cancelTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
