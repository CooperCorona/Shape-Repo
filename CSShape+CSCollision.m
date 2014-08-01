//
//  CSShape+CSCollision.m
//  OmniPurposeLibrary
//
//  Created by Cooper Knaak on 7/8/13.
//  Copyright (c) 2013 Cooper Knaak. All rights reserved.
//

#import "CSShape+CSCollision.h"

#import "CSLineSegment.h"

#import "CSRectangle.h"

#import "CSTriangle.h"

#import "CSCircle.h"

#import "CSEllipse.h"

#import "CSPoint.h"

#import "Miscellaneous.h"

@implementation CSShape (CSCollision)

#pragma mark - Line

+ (BOOL) collideLineLine :(CSLineSegment*)first :(CSLineSegment*)second
{//collision between two lines
    if (first.vertical)
    {//first line is vertical
            if (second.vertical)
                return epsilon(first.point1.x, second.point1.x, kCloseEnoughFloat);
        float ypos2 = [second getYforX:first.point1.x];
        return inBetween(second.point1.x, second.point2.x, first.point1.x)
        && inBetween(first.point1.y, first.point2.y, ypos2);
    }//first line is vertical
    else if (second.vertical)
    {//second line is vertical
        //NOTE: Switches 'first' and 'second' so that 'first.vertical' conditional takes care of collision detection
        return [CSShape collideLineLine:second :first];
    }//second line is vertical
    
    float slope1 = [first getSlope];
    float inter1 = [first getYIntercept];
    float slope2 = [second getSlope];
    float inter2 = [second getYIntercept];

    if (epsilon(slope1, slope2, kCloseEnoughFloat))
        return NO;//Parallel lines never touch

    float x = -(inter1 - inter2) / (slope1 - slope2);

    float min1 = MIN(first.point1.x, first.point2.x);
    float min2 = MIN(second.point1.x, second.point2.x);
    float max1 = MAX(first.point1.x, first.point2.x);
    float max2 = MAX(second.point1.x, second.point2.x);

    float minX = MAX(min1, min2);
    float maxX = MIN(max1, max2);
    //NSLog(@"pnts:%@", pnts);
    //NSLog(@"points:%@", points);
    return inBetween(minX, maxX, x);
}//collision between two lines

+ (BOOL) collideLineRectangle :(CSLineSegment*)first :(CSRectangle*)second
{//collision between line segment and rectangle
    if (second.canTouchInside && [second pointLiesInside:first.point1])
        return YES;
    NSArray* segments = [second getLineSegments];
    for (CSLineSegment* current in segments)
    {//loop through line segments
        if ([CSShape collideLineLine :first: current])
            return YES;
    }//loop through line segments
    return NO;
}//collision between line segment and rectangle

+ (BOOL) collideLineTriangle :(CSLineSegment*)first :(CSTriangle*)second
{//collision between line segment and triangle
    if (second.canTouchInside && [second pointLiesInside:first.point1])
        return YES;
    else if (!second.canTouchInside && [second pointLiesInside:first.point1] && [second pointLiesInside:first.point2])
        return NO;
    NSArray* segments = [second getLineSegments];
    for (CSLineSegment* current in segments)
    {//loop through line segments
        if ([CSShape collideLineLine :first: current])
            return YES;
    }//loop through line segments
    return NO;
}//collision between line segment and triangle

+ (BOOL) collideLineCircle :(CSLineSegment*)first :(CSCircle*)second
{//collision between line segment and circle
    if (second.canTouchInside && [second pointLiesInside:first.point1])
        return YES;
    else if (!second.canTouchInside && [second pointLiesInside:first.point1] && [second pointLiesInside:first.point2])
        return NO;
    CGPoint center = second.center;
    float radius = second.radius;
        if (first.vertical)
        {//first is vertical line
            float y_pos = [second getPositiveYforX:first.point1.x];
            float y_neg = [second getNegativeYforX:first.point1.x];
            return inBetween(center.x - radius, center.x + radius, first.point1.x)
                && (inBetween(first.point1.y, first.point2.y, y_pos)
                || inBetween(first.point1.y, first.point2.y, y_neg));
        }//first is vertical line
    
    //CSLineSegment* transposed = [CSLineSegment create:CGPointMake(first.point1.x - center.x, first.point1.y - center.y) :CGPointMake(first.point2.x - center.x, first.point2.y - center.y)];
    /*[first transpose:CGPointMake(-center.x, -center.y)];
    float slope = [first getSlope];
    float inter = [first getYIntercept];
    [first transpose:CGPointMake(center.x, center.y)];
    
    float radical = 4 * slope * slope * inter * inter - 4 * (slope * slope + 1) * (inter * inter - radius * radius);
        if (radical < 0)
            return NO;
    float x_pos = (-2 * slope * inter + sqrtf(radical)) / (2 * slope * slope + 2) + center.x;
    float x_neg = (-2 * slope * inter - sqrtf(radical)) / (2 * slope * slope + 2) + center.x;
    
    return inBetween(first.point1.x, first.point2.x, x_pos)
        || inBetween(first.point1.x, first.point2.x, x_neg);
    */
    
    float r = second.radius;
    float m = first.getSlope;
    float l = m * second.center.x + first.getYIntercept - second.center.y;
    float qA = m * m + 1;
    float qB = 2 * m * l;
    float qC = l * l - r * r;
    float rad = qB * qB - 4 * qA * qC;
    if (rad < 0.0)
        return NO;
    float radical = sqrtf(rad);
    float neg = (-qB - radical) / (2.0 * qA) + second.center.x;
    float pos = (-qB + radical) / (2.0 * qA) + second.center.x;
    
    BOOL returnee = inBetween(first.point1.x, first.point2.x, neg)
    || inBetween(first.point1.x, first.point2.x, pos);
    return returnee;
}//collision between line segment and circle

