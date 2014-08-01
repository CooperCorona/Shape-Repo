//
//  CSShape.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "TexturedQuad.h"

@class CSPoint;
@class CSLineSegment;
@class CSRectangle;
@class CSTriangle;
@class CSCircle;
@class CSEllipse;

//How many vertices on side of circle/ellipse there will be, higher for more accuracy
#define kGLCircleEllipseVertexConstant 16
#define UsingOpenGLCoordinates YES
#define kVerticesAreAnchoredAtCenter YES

@interface CSShape : NSObject <NSCopying>
{//variables
    BOOL _canTouchInside;
}//variables

@property (readonly) BOOL canTouchInside;

- (id) init:(BOOL)setTouch;

- (void) draw :(UIColor*)color;
- (CGMutablePathRef) getPath;

- (void) transpose:(CGPoint)move;
- (CGRect) getFrame;

- (CGPoint) getRandomPoint;
+ (float) randomFloatBetween :(float)low :(float)high;

#ifdef kVerticesAreAnchoredAtCenter
- (void) getVertices :(Vertex*)array from:(NSUInteger)start anchor:(CGPoint)center;
#else
- (void) getVertices :(Vertex*)array from:(NSUInteger)start;
#endif

- (NSUInteger) numberOfVertices;//Returns number of vertices (your array must 
                                //have enough space for this number of vertices

@end
