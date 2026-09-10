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
        // Downsample to prevent memory crashes with large images
        return [self downsampledImageWithPath:filePath];
    }
    
    return nil;
}

+ (UIImage *)downsampledImageWithPath:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    CGImageSourceRef source = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
    if (!source) return nil;
    
    // Target size: max 300px wide/tall (enough for display)
    const CGFloat maxDimension = 300.0;
    CFDictionaryRef options = (__bridge CFDictionaryRef)@{
        (id)kCGImageSourceThumbnailMaxPixelSize: @(maxDimension),
        (id)kCGImageSourceCreateThumbnailFromImageAlways: @YES,
        (id)kCGImageSourceCreateThumbnailWithTransform: @YES,
    };
    
    CGImageRef thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, options);
    CFRelease(source);
    
    if (!thumbnail) return nil;
    
    UIImage *image = [UIImage imageWithCGImage:thumbnail];
    CGImageRelease(thumbnail);
    
    return image;
}

@end