+ (BOOL) collideLineEllipse :(CSLineSegment*)first :(CSEllipse*)second
{//collision between line segment and ellipse
    if (second.canTouchInside && [second pointLiesInside:first.point1])
        return YES;
    else if (!second.canTouchInside && [second pointLiesInside:first.point1] && [second pointLiesInside:first.point2])
        return NO;
        if (first.vertical)
        {//first is vertical line
            float y_pos = [second getPositiveYforX:first.point1.x];
            float y_neg = [second getNegativeYforX:first.point1.x];
            return inBetween(second.center.x - second.width / 2.0, second.center.x + second.width / 2.0, first.point1.x)
                && (inBetween(first.point1.y, first.point2.y, y_pos)
                || inBetween(first.point1.y, first.point2.y, y_neg));
        }//first is vertical line
    
    //CSLineSegment* transposed = [CSLineSegment create:CGPointMake(first.point1.x - center.x, first.point1.y - center.y) :CGPointMake(first.point2.x - center.x, first.point2.y - center.y)];
    
    /*    [first transpose:CGPointMake(-center.x, -center.y)];
    float slope = [first getSlope];
    float inter = [first getYIntercept];
        [first transpose:CGPointMake(center.x, center.y)];
    
    float radical = 4 * slope * slope * inter * inter - 4 * (slope * slope + hei2 * hei2 / (wid2 * wid2)) * (inter * inter - hei2 * hei2);
    if (radical < 0)
        return NO;
    float x_pos = (-2 * slope * inter + sqrtf(radical)) / (2 * slope * slope + 2 * hei2 * hei2 / (wid2 * wid2)) + center.x;
    float x_neg = (-2 * slope * inter - sqrtf(radical)) / (2 * slope * slope + 2 * hei2 * hei2 / (wid2 * wid2)) + center.x;
    
    return inBetween(first.point1.x, first.point2.x, x_pos)
    || inBetween(first.point1.x, first.point2.x, x_neg);
    */
    /*float m = first.getSlope;
    //adjust y-intercept to correct for ellipse's center not being (0, 0)
    float b1 = first.getYIntercept - m * second.center.x + second.center.y;
    float a = second.width / 2.0;
    float b2 = second.height / 2.0;
    
    CGPoint point1 = CGPointMake(first.point1.x - second.center.x, first.point1.y - m * second.center.x + second.center.y);
    CGPoint point2 = CGPointMake(first.point2.x - second.center.x, first.point2.y - m * second.center.x + second.center.y);
    
    float qA = m * m + b2 * b2 / (a * a);
    float qB = 2 * m * b1;
    float qC = b1 * b1 - b2 * b2;
    float unRadical = qB * qB - 4 * qA * qC;
        if (unRadical < 0.0)
            return NO;
    float radical = sqrt(unRadical);
    float neg = (-qB - radical) / (2.0 * qA);
    float pos = (-qB + radical) / (2.0 * qA);
    return inBetween(point1.x, point2.x, neg)
        || inBetween(point1.x, point2.x, pos);*/
    /*
    float m = first.getSlope;
    float b1 = first.getYIntercept;
    float a = second.width / 2;
    float b2 = second.height / 2;
    float h = second.center.x;
    float k = second.center.y;
    float qA = m * m + b2 * b2 / (a * a);
    float qB = 2 * (m * m * h + m * b1 - m * k);
    float qC = m * m * h * h + 2 * m * h * b1 - 2 * m * h * k + b1 * b1 - 2 * b1 * k + k * k - b2 * b2;
    float radical = qB * qB - 4 * qA * qC;
        if (radical < 0.0)
            return NO;
    float radRoot = sqrtf(radical);
    float neg = (-qB - radRoot) / (2 * qA);
    float pos = (-qB + radRoot) / (2 * qA);
    NSLog(@"pos:%f neg:%f p1:%@ p2:%@", pos, neg, NSStringFromCGPoint(first.point1), NSStringFromCGPoint(first.point2));
    return inBetween(first.point1.x, first.point2.x, neg)
        || inBetween(first.point1.x, first.point2.x, pos);*/
    float a = second.width / 2.0;
    float b = second.height / 2.0;
    float m = first.getSlope;
    float l = m * second.center.x + first.getYIntercept - second.center.y;
    float qA = m * m + b * b / (a * a);
    float qB = 2 * m * l;
    float qC = l * l - b * b;
    float rad = qB * qB - 4 * qA * qC;
        if (rad < 0.0)
            return NO;
    float radical = sqrtf(rad);
    float neg = (-qB - radical) / (2.0 * qA) + second.center.x;
    float pos = (-qB + radical) / (2.0 * qA) + second.center.x;
    
    BOOL returnee = inBetween(first.point1.x, first.point2.x, neg)
    || inBetween(first.point1.x, first.point2.x, pos);
    return returnee;
}//collision between line segment and ellipse

