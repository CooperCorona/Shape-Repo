//
//  CSShapeGroup.h
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/9/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class CSShape;

#define CSCollisionFailureIsNil YES
//#define CSShapeGroupTestsFramesForCollision YES
@interface CSCollisionInfo : NSObject

@property BOOL success;
@property CSShape* shape1;
@property CSShape* shape2;
@property CGRect overlap;

- (id) init :(BOOL)successful :(CSShape*)first :(CSShape*)second;
+ (CSCollisionInfo*) create :(BOOL)successful :(CSShape*)first :(CSShape*)second;

@end


@protocol CSShapeGroupProtocol <NSObject>

- (CGRect) frame;

@end

@interface CSShapeGroup : NSObject <NSCopying> 

@property (nonatomic) CGPoint center;
@property (readonly) CGRect frame;
@property (nonatomic) BOOL flipH;
@property (nonatomic) BOOL flipV;

- (id) initWithArray :(NSArray*)array frame:(CGRect)setFrame;
+ (CSShapeGroup*) createWithArray :(NSArray*)array frame:(CGRect)setFrame;

- (id) initWithArray :(NSArray*)array center:(CGPoint)setCent;
+ (CSShapeGroup*) createWithArray :(NSArray*)array center:(CGPoint)setCent;

- (id) initWithString :(NSString*)string center:(CGPoint)setCent transposeShapes:(BOOL)tranShapes;
+ (CSShapeGroup*) createWithString :(NSString*)string center:(CGPoint)setCent transposeShapes:(BOOL)tranShapes;

+ (CSCollisionInfo*) collide :(CSShapeGroup*)first :(CSShapeGroup*)second;

- (void) flipHorizontally;
- (void) flipVertically;
- (void) setFlipV:(BOOL)flipV;

- (void) draw :(UIColor*)color;

- (CGRect) getFrame;
- (NSArray*) getShapes;

@end
