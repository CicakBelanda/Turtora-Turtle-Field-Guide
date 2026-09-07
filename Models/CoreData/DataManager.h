//
//  DataManager.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedManager;

- (void)importSpeciesIfNeeded;
- (NSArray *)fetchAllSpecies;
- (NSArray *)fetchFavorites;
- (NSArray *)fetchSpeciesWithPredicate:(NSPredicate *)predicate;
- (NSArray *)fetchCategories;
- (NSArray *)fetchFamilies;
- (NSArray *)fetchRecentSpecies:(NSInteger)limit;
- (NSArray *)fetchOrders;
- (NSArray *)fetchFamiliesForOrder:(NSManagedObject *)order;
- (NSArray *)fetchGeneraForFamily:(NSManagedObject *)family;
- (NSArray *)fetchSpeciesForGenus:(NSManagedObject *)genus;
- (void)addRecentSpecies:(NSManagedObject *)species;
- (void)toggleFavoriteForSpecies:(NSManagedObject *)species;
- (void)saveContext;

@end

NS_ASSUME_NONNULL_END
