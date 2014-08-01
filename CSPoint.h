//
//  CSPoint.h
//  Alfredo's_Adventure_0.1
//
//  Created by Cooper Knaak on 9/14/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@interface CSPoint : CSShape

@property (readonly) float x;
@property (readonly) float y;

- (id) initWithCGPoint:(CGPoint)point;
- (id) initWithX:(float)setX Y:(float)setY;
+ (CSPoint*) createWithCGPoint:(CGPoint)point;
+ (CSPoint*) createWithX:(float)setX Y:(float)setY;

- (CGPoint) CGPoint;

@end
