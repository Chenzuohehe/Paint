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
    
    NSMutableArray *_points;// 保存路径的数组
    UIButton *_rubber;
    
    NSMutableArray *_aPoints;// 保存橡皮擦的路径的数组
    
    
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _points = [NSMutableArray new];
        _aPoints = [NSMutableArray new];
        self.allPoints = [NSMutableArray array];
        [self createRubber];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _points = [NSMutableArray new];
        _aPoints = [NSMutableArray new];
        self.allPoints = [NSMutableArray array];
        [self createRubber];
    }
    
    return self;
}

- (void)createRubber
{
    _rubber = [UIButton buttonWithType:UIButtonTypeCustom];
    _rubber.frame = CGRectMake(self.frame.size.width/2 - 10, 20, 80, 80);
    [_rubber setBackgroundImage:[UIImage imageNamed:@"Eraser"] forState:UIControlStateNormal];
    _rubber.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pressPan:)];
    [_rubber addGestureRecognizer:pan];
    [self addSubview:_rubber];
    self.lineWidht = 10;
    
}

#pragma mark  ----- touchPaint ----
//橡皮移动
- (void)pressPan:(UIPanGestureRecognizer *)pan{
    
    static CGPoint oldPoint;
    if (pan.state == UIGestureRecognizerStateBegan) {
        //橡皮按住。
        oldPoint = [pan locationInView:self];
        NSMutableArray *thisStroke = [NSMutableArray new];
        [thisStroke addObject:NSStringFromCGPoint(_rubber.center)];
        NSMutableDictionary * strokeDic = [NSMutableDictionary dictionary];
        [strokeDic setObject:thisStroke forKey:@"path"];
        [strokeDic setObject:[UIColor whiteColor] forKey:@"penColor"];
        
        [self.allPoints addObject:strokeDic];
        self.lineWidht = 40;
        [strokeDic setObject:[NSString stringWithFormat:@"%f",self.lineWidht] forKey:@"lineWidth"];
        [self setNeedsDisplay];
    }else{
        CGPoint newPoint = [pan locationInView:self];
        //        CGPoint point = [_rubber convertPoint:newPoint toView:self];
        CGPoint center = _rubber.center;
        center.x += (newPoint.x - oldPoint.x);
        center.y += (newPoint.y - oldPoint.y);
        _rubber.center = center;
        
        
        //橡皮滑动。
        NSMutableDictionary * strokeDic = [self.allPoints lastObject];
        NSMutableArray * strokeArr = strokeDic[@"path"];
        [strokeArr addObject:NSStringFromCGPoint(_rubber.center)];
        [strokeDic setObject:strokeArr forKey:@"path"];
        [self.allPoints removeLastObject];
        [self.allPoints addObject:strokeDic];
        oldPoint = newPoint;
        // drawRect方法 不能直接调用 间接调用
        [self setNeedsDisplay];
        
    }
    
}
//- (void)pressPan:(UIPanGestureRecognizer *)pan{
//    static CGPoint oldPoint;
//    //橡皮按住。。
//    if (pan.state == UIGestureRecognizerStateBegan) {
//        oldPoint = [pan locationInView:self];
//        NSMutableArray *arr = [NSMutableArray new];
//        [_aPoints addObject:arr];
//    }
//    else {
//        //橡皮滑动
//        CGPoint newPoint = [pan locationInView:self];
////        CGPoint point = [_rubber convertPoint:newPoint toView:self];
//        CGPoint center = _rubber.center;
//        center.x += (newPoint.x - oldPoint.x);
//        center.y += (newPoint.y - oldPoint.y);
//        _rubber.center = center;
//        NSMutableArray *arr = _aPoints.lastObject;
//        [arr addObject:NSStringFromCGPoint(newPoint)];
//
//        oldPoint = newPoint;
//        NSLog(@"%@",NSStringFromCGPoint(oldPoint));
////        NSLog(@"%ld", _aPoints.count);
//        [self setNeedsDisplay];
//
//    }
//}

