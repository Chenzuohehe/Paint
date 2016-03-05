//
//  PaintBoard.h
//  画板
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintBoard : UIView
{
//    NSMutableArray * allPoints;//一个保存所有图层的数组，每一个点击就是一个图层
    
    CGContextRef context;
}

@property (nonatomic, strong)UIColor * penColor;
@property (nonatomic, strong)NSMutableArray * allPoints;//一个保存所有图层的数组，每一个点击就是一个图层

@end
