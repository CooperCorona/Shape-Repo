//
//  CSEllipse.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@interface CSEllipse : CSShape
{//properties
    CGPoint _center;
    float _width;
    float _height;
}//properties

@property (readonly) CGPoint center;
@property (readonly) float width;
@property (readonly) float height;

- (id) init :(CGPoint)setCent :(float)setW :(float)setH;
- (id) init :(CGPoint)setCent :(float)setW :(float)setH :(BOOL)setTouch;

+ (CSEllipse*)create :(CGPoint)setCent :(float)setW :(float)setH;
+ (CSEllipse*)create :(CGPoint)setCent :(float)setW :(float)setH :(BOOL)setTouch;

- (BOOL) pointLiesInside :(CGPoint)pnt;

- (float) getPositiveYforX :(float)x;
- (float) getNegativeYforX :(float)x;

- (float) getPositiveXforY :(float)y;
- (float) getNegativeXforY :(float)y;

- (CGPoint) getPointForAngle :(float)angle;

@end
