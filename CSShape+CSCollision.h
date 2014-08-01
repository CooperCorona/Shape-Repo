//
//  CSShape+CSCollision.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@class CSLineSegment;
@class CSRectangle;
@class CSTriangle;
@class CSCircle;
@class CSEllipse;
@class CSPoint;

@interface CSShape (CSCollision)

+ (BOOL) collideLineLine :(CSLineSegment*)first :(CSLineSegment*)second;
+ (BOOL) collideLineRectangle :(CSLineSegment*)first :(CSRectangle*)second;
+ (BOOL) collideLineTriangle :(CSLineSegment*)first :(CSTriangle*)second;
+ (BOOL) collideLineCircle :(CSLineSegment*)first :(CSCircle*)second;
+ (BOOL) collideLineEllipse :(CSLineSegment*)first :(CSEllipse*)second;
+ (BOOL) collideLinePoint :(CSLineSegment*)first :(CSPoint*)second;

+ (BOOL) collideRectangleRectangle :(CSRectangle*)first :(CSRectangle*)second;
+ (BOOL) collideRectangleTriangle :(CSRectangle*)first :(CSTriangle*)second;
+ (BOOL) collideRectangleCircle :(CSRectangle*)first :(CSCircle*)second;
+ (BOOL) collideRectangleEllipse :(CSRectangle*)first :(CSEllipse*)second;
+ (BOOL) collideRectanglePoint :(CSRectangle*)first :(CSPoint*)second;

+ (BOOL) collideTriangleTriangle :(CSTriangle*)first :(CSTriangle*)second;
+ (BOOL) collideTriangleCircle :(CSTriangle*)first :(CSCircle*)second;
+ (BOOL) collideTriangleEllipse :(CSTriangle*)first :(CSEllipse*)second;
+ (BOOL) collideTrianglePoint :(CSTriangle*)first :(CSPoint*)second;

+ (BOOL) collideCircleCircle :(CSCircle*)first :(CSCircle*)second;
+ (BOOL) collideCircleEllipse :(CSCircle*)first :(CSEllipse*)second;
+ (BOOL) collideCirclePoint :(CSCircle*)first :(CSPoint*)second;

+ (BOOL) collideEllipseEllipse :(CSEllipse*)first :(CSEllipse*)second;
+ (BOOL) collideEllipsePoint :(CSEllipse*)first :(CSPoint*)second;

+ (BOOL) collidePointPoint :(CSPoint*)first :(CSPoint*)second;

+ (BOOL) collide :(CSShape*)first :(CSShape*)second;

@end
