//
//  CSShape.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape.h"

@implementation CSShape

@synthesize canTouchInside = _canTouchInside;

- (id) init:(BOOL)setTouch
{//initialize
    self = [super init];
    _canTouchInside = setTouch;
    return self;
}//initialize

- (void) draw:(UIColor *)color
{//draw
    
}//draw
- (CGMutablePathRef) getPath
{
    CGMutablePathRef path = CGPathCreateMutable();
    return path;
}

- (void) transpose:(CGPoint)move
{//transpose shape
    
}//transpose shape
- (CGRect) getFrame
{//get frame of shape
    return CGRectZero;
}//get frame of shape

- (CGPoint) getRandomPoint
{//get random point inside shape
    return CGPointZero;
}//get random point inside shape

+ (float) randomFloatBetween :(float)low :(float)high
{//get a random float between 'low' and 'high'
        if (low == high)
            return low;
    float rand = arc4random() % (int)((ABS(high - low) + 1));
    //float range = (high - low);
    float randomNumber = (float)(rand) + MIN(low, high);
    /*static BOOL once = YES;
        if (once)
        {
            //once = NO;
            NSLog(@"low:%f high:%f rand:%f range:%f random:%f", low, high, rand, range, randomNumber);
        }*/
    return randomNumber;
}//get a random float between 'low' and 'high'

- (id) copy
{//copy shape
    NSLog(@"ERROR: Copying 'CSShape'--Not Subclass");
    return nil;
}//copy shape

- (id) copyWithZone:(NSZone *)zone {return [self copy];}

#ifdef kVerticesAreAnchoredAtCenter
- (void) getVertices :(Vertex*)array from:(NSUInteger)start anchor:(CGPoint)center
{//get vertices
    NSLog(@"-[CSShape getVertices:from:anchor: Invoked!");
}//get vertices
#else
- (void) getVertices :(Vertex*)array from:(NSUInteger)start
{//get vertices
    NSLog(@"-[CSShape getVertices:from: Invoked!");
}//get vertices
#endif
- (NSUInteger) numberOfVertices {return 0;}

@end
