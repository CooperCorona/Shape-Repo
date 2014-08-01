//
//  CSCircle.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@interface CSCircle : CSShape
{//properties
    CGPoint _center;
    float _radius;
}//properties

@property (readonly) CGPoint center;
@property (readonly) float radius;

- (id) init :(CGPoint)setCent :(float)setRad;
- (id) init :(CGPoint)setCent :(float)setRad :(BOOL)setTouch;

+ (CSCircle*) create :(CGPoint)setCent :(float)setRad;
+ (CSCircle*) create :(CGPoint)setCent :(float)setRad :(BOOL)setTouch;

- (BOOL) pointLiesInside :(CGPoint)pnt;

- (float) getPositiveYforX :(float)x;
- (float) getNegativeYforX :(float)x;

- (float) getPositiveXForY :(float)y;
- (float) getNegativeXForY :(float)y;

- (CGPoint) getPointForAngle :(float)angle;

@end
