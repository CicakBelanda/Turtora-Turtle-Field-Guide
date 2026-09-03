//
//  ExploreViewController.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 03/09/26.
//

#import "ExploreViewController.h"
#import "DataManager.h"

@interface ExploreViewController ()

@end

@implementation ExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Explore";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // Temporary label to verify the screen works
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    label.center = self.view.center;
    label.text = @"Explore Screen";
    label.textColor = [UIColor labelColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24 weight:UIFontWeightBold];
    [self.view addSubview:label];
}

@end
