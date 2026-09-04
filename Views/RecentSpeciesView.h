//
//  RecentSpeciesView.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecentSpeciesView : UIControl

@property (nonatomic, strong) NSManagedObject *species;

- (instancetype)initWithSpecies:(NSManagedObject *)species;

@end

NS_ASSUME_NONNULL_END
