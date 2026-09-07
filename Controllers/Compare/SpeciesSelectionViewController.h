//
//  SpeciesSelectionViewController.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SpeciesSelectionViewController;

@protocol SpeciesSelectionDelegate <NSObject>
- (void)speciesSelectionViewController:(SpeciesSelectionViewController *)controller didSelectSpecies:(NSManagedObject *)species;
@end

@interface SpeciesSelectionViewController : UIViewController

@property (nonatomic, weak) id<SpeciesSelectionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
