//
//  CSShapeGroup.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/9/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShapeGroup.h"

#import "CSShape.h"

#import "CSShape+CSCollision.h"

#import "CSShape+CSCreation.h"

#import "ShapeFiles.h"

@implementation CSCollisionInfo

- (id) init :(BOOL)successful :(CSShape*)first :(CSShape*)second
{//initialize
    self = [super init];
    
    self.success = successful;
    self.shape1 = first;
    self.shape2 = second;
    
#if CSCollisionFailureIsNil == YES
    if (!self.success)
        return nil;
    self.overlap = CGRectIntersection([first getFrame], [second getFrame]);
#endif
    
    return self;
}//initialize

+ (CSCollisionInfo*) create :(BOOL)successful :(CSShape*)first :(CSShape*)second
{//create
    return [[CSCollisionInfo alloc] init:successful :first :second];
}//create

- (NSString*) description
{//description
    return [NSString stringWithFormat:@"Success:%hhd\nShape 1:%@\nShape 2:%@", self.success, self.shape1, self.shape2];
}//description

@end


typedef struct csVertex
{//vertex for CSShapeGroup
    GLKVector2 position;
    GLKVector4 color;
} csVertex;


@interface CSShapeGroup ()

@property NSArray* shapes;

- (void) transposeFrame;

@end

@implementation CSShapeGroup

@synthesize frame = _frame;
@synthesize center = _center;

- (id) initWithArray :(NSArray*)array center:(CGPoint)setCent
{//initialize with array
    float minX = 1024 * 1024;
    float minY = 1024 * 1024;
    float maxX = -1024 * 1024;
    float maxY = -1024 * 1024;
        for (CSShape* current in array)
        {//generate frame
            CGRect rect = [current getFrame];
            if (rect.origin.x < minX)
                minX = rect.origin.x;
            if (rect.origin.y < minY)
                minY = rect.origin.y;
            if (rect.origin.x + rect.size.width > maxX)
                maxX = rect.origin.x + rect.size.width;
            if (rect.origin.y + rect.size.height > maxY)
                maxY = rect.origin.y + rect.size.height;
        }//generate frame
    float width = maxX - minX;
    float height = maxY - minY;
    //CGRect frame = CGRectMake(minX, minY, maxX - minX, maxY - minY);
    CGRect frame = CGRectMake(setCent.x - width / 2, setCent.y - height / 2, width , height);
    self = [self initWithArray:array frame:frame];
    return self;
}//initialize with array

- (id) copyWithZone:(NSZone *)zone
{//??? just invoke 'copy' ???
    return [self copy];
}//??? just invoke 'copy' ???

- (id) copy
{//copy
    NSMutableArray* mArray = [NSMutableArray arrayWithCapacity:[self.shapes count]];
        for (CSShape* cur in self.shapes)
             [mArray addObject:[cur copy]];
    return [CSShapeGroup createWithArray:[NSArray arrayWithArray:mArray] frame:self.frame];
}//copy

+ (CSShapeGroup*) createWithArray :(NSArray*)array center:(CGPoint)setCent
{//create with array
    return [[CSShapeGroup alloc] initWithArray:array center:setCent];
}//create with array

- (id) initWithArray :(NSArray*)array frame:(CGRect)setFrame
{//initialize with array and frame
    self = [super init];
    
    self.shapes = array;
    _center = CGPointZero;
    self.center = CGPointMake(CGRectGetMidX(setFrame), CGRectGetMidY(setFrame));
    self.flipH = NO;
    _frame = setFrame;
    
    return self;
}//initialize with array and frame

+ (CSShapeGroup*) createWithArray :(NSArray*)array frame:(CGRect)setFrame
{//create with array and frame
    return [[CSShapeGroup alloc] initWithArray:array frame:setFrame];
}//create with array and frame

