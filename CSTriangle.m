//
//  CSTriangle.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSTriangle.h"

#import "CSLineSegment.h"

#import "Miscellaneous.h"

@implementation CSTriangle

@synthesize point1 = _point1;
@synthesize point2 = _point2;
@synthesize point3 = _point3;

- (id) init :(CGPoint)first :(CGPoint)second :(CGPoint)third
{//initialize
    self = [self init :first :second :third :YES];
    return self;
}//initialize
- (id) init :(CGPoint)first :(CGPoint)second :(CGPoint)third :(BOOL)setTouch
{//initialize
    self = [super init:setTouch];
    _point1 = first;
    _point2 = second;
    _point3 = third;
    return self;
}//initialize

+ (CSTriangle*) create :(CGPoint)first :(CGPoint)second :(CGPoint)third
{//create
    return [[CSTriangle alloc] init :first :second :third];
}//create
+ (CSTriangle*) create :(CGPoint)first :(CGPoint)second :(CGPoint)third :(BOOL)setTouch
{//create
    return [[CSTriangle alloc] init :first :second :third :setTouch];
}//create

- (void) draw:(UIColor *)color
{//draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddPath(context, [self getPath]);
    if (self.canTouchInside)
    {//filled
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    }//filled
    else
    {//outline
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextStrokePath(context);
    }//outline
    CGContextRestoreGState(context);
}//draw
- (CGMutablePathRef) getPath
{//get path for drawing
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, 0, self.point1.x, self.point1.y);
    CGPathAddLineToPoint(path, 0, self.point2.x, self.point2.y);
    CGPathAddLineToPoint(path, 0, self.point3.x, self.point3.y);
    CGPathCloseSubpath(path);
    return path;
}//get path for drawing


- (NSArray*) getLineSegments
{//get array of 'CSLineSegment'
    if (!self.lineSegments)
    {//create 'lineSegments'
        _lineSegments = [NSArray arrayWithObjects:[CSLineSegment create:self.point1 :self.point2],
                          [CSLineSegment create:self.point2 :self.point3], [CSLineSegment create:self.point3 :self.point1], nil];
    }//create 'lineSegments'
    return self.lineSegments;
}//get array of 'CSLineSegment'

- (float) getPositiveYforX:(float)x
{//get highest y-value that corresponds to given x-value
    CGRect frame = self.getFrame;
        if (!inBetween(frame.origin.x, frame.origin.x + frame.size.width, x))
            return 0;//Not inside triangle!
    NSArray* segments = [self getLineSegments];
        if (inBetween(self.point1.x, self.point2.x, x) && inBetween(self.point2.x, self.point3.x, x))
        {//on lines 1-2 and 2-3
            return MAX([[segments objectAtIndex:0] getYforX:x], [[segments objectAtIndex:1] getYforX:x]);
        }//on lines 1-2 and 2-3
    
        else if(inBetween(self.point1.x, self.point2.x, x) && inBetween(self.point1.x, self.point3.x, x))
        {//on lines 1-2 and 1-3
            return MAX([[segments objectAtIndex:0] getYforX:x], [[segments objectAtIndex:2] getYforX:x]);
        }//on lines 1-2 and 1-3
    
        else
        {//on lines 2-3 and 1-3
            return MAX([[segments objectAtIndex:1] getYforX:x], [[segments objectAtIndex:2] getYforX:x]);
        }//on lines 2-3 and 1-3
    
}//get highest y-value that corresponds to given x-value

- (float) getNegativeYforX:(float)x
{//get lowest y-value that corresponds to given x-value
    CGRect frame = self.getFrame;
    if (!inBetween(frame.origin.x, frame.origin.x + frame.size.width, x))
        return 0;//Not inside triangle!
    NSArray* segments = [self getLineSegments];
    if (inBetween(self.point1.x, self.point2.x, x) && inBetween(self.point2.x, self.point3.x, x))
    {//on lines 1-2 and 2-3
        /*
        CSLineSegment* ls0 = [segments objectAtIndex:0];
        CSLineSegment* ls1 = [segments objectAtIndex:1];
        return MIN([ls0 getYforX:x], [ls1 getYforX:x]);
        */
        CSLineSegment* ls0 = [segments objectAtIndex:0];
        float min0 = (ls0.vertical ? MIN(ls0.point1.y, ls0.point2.y) : [ls0 getYforX:x]);
        
        CSLineSegment* ls1 = [segments objectAtIndex:1];
        float min1 = (ls1.vertical ? MIN(ls1.point1.y, ls1.point2.y) : [ls1 getYforX:x]);
        
        return MIN(min0, min1);
    }//on lines 1-2 and 2-3
    
    else if(inBetween(self.point1.x, self.point2.x, x) && inBetween(self.point1.x, self.point3.x, x))
    {//on lines 1-2 and 1-3
        /*
        CSLineSegment* ls0 = [segments objectAtIndex:0];
        CSLineSegment* ls2 = [segments objectAtIndex:2];
        return MIN([ls0 getYforX:x], [ls2 getYforX:x]);
        */
        CSLineSegment* ls0 = [segments objectAtIndex:0];
        float min0 = (ls0.vertical ? MIN(ls0.point1.y, ls0.point2.y) : [ls0 getYforX:x]);
        
        CSLineSegment* ls2 = [segments objectAtIndex:2];
        float min2 = (ls2.vertical ? MIN(ls2.point1.y, ls2.point2.y) : [ls2 getYforX:x]);
        
        return MIN(min0, min2);
    }//on lines 1-2 and 1-3
    
    else
    {//on lines 2-3 and 1-3
        CSLineSegment* ls1 = [segments objectAtIndex:1];
        float min1 = (ls1.vertical ? MIN(ls1.point1.y, ls1.point2.y) : [ls1 getYforX:x]);
        
        CSLineSegment* ls2 = [segments objectAtIndex:2];
        float min2 = (ls2.vertical ? MIN(ls2.point1.y, ls2.point2.y) : [ls2 getYforX:x]);
        
        return MIN(min1, min2);
    }//on lines 2-3 and 1-3
    
}//get lowest y-value that corresponds to given x-value

