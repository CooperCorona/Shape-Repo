//
//  CSLineSegment.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSLineSegment.h"

#import "Miscellaneous.h"

#import "Point_Wrapper.h"

@implementation CSLineSegment

@synthesize point1 = _point1;
@synthesize point2 = _point2;
@synthesize vertical = _vertical;

- (id) init :(CGPoint)first :(CGPoint)second
{//initialize
    self = [super init:YES];
        if (first.x < second.x)
        {//first.x is smaller than second.x
            _point1 = first;
            _point2 = second;
        }//first.x is smaller than second.x
        else
        {//first.x is larger than second.x
            _point1 = second;
            _point2 = first;
        }//first.x is larger than second.x
    _vertical = epsilon(first.x, second.x, kCloseEnoughFloat);
    return self;
}//initialize
+ (CSLineSegment*) create :(CGPoint)first :(CGPoint)second
{//convenience method
    return [[CSLineSegment alloc] init :first :second];
}//convenience method

+ (CSLineSegment*) createWithPoint:(CGPoint)start vector:(GLKVector2)vect
{//create with starting point and 2-dimensional vector
    return [[CSLineSegment alloc] init:start :CGPointMake(start.x + vect.x, start.y + vect.y)];
}//create with starting point and 2-dimensional vector

- (void) draw:(UIColor *)color
{//draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 2);
    CGContextMoveToPoint(context, self.point1.x, self.point1.y);
    CGContextAddLineToPoint(context, self.point2.x, self.point2.y);
        /*if (self.canTouchInside)
        {//filled
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillPath(context);
        }//filled
        else*/
        {//outline
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            CGContextStrokePath(context);
        }//outline
    CGContextRestoreGState(context);
}//draw
- (CGMutablePathRef) getPath
{//get path for drawing
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, 0, _point1.x, _point1.y);
    CGPathAddLineToPoint(path, 0, _point2.x, _point2.y);
    return path;
}//get path for drawing


- (float) getSlope
{//get slope of line segment
    if (self.vertical)
        return 0;
    return (self.point2.y - self.point1.y) / (self.point2.x - self.point1.x);
}//get slope of line segment

- (float) getYIntercept
{//get y-intercept (as if line segment was true line)
    return self.point1.y - [self getSlope] * self.point1.x;
}//get y-intercept (as if line segment was true line)

- (float) getYforX:(float)x
{//get y-value for corresponding x-value
    return [self getSlope] * x + [self getYIntercept];
}//get y-value for corresponding x-value
- (float) getXforY:(float)y
{//get x-value for corresponding y-value
        if (self.vertical)
            return self.point1.x;
    return (y - [self getYIntercept]) / [self getSlope];
}//get x-value for corresponding y-value

+ (BOOL) between_lines_vertically :(CSLineSegment*)l1 :(CSLineSegment*)l2 :(CGPoint)pnt
{//point is between lines vertically
    //NSArray* points = [CSLineSegment organizePoints:[NSMutableArray arrayWithObjects:[Point_Wrapper pointCG:l1.point1], [Point_Wrapper pointCG:l1.point2], [Point_Wrapper pointCG:l2.point1], [Point_Wrapper pointCG:l2.point2], nil] :YES];
    float min1 = MIN(l1.point1.x, l1.point2.x);
    float min2 = MIN(l2.point1.x, l2.point2.x);
    float max1 = MAX(l1.point1.x, l1.point2.x);
    float max2 = MAX(l2.point1.x, l2.point2.x);
    float min = MAX(min1, min2);
    float max = MIN(max1, max2);
    /*
    CGPoint min = [[points objectAtIndex:1] castCGPoint];
    CGPoint max = [[points objectAtIndex:2] castCGPoint];
    */
        if (!inBetween(min, max, pnt.x))
            return NO;
        else if ([l1 getYforX:pnt.x] > [l2 getYforX:pnt.x])
        {//line1(x) > line2(x)
            return pnt.y >= [l2 getYforX:pnt.x] && pnt.y <= [l1 getYforX:pnt.x];
        }//line1(x) > line2(x)
        else
        {//line1(x) < line2(x)
            return pnt.y >= [l1 getYforX:pnt.x] && pnt.y <= [l2 getYforX:pnt.x];
        }//line1(x) < line2(x)
}//point is between lines vertically