+ (BOOL) collideLinePoint:(CSLineSegment *)first :(CSPoint *)second
{//collision between line segment and point
    if (!inBetween(first.point1.x, first.point2.x, second.x))
        return NO;
    float yPos = [first getYforX:second.x];
    return epsilon(yPos, second.y, kCloseEnoughFloat);
}//collision between line segment and point

#pragma mark - Rectangle

+ (BOOL) collideRectangleRectangle :(CSRectangle*)first :(CSRectangle*)second
{//collision between two rectangles
    float l1 = [first getLeft];
    float r1 = [first getRight];
    float t1 = [first getTop];
    float b1 = [first getBottom];
    float l2 = [second getLeft];
    float r2 = [second getRight];
    float t2 = [second getTop];
    float b2 = [second getBottom];
        if (r1 < l2 || l1 > r2
         || b1 > t2 || t1 < b2)
        {
            return NO;
        }
        /*else if (!first.canTouchInside && first.width > second.width && first.height > second.height)
        {//first is not filled in
            if (l2 > l1 && r2 < r1
             && t2 > t1 && b2 < b1)
                return NO;
            else
                return YES;
        }//first is not filled in
        else if (!second.canTouchInside && second.width > first.width && second.height > first.height)
            return [CSShape collideRectangleRectangle:second :first];*/
    return YES;
}//collision between two rectangles

+ (BOOL) collideRectangleTriangle :(CSRectangle*)first :(CSTriangle*)second
{//collision between rectangle and triangle
    NSArray* rectSegments = [first getLineSegments];
    NSArray* triSegments = [second getLineSegments];
    for (CSLineSegment* curRect in rectSegments)
    for (CSLineSegment* curTri in triSegments)
    {//check against all lines
        if ([CSShape collideLineLine :curRect :curTri])
            return YES;
    }//check against all lines
    //If lines aren't touching, then all points must be either inside or outside
    if (!first.canTouchInside)
    {//first is not filled
        if ([first pointLiesInside:second.point1])
            return NO;
    }//first is not filled
    if (!second.canTouchInside)
    {//second is not filled
        if ([second pointLiesInside:[first getTopLeft]])
            return NO;
    }//second is not filled
    return NO;
}//collision between rectangle and triangle

+ (BOOL) collideRectangleCircle :(CSRectangle*)first :(CSCircle*)second
{//collision between rectangle and circle
    NSArray* segments = [first getLineSegments];
        for (CSLineSegment* current in segments)
        {//loop through line segments
            if ([CSShape collideLineCircle:current :second])
                return YES;
        }//loop through line segments
        if (!first.canTouchInside)
        {//rectangle is not filled in
        //NOTE: Previous algorithm guaruntees lines don't touch circle, thus if
        //circle's center is inside rectangle, the rest of it must also be inside
            if ([first pointLiesInside:second.center])
                return NO;
        }//rectangle is not filled in
        else if (!second.canTouchInside)
        {//circle is not filled in
            //NOTE: Previous algorithm guaruntees lines don't touch circle, thus if
            //circle's center is inside rectangle, the rest of it must also be inside
            if ([second pointLiesInside:[first getTopLeft]])
                return NO;
        }//circle is not filled in
    return NO;
}//collision between rectangle and circle

