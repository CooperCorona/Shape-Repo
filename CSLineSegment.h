//
//  CSLineSegment.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

#import <UIKit/UIKit.h>

#import <GLKit/GLKit.h>

@interface CSLineSegment : CSShape
{//properties
    CGPoint _point1;
    CGPoint _point2;
    BOOL _vertical;
}//properties

@property (readonly) CGPoint point1;
@property (readonly) CGPoint point2;
@property (readonly) BOOL vertical;

- (id) init :(CGPoint)first :(CGPoint)second;
//- (id) init :(CGPoint)first :(CGPoint)second :(BOOL)setTouch;
+ (CSLineSegment*) create :(CGPoint)first :(CGPoint)second;
+ (CSLineSegment*) createWithPoint:(CGPoint)start vector:(GLKVector2)vect;

- (float) getSlope;
- (float) getYIntercept;
- (float) getYforX:(float)x;
- (float) getXforY:(float)y;

+ (BOOL) between_lines_vertically :(CSLineSegment*)l1 :(CSLineSegment*)l2 :(CGPoint)pnt;
+ (BOOL) between_lines_horizontally :(CSLineSegment*)l1 :(CSLineSegment*)l2 :(CGPoint)pnt;

+ (NSArray*) organizePoints:(NSMutableArray*)points :(BOOL)horizontal;

- (void) flipHorizontallyInRect:(CGRect)rect;
- (void) flipVerticallyInRect:(CGRect)rect;
- (void) flip;

@end