+ (BOOL) between_lines_horizontally :(CSLineSegment*)l1 :(CSLineSegment*)l2 :(CGPoint)pnt
{//point is between lines horizontally
    NSArray* points = [CSLineSegment organizePoints:[NSMutableArray arrayWithObjects:[Point_Wrapper pointCG:l1.point1], [Point_Wrapper pointCG:l1.point2], [Point_Wrapper pointCG:l2.point1], [Point_Wrapper pointCG:l2.point2], nil] :NO];
    CGPoint min = [[points objectAtIndex:1] castCGPoint];
    CGPoint max = [[points objectAtIndex:2] castCGPoint];
    if (!inBetween(min.y, max.y, pnt.y))
        return NO;
    return inBetween([l1 getXforY:pnt.y], [l2 getXforY:pnt.x], pnt.x);
}//point is between lines horizontally

+ (NSArray*) organizePoints:(NSMutableArray*)points :(BOOL)horizontal
{//organize points
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:[points count]];
        for (NSUInteger all = 0; all < [points count]; ++all)
        {//loop through points
            Point_Wrapper* current = [points objectAtIndex:all];
            Point_Wrapper* smallest = current;
            for (NSUInteger many = all + 1; many < [points count]; ++many)
            {//loop through points
                Point_Wrapper* next = [points objectAtIndex:many];
                    if (horizontal)
                    {//x-values
                        if (next.x < smallest.x)
                            smallest = next;
                    }//x-values
                    else
                    {//y-values
                        if (next.y < smallest.y)
                            smallest = next;
                    }//y-values
            }//loop through points
            [array addObject:smallest];
        }//loop through points
    return array;
}//organize points

- (void) transpose:(CGPoint)move
{//transpose
    _point1 = CGPointMake(_point1.x + move.x, _point1.y + move.y);
    _point2 = CGPointMake(_point2.x + move.x, _point2.y + move.y);
}//transpose
- (CGRect) getFrame
{//get frame
    float minX = MIN(self.point1.x, self.point2.x);
    float maxX = MAX(self.point1.x, self.point2.x);
    float minY = MIN(self.point1.y, self.point2.y);
    float maxY = MAX(self.point1.y, self.point2.y);
    return CGRectMake(minX, minY, maxX - minX, maxY - minY);
}//get frame

- (void) flip
{//flip line
    [self flipHorizontallyInRect:[self getFrame]];
    return;
    /*
    CGPoint middle = _point1;
    _point1 = CGPointMake(_point1.x, _point2.y);
    _point2 = CGPointMake(_point2.x, middle.y);
     */
}//flip line

- (void) flipHorizontallyInRect:(CGRect)rect
{//flip horizontally inside rectangle
    _point1 = CGPointMake(2 * rect.origin.x + rect.size.width - _point1.x, _point1.y);
    _point2 = CGPointMake(2 * rect.origin.x + rect.size.width - _point2.x, _point2.y);
}//flip horizontally inside rectangle

- (void) flipVerticallyInRect:(CGRect)rect
{//flip vertically inside rectangle
    _point1 = CGPointMake(_point1.x, 2 * rect.origin.y + rect.size.height - _point1.y);
    _point2 = CGPointMake(_point2.x, 2 * rect.origin.y + rect.size.height - _point2.y);
}//flip vertically inside rectangle

- (NSString*) description
{//description
    return [NSString stringWithFormat:@"Point1:{%f, %f}--Point2:{%f, %f}", self.point1.x, self.point1.y, self.point2.x, self.point2.y];
}//description

- (CGPoint) getRandomPoint
{//get random point on line
        if (self.vertical)
        {//vertical line
            float yPos = [CSShape randomFloatBetween:self.point1.y :self.point2.y];
            //CGPoint returnee = CGPointMake([self getXforY:yPos], yPos);
            return CGPointMake(self.point1.x, yPos);
        }//vertical line
    float xPos = [CSShape randomFloatBetween:self.point1.x :self.point2.x];
    return CGPointMake(xPos, [self getYforX:xPos]);
}//get random point on line

#ifdef kVerticesAreAnchoredAtCenter
- (void) getVertices :(Vertex*)array from:(NSUInteger)start anchor:(CGPoint)center
{//get vertices
    NSLog(@"-[CSLineSegment getVertices:from:anchor: Invoked!");
}//get vertices
#else
- (void) getVertices :(Vertex*)array from:(NSUInteger)start
{//get vertices
    NSLog(@"-[CSLineSegment getVertices:from: Invoked!");
}//get vertices
#endif
- (NSUInteger) numberOfVertices {return 2;}

#pragma mark - Copying

- (id) copy
{//copy
    return [[CSLineSegment alloc] init:self.point1 :self.point2];
}//copy

- (id) copyWithZone:(NSZone *)zone {return [self copy];}

@end
