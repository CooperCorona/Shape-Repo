//
//  CSEllipse.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSEllipse.h"

@implementation CSEllipse

- (id) init :(CGPoint)setCent :(float)setW :(float)setH
{//initialize
    return [self init:setCent :setW :setH :YES];
}//initialize
- (id) init :(CGPoint)setCent :(float)setW :(float)setH :(BOOL)setTouch
{//initialize
    self = [super init:setTouch];
    _center = setCent;
    _width = setW;
    _height = setH;
    return self;
}//initialize

+ (CSEllipse*)create :(CGPoint)setCent :(float)setW :(float)setH
{//create
    return [[CSEllipse alloc] init:setCent :setW :setH];
}//create

+ (CSEllipse*)create :(CGPoint)setCent :(float)setW :(float)setH :(BOOL)setTouch;
{//create
    return [[CSEllipse alloc] init:setCent :setW :setH :setTouch];
}//create

- (void) draw:(UIColor *)color
{//draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, CGRectMake(self.center.x - self.width / 2, self.center.y - self.height / 2, self.width, self.height));
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
    CGPathAddEllipseInRect(path, 0, CGRectMake(self.center.x - self.width / 2, self.center.y - self.height / 2, self.width, self.height));
    return path;
}//get path for drawing


- (BOOL) pointLiesInside :(CGPoint)pnt
{//point lise inside ellipse?
    float x_width = self.center.x - pnt.x;
    float y_height = self.center.y - pnt.y;
    float a = self.width / 2;
    float b = self.height / 2;
    return x_width * x_width / (a * a) + y_height * y_height / (b * b) <= 1;
}//point lies inside ellipse?

- (float) getPositiveYforX :(float)x
{//positive y-value for x-value
    float x_width = x - self.center.x;
    float a = self.width / 2;
    float b = self.height / 2;
    float radical = 1 - x_width * x_width / (a * a);
        if (radical < 0)
            return 0;
    return b * sqrtf(radical) + self.center.y;
}//positive y-value for x-value

- (float) getNegativeYforX :(float)x
{//negative y-value for x-value
    float x_width = x - self.center.x;
    float a = self.width / 2;
    float b = self.height / 2;
    float radical = 1 - x_width * x_width / (a * a);
    if (radical < 0)
        return 0;
    return -b * sqrtf(radical) + self.center.y;
}//negative y-value for x-value


- (float) getPositiveXforY :(float)y
{//positive x-value for y-value
    float y_height = y - self.center.y;
    float a = self.width / 2;
    float b = self.height / 2;
    float radical = 1 - y_height * y_height / (b * b);
        if (radical < 0)
            return 0;
    return a * sqrtf(radical) + self.center.x;
}//positive x-value for y-value

- (float) getNegativeXforY :(float)y
{//negative x-value for y-value
    float y_height = y - self.center.y;
    float a = self.width / 2;
    float b = self.height / 2;
    float radical = 1 - y_height * y_height / (b * b);
    if (radical < 0)
        return 0;
    return -a * sqrtf(radical) + self.center.x;
}//negative x-value for y-value

- (void) transpose:(CGPoint)move
{//transpose
    _center = CGPointMake(_center.x + move.x, _center.y + move.y);
}//transpose
- (CGRect) getFrame
{//get frame
    return CGRectMake(self.center.x - self.width / 2, self.center.y - self.height / 2, self.width, self.height);
}//get frame

- (NSString*) description
{//description
    return [NSString stringWithFormat:@"Ellipse--Center:{%f, %f}--Size:{%f, %f}", self.center.x, self.center.y, self.width, self.height];
}//description

#pragma mark - Getting Points

- (CGPoint) getRandomPoint
{//get a random point inside ellipse
    /*
    float randomY = arc4random() % (int)(self.height / 2) + self.center.y;
    float xForY = [self getPositiveXforY:randomY];
    int randomSign = (arc4random() % 2 + 1) * 2 - 3;
    float displacement = (self.center.x - xForY) * randomSign;
    float xValue = self.center.x + displacement;
    float yPosForX = [self getPositiveYforX:xValue];
    float yNegForX = 2 * self.center.y - yPosForX;
    float randY = [CSShape randomFloatBetween:yNegForX :yPosForX];
    return CGPointMake(xValue, randY);
    */
    float a = self.width / 2.0;
    float b = self.height / 2.0;
    float randAngle = [CSShape randomFloatBetween:0.0 :2.0 * M_PI];
    float radius = 1.0 / sqrt(cos(randAngle) * cos(randAngle) / (a * a) + sin(randAngle) * sin(randAngle) / (b * b));
    float randRadius = [CSShape randomFloatBetween:0.0 :radius];
    return CGPointMake(randRadius * cos(randAngle), randRadius * sin(randAngle));
}//get a random point inside ellipse

- (CGPoint) getPointForAngle:(float)angle
{//get point for specified angle
    float a = self.width / 2.0;
    float b = self.height / 2.0;
    float radius = 1.0 / sqrt(cos(angle) * cos(angle) / (a * a) + sin(angle) * sin(angle) / (b * b));
    float xpos = radius * cos(angle) + self.center.x;
    float ypos = radius * sin(angle) + self.center.y;
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
    return [[CSEllipse alloc] init:self.center :self.width :self.height :self.canTouchInside];
}//copy

- (id) copyWithZone:(NSZone *)zone {return [self copy];}

@end
