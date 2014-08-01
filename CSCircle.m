//
//  CSCircle.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSCircle.h"

#import "Miscellaneous.h"

@implementation CSCircle

- (id) init :(CGPoint)setCent :(float)setRad
{//initialize
    return [self init:setCent :setRad :YES];
}//initialize
- (id) init :(CGPoint)setCent :(float)setRad :(BOOL)setTouch
{//initialize
    self = [super init:setTouch];
    _center = setCent;
    _radius = setRad;
    return self;
}//initialize

+ (CSCircle*) create :(CGPoint)setCent :(float)setRad
{//create
    return [[CSCircle alloc] init:setCent :setRad];
}//create
+ (CSCircle*) create :(CGPoint)setCent :(float)setRad :(BOOL)setTouch
{//create
    return [[CSCircle alloc] init:setCent :setRad :setTouch];
}//create

- (void) draw:(UIColor *)color
{//draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, CGRectMake(self.center.x - self.radius, self.center.y - self.radius, self.radius * 2, self.radius * 2));
    CGContextClosePath(context);
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
    CGPathAddEllipseInRect(path, 0, CGRectMake(self.center.x - self.radius / 2, self.center.y - self.radius / 2, self.radius * 2, self.radius * 2));
    return path;
}//get path for drawing


- (BOOL) pointLiesInside:(CGPoint)pnt
{//point lies inside circle?
    return (self.center.x - pnt.x) * (self.center.x - pnt.x) +
    (self.center.y - pnt.y) * (self.center.y - pnt.y) <= self.radius * self.radius;
}//point lies inside circle?

- (float) getPositiveYforX :(float)x
{//get positive y-value for x-value
    float radical = self.radius * self.radius - (x - self.center.x) * (x - self.center.x);
        if (radical < 0)
        {
            //NSLog(@"CSCircle::getPositiveYforX invalid radical:%f", x);
            return 0;
        }
    return sqrtf(radical) + self.center.y;
}//get positive y-value for x-value

- (float) getNegativeYforX :(float)x
{//get negative y-value for x-value
    float radical = self.radius * self.radius - (x - self.center.x) * (x - self.center.x);
    if (radical < 0)
        return 0;
    return -sqrtf(radical) + self.center.y;
}//get negative y-value for x-value

- (float) getPositiveXForY :(float)y
{//get positive x (on right side of center) for y value
    //if (!inBetween(self.center.y - self.radius, self.center.y + self.radius, y))
    float radical = self.radius * self.radius - (y - self.center.y) * (y - self.center.y);
    
    if (radical < 0)
    {//invalid y-value
        NSLog(@"Invalid Y-value!");
        return 0;
    }//invalid y-value
    
    return sqrtf(radical) + self.center.x;
}//get positive x (on right side of center) for y value

- (float) getNegativeXForY :(float)y
{//get negative x (on left side of center) for y value
    float radical = self.radius * self.radius - (y - self.center.y) * (y - self.center.y);
    
    if (radical < 0)
    {//invalid y-value
        NSLog(@"Invalid Y-value!");
        return 0;
    }//invalid y-value
    
    return -sqrtf(radical) + self.center.x;
}//get negative x (on left side of center) for y value

- (void) transpose:(CGPoint)move
{//transpose
    _center = CGPointMake(_center.x + move.x, _center.y + move.y);
}//transpose
- (CGRect) getFrame
{//get frame
    return CGRectMake(self.center.x - self.radius, self.center.y - self.radius, self.radius * 2, self.radius * 2);
}//get frame

- (NSString*) description
{//description
    return [NSString stringWithFormat:@"Circle--Center:{%f, %f}--Radius:%f", self.center.x, self.center.y, self.radius];
}//description

#pragma mark - Getting Points

- (CGPoint) getRandomPoint
{//get a random point inside circle
    /*
    float randomY = arc4random() % (int)self.radius + self.center.y;
    float xForY = [self getPositiveXForY:randomY];
    int randomSign = (arc4random() % 2 + 1) * 2 - 3;
    float displacement = (self.center.x - xForY) * randomSign;
    float xValue = self.center.x + displacement;
    float yPosForX = [self getPositiveYforX:xValue];
    float yNegForX = 2 * self.center.y - yPosForX;
    float randY = [CSShape randomFloatBetween:yNegForX :yPosForX];
    return CGPointMake(xValue, randY);
    */
    float randRadius = [CSShape randomFloatBetween:0.0 :self.radius];
    float randAngle = [CSShape randomFloatBetween:0.0 :2.0 * M_PI];
    return CGPointMake(randRadius * cos(randAngle) + self.center.x, randRadius * sin(randAngle) + self.center.y);
}//get a random point inside circle

- (CGPoint) getPointForAngle:(float)angle
{//get point for specified angle
    float xpos = self.radius * cos(angle) + self.center.x;
    float ypos = self.radius * sin(angle) + self.center.y;
    return CGPointMake(xpos, ypos);
}//get point for specified angle

#pragma mark - OpenGL Vertices

#ifdef kVerticesAreAnchoredAtCenter
- (void) getVertices:(Vertex *)array from:(NSUInteger)start anchor:(CGPoint)center
{//get locations of vertices
    GLKVector2 vCenter = GLKVector2Make(self.center.x - center.x, self.center.y - center.y);
    for (NSUInteger all = 0; all < kGLCircleEllipseVertexConstant; ++all)
    {//loop through points, add triangles
        //Start = Beginning, 'all * 3' = iteration
        float angle = (float)all / kGLCircleEllipseVertexConstant * (2.0 * M_PI);
        float next = (float)(all + 1) / kGLCircleEllipseVertexConstant * (2.0 * M_PI);
        CGPoint vert1 = [self getPointForAngle:angle];
        CGPoint vert2 = [self getPointForAngle:next];
        array[start + all * 3 + 0].geometry = vCenter;
        array[start + all * 3 + 1].geometry = GLKVector2Make(vert1.x - center.x, vert1.y - center.y);
        array[start + all * 3 + 2].geometry = GLKVector2Make(vert2.x - center.x, vert2.y - center.y);
    }//loop through points, add triangles
    
}//get locations of vertices
#else
- (void) getVertices:(Vertex *)array from:(NSUInteger)start
{//get locations of vertices
    GLKVector2 center = GLKVector2Make(self.center.x, self.center.y);
    for (NSUInteger all = 0; all < kGLCircleEllipseVertexConstant; ++all)
    {//loop through points, add triangles
        //Start = Beginning, 'all * 3' = iteration
        float angle = (float)all / kGLCircleEllipseVertexConstant * (2.0 * M_PI);
        float next = (float)(all + 1) / kGLCircleEllipseVertexConstant * (2.0 * M_PI);
        CGPoint vert1 = [self getPointForAngle:angle];
        CGPoint vert2 = [self getPointForAngle:next];
        array[start + all * 3 + 0].geometry = center;
        array[start + all * 3 + 1].geometry = GLKVector2Make(vert1.x, vert1.y);
        array[start + all * 3 + 2].geometry = GLKVector2Make(vert2.x, vert2.y);
    }//loop through points, add triangles
    
}//get locations of vertices
#endif
//3 Vertices for each triangle, 'kGLCircleEllipseVertexConstant' number of triangles
- (NSUInteger) numberOfVertices {return kGLCircleEllipseVertexConstant * 3;}

#pragma mark - Copying

- (id) copy
{//copy
    return [[CSCircle alloc] init:self.center :self.radius :self.canTouchInside];
}//copy

- (id) copyWithZone:(NSZone *)zone {return [self copy];}

@end