- (id) initWithString :(NSString*)string center:(CGPoint)setCent transposeShapes:(BOOL)tranShapes
{//initialize with a string
    if (!string)
        return nil;
    CGPoint negativeCenter = CGPointMake(-setCent.x, -setCent.y);
    
    NSArray* components = [string componentsSeparatedByString:@", "];
    NSMutableArray* shapes = [NSMutableArray arrayWithCapacity:5];
    NSUInteger current = 0;
    NSUInteger next = current;
    NSString* name = nil;
        for (NSUInteger all = 0; all < [components count]; ++all)
        {//get positions of names
            current = all;
            NSString* cur = [components objectAtIndex:all];
            NSScanner* scanner = [NSScanner scannerWithString:cur];
            float curFloat = 0;
            if (![scanner scanFloat:&curFloat])
            {//not a number
                if (all != 0)
                {//not first one
                    NSRange range;
                    range.location = next + 1;
                    range.length = current - range.location;
                    NSArray* subArray = [components subarrayWithRange:range];
                    CSShape* shape = [CSShape createWithName:name andArray:subArray :YES];
                        if (tranShapes)
                            [shape transpose:negativeCenter];
                    if (shape)
                    [shapes addObject:shape];
                    next = current;
                }//not first one
                name = cur;
            }//not a number
        }//get positions of names
    NSRange range;
    range.location = next + 1;
    range.length = 1 + current - range.location;
    NSArray* subArray = [components subarrayWithRange:range];
    CSShape* shape = [CSShape createWithName:name andArray:subArray :YES];
    if (tranShapes)
        [shape transpose:negativeCenter];
    if (shape)
    [shapes addObject:shape];
    next = current;
    //NOTE: 'shapePositions' keeps track of where the names of the shapes are in 'components'
        if ([shapes count] == 0)
            return nil;
    self = [self initWithArray:shapes center:setCent];
    return self;
}//initialize with a string

+ (CSShapeGroup*) createWithString :(NSString*)string center:(CGPoint)setCent transposeShapes:(BOOL)tranShapes
{//create with a string
    return [[CSShapeGroup alloc] initWithString:string center:setCent transposeShapes:tranShapes];
}//create with a string

+ (CSCollisionInfo*) collide :(CSShapeGroup*)first :(CSShapeGroup*)second
{//collision?
#ifdef CSShapeGroupTestsFramesForCollision
        if (!CGRectIntersectsRect(first.frame, second.frame))
#ifdef CSCollisionFailureIsNil
            return nil;
#else
            return [CSCollisionInfo create:NO :nil :nil];
#endif
#endif
    for (CSShape* cur1 in first.shapes)
    for (CSShape* cur2 in second.shapes)
    {//loop through shapes
        //[cur1 transpose:first.center];
        //[cur2 transpose:second.center];
        BOOL success = [CSShape collide:cur1 :cur2];
        //[cur1 transpose:CGPointMake(-first.center.x, -first.center.y)];
        //[cur2 transpose:CGPointMake(-second.center.x, -second.center.y)];
        if (success)
        {//successful collision
            CSCollisionInfo* info = [CSCollisionInfo create:YES :cur1 :cur2];
            //[cur1 transpose:CGPointMake(-first.center.x, -first.center.y)];
            //[cur2 transpose:CGPointMake(-second.center.x, -second.center.y)];
            return info;
        }//successful collision
        
    }//loop through shapes
    
#if CSCollisionFailureIsNil == YES
        return nil;
#else
        return [[CSCollisionInfo alloc] init:NO :nil :nil];
#endif
}//collision?

- (void) transposeFrame
{//transpose frame to center
    _frame.origin = CGPointMake(self.center.x - _frame.size.width / 2, self.center.y - _frame.size.height  / 2);
}//transpose frame to center

