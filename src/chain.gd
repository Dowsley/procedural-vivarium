extends Line2D
class_name Chain


## Space between joints.
var joint_count: int 
## Space between joints.
var link_size: int 
## Max angle diff between two adjacent joints, higher = loose, lower = rigid
var angle_constraint: float

# Only used in non-FABRIK resolution
var angles: Array[float]


func initialize(joint_count: int, link_size: int, angle_constraint: float) -> void:
	self.joint_count = joint_count
	self.link_size = link_size
	self.angle_constraint = angle_constraint
	
	points.clear()
	angles.clear()
	add_point(Vector2.ZERO)
	angles.push_back(0.0);
	for i in range(joint_count):
		add_point(points[i-1] + Vector2(0, link_size))
		angles.push_back(0.0)


func resolve(pos: Vector2) -> void:
	angles[0] = (pos - points[0]).angle()
	points[0] = pos
	for i in range(1, points.size()):
		var curr_angle := (points[i-1] - points[i]).angle()
		angles[i] = ConstraintUtil.constrain_angle(curr_angle, angles[i-1], angle_constraint)
		points[i] = points[i-1] - Vector2.RIGHT.rotated(angles[i]).normalized() * link_size


func fabrik_resolve(pos: Vector2, anchor: Vector2) -> void:
	# Forward pass
	points[0] = pos
	for i in range(1, points.size()):
		points[i] = ConstraintUtil.constrain_distance(points[i], points[i-1], link_size)

	# Backward pass
	points[points.size() - 1] = anchor
	for i in range(points.size() - 2, -1, -1):
		points[i] = ConstraintUtil.constrain_distance(points[i], points[i-1], link_size)
