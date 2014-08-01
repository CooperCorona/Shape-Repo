//
//  CSRectangle.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@interface CSRectangle : CSShape
{//properties
    CGPoint _center;
    float _width;
    float _height;
}//properties

@property (readonly) CGPoint center;
@property (readonly) float width;
@property (readonly) float height;
//Invoke -[getLineSegments], do not access this property directly
@property (readonly) NSArray* lineSegments;

- (id) init:(CGPoint)setCenter :(float)setWidth :(float)setHeight;
- (id) init:(CGPoint)setCenter :(float)setWidth :(float)setHeight :(BOOL)setTouch;

+ (CSRectangle*) create :(CGPoint)setCenter :(float)setWidth :(float)setHeight;
+ (CSRectangle*) create :(CGPoint)setCenter :(float)setWidth :(float)setHeight :(BOOL)setTouch;

- (float) getLeft;
- (float) getRight;
- (float) getTop;
- (float) getBottom;
- (CGPoint) getTopLeft;
- (CGPoint) getTopRight;
- (CGPoint) getBottomLeft;
- (CGPoint) getBottomRight;

- (CGRect) getCGRect;

- (NSArray*) getLineSegments;

- (BOOL) pointLiesInside:(CGPoint)pnt;

@end
