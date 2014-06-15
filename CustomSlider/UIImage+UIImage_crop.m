//
//  UIImage+UIImage_crop.m
//  CustomSlider
//
//  Created by Allen on 07/04/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "UIImage+UIImage_crop.h"

@implementation UIImage (UIImage_crop)

- (UIImage *)crop:(CGRect)rect
{
    if (self.scale > 1.0f)
    {
        rect = CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale,
                          rect.size.width * self.scale, rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

@end