+ (BOOL) collideRectangleEllipse :(CSRectangle*)first :(CSEllipse*)second
{//collision between rectangle and ellipse
    NSArray* segments = [first getLineSegments];
    for (CSLineSegment* current in segments)
    {//loop through line segments
        if ([CSShape collideLineEllipse:current :second])
            return YES;
    }//loop through line segments
    if (!first.canTouchInside)
    {//rectangle is not filled in
        //NOTE: Previous algorithm guaruntees lines don't touch circle, thus if
        //circle's center is inside rectangle, the rest of it must also be inside
        if ([first pointLiesInside:second.center])
            return NO;
    }//rectangle is not filled in
    return NO;
}//collision between rectangle and ellipse

+ (BOOL) collideRectanglePoint:(CSRectangle*)first :(CSPoint *)second
{//collision between rectangle and point
    if (first.canTouchInside)
    {//entire rectangle are valid
        return [first pointLiesInside:second.CGPoint];
    }//entire rectangle are valid
    else
    {//only lines of rectangle is valid
        NSArray* segments = first.getLineSegments;
        for (CSLineSegment* ls in segments)
        {//loop through segments
            if ([CSShape collideLinePoint:ls :second])
                return YES;
        }//loop through segments
        return NO;
    }//only lines of rectangle is valid
}//collision between rectangle and point

#pragma mark - Triangle

+ (BOOL) collideTriangleTriangle :(CSTriangle*)first :(CSTriangle*)second
{//collision between triangle and triangle
    NSArray* segments1 = [first getLineSegments];
    NSArray* segments2 = [second getLineSegments];
        for (CSLineSegment* cur1 in segments1)
        for (CSLineSegment* cur2 in segments2)
        {//check against line segments
            if ([CSShape collideLineLine:cur1 :cur2])
                return YES;
        }//check against line segments

        
        if (!first.canTouchInside)
        {//first is not filled
            //NOTE: Lines are not touching because for loops would've caught that
            //Therefore, if one points is inside, all points are inside
            if ([first pointLiesInside:second.point1])
                return NO;
        }//first is not filled
        else if (!second.canTouchInside)
        {//second is not filled
            //NOTE: Lines are not touching because for loops would've caught that
            //Therefore, if one points is inside, all points are inside
            if ([second pointLiesInside:first.point1])
                return NO;
        }//second is not filled
    
    return NO;
}//collision between triangle and triangle

+ (BOOL) collideTriangleCircle :(CSTriangle*)first :(CSCircle*)second
{//collision between triangle and circle
    NSArray* segments = [first getLineSegments];
        for (CSLineSegment* current in segments)
        {//check against line segments
            if ([CSShape collideLineCircle:current :second])
                return YES;
        }//check against line segments
    //Not touching, therefore, extremes are either all inside or all outisde
    //if (!first.canTouchInside)
    {//first is not filled
        if ([first pointLiesInside:CGPointMake(second.center.x - second.radius, second.center.y)])
            return first.canTouchInside;
    }//first is not filled
    //else if (!second.canTouchInside)
    {//second is not filled
        if ([second pointLiesInside:first.point1])
            return second.canTouchInside;
    }//second is not filled
    
    return NO;
}//collision between triangle and circle

+ (BOOL) collideTriangleEllipse :(CSTriangle*)first :(CSEllipse*)second
{//collision between triangle and ellipse
    NSArray* segments = [first getLineSegments];
    for (CSLineSegment* current in segments)
    {//check against line segments
        if ([CSShape collideLineEllipse:current :second])
            return YES;
    }//check against line segments
    
    //Not touching, therefore, extremes are either all inside or all outisde
    //if (!first.canTouchInside)
    {//first is not filled
        if ([first pointLiesInside:CGPointMake(second.center.x - second.width / 2, second.center.y)])
            return first.canTouchInside;
    }//first is not filled
    //else if (!second.canTouchInside)
    {//second is not filled
        if ([second pointLiesInside:first.point1])
            return second.canTouchInside;
    }//second is not filled
    
    return NO;
}//collision between triangle and ellipse

+ (BOOL) collideTrianglePoint:(CSTriangle*)first :(CSPoint *)second
{//collision between triangle and point
    if (first.canTouchInside)
    {//entire triangle are valid
        return [first pointLiesInside:second.CGPoint];
    }//entire triangle are valid
    else
    {//only lines of triangle is valid
        NSArray* segments = first.getLineSegments;
        for (CSLineSegment* ls in segments)
        {//loop through segments
            if ([CSShape collideLinePoint:ls :second])
                return YES;
        }//loop through segments
        return NO;
    }//only lines of triangle is valid
}//collision between triangle and point

#pragma mark - Circle

