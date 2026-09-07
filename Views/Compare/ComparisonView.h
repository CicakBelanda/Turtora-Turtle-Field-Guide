//
//  ComparisonView.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ComparisonView : UIView

- (void)configureWithSpeciesA:(NSManagedObject *)speciesA speciesB:(NSManagedObject *)speciesB;

@end

NS_ASSUME_NONNULL_END
