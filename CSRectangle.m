//
//  CSRectangle.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSRectangle.h"

#import "CSLineSegment.h"

@implementation CSRectangle

@synthesize center = _center;
@synthesize width = _width;
@synthesize height = _height;

- (id) init:(CGPoint)setCenter :(float)setWidth :(float)setHeight
{//initialize
    return [self init:setCenter :setWidth :setHeight :YES];
}//initialize

- (id) init:(CGPoint)setCenter :(float)setWidth :(float)setHeight :(BOOL)setTouch
{//initialize
    self = [super init:setTouch];
    _center = setCenter;
    _width = setWidth;
    _height = setHeight;
    return self;
}//initialize

+ (CSRectangle*) create :(CGPoint)setCenter :(float)setWidth :(float)setHeight
{//create
    return [[CSRectangle alloc] init:setCenter :setWidth :setHeight];
}//create

+ (CSRectangle*) create :(CGPoint)setCenter :(float)setWidth :(float)setHeight :(BOOL)setTouch
{//create
    return [[CSRectangle alloc] init :setCenter :setWidth :setHeight :setTouch];
}//create

- (void) draw:(UIColor *)color
{//draw
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextAddRect(context, CGRectMake([self getLeft], [self getBottom], self.width, self.height));
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
    CGPathAddRect(path, 0, CGRectMake([self getLeft], [self getBottom], self.width, self.height));
    return path;
}//get path for drawing


- (float) getLeft {return self.center.x - self.width / 2;}
- (float) getRight {return self.center.x + self.width / 2;}

#ifdef UsingOpenGLCoordinates

- (float) getTop {return self.center.y + self.height / 2;}
- (float) getBottom {return self.center.y - self.height / 2;}

#else

- (float) getTop {return self.center.y - self.height / 2;}
- (float) getBottom {return self.center.y + self.height / 2;}

#endif

- (CGPoint) getTopLeft {return CGPointMake([self getLeft], [self getTop]);}
- (CGPoint) getTopRight {return CGPointMake([self getRight], [self getTop]);}
- (CGPoint) getBottomLeft {return CGPointMake([self getLeft], [self getBottom]);}
- (CGPoint) getBottomRight {return CGPointMake([self getRight], [self getBottom]);}

#ifdef UsingOpenGLCoordinates
- (CGRect) getCGRect
{//convert to CGRect
    return CGRectMake([self getLeft], [self getBottom], self.width, self.height);
}//convert to CGRect
#else
- (CGRect) getCGRect
{//convert to CGRect
    return CGRectMake([self getLeft], [self getTop], self.width, self.height);
}//convert to CGRect
#endif

- (NSArray*) getLineSegments
{//get array of 'CSLineSegment'
    if (!self.lineSegments)
    {//create 'lineSegments'
        CGPoint topLeft = [self getTopLeft];
        CGPoint topRight = [self getTopRight];
        CGPoint bottomLeft = [self getBottomLeft];
        CGPoint bottomRight = [self getBottomRight];
        _lineSegments = [NSArray arrayWithObjects:[CSLineSegment create:topLeft :topRight],
                          [CSLineSegment create:topRight :bottomRight], [CSLineSegment create:bottomRight :bottomLeft],
                          [CSLineSegment create:bottomLeft :topLeft], nil];
    }//create 'lineSegments'
    return self.lineSegments;
}//get array of 'CSLineSegment'

- (BOOL) pointLiesInside:(CGPoint)pnt
{//checks if point is inside rectangle
    return [self getLeft] <= pnt.x && [self getRight] >= pnt.x
        && [self getTop] <= pnt.y && [self getBottom] >= pnt.y;
}//checks if point is inside rectangle

- (void) transpose:(CGPoint)move
{//transpose
    _center = CGPointMake(_center.x + move.x, _center.y + move.y);
        for (CSLineSegment* cur in self.lineSegments)
            [cur transpose:move];
}//transpose
- (CGRect) getFrame
{//get frame
    return [self getCGRect];
}//get frame


- (NSString*) description
{//description
    return [NSString stringWithFormat:@"Rectangle--Center:{%f, %f}--Size:{%f, %f}", self.center.x, self.center.y, self.width, self.height];
}//description

- (CGPoint) getRandomPoint
{//get a random point inside the rectangle
    float xpos = [CSShape randomFloatBetween:self.center.x - self.width / 2 :self.center.x + self.width / 2];
    float ypos = [CSShape randomFloatBetween:self.center.y - self.height / 2 :self.center.y + self.height / 2];
    return CGPointMake(xpos, ypos);
}//get a random point inside the rectangle
#ifdef kVerticesAreAnchoredAtCenter
- (void) getVertices :(Vertex*)array from:(NSUInteger)start anchor:(CGPoint)center
{//get vertices
    CGPoint tl = self.getTopLeft;
    CGPoint tr = self.getTopRight;
    CGPoint bl = self.getBottomLeft;
    CGPoint br = self.getBottomRight;
    array[start + 0].geometry = GLKVector2Make(bl.x - center.x, bl.y - center.y);
    array[start + 1].geometry = GLKVector2Make(tl.x - center.x, tl.y - center.y);
    array[start + 2].geometry = GLKVector2Make(tr.x - center.x, tr.y - center.y);
    array[start + 3].geometry = GLKVector2Make(tr.x - center.x, tr.y - center.y);
    array[start + 4].geometry = GLKVector2Make(bl.x - center.x, bl.y - center.y);
    array[start + 5].geometry = GLKVector2Make(br.x - center.x, br.y - center.y);
}//get vertices
#else
- (void) getVertices :(Vertex*)array from:(NSUInteger)start
{//get vertices
    CGPoint tl = self.getTopLeft;
    CGPoint tr = self.getTopRight;
    CGPoint bl = self.getBottomLeft;
    CGPoint br = self.getBottomRight;
    array[start + 0].geometry = GLKVector2Make(bl.x, bl.y);
    array[start + 1].geometry = GLKVector2Make(tl.x, tl.y);
    array[start + 2].geometry = GLKVector2Make(tr.x, tr.y);
    array[start + 3].geometry = GLKVector2Make(tr.x, tr.y);
    array[start + 4].geometry = GLKVector2Make(bl.x, bl.y);
    array[start + 5].geometry = GLKVector2Make(br.x, br.y);
}//get vertices
#endif
- (NSUInteger) numberOfVertices {return 6;}

#pragma mark - Copying

- (id) copy
{//copy
    return [[CSRectangle alloc] init:self.center :self.width :self.height :self.canTouchInside];
}//copy

- (id) copyWithZone:(NSZone *)zone {return [self copy];}

@end
