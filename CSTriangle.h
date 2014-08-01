//
//  CSTriangle.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@interface CSTriangle : CSShape
{//properties
    CGPoint _point1;
    CGPoint _point2;
    CGPoint _point3;
}//properties

@property (readonly) CGPoint point1;
@property (readonly) CGPoint point2;
@property (readonly) CGPoint point3;
//Invoke -[getLineSegments], do not access this property directly
@property (readonly) NSArray* lineSegments;


- (id) init :(CGPoint)first :(CGPoint)second :(CGPoint)third;
- (id) init :(CGPoint)first :(CGPoint)second :(CGPoint)third :(BOOL)setTouch;
+ (CSTriangle*) create :(CGPoint)first :(CGPoint)second :(CGPoint)third;
+ (CSTriangle*) create :(CGPoint)first :(CGPoint)second :(CGPoint)third :(BOOL)setTouch;

- (NSArray*) getLineSegments;
- (float) getPositiveYforX:(float)x;
- (float) getNegativeYforX:(float)x;

- (BOOL) pointLiesInside :(CGPoint)pnt;

- (void) flipHorizontal;
- (void) flipHorizontalWithRect:(CGRect)frame;
- (void) flipVertical;
- (void) flipVerticalWithRect:(CGRect)frame;

@end