+ (BOOL) collideCircleCircle :(CSCircle*)first :(CSCircle*)second
{//collision between two circles
    float total_dist = first.radius + second.radius;
    CGPoint distXY = CGPointMake(first.center.x - second.center.x, first.center.y - second.center.y);
    float distSquared = distXY.x * distXY.x + distXY.y * distXY.y;
        if (!first.canTouchInside)
        {//first is not filled in
            float distTo2 = sqrtf(distSquared) + second.radius;
            if (distTo2 < first.radius)
                return NO;
        }//first is not filled in
        else if (!second.canTouchInside)
        {//second is not filled in
            return [CSShape collideCircleCircle:second :first];
        }//second is not filled in
    return distSquared <= total_dist * total_dist;
}//collision between two circles

+ (BOOL) collideCircleEllipse2 :(CSCircle*)first :(CSEllipse*)second
{//collision between circle and ellipse
    CGPoint distance = CGPointMake(second.center.x - first.center.x, second.center.y - first.center.y);
    float angle = atan2f(distance.y, distance.x);
    angle += M_PI;
        while (angle >= 2 * M_PI)
            angle -= 2 * M_PI;
    float a = second.width / 2;
    float b = second.height / 2;
    float distRadical = b * b * cos(angle) * cos(angle) + a * a * sin(angle) * sin(angle);
        if (distRadical <= 0)
            return NO;
    float toSideDist = a * b / sqrt(distRadical);
    float dist = sqrt(distance.x * distance.x + distance.y + distance.y);
    CGPoint onEllipse = CGPointMake(second.center.x - distance.x * toSideDist / dist, second.center.y - distance.y * toSideDist / dist);
    
        if (!first.canTouchInside || !second.canTouchInside)
        {//one of them is not filled
            bool radWidth = first.radius < second.width;
            bool radHeight = first.radius < second.height;
            float distTo2 = dist + toSideDist;
            if (radWidth && radHeight)
            {//circle is smaller
                if (first.radius < distTo2)
                    return NO;
            }//circle is smaller
            else if (!radWidth && !radHeight)
            {//ellipse is smaller
                if (first.radius > distTo2)
                    return NO;
            }//ellipse is smaller
            
        }//one of them is not filled
    
        if (first.canTouchInside && second.canTouchInside
            && ([first pointLiesInside:second.center]
            || [second pointLiesInside:first.center]))
            return YES;
    
        if ([first pointLiesInside:onEllipse])
            return YES;
    
    return NO;
}//collision between circle and ellipse

+ (BOOL) collideCircleEllipse :(CSCircle*)first :(CSEllipse*)second
{//collision between circle and ellipse
    float a1 = first.radius;
    float b1 = first.radius;
    //float h1 = first.center.x;
    //float k1 = first.center.y;
    
    float a2 = second.width / 2;
    float b2 = second.height / 2;
    //float h2 = second.center.x;
    //float k2 = second.center.y;
    
    float minX = MAX(first.center.x - a1, second.center.x - a2);
    float maxX = MIN(first.center.x + a1, second.center.x + a2);
    float minY = MAX(first.center.y - b1, second.center.y - b2);
    float maxY = MIN(first.center.y + b1, second.center.y + b2);
    if (minX > maxX || minY > maxY)
        return NO;
    else if (epsilon(minX, maxX, kCloseEnoughFloat) && epsilon(minY, maxY, kCloseEnoughFloat))
    {
        return YES;
    }
    float m = (minX + maxX) / 2.0;
    
    
    NSArray* pos1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[first getPositiveYforX:minX]],
                     [NSNumber numberWithFloat:[first getPositiveYforX:m]],
                     [NSNumber numberWithFloat:[first getPositiveYforX:maxX]], nil];
    NSArray* neg1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[first getNegativeYforX:minX]],
                     [NSNumber numberWithFloat:[first getNegativeYforX:m]],
                     [NSNumber numberWithFloat:[first getNegativeYforX:maxX]], nil];
    NSArray* pos2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[second getPositiveYforX:minX]],
                     [NSNumber numberWithFloat:[second getPositiveYforX:m]],
                     [NSNumber numberWithFloat:[second getPositiveYforX:maxX]], nil];
    NSArray* neg2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[second getNegativeYforX:minX]],
                     [NSNumber numberWithFloat:[second getNegativeYforX:m]],
                     [NSNumber numberWithFloat:[second getNegativeYforX:maxX]], nil];
    
    
    for (NSUInteger al1 = 0; al1 < 2; ++al1)
        for (NSUInteger al2 = 0; al2 < 2; ++al2)
        {//check points
            NSArray* __weak v1 = (al1 == 0) ? pos1 : neg1;
            NSArray* __weak v2 = (al2 == 0) ? pos2 : neg2;
            float v1Min = [[v1 objectAtIndex:0] floatValue];
            float v1Mid = [[v1 objectAtIndex:1] floatValue];
            float v1Max = [[v1 objectAtIndex:2] floatValue];
            float v2Min = [[v2 objectAtIndex:0] floatValue];
            float v2Mid = [[v2 objectAtIndex:1] floatValue];
            float v2Max = [[v2 objectAtIndex:2] floatValue];
            if (epsilon(v1Min, v2Min, kCloseEnoughFloat)
                || epsilon(v1Mid, v2Mid, kCloseEnoughFloat)
                || epsilon(v1Max, v2Max, kCloseEnoughFloat))
            {
                return YES;
            }
            else if (v1Min > v2Min && v1Max < v2Max)
            {
                return YES;
            }
            else if (v1Min < v2Min && v1Max > v2Max)
            {
                return YES;
            }
            else if (v1Min > v2Min && v1Mid < v2Mid && v1Max > v2Max)
            {
                return YES;
            }
            else if (v1Min < v2Min && v1Mid > v2Mid && v1Max < v2Max)
            {
                return YES;
            }
        }//check points
    return NO;
}//collision between circle and ellipse