- (BOOL) pointLiesInside :(CGPoint)pnt
{//point lies inside triangle
    NSArray* segments = [self getLineSegments];
    
    return [CSLineSegment between_lines_vertically:[segments objectAtIndex:0] :[segments objectAtIndex:2] :pnt]
    || [CSLineSegment between_lines_vertically:[segments objectAtIndex:1] :[segments objectAtIndex:2] :pnt]
    || [CSLineSegment between_lines_vertically:[segments objectAtIndex:2] :[segments objectAtIndex:0] :pnt];
}//point lies inside triangle

- (void) transpose:(CGPoint)move
{//transpose
    _point1 = CGPointMake(_point1.x + move.x, _point1.y + move.y);
    _point2 = CGPointMake(_point2.x + move.x, _point2.y + move.y);
    _point3 = CGPointMake(_point3.x + move.x, _point3.y + move.y);
    for (CSLineSegment* cur in self.lineSegments)
        [cur transpose:move];
}//transpose

- (void) flipHorizontal
{//flip triangle
    CGRect frame = [self getFrame];
    [self flipHorizontalWithRect:frame];
    //subtract point from far sides (right/bottom) of frame, add near (left/top) sides
    //left + length - point + left == 2 * left + length - point
}//flip triangle
- (void) flipVertical
{//flip triangle
    CGRect frame = [self getFrame];
    [self flipVerticalWithRect:frame];
    //subtract point from far sides (right/bottom) of frame, add near (left/top) sides
    //left + length - point + left == 2 * left + length - point
}//flip triangle

- (void) flipHorizontalWithRect:(CGRect)frame
{//flip horizontally
    _point1 = CGPointMake(2 * frame.origin.x + frame.size.width - self.point1.x, self.point1.y);
    _point2 = CGPointMake(2 * frame.origin.x + frame.size.width - self.point2.x, self.point2.y);
    _point3 = CGPointMake(2 * frame.origin.x + frame.size.width - self.point3.x, self.point3.y);
}//flip horizontally

- (void) flipVerticalWithRect:(CGRect)frame
{//flip vertically
    _point1 = CGPointMake(self.point1.x, 2 * frame.origin.y + frame.size.height - self.point1.y);
    _point2 = CGPointMake(self.point2.x, 2 * frame.origin.y + frame.size.height - self.point2.y);
    _point3 = CGPointMake(self.point3.x, 2 * frame.origin.y + frame.size.height - self.point3.y);
}//flip vertically

- (CGRect) getFrame
{//get frame
    float minX = MIN(MIN(self.point1.x, self.point2.x), self.point3.x);
    float maxX = MAX(MAX(self.point1.x, self.point2.x), self.point3.x);
    float minY = MIN(MIN(self.point1.y, self.point2.y), self.point3.y);
    float maxY = MAX(MAX(self.point1.y, self.point2.y), self.point3.y);
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}//get frame

- (NSString*) description
{//description
    return [NSString stringWithFormat:@"Point1:{%f, %f}--Point2:{%f, %f}--Point3:{%f, %f}", self.point1.x, self.point1.y, self.point2.x, self.point2.y, self.point3.x, self.point3.y];
}//description

- (CGPoint) getRandomPoint
{//get a random point inside triangle
    CGRect sFrame = self.getFrame;
    float xPos = arc4random() % (int)sFrame.size.width + sFrame.origin.x;
    float yPos = 0;
    do
    {//get random y
        yPos = arc4random() % (int)sFrame.size.height + sFrame.origin.y;
    }//get random y
    while (!inBetween(sFrame.origin.y, sFrame.origin.y + sFrame.size.height, yPos));
    
    return CGPointMake(xPos, yPos);
}//get a random point inside triangle

#ifdef kVerticesAreAnchoredAtCenter
- (void) getVertices :(Vertex*)array from:(NSUInteger)start anchor:(CGPoint)center
{//add vertices to array from 'start' to 'start + 3'
    array[start + 0].geometry = GLKVector2Make(self.point1.x - center.x, self.point1.y - center.y);
    array[start + 1].geometry = GLKVector2Make(self.point2.x - center.x, self.point2.y - center.y);
    array[start + 2].geometry = GLKVector2Make(self.point3.x - center.x, self.point3.y - center.y);
}//add vertices to array from 'start' to 'start + 3'
#else
- (void) getVertices :(Vertex*)array from:(NSUInteger)start
{//add vertices to array from 'start' to 'start + 3'
    array[start + 0].geometry = GLKVector2Make(self.point1.x, self.point1.y);
    array[start + 1].geometry = GLKVector2Make(self.point2.x, self.point2.y);
    array[start + 2].geometry = GLKVector2Make(self.point3.x, self.point3.y);
}//add vertices to array from 'start' to 'start + 3'
#endif
- (NSUInteger) numberOfVertices {return 3;}

#pragma mark - Copying

- (id) copy
{//copy
    return [[CSTriangle alloc] init:self.point1 :self.point2 :self.point3 :self.canTouchInside];
}//copy

- (id) copyWithZone:(NSZone *)zone {return [self copy];}

@end
