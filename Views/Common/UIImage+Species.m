//
//  UIImage+Species.m
//  Turtora
//
//  Created by Kevin Joseph Handoyo on 10/09/26.
//

#import "UIImage+Species.h"

@implementation UIImage (Species)

+ (nullable UIImage *)speciesImageForImageName:(NSString *)imageName {
    // Map imageName to actual filename
    static NSDictionary *mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"image_mapping" ofType:@"json"];
        if (path) {
            NSData *data = [NSData dataWithContentsOfFile:path];
            if (data) {
                mapping = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
        }
    });
    
    if (!mapping || !imageName) return nil;
    
    NSString *filename = mapping[imageName];
    if (!filename) return nil;
    
    // Try to load from bundle
    NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    if (filePath) {
        return [UIImage imageWithContentsOfFile:filePath];
    }
    
    return nil;
}

@end
