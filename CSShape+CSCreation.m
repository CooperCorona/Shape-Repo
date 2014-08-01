//
//  CSShape+CSCreation.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 9/17/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape+CSCreation.h"

#import "CSPoint.h"
#import "CSLineSegment.h"
#import "CSRectangle.h"
#import "CSTriangle.h"
#import "CSCircle.h"
#import "CSEllipse.h"

#import "Miscellaneous.h"

typedef enum pointComponents
{
    PointX = 0,
    PointY
} pointComponents;
typedef enum lineSegmentComponents
{
    LineSegmentX1 = 0,
    LineSegmentY1,
    LineSegmentX2,
    LineSegmentY2
} lineSegmentComponents;
typedef enum rectangleComponents
{
    RectangleX = 0,
    RectangleY,
    RectangleWidth,
    RectangleHeight
} rectangleComponents;
typedef enum triangleComponents
{
    TriangleX1 = 0,
    TriangleY1,
    TriangleX2,
    TriangleY2,
    TriangleX3,
    TriangleY3
} triangleComponents;
typedef enum circleComponents
{
    CircleX = 0,
    CircleY,
    CircleRadius
} circleComponents;
typedef enum ellipseComponents
{
    EllipseX = 0,
    EllipseY,
    EllipseWidth,
    EllipseHeight
} ellipseComponents;

@implementation CSShape (CSCreation)

+ (CSShape*) createWithString :(NSString*)str :(BOOL)filledIn
{//create with string
    NSArray* components = [str componentsSeparatedByString:@", "];
    NSString* name = [components objectAtIndex:0];
    NSArray* shapeComponents = [components subarrayWithRange:NSRangeMake(1, [components count] - 1)];
    return [CSShape createWithName:name andArray:shapeComponents :filledIn];
}//create with string

+ (CSShape*) createWithName :(NSString*)name andArray:(NSArray*)shapeComponents :(BOOL)filledIn
{//create with name of shape and array of its values

    if ([name isEqualToString:@"Point"])
        return [CSShape createPointWithArray:shapeComponents];
    else if ([name isEqualToString:@"Line Segment"])
        return [CSShape createLineSegmentWithArray:shapeComponents];
    else if ([name isEqualToString:@"Rectangle"])
        return [CSShape createRectangleWithArray:shapeComponents :filledIn];
    else if ([name isEqualToString:@"Triangle"])
        return [CSShape createTriangleWithArray:shapeComponents :filledIn];
    else if ([name isEqualToString:@"Circle"])
        return [CSShape createCircleWithArray:shapeComponents :filledIn];
    else if ([name isEqualToString:@"Ellipse"])
        return [CSEllipse createEllipseWithArray:shapeComponents :filledIn];
    else
    {//invalid name!
        NSLog(@"CSShape--createWithName:andArray:NSString has invalid name:%@", name);
        return [CSPoint createWithX:0 Y:0];
    }//invalid name!
    return nil;
}//create with name of shape and array of its values

+ (CSPoint*) createPointWithArray :(NSArray*)components
{//create point
    float x = [[components objectAtIndex:PointX] floatValue];
    float y = [[components objectAtIndex:PointY] floatValue];
    
    return [CSPoint createWithX:x Y:y];
}//create point

+ (CSLineSegment*) createLineSegmentWithArray :(NSArray*)components
{//create line segment
    float x1 = [[components objectAtIndex:LineSegmentX1] floatValue];
    float y1 = [[components objectAtIndex:LineSegmentY1] floatValue];
    float x2 = [[components objectAtIndex:LineSegmentX2] floatValue];
    float y2 = [[components objectAtIndex:LineSegmentY2] floatValue];
    
    return [CSLineSegment create:CGPointMake(x1, y1) :CGPointMake(x2, y2)];
}//create line segment

+ (CSRectangle*) createRectangleWithArray :(NSArray*)components :(BOOL)filledIn
{//create rectangle
    float x = [[components objectAtIndex:RectangleX] floatValue];
    float y = [[components objectAtIndex:RectangleY] floatValue];
    float width = [[components objectAtIndex:RectangleWidth] floatValue];
    float height = [[components objectAtIndex:RectangleHeight] floatValue];
    
    return [CSRectangle create:CGPointMake(x, y) :width :height :filledIn];
}//create rectangle

+ (CSTriangle*) createTriangleWithArray :(NSArray*)components :(BOOL)filledIn
{//create triangle
    float x1 = [[components objectAtIndex:TriangleX1] floatValue];
    float y1 = [[components objectAtIndex:TriangleY1] floatValue];
    float x2 = [[components objectAtIndex:TriangleX2] floatValue];
    float y2 = [[components objectAtIndex:TriangleY2] floatValue];
    float x3 = [[components objectAtIndex:TriangleX3] floatValue];
    float y3 = [[components objectAtIndex:TriangleY3] floatValue];
    
    return [CSTriangle create:CGPointMake(x1, y1) :CGPointMake(x2, y2) :CGPointMake(x3, y3) :filledIn];
}//create triangle

+ (CSCircle*) createCircleWithArray :(NSArray*)components :(BOOL)filledIn
{//create circle
    float x = [[components objectAtIndex:CircleX] floatValue];
    float y = [[components objectAtIndex:CircleY] floatValue];
    float radius = [[components objectAtIndex:CircleRadius] floatValue];
    
    return [CSCircle create:CGPointMake(x, y) :radius :filledIn];
}//create circle

+ (CSEllipse*) createEllipseWithArray :(NSArray*)components :(BOOL)filledIn
{//create ellipse
    float x = [[components objectAtIndex:EllipseX] floatValue];
    float y = [[components objectAtIndex:EllipseY] floatValue];
    float width = [[components objectAtIndex:EllipseWidth] floatValue];
    float height = [[components objectAtIndex:EllipseHeight] floatValue];
    
    return [CSEllipse create:CGPointMake(x, y) :width :height :filledIn];
}//create ellipse

@end
