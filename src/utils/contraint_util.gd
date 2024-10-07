extends Node


# Constrain the vector to be at a certain range of the anchor
func constrain_distance(pos: Vector2, anchor: Vector2, constraint: float) -> Vector2:
	return anchor + (pos - anchor).normalized() * constraint


# Constrain the angle to be within a certain range of the anchor
func constrain_angle(angle: float, anchor: float, constraint: float) -> float:
	if abs(relative_angle_diff(angle, anchor)) <= constraint:
		return simplify_angle(angle)
	
	if relative_angle_diff(angle, anchor) > constraint:
		return simplify_angle(anchor - constraint)
	
	return simplify_angle(anchor + constraint)


# i.e. How many radians do you need to turn the angle to match the anchor?
func relative_angle_diff(angle: float, anchor: float) -> float:
	# Since angles are represented by values in [0, TAU), it's helpful to rotate
	# the coordinate space such that PI is at the anchor. That way we don't have
	# to worry about the "seam" between 0 and TAU.
	angle = simplify_angle(angle + PI - anchor)
	anchor = PI

	return anchor - angle


# Simplify the angle to be in the range [0, TAU)
func simplify_angle(angle: float) -> float:
	while angle >= TAU:
		angle -= TAU
	
	while angle < 0:
		angle += TAU
	
	return angle
