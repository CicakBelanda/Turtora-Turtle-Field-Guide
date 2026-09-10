//
//  FamilyListViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "FamilyListViewController.h"
#import "SpeciesDetailViewController.h"
#import "SpeciesCardCell.h"
#import "DataManager.h"
#import "Constants.h"

@interface FamilyListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation FamilyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 80;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[SpeciesCardCell class] forCellReuseIdentifier:@"SpeciesCardCell"];
    [self.view addSubview:self.tableView];
    
    // Loading indicator
    self.loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.loadingIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    self.loadingIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.loadingIndicator];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.loadingIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.loadingIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    [self loadSpecies];
}

- (void)loadSpecies {
    [self.loadingIndicator startAnimating];
    self.tableView.hidden = YES;
    
    NSString *filter = self.categoryFilter;
    NSArray *existingSpecies = self.species;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *results;
        if (filter) {
            DataManager *dataManager = [DataManager sharedManager];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"category == %@", filter];
            results = [dataManager fetchSpeciesWithPredicate:predicate];
        } else {
            results = existingSpecies ?: @[];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.species = results;
            [self.tableView reloadData];
            [self.loadingIndicator stopAnimating];
            self.tableView.hidden = NO;
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.species.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpeciesCardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpeciesCardCell" forIndexPath:indexPath];
    [cell configureWithSpecies:self.species[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSManagedObject *species = self.species[indexPath.row];
    [[DataManager sharedManager] addRecentSpecies:species];
    
    SpeciesDetailViewController *detailVC = [[SpeciesDetailViewController alloc] init];
    detailVC.species = species;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end
