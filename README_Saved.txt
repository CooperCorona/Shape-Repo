Variety of classes defining different shapes used for collision detection.


*** CSShape ***

	Don’t use CSShape directly; it is abstract.

	If you wish to make a subclass of CSShape, you must override these methods:
		-[transpose:] method, which takes a CGPoint as an argument
and moves the shape according to the x and y values of the point
		 -[pointLiesInside:], which returns a boolean that states whether a given point lies inside (or on) the shape.
(OPTIONAL)	-[getRandomPoint], which returns a random point inside/on the shape


*** CSShapeGroup ***

	CSShapeGroup contains an array of shapes that can be tested against other shape groups. For example, you could define a group comprised of two separate circles, and if either of them trigger a collision, the shape group will detect it.
	
	Change the ‘center’ property to move the shape group. However, shape groups initially start at point {0, 0}. All shapes are therefore anchored as they were before being in a shape group. So setting a group’s center to {20, 20} will change a circle initially centered at {10, 10} will then be centered at {30, 30}.


*** CSPoint ***

	CSPoint defines a point in space. CSPoints only collide with other shapes if the point lies inside the shape (or in the case of a point, they must occupy the same point).


*** CSLineSegment ***

	CSLineSegment defines a line segment. When instantiating a line segment, pass in the two endpoints of the line segment.


*** CSRectangle ***

	CSRectangle defines a rectangle.

	You can access the line segments that comprise the rectangle with -[getLineSegments].


*** CSTriangle ***

	CSTriangle defines a triangle.

	You can access the line segments that comprise the triangle with -[getLineSegments].


*** CSCircle ***

	CSCircle defines a circle.

	-[getPositiveYforX:] and -[getNegativeYforX:] return the y-value corresponding to the given x-value. They return 0 if the x-value is invalid.

	-[getPositiveXForY:] and -[getNegativeXForY:] return the x-value corresponding to the given y-value. They return 0 if the y-value is invalid.

	-[getPointForAngle:] returns the point on the circle corresponding to the given angle.


*** CSEllipse ***

	CSEllipse defines an ellipse (oval).

	-[getPositiveYforX:] and -[getNegativeYforX:] return the y-value corresponding to the given x-value. They return 0 if the x-value is invalid.

	-[getPositiveXForY:] and -[getNegativeXForY:] return the x-value corresponding to the given y-value. They return 0 if the y-value is invalid.

	-[getPointForAngle:] returns the point on the circle corresponding to the given angle.

	### NOTE ### Collision detection for ellipses are not quite perfect. I’ve yet to find a mathematical formula determining collision detection, so I just test the far left, middle, and far right of the overlapping portions of the ellipse (if the far left of the first ellipse is greater than the far left of the second ellipse, but vice-versa for the far right, then they collide). If anyone figures out an exact formula for collision of two ellipses, then I would gladly update the code.