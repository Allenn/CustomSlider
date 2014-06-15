//
//  CustomSlider.m
//  CustomSlider
//
//  Created by Allen on 07/04/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "CustomSlider.h"
#import "UIImage+UIImage_crop.h"

@interface CustomSlider ()

@property (weak, nonatomic) IBOutlet UIImageView *frontImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontImageHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImageWidthConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *buttonImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonImageWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonImageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonImagePositionConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImagePositionConstraint;

@end

@implementation CustomSlider

- (id)initWithBackImage:(NSString*)backImageName andWithFrontImage:(NSString*)frontImageName andWithCurrentPositionImage:(NSString *)buttonImageName andWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"CustomSliderView" bundle:[NSBundle mainBundle]];
    
    if (self) {
        UIImage* imageTmp = [UIImage imageNamed:frontImageName];
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y, imageTmp.size.width, imageTmp.size.height);
        [self.frontImageWidthConstraint setConstant:imageTmp.size.width];
        [self.frontImageHeightConstraint setConstant:imageTmp.size.height];
        [self.frontImageView setImage:imageTmp];
        
        imageTmp = [UIImage imageNamed:backImageName];
        [self.backImageWidthConstraint setConstant:imageTmp.size.width];
        [self.backImageHeightConstraint setConstant:imageTmp.size.height];
        [self.backImageView setImage:imageTmp];
        self.backImage = imageTmp;
        
        imageTmp = [UIImage imageNamed:buttonImageName];
        if (imageTmp.size.height > self.view.frame.size.height)
        {
            self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, imageTmp.size.height);
        }
        
        [self.buttonImageWidthConstraint setConstant:imageTmp.size.width];
        [self.buttonImageHeightConstraint setConstant:imageTmp.size.height];
        [self.buttonImageView setImage:imageTmp];
        [self setNbPositions:2 andCurrentPosition:0];
    }
    
    return self;
}

- (void)setNbPositions:(NSInteger)nbPos andCurrentPosition:(NSInteger)pos
{
    self.nbPositions = nbPos;
    self.currentPosition = pos;
    [self updateButtonPosition];
}

- (void)updateButtonPosition
{
    CGFloat oldPosition = self.buttonImagePositionConstraint.constant;
    CGFloat newPosition = ((self.view.frame.size.width - self.buttonImageView.frame.size.width) / (self.nbPositions - 1)) * self.currentPosition;
    if (newPosition != oldPosition)
    {
        if (self.currentPosition == 0)
        {
            [self.backImageWidthConstraint setConstant:self.backImage.size.width];
            [self.backImageView setImage:self.backImage];
            [self.backImagePositionConstraint setConstant:newPosition];
        }
        else if (self.currentPosition == (self.nbPositions - 1))
        {
            [self.backImageWidthConstraint setConstant:0];
            [self.backImageView setImage:nil];
            [self.backImagePositionConstraint setConstant:newPosition];
        }
        else
        {
            if (self.backImage.size.width - newPosition - self.buttonImageView.frame.size.width / 2 < 0)
            {
                [self.backImageWidthConstraint setConstant:self.backImage.size.width];
                newPosition = self.backImage.size.width - self.buttonImageView.frame.size.width;
            }
            else
            {
                [self.backImageWidthConstraint setConstant:self.backImage.size.width - newPosition - self.buttonImageView.frame.size.width / 2];
            }
            
            [self.backImageView setImage:[self.backImage crop:CGRectMake(newPosition + self.buttonImageView.frame.size.width / 2, 0, self.backImage.size.width - newPosition - self.buttonImageView.frame.size.width / 2, self.backImage.size.height)]];
            [self.backImagePositionConstraint setConstant:newPosition + (self.buttonImageView.frame.size.width / 2)];
        }
        
        [self.buttonImagePositionConstraint setConstant:newPosition];

        [self.backImageView setNeedsLayout];
        [self.backImageView layoutIfNeeded];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.buttonImageView setNeedsLayout];
            [self.buttonImageView layoutIfNeeded];
        }];
    }
}

- (IBAction)dragAndDrop:(UIPanGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:[self view]];
    touchPoint.x -= self.buttonImageView.frame.size.width / 2;
    touchPoint.y -= self.buttonImageView.frame.size.height / 2;
    
    if (touchPoint.x >= 0 && touchPoint.x <= (self.backImage.size.width - self.buttonImageView.frame.size.width))
    {
        [self.backImageWidthConstraint setConstant:self.backImage.size.width - touchPoint.x - self.buttonImageView.frame.size.width / 2];
        
        [self.backImageView setImage:[self.backImage crop:CGRectMake(touchPoint.x + self.buttonImageView.frame.size.width / 2, 0, self.backImage.size.width - touchPoint.x - self.buttonImageView.frame.size.width / 2, self.backImage.size.height)]];
        [self.buttonImagePositionConstraint setConstant:touchPoint.x];
        [self.buttonImageView setNeedsLayout];
        [self.buttonImageView layoutIfNeeded];
        [self.backImagePositionConstraint setConstant:touchPoint.x + (self.buttonImageView.frame.size.width / 2)];
        [self.backImageView setNeedsLayout];
        [self.backImageView layoutIfNeeded];
    }
}

- (IBAction)oneTap:(id)sender
{
    CGPoint touchPoint = [sender locationInView:[self view]];
    self.currentPosition = ((touchPoint.x / (self.view.frame.size.width / (self.nbPositions + 1))) + 1) / 2;
    [self updateButtonPosition];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *currentTouch = [touches anyObject];
    CGPoint touchPoint = [currentTouch locationInView:self.view];
    if (touchPoint.x < 0)
    {
        self.currentPosition = 0;
    }
    else
    {
        self.currentPosition = ((touchPoint.x / (self.view.frame.size.width / (self.nbPositions + 1))) + 1) / 2    ;
    }
    
    [self updateButtonPosition];
}

@end