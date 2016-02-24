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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    PaintBoard *paint = [[PaintBoard alloc] initWithFrame:self.view.bounds];
    paint.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:paint];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    label.text = @" 佐佐，先在画板上画红线，再使用橡皮";
    label.font = [UIFont boldSystemFontOfSize:20];
    [self.view addSubview:label];
    
}

@end