+ (BOOL) collideCirclePoint:(CSCircle *)first :(CSPoint *)second
{//collision between circle and point
    if (first.canTouchInside)
    {//entire circle is valid
        return [first pointLiesInside:second.CGPoint];
    }//entire circle is valid
    else
    {//only outline of circle is valid
            if (!inBetween(first.center.x - first.radius / 2, first.center.x + first.radius / 2, second.x))
                return NO;
        float yPositive = [first getPositiveYforX:second.x];
        float yNegative = [first getNegativeYforX:second.x];
        return epsilon(yPositive, second.y, kCloseEnoughFloat) || epsilon(yNegative, second.y, kCloseEnoughFloat);
    }//only outline of circle is valid
    
}//collision between circle and point

#pragma mark - Ellipse

+ (BOOL) collideEllipseEllipse2 :(CSEllipse*)first :(CSEllipse*)second
{//collision between ellipse and ellipse
    float a1 = first.width / 2;
    float b1 = first.height / 2;
    float h1 = first.center.x;
    //float k1 = first.center.y;
    
    float a2 = second.width / 2;
    float b2 = second.height / 2;
    float h2 = second.center.x;
    //float k2 = second.center.y;
    
        if (a1 > a2 && b1 > b2)
        {//first is bigger than second
            if (second.center.x - a2 > [first getNegativeXforY:second.center.y]
             && second.center.x + a2 < [first getPositiveXforY:second.center.y]
             && second.center.y - b2 > [first getNegativeYforX:second.center.x]
             && second.center.y + b2 < [first getPositiveYforX:second.center.x])
                return first.canTouchInside;
        }//first is bigger than second
        else if (a1 < a2 && b1 < b2)
        {//second is bigger than first
            return [CSShape collideEllipseEllipse:second :first];
        }//second is bigger than first
    
    float minimum = MAX(first.center.x - a1, second.center.x - a2);
    float maximum = MIN(first.center.x + a1, second.center.x + a2);
        if (minimum > maximum)
            return NO;
    //float m = (minimum + maximum) / 2.0;
    
    float critical = (h2 * b2 - h1 * b1) / (b2 - b1);
    
    NSArray* pos1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[first getPositiveYforX:minimum]],
                     [NSNumber numberWithFloat:[first getPositiveYforX:critical]],
                     [NSNumber numberWithFloat:[first getPositiveYforX:maximum]], nil];
    NSArray* neg1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[first getNegativeYforX:minimum]],
                     [NSNumber numberWithFloat:[first getNegativeYforX:critical]],
                     [NSNumber numberWithFloat:[first getNegativeYforX:maximum]], nil];
    NSArray* pos2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[second getPositiveYforX:minimum]],
                     [NSNumber numberWithFloat:[second getPositiveYforX:critical]],
                     [NSNumber numberWithFloat:[second getPositiveYforX:maximum]], nil];
    NSArray* neg2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[second getNegativeYforX:minimum]],
                     [NSNumber numberWithFloat:[second getNegativeYforX:critical]],
                     [NSNumber numberWithFloat:[second getNegativeYforX:maximum]], nil];
    
    for (NSUInteger al1 = 0; al1 < 2; ++al1)
    for (NSUInteger al2 = 0; al2 < 2; ++al2)
    {//loop through different critical points
        NSArray* __weak v1 = (al1 == 0) ? pos1 : neg1;
        NSArray* __weak v2 = (al2 == 0) ? pos2 : neg2;
            for (NSNumber* cur1 in v1)
            for (NSNumber* cur2 in v2)
                if (epsilon([cur1 floatValue], [cur2 floatValue], kCloseEnoughFloat))
                    return YES;
        float v1Min = [[v1 objectAtIndex:0] floatValue];
        float v1Mid = [[v1 objectAtIndex:1] floatValue];
        float v1Max = [[v1 objectAtIndex:2] floatValue];
        float v2Min = [[v2 objectAtIndex:0] floatValue];
        float v2Mid = [[v2 objectAtIndex:1] floatValue];
        float v2Max = [[v2 objectAtIndex:2] floatValue];
            if (v1Min > v2Min && v1Max < v2Max)
                return YES;
            else if (v1Min > v2Min && v1Mid < v2Mid && v1Max > v2Max)
                return YES;
            else if (v1Min < v2Min && v1Max > v2Max)
                return YES;
            else if (v1Min < v2Min && v1Mid > v2Mid && v1Max < v2Max)
                return YES;
    }//loop through different critical points
    return NO;
}//collision between ellipse and ellipse

