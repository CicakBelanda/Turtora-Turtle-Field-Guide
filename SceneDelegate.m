//
//  SceneDelegate.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 02/09/26.
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "ExploreViewController.h"
#import "CompareViewController.h"
#import "FavoritesViewController.h"
#import "DataManager.h"

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    if ([scene isKindOfClass:[UIWindowScene class]]) {
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
        
        // Initialize tab bar controller
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        
        // Explore tab
        ExploreViewController *exploreVC = [[ExploreViewController alloc] init];
        UINavigationController *exploreNav = [[UINavigationController alloc] initWithRootViewController:exploreVC];
        exploreNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Explore" image:[UIImage systemImageNamed:@"magnifyingglass"] tag:0];
        
        // Compare tab
        CompareViewController *compareVC = [[CompareViewController alloc] init];
        UINavigationController *compareNav = [[UINavigationController alloc] initWithRootViewController:compareVC];
        compareNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Compare" image:[UIImage systemImageNamed:@"arrow.left.arrow.right"] tag:1];
        
        // Favorites tab
        FavoritesViewController *favoritesVC = [[FavoritesViewController alloc] init];
        UINavigationController *favoritesNav = [[UINavigationController alloc] initWithRootViewController:favoritesVC];
        favoritesNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage systemImageNamed:@"heart"] tag:2];
        
        tabBarController.viewControllers = @[exploreNav, compareNav, favoritesNav];
        
        self.window.rootViewController = tabBarController;
        [self.window makeKeyAndVisible];
        
        // Import data on first launch
        [[DataManager sharedManager] importSpeciesIfNeeded];
    }
}

- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}

- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}

- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}

- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}

- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    
    // Save changes in the application's managed object context when the application transitions to the background.
    [(AppDelegate *)UIApplication.sharedApplication.delegate saveContext];
}

@end
