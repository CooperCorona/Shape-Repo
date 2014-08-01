//
//  CSPoint.m
//  Alfredo's_Adventure_0.1
//
//  Created by Cooper Knaak on 9/14/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSPoint.h"

@implementation CSPoint

- (id) initWithCGPoint:(CGPoint)point
{//initialize
    self = [self initWithX:point.x Y:point.y];
    
    return self;
}//initialize

- (id) initWithX:(float)setX Y:(float)setY
{//initialize
    self = [super init:YES];
    
    _x = setX;
    _y = setY;
    
    return self;
}//initialize

+ (CSPoint*) createWithCGPoint:(CGPoint)point
{//create
    return [[CSPoint alloc] initWithCGPoint:point];
}//create

+ (CSPoint*) createWithX:(float)setX Y:(float)setY
{//create
    return [[CSPoint alloc] initWithX:setX Y:setY];
}//create

- (void) transpose:(CGPoint)move
{//transpose point
    _x += move.x;
    _y += move.y;
}//transpose point

- (CGPoint) CGPoint {return CGPointMake(_x, _y);}
- (CGPoint) getRandomPoint {return self.CGPoint;}

#ifdef kVerticesAreAnchoredAtCenter
- (void) getVertices :(Vertex*)array from:(NSUInteger)start anchor:(CGPoint)center
{//get vertices
    NSLog(@"-[CSPoint getVertices:from:anchor: Invoked!");
}//get vertices
#else
- (void) getVertices :(Vertex*)array from:(NSUInteger)start
{//get vertices
    NSLog(@"-[CSPoint getVertices:from: Invoked!");
}//get vertices
#endif
- (NSUInteger) numberOfVertices {return 1;}

- (NSString*) description
{//get description
    return [NSString stringWithFormat:@"CSPoint:{%f, %f}", _x, _y];
}//get description

- (void) draw:(UIColor *)color
{//draw with color
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextMoveToPoint(context, self.x, self.y);
    CGContextAddLineToPoint(context, self.x, self.y);
    CGContextStrokePath(context);
}//draw with color

- (CGRect) getFrame
{//get frame
    return CGRectMake(self.x, self.y, 0, 0);
}//get frame

#pragma mark - Copying

- (id) copy
{//copy 'CSPoint'
    return [CSPoint createWithX:self.x Y:self.y];
}//copy 'CSPoint'

- (id) copyWithZone:(NSZone *)zone {return [self copy];}

@end
