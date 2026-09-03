//
//  DataManager.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "DataManager.h"

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Turtora"];
        [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
            if (error) {
                NSLog(@"Core Data error: %@", error);
            }
        }];
    }
    return self;
}

- (void)importSpeciesIfNeeded {
    // Check if data already exists
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
    NSError *error = nil;
    NSUInteger count = [self.persistentContainer.viewContext countForFetchRequest:fetchRequest error:&error];
    
    if (count > 0) {
        NSLog(@"Species data already exists (%lu records), skipping import.", (unsigned long)count);
        return;
    }
    
    // Load JSON
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"species" ofType:@"json"];
    if (!jsonPath) {
        NSLog(@"species.json not found in bundle.");
        return;
    }
    
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    if (!jsonData) {
        NSLog(@"Failed to read species.json");
        return;
    }
    
    NSError *jsonError = nil;
    NSArray *speciesArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&jsonError];
    if (jsonError) {
        NSLog(@"JSON parse error: %@", jsonError);
        return;
    }
    
    // Import into Core Data
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    for (NSDictionary *speciesDict in speciesArray) {
        // Create Species
        NSManagedObject *species = [NSEntityDescription insertNewObjectForEntityForName:@"Species" inManagedObjectContext:context];
        
        [species setValue:[NSUUID UUID] forKey:@"id"];
        [species setValue:speciesDict[@"commonName"] forKey:@"commonName"];
        [species setValue:speciesDict[@"scientificName"] forKey:@"scientificName"];
        [species setValue:speciesDict[@"speciesDescription"] forKey:@"speciesDescription"];
        [species setValue:speciesDict[@"imageName"] forKey:@"imageName"];
        [species setValue:speciesDict[@"category"] forKey:@"category"];
        [species setValue:speciesDict[@"size"] forKey:@"size"];
        [species setValue:speciesDict[@"diet"] forKey:@"diet"];
        [species setValue:speciesDict[@"habitat"] forKey:@"habitat"];
        [species setValue:speciesDict[@"distribution"] forKey:@"distribution"];
        [species setValue:speciesDict[@"lifespan"] forKey:@"lifespan"];
        [species setValue:speciesDict[@"conservationStatus"] forKey:@"conservationStatus"];
        [species setValue:@NO forKey:@"isFavorite"];
        
        // Find or create Genus
        NSString *genusName = speciesDict[@"genusName"];
        NSManagedObject *genus = [self findOrCreateEntity:@"Genus" withName:genusName inContext:context];
        [species setValue:genus forKey:@"genus"];
        
        // Find or create Family
        NSString *familyName = speciesDict[@"familyName"];
        NSManagedObject *family = [self findOrCreateEntity:@"Family" withName:familyName inContext:context];
        [genus setValue:family forKey:@"family"];
        
        // Find or create Order
        NSString *orderName = speciesDict[@"orderName"];
        NSManagedObject *order = [self findOrCreateEntity:@"Order" withName:orderName inContext:context];
        [family setValue:order forKey:@"order"];
    }
    
    // Save
    if ([context hasChanges]) {
        NSError *saveError = nil;
        if (![context save:&saveError]) {
            NSLog(@"Failed to save context: %@", saveError);
        } else {
            NSLog(@"Successfully imported %lu species.", (unsigned long)speciesArray.count);
        }
    }
}

- (NSManagedObject *)findOrCreateEntity:(NSString *)entityName withName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    fetchRequest.fetchLimit = 1;
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    if (results.count > 0) {
        return results[0];
    }
    
    // Create new
    NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    [newObject setValue:[NSUUID UUID] forKey:@"id"];
    [newObject setValue:name forKey:@"name"];
    return newObject;
}

- (NSArray *)fetchAllSpecies {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commonName" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Fetch error: %@", error);
        return @[];
    }
    return results;
}

- (NSArray *)fetchFavorites {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isFavorite == YES"];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commonName" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Fetch error: %@", error);
        return @[];
    }
    return results;
}

- (NSArray *)fetchSpeciesWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Species"];
    fetchRequest.predicate = predicate;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"commonName" ascending:YES];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    
    NSError *error = nil;
    NSArray *results = [self.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"Fetch error: %@", error);
        return @[];
    }
    return results;
}

- (void)toggleFavoriteForSpecies:(NSManagedObject *)species {
    NSNumber *currentValue = [species valueForKey:@"isFavorite"];
    [species setValue:@(!currentValue.boolValue) forKey:@"isFavorite"];
    [self saveContext];
}

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    if ([context hasChanges]) {
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Save error: %@", error);
        }
    }
}

@end
