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
    UIButton *_rubber;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.allPoints = [NSMutableArray array];
        [self createRubber];
        self.lineWidht = 10;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.allPoints = [NSMutableArray array];
        [self createRubber];
        self.lineWidht = 10;
    }
    
    return self;
}

/**
 *  创建橡皮擦（橡皮擦也是画笔）
 */
- (void)createRubber
{
    _rubber = [UIButton buttonWithType:UIButtonTypeCustom];
    _rubber.frame = CGRectMake(self.frame.size.width/2 - 10, 20, 80, 80);
    [_rubber setBackgroundImage:[UIImage imageNamed:@"Eraser"] forState:UIControlStateNormal];
    _rubber.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pressPan:)];
    [_rubber addGestureRecognizer:pan];
    [self addSubview:_rubber];
    
    
}

/**
 *  画笔点击，一条线段的开始
 *
 *  @param color 线段的颜色
 *  @param widht 线条的宽度
 *  @param arr   线段的坐标数组
 */
- (void)penDrawWithColor:(UIColor *)color lineWidht:(CGFloat)widht pointArr:(NSMutableArray *)arr
{
    NSMutableDictionary * strokeDic = [NSMutableDictionary dictionary];
    [strokeDic setObject:arr forKey:@"path"];
    [strokeDic setObject:color forKey:@"penColor"];
    
    [self.allPoints addObject:strokeDic];
    [strokeDic setObject:[NSString stringWithFormat:@"%f",widht] forKey:@"lineWidth"];
    [self setNeedsDisplay];
}

/**
 *  画笔移动
 *
 *  @param point 画笔坐标
 */
- (void)penMovePoint:(CGPoint)point{
    NSMutableDictionary * strokeDic = [self.allPoints lastObject];
    NSMutableArray * strokeArr = strokeDic[@"path"];
    [strokeArr addObject:NSStringFromCGPoint(point)];
    [strokeDic setObject:strokeArr forKey:@"path"];
    [self.allPoints removeLastObject];
    [self.allPoints addObject:strokeDic];
    [self setNeedsDisplay];
}


#pragma mark  ----- touchPaint ----
/**
 *  橡皮移动
 *
 *  @param pan 拖动手势
 */
- (void)pressPan:(UIPanGestureRecognizer *)pan{
    
    static CGPoint oldPoint;
    if (pan.state == UIGestureRecognizerStateBegan) {
        //橡皮按住。
        oldPoint = [pan locationInView:self];
        NSMutableArray *thisStroke = [NSMutableArray new];
        [thisStroke addObject:NSStringFromCGPoint(_rubber.center)];
        
        [self penDrawWithColor:[UIColor whiteColor] lineWidht:40 pointArr:thisStroke];
        
    }else{
        CGPoint newPoint = [pan locationInView:self];//橡皮的新位置？
        //        CGPoint point = [_rubber convertPoint:newPoint toView:self];
        CGPoint center = _rubber.center;
        center.x += (newPoint.x - oldPoint.x);
        center.y += (newPoint.y - oldPoint.y);
        _rubber.center = center;
        oldPoint = newPoint;
        
        //橡皮滑动。
        [self penMovePoint:_rubber.center];
        
    }
    
}


// 一个笔画开始(点击)
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    // 一个数组代表一个完整的线  起点
    NSMutableArray *thisStroke= [NSMutableArray new];
    [thisStroke addObject:NSStringFromCGPoint(point)];
    self.lineWidht = self.lineWidht;
    if (_penColor ==nil) {
        _penColor = [UIColor blackColor];
    }
    [self penDrawWithColor:_penColor lineWidht:self.lineWidht pointArr:thisStroke];
    
}

// 手指移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    [self penMovePoint:point];
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
            CGContextStrokePath(context);
        }
    }
}

@end