// 一个笔画开始(点击)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    // 一个数组代表一个完整的线  起点
    NSMutableArray *thisStroke= [NSMutableArray new];
    [thisStroke addObject:NSStringFromCGPoint(point)];
    self.lineWidht = 10;
    
    NSMutableDictionary * strokeDic = [NSMutableDictionary dictionary];
    
    if (_penColor ==nil) {
        _penColor = [UIColor blackColor];
    }
    
    [strokeDic setObject:_penColor forKey:@"penColor"];
    [strokeDic setObject:thisStroke forKey:@"path"];
    [strokeDic setObject:[NSString stringWithFormat:@"%f",self.lineWidht] forKey:@"lineWidth"];
    [self.allPoints addObject:strokeDic];
    
    [self setNeedsDisplay];
}

// 手指移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSMutableDictionary * strokeDic = [self.allPoints lastObject];
    NSMutableArray * strokeArr = strokeDic[@"path"];
    [strokeArr addObject:NSStringFromCGPoint(point)];
    [strokeDic setObject:strokeArr forKey:@"path"];
    [self.allPoints removeLastObject];
    [self.allPoints addObject:strokeDic];
    
    // drawRect方法 不能直接调用 间接调用//这就是重画啊！！！！
    [self setNeedsDisplay];
}


//所有绘图的移动(渲染？)
#pragma mark  ----- 渲染？ ----
- (void)drawRect:(CGRect)rect
{
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSaveGState(context);
//    CGContextRestoreGState(context);
    if (self.allPoints.count != 0) {
        for (NSMutableDictionary * strokeDic in self.allPoints) {
            
            CGContextRestoreGState(context);
            CGContextSaveGState(context);
            
            UIColor * color = [strokeDic objectForKey:@"penColor"];
            NSString * lineWigth = [strokeDic objectForKey:@"lineWidth"];
            CGFloat width = [lineWigth floatValue];
            CGContextSetLineWidth(context, width);
            [color setStroke];
            NSMutableArray * strokeArr = [strokeDic objectForKey:@"path"];
            CGPoint statPoint = CGPointFromString(strokeArr[0]);
            CGContextMoveToPoint(context, statPoint.x, statPoint.y);
            for (int i = 0; i < strokeArr.count; i++) {
                CGPoint movePoint = CGPointFromString(strokeArr[i]);
                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
                
                
            }
            NSLog(@"%f",width);
            CGContextStrokePath(context);
        }
    }
}

//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    
//    if (_points.count == 0) {
//        return;
//    }
//    else {
//        [self.penColor setStroke];//这是设置渲染的颜色
//        
//        //获取自己创建的位图上下文
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        for (NSMutableArray *thisStroke in _points) {
//            CGContextSetLineWidth(context, 1);
//
//            // 路径起点
//            CGPoint startPoint = CGPointFromString(thisStroke[0]);
//            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
//            // 划线
//            for (NSInteger i = 1; i < thisStroke.count; i++) {
//                CGPoint movePoint = CGPointFromString(thisStroke[i]);
//                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
//            }
//        }
//        // 渲染路径
//        CGContextStrokePath(context);
//    }
//    
//    if (_aPoints.count != 0) {
//        [[UIColor whiteColor] setStroke];
//        CGContextRef context = UIGraphicsGetCurrentContext();
//
//        for (NSMutableArray *thisStroke in _aPoints) {
//            CGContextSetLineWidth(context, 30);
//
//            // 路径起点
//            CGPoint startPoint = CGPointFromString(thisStroke[0]);
//            CGContextMoveToPoint(context, startPoint.x, startPoint.y);
//            // 划线
//            for (NSInteger i = 1; i < thisStroke.count; i++) {
//                CGPoint movePoint = CGPointFromString(thisStroke[i]);
//                CGContextAddLineToPoint(context, movePoint.x, movePoint.y);
//
//            }
//        }
//        CGContextStrokePath(context);
// 
//    }
//
//
//}



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