+ (BOOL) collideEllipseEllipse :(CSEllipse*)first :(CSEllipse*)second
{//collision between ellipse and ellipse
    float a1 = first.width / 2;
    float b1 = first.height / 2;
    //float h1 = first.center.x;
    //float k1 = first.center.y;
    
    float a2 = second.width / 2;
    float b2 = second.height / 2;
    //float h2 = second.center.x;
    //float k2 = second.center.y;
    
    float minX = MAX(first.center.x - a1, second.center.x - a2);
    float maxX = MIN(first.center.x + a1, second.center.x + a2);
    float minY = MAX(first.center.y - b1, second.center.y - b2);
    float maxY = MIN(first.center.y + b1, second.center.y + b2);
    if (minX > maxX || minY > maxY)
        return NO;
    else if (epsilon(minX, maxX, kCloseEnoughFloat) && epsilon(minY, maxY, kCloseEnoughFloat))
    {
        return YES;
    }
    float m = (minX + maxX) / 2.0;
    
    
    NSArray* pos1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[first getPositiveYforX:minX]],
                     [NSNumber numberWithFloat:[first getPositiveYforX:m]],
                     [NSNumber numberWithFloat:[first getPositiveYforX:maxX]], nil];
    NSArray* neg1 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[first getNegativeYforX:minX]],
                     [NSNumber numberWithFloat:[first getNegativeYforX:m]],
                     [NSNumber numberWithFloat:[first getNegativeYforX:maxX]], nil];
    NSArray* pos2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[second getPositiveYforX:minX]],
                     [NSNumber numberWithFloat:[second getPositiveYforX:m]],
                     [NSNumber numberWithFloat:[second getPositiveYforX:maxX]], nil];
    NSArray* neg2 = [NSArray arrayWithObjects:[NSNumber numberWithFloat:[second getNegativeYforX:minX]],
                     [NSNumber numberWithFloat:[second getNegativeYforX:m]],
                     [NSNumber numberWithFloat:[second getNegativeYforX:maxX]], nil];
    
    
    for (NSUInteger al1 = 0; al1 < 2; ++al1)
    for (NSUInteger al2 = 0; al2 < 2; ++al2)
    {//check points
        NSArray* __weak v1 = (al1 == 0) ? pos1 : neg1;
        NSArray* __weak v2 = (al2 == 0) ? pos2 : neg2;
        float v1Min = [[v1 objectAtIndex:0] floatValue];
        float v1Mid = [[v1 objectAtIndex:1] floatValue];
        float v1Max = [[v1 objectAtIndex:2] floatValue];
        float v2Min = [[v2 objectAtIndex:0] floatValue];
        float v2Mid = [[v2 objectAtIndex:1] floatValue];
        float v2Max = [[v2 objectAtIndex:2] floatValue];
        if (epsilon(v1Min, v2Min, kCloseEnoughFloat)
        || epsilon(v1Mid, v2Mid, kCloseEnoughFloat)
        || epsilon(v1Max, v2Max, kCloseEnoughFloat))
            return YES;
        else if (v1Min > v2Min && v1Max < v2Max)
            return YES;
        else if (v1Min < v2Min && v1Max > v2Max)
            return YES;
        else if (v1Min > v2Min && v1Mid < v2Mid && v1Max > v2Max)
        {
            return YES;
        }
        else if (v1Min < v2Min && v1Mid > v2Mid && v1Max < v2Max)
        {
            return YES;
        }
    }//check points
    
    return NO;
}//collision between ellipse and ellipse

