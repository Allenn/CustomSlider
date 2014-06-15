//
//  ViewController.m
//  CustomSlider
//
//  Created by Allen on 07/04/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView* sliderView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.slider = [[CustomSlider alloc] initWithBackImage:@"Back" andWithFrontImage:@"Front" andWithCurrentPositionImage:@"Button" andWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.slider setNbPositions:3 andCurrentPosition:0];
    [self.sliderView addSubview:self.slider.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
