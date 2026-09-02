//
//  AppDelegate.h
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 02/09/26.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

