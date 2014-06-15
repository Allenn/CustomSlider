//
//  CustomSlider.h
//  CustomSlider
//
//  Created by Allen on 07/04/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSlider : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic) NSInteger nbPositions;
@property (nonatomic) NSInteger currentPosition;
@property (nonatomic) UIImage* backImage;

- (id)initWithBackImage:(NSString*)backImageName andWithFrontImage:(NSString*)frontImageName andWithCurrentPositionImage:(NSString *)buttonImageName andWithFrame:(CGRect)frame;
- (void)setNbPositions:(NSInteger)nbPos andCurrentPosition:(NSInteger)pos;

@end