+ (BOOL) collideEllipsePoint:(CSEllipse *)first :(CSPoint *)second
{//collision between ellipse and point
    if (first.canTouchInside)
    {//entire ellipse is valid
        return [first pointLiesInside:second.CGPoint];
    }//entire ellipse is valid
    else
    {//only outline of ellipse is valid
        if (!inBetween(first.center.x - first.width / 2, first.center.x + first.width / 2, second.x))
            return NO;
        float yPos = [first getPositiveYforX:second.x];
        float yNeg = [first getNegativeYforX:second.x];
        return epsilon(yPos, second.y, kCloseEnoughFloat) || epsilon(yNeg, second.y, kCloseEnoughFloat);
    }//only outline of ellipse is valid
}//collision between ellipse and point

#pragma mark - Point

+ (BOOL) collidePointPoint:(CSPoint *)first :(CSPoint *)second
{//collision between two points
    return epsilon(first.x, second.x, kCloseEnoughFloat) && epsilon(first.y, second.y, kCloseEnoughFloat);
}//collision between two points


+ (BOOL) collide :(CSShape*)first :(CSShape*)second
{//collision between shapes
    if ([first isKindOfClass:[CSLineSegment class]] && [second isKindOfClass:[CSLineSegment class]])
        return [CSShape collideLineLine :(CSLineSegment*)first :(CSLineSegment*)second];
    else if ([first isKindOfClass:[CSLineSegment class]] && [second isKindOfClass:[CSRectangle class]])
        return [CSShape collideLineRectangle :(CSLineSegment*)first :(CSRectangle*)second];
    else if ([first isKindOfClass:[CSLineSegment class]] && [second isKindOfClass:[CSTriangle class]])
        return [CSShape collideLineTriangle :(CSLineSegment*)first :(CSTriangle*)second];
    else if ([first isKindOfClass:[CSLineSegment class]] && [second isKindOfClass:[CSCircle class]])
        return [CSShape collideLineCircle :(CSLineSegment*)first :(CSCircle*)second];
    else if ([first isKindOfClass:[CSLineSegment class]] && [second isKindOfClass:[CSEllipse class]])
        return [CSShape collideLineEllipse :(CSLineSegment*)first :(CSEllipse*)second];
    
    else if ([first isKindOfClass:[CSRectangle class]] && [second isKindOfClass:[CSRectangle class]])
        return [CSShape collideRectangleRectangle :(CSRectangle*)first :(CSRectangle*)second];
    else if ([first isKindOfClass:[CSRectangle class]] && [second isKindOfClass:[CSTriangle class]])
        return [CSShape collideRectangleTriangle :(CSRectangle*)first :(CSTriangle*)second];
    else if ([first isKindOfClass:[CSRectangle class]] && [second isKindOfClass:[CSCircle class]])
        return [CSShape collideRectangleCircle :(CSRectangle*)first :(CSCircle*)second];
    else if ([first isKindOfClass:[CSRectangle class]] && [second isKindOfClass:[CSEllipse class]])
        return [CSShape collideRectangleEllipse :(CSRectangle*)first :(CSEllipse*)second];
    
    else if ([first isKindOfClass:[CSTriangle class]] && [second isKindOfClass:[CSTriangle class]])
        return [CSShape collideTriangleTriangle :(CSTriangle*)first :(CSTriangle*)second];
    else if ([first isKindOfClass:[CSTriangle class]] && [second isKindOfClass:[CSCircle class]])
        return [CSShape collideTriangleCircle :(CSTriangle*)first :(CSCircle*)second];
    else if ([first isKindOfClass:[CSTriangle class]] && [second isKindOfClass:[CSEllipse class]])
        return [CSShape collideTriangleEllipse :(CSTriangle*)first :(CSEllipse*)second];
    
    else if ([first isKindOfClass:[CSCircle class]] && [second isKindOfClass:[CSCircle class]])
        return [CSShape collideCircleCircle :(CSCircle*)first :(CSCircle*)second];
    else if ([first isKindOfClass:[CSCircle class]] && [second isKindOfClass:[CSEllipse class]])
        return [CSShape collideCircleEllipse :(CSCircle*)first :(CSEllipse*)second];
    
    else if ([first isKindOfClass:[CSEllipse class]] && [second isKindOfClass:[CSEllipse class]])
        return [CSShape collideEllipseEllipse :(CSEllipse*)first :(CSEllipse*)second];
    
    else
    {//invalid
        BOOL returnValue = NO;
        static BOOL invert = YES;
        if (invert)
        {//switch 'first' and 'second'
            invert = NO;
            returnValue = [CSShape collide:second :first];
            invert = YES;
        }//switch 'first' and 'second'
        return returnValue;
    }//invalid
    
}//collision between shapes

@end