- (void) flipHorizontally
{//flip horizontally
    float x1 = self.frame.origin.x;
    float x2 = self.frame.origin.x + self.frame.size.width;
    float mid = (x2 + x1) / 2.0;
    //float width = self.frame.size.width;
    for (CSShape* curShape in self.shapes)
    {//loop through shapes
        if ([curShape isKindOfClass:[CSLineSegment class]])
        {//line
            CSLineSegment* current = (CSLineSegment*)curShape;
            /*
            CGPoint center = CGPointMake((current.point1.x + current.point2.x) / 2, (current.point1.y + current.point2.y) / 2);
            CGPoint pose = CGPointMake(-(x2 - center.x + x1), 0);
            */
            [current flipHorizontallyInRect:self.frame];
        }//line
        else if ([curShape isKindOfClass:[CSTriangle class]])
        {//triangle
            CSTriangle* current = (CSTriangle*)curShape;
            [current flipHorizontalWithRect:self.frame];
        }//triangle
        else if ([curShape isKindOfClass:[CSRectangle class]] || [curShape isKindOfClass:[CSCircle class]] || [curShape isKindOfClass:[CSEllipse class]])
        {//rectangle
            //CSRectangle* current = (CSRectangle*)curShape;
            CGPoint center = [(CSRectangle*)curShape center];
            CGPoint pose = CGPointMake(2.0 * (mid - center.x), 0);
            [curShape transpose:pose];
        }//rectangle
    
    }//loop through shapes

}//flip horizontally

- (void) flipVertically
{//flip vertically
    float y1 = self.frame.origin.y;
    float y2 = self.frame.origin.y + self.frame.size.height;
    float mid = (y2 + y1) / 2.0;
    for (CSShape* curShape in self.shapes)
    {//loop through shapes
        if ([curShape isKindOfClass:[CSLineSegment class]])
        {//line
            CSLineSegment* current = (CSLineSegment*)curShape;
            /*
             CGPoint center = CGPointMake((current.point1.x + current.point2.x) / 2, (current.point1.y + current.point2.y) / 2);
             CGPoint pose = CGPointMake(-(x2 - center.x + x1), 0);
             */
            [current flipVerticallyInRect:self.frame];
        }//line
        else if ([curShape isKindOfClass:[CSTriangle class]])
        {//triangle
            CSTriangle* current = (CSTriangle*)curShape;
            [current flipVerticalWithRect:self.frame];
        }//triangle
        else if ([curShape isKindOfClass:[CSRectangle class]] || [curShape isKindOfClass:[CSCircle class]] || [curShape isKindOfClass:[CSEllipse class]])
        {//rectangle
            //CSRectangle* current = (CSRectangle*)curShape;
            CGPoint center = [(CSRectangle*)curShape center];
            CGPoint pose = CGPointMake(0, 2 * (mid - center.y));
            [curShape transpose:pose];
        }//rectangle
        
    }//loop through shapes
    
}//flip vertically

- (void) draw :(UIColor*)color
{//draw group
    for (CSShape* current in self.shapes)
    {//loop
        //[current transpose:self.center];
        [current draw:color];
        //[current transpose:CGPointMake(-self.center.x, -self.center.y)];
    }//loop
}//draw group

- (void) setFlipH:(BOOL)flipH
{//set flipH
    if (flipH == self.flipH)
        return;
    else
    {//must flip
        _flipH = flipH;
        [self flipHorizontally];
    }//must flip
    
}//set flipH
- (void) setFlipV:(BOOL)flipV
{//set flipV
    if (flipV == self.flipV)
        return;
    else
    {//must flip
        _flipV = flipV;
        [self flipVertically];
    }//must flip
    
}//set flipV

- (CGRect) getFrame {return self.frame;}

- (NSString*) description
{
    //return [super description];
    
    NSString* returnee = @"";
    NSUInteger all = 0;
    for (CSShape* current in self.shapes)
    {
        returnee = [returnee stringByAppendingFormat:@"%lu:%@", (unsigned long)all, current];
        ++all;
    }
    return returnee;
}

- (void) setCenter:(CGPoint)center
{//set center
    if (CGPointEqualToPoint(_center, center))
        ;//return;
        for (CSShape* cur in self.shapes)
            [cur transpose:CGPointMake(center.x - _center.x, center.y - _center.y)];
    _center = center;
    [self transposeFrame];
}//set center

- (NSArray*) getShapes {return self.shapes;}

@end
