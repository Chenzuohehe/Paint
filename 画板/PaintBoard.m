//
//  PaintBoard.m
//  画板
//
//  Created by qianfeng on 16/2/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "PaintBoard.h"

@implementation PaintBoard
{
    // 保存路径的数组
    NSMutableArray *_points;
    UIButton *_rubber;
    // 保存橡皮擦的路径的数组
    NSMutableArray *_aPoints;
}

- (void)createRubber
{
    _rubber = [UIButton buttonWithType:UIButtonTypeCustom];
    _rubber.frame = CGRectMake(self.frame.size.width/2 - 10, 20, 80, 80);
    _rubber.layer.borderWidth = 4;
    _rubber.layer.borderColor = [UIColor blackColor].CGColor;
    _rubber.userInteractionEnabled = YES;
    [_rubber setTitle:@"路飞的橡皮擦" forState:UIControlStateNormal];
    [_rubber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rubber.titleLabel.numberOfLines = 0;
    _rubber.backgroundColor = [UIColor whiteColor];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pressPan:)];
    [_rubber addGestureRecognizer:pan];
    [self addSubview:_rubber];
}

- (void)pressPan:(UIPanGestureRecognizer *)pan{
    static CGPoint oldPoint;
    if (pan.state == UIGestureRecognizerStateBegan) {
        oldPoint = [pan locationInView:self];
        NSMutableArray *arr = [NSMutableArray new];
        [_aPoints addObject:arr];
    }
    else {
        CGPoint newPoint = [pan locationInView:self];
//        CGPoint point = [_rubber convertPoint:newPoint toView:self];
        CGPoint center = _rubber.center;
        center.x += newPoint.x - oldPoint.x;
        center.y += newPoint.y - oldPoint.y;
        _rubber.center = center;
        NSMutableArray *arr = _aPoints.lastObject;
        [arr addObject:NSStringFromCGPoint(newPoint)];

        oldPoint = newPoint;
        NSLog(@"%ld", _aPoints.count);
        [self setNeedsDisplay];

    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _points = [NSMutableArray new];
        _aPoints = [NSMutableArray new];
        self.backgroundColor = [UIColor blackColor];
        [self createRubber];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (_points.count == 0) {
        return;
    }
    else {
        [[UIColor redColor] setStroke];

        CGContextRef context = UIGraphicsGetCurrentContext();
        for (NSMutableArray *thisStroke in _points) {
            CGContextSetLineWidth(context, 20);

            // 路径起点
            CGPoint startPoint = CGPointFromString(thisStroke[0]);
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            // 划线
            for (NSInteger i = 1; i < thisStroke.count; i++) {
                CGPoint movePoint = CGPointFromString(thisStroke[i]);
                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
            }
        }
        // 渲染路径
        CGContextStrokePath(context);
    }
    
    if (_aPoints.count != 0) {
        [[UIColor whiteColor] setStroke];
        CGContextRef context = UIGraphicsGetCurrentContext();

        for (NSMutableArray *thisStroke in _aPoints) {
            CGContextSetLineWidth(context, 30);

            // 路径起点
            CGPoint startPoint = CGPointFromString(thisStroke[0]);
            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
            // 划线
            for (NSInteger i = 1; i < thisStroke.count; i++) {
                CGPoint movePoint = CGPointFromString(thisStroke[i]);
                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);

            }
        }
        CGContextStrokePath(context);
 
    }


}


// 一个笔画开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    // 一个数组代表一个笔画  起点
    NSMutableArray *thisStroke = [NSMutableArray new];
    [thisStroke addObject:NSStringFromCGPoint(point)];
    // 保存多条路径开始的点
    [_points addObject:thisStroke];
}

// 手指移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
        
    [[_points lastObject] addObject:NSStringFromCGPoint(point)];
    
    // 重绘
    // drawRect方法 不能直接调用 间接调用
    [self setNeedsDisplay];

//    if (CGRectContainsPoint(_rubber.frame, point)) {
//        CGPoint oldPoint = [touch previousLocationInView:self];
//        CGPoint newpoint = [touch locationInView:self];
//        _rubber.center = CGPointMake(_rubber.center.x + newpoint.x - oldPoint.x, _rubber.center.y + newpoint.y- oldPoint.y);
//    }
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    [super pointInside:point withEvent:event];
//    return YES;
//}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (CGRectContainsPoint(_rubber.frame, point)) {
//        return self;
//    }
//    return [super hitTest:point withEvent:event];
//}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
