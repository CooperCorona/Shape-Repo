//
//  CSShape+CSCreation.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 9/17/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@interface CSShape (CSCreation)

/*
 *  FORMAT: name, ... (name corresponds to next lines; each shape has specific format)
 *  Point: x, y
 *  LineSegment: x1, y1, x2, y2
 *  Rectangle: x, y, width, height
 *  Triangle: x1, y1, x2, y2, x3, y3
 *  Circle: x, y, radius
 *  Ellipse: x, y, width, height
 */
+ (CSShape*) createWithString :(NSString*)str :(BOOL)filledIn;
+ (CSShape*) createWithName :(NSString*)name andArray:(NSArray*)shapeComponents :(BOOL)filledIn;

//These are all called by 'createWithString' (components are the components of 'str' without the name)
+ (CSPoint*) createPointWithArray :(NSArray*)components;
+ (CSLineSegment*) createLineSegmentWithArray :(NSArray*)components;
+ (CSRectangle*) createRectangleWithArray :(NSArray*)components :(BOOL)filledIn;
+ (CSTriangle*) createTriangleWithArray :(NSArray*)components :(BOOL)filledIn;
+ (CSCircle*) createCircleWithArray :(NSArray*)components :(BOOL)filledIn;
+ (CSEllipse*) createEllipseWithArray :(NSArray*)components :(BOOL)filledIn;

@end
