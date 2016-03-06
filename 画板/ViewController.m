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
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;

@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet PaintBoard *patintView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *testViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.redSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.greenSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.blueSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.sizeSlider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    
    self.testView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    
    
}

- (void)sliderChange:(UISlider *)slider
{
    self.redSlider.minimumTrackTintColor = [UIColor colorWithRed:self.redSlider.value green:0 blue:0 alpha:1];
    self.greenSlider.minimumTrackTintColor = [UIColor colorWithRed:0 green:self.greenSlider.value blue:0 alpha:1];
    self.blueSlider.minimumTrackTintColor = [UIColor colorWithRed:0 green:0 blue:self.blueSlider.value alpha:1];
    self.testView.backgroundColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    self.patintView.penColor = [UIColor colorWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%.1f",self.sizeSlider.value];
    self.testViewWidth.constant = self.sizeSlider.value;
    self.patintView.lineWidht = self.sizeSlider.value;
}

- (IBAction)removeAll:(id)sender {
    
    [self.patintView.allPoints removeAllObjects];
    [self.patintView setNeedsDisplay];
    
}

- (IBAction)saveImage:(id)sender {
    UIGraphicsBeginImageContext(self.patintView.bounds.size);
    
    [self.patintView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    UIImageWriteToSavedPhotosAlbum(viewImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
}
@end
