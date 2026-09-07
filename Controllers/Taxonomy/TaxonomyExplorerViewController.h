//
//  TaxonomyExplorerViewController.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TaxonomyLevel) {
    TaxonomyLevelOrder,
    TaxonomyLevelFamily,
    TaxonomyLevelGenus,
    TaxonomyLevelSpecies
};

@interface TaxonomyExplorerViewController : UIViewController

@property (nonatomic, assign) TaxonomyLevel currentLevel;
@property (nonatomic, strong, nullable) NSManagedObject *parentObject;

@end

NS_ASSUME_NONNULL_END
