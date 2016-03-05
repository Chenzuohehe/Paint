//
//  ViewController.m
//  画板
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "ViewController.h"
#import "PaintBoard.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet PaintBoard *patintView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.redSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.greenSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.blueSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    self.testView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    
    
}

- (void)sliderChange:(UISlider *)slider
{
    self.redSlider.minimumTrackTintColor = [UIColor colorWithRed:self.redSlider.value green:0 blue:0 alpha:1];
    self.greenSlider.minimumTrackTintColor = [UIColor colorWithRed:0 green:self.greenSlider.value blue:0 alpha:1];
    self.blueSlider.minimumTrackTintColor = [UIColor colorWithRed:0 green:0 blue:self.blueSlider.value alpha:1];
    self.testView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    self.patintView.penColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
}

- (IBAction)removeAll:(id)sender {
    
    [self.patintView.allPoints removeAllObjects];
    [self.patintView setNeedsDisplay];
    
}
@end
