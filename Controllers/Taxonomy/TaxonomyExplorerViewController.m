//
//  TaxonomyExplorerViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "TaxonomyExplorerViewController.h"
#import "DataManager.h"
#import "SpeciesDetailViewController.h"
#import "TaxonomyLevelCell.h"

@interface TaxonomyExplorerViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *items;

@end

@implementation TaxonomyExplorerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    [self setupTableView];
    [self loadData];
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

- (void)loadData {
    DataManager *dataManager = [DataManager sharedManager];
    
    switch (self.currentLevel) {
        case TaxonomyLevelOrder:
            self.items = [dataManager fetchOrders];
            self.title = @"Browse Taxonomy";
            break;
        case TaxonomyLevelFamily:
            if (self.parentObject) {
                self.items = [dataManager fetchFamiliesForOrder:self.parentObject];
                self.title = [self.parentObject valueForKey:@"name"];
            } else {
                self.items = [dataManager fetchFamilies];
                self.title = @"Browse Taxonomy";
            }
            break;
        case TaxonomyLevelGenus:
            self.items = [dataManager fetchGeneraForFamily:self.parentObject];
            self.title = [self.parentObject valueForKey:@"name"];
            break;
        case TaxonomyLevelSpecies:
            self.items = [dataManager fetchSpeciesForGenus:self.parentObject];
            self.title = [self.parentObject valueForKey:@"name"];
            break;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaxonomyLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaxonomyLevelCell" forIndexPath:indexPath];
    
    NSManagedObject *object = self.items[indexPath.row];
    NSString *name;
    if (self.currentLevel == TaxonomyLevelSpecies) {
        name = [object valueForKey:@"commonName"];
    } else {
        name = [object valueForKey:@"name"];
    }
    NSString *subtitle = [self subtitleForObject:object];
    NSString *countText = [self countTextForObject:object];
    NSString *iconName = [self iconNameForCurrentLevel];
    
    cell.titleText = name;
    cell.subtitleText = subtitle;
    cell.countText = countText;
    cell.iconName = iconName;
    
    return cell;
}

- (NSString *)subtitleForObject:(NSManagedObject *)object {
    switch (self.currentLevel) {
        case TaxonomyLevelOrder:
            return @"Order";
        case TaxonomyLevelFamily:
            return @"Family";
        case TaxonomyLevelGenus:
            return @"Genus";
        case TaxonomyLevelSpecies:
            return [object valueForKey:@"scientificName"] ?: @"";
    }
    return @"";
}

- (NSString *)countTextForObject:(NSManagedObject *)object {
    DataManager *dataManager = [DataManager sharedManager];
    NSInteger count = 0;
    
    switch (self.currentLevel) {
        case TaxonomyLevelOrder:
            count = [[dataManager fetchFamiliesForOrder:object] count];
            return [NSString stringWithFormat:@"%ld families", (long)count];
        case TaxonomyLevelFamily:
            count = [[dataManager fetchGeneraForFamily:object] count];
            return [NSString stringWithFormat:@"%ld genera", (long)count];
        case TaxonomyLevelGenus:
            count = [[dataManager fetchSpeciesForGenus:object] count];
            return [NSString stringWithFormat:@"%ld species", (long)count];
        case TaxonomyLevelSpecies:
            return [object valueForKey:@"category"] ?: @"";
    }
    return @"";
}

- (NSString *)iconNameForCurrentLevel {
    switch (self.currentLevel) {
        case TaxonomyLevelOrder:
            return @"list.bullet.indent";
        case TaxonomyLevelFamily:
            return @"list.bullet";
        case TaxonomyLevelGenus:
            return @"circle.grid.2x1";
        case TaxonomyLevelSpecies:
            return @"leaf.fill";
    }
    return @"circle";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSManagedObject *selectedObject = self.items[indexPath.row];
    
    if (self.currentLevel == TaxonomyLevelSpecies) {
        // Show species detail
        SpeciesDetailViewController *detailVC = [[SpeciesDetailViewController alloc] init];
        detailVC.species = selectedObject;
        [self.navigationController pushViewController:detailVC animated:YES];
    } else {
        // Drill down
        TaxonomyExplorerViewController *nextVC = [[TaxonomyExplorerViewController alloc] init];
        nextVC.currentLevel = self.currentLevel + 1;
        nextVC.parentObject = selectedObject;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
}

@end
