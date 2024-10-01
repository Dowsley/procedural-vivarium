extends Creature
class_name Lizard


@onready var arms: Array[Chain] = [
	$Arm1,
	$Arm2,
	$Arm3,
	$Arm4,
]
var arms_desired: Array[Vector2] = []

var debug := false
var m_arm_length1 := 52 / 4
var m_arm_length2 := 36 / 4
var m_joint_count := 3
var m_body_index1 := 3
var m_body_index2 := 7
var m_angle1 := PI / 4
var m_angle2 := PI / 3
var m_len_offset_desired := 50
var m_distance_thres := 100
var m_len_offset_end := -5
var m_fabrik_lerp_weight := 0.2


func _ready() -> void:
	spine.initialize(joint_count, link_size, angle_constraint)
	left_eye.initialize(eye_size, eye_color)
	right_eye.initialize(eye_size, eye_color)
	
	arms_desired.resize(4)
	for i in range(4):
		arms_desired[i] = Vector2.ZERO
		var arm_length := m_arm_length1 if i < 2 else m_arm_length2
		arms[i].initialize(m_joint_count, arm_length)


func _process(delta: float) -> void:
	var head_pos := spine.points[0]
	if not should_stop(head_pos):
		update_velocity(delta, head_pos)
		spine.resolve(compute_new_pos(head_pos))

	update_eye_positions(head_pos)

	for i in range(arms.size()):
		var side := 1 if i % 2 == 0 else -1
		var body_index := m_body_index1 if i < 2 else m_body_index2
		var angle := m_angle1 if i < 2 else m_angle2
		var angle_offset := angle * side
		
		var desired_pos := Vector2(
			get_pos_x(body_index, angle_offset, m_len_offset_desired),
			get_pos_y(body_index, angle_offset, m_len_offset_desired)
		)
		
		if desired_pos.distance_to(arms_desired[i]) > m_distance_thres:
			arms_desired[i] = desired_pos

		var end_angle_offset := (PI / 2 * side)
		var end_pos := Vector2(
			get_pos_x(body_index, end_angle_offset, m_len_offset_end),
			get_pos_y(body_index, end_angle_offset, m_len_offset_end)
		)
		
		arms[i].fabrik_resolve(
			arms[i].points[0].lerp(arms_desired[i], m_fabrik_lerp_weight),
			end_pos
		)
	queue_redraw()


func _draw() -> void:
	if not debug:
		return
	for i in range(arms.size()):
		# Debugging: Uncomment the lines below to visualize arm targets
		draw_line(arms[i].points[0], arms_desired[i], Color.GREEN, 2)  # Target position


func get_pos_x(i: int, angle_offset: float, length_offset: float) -> float:
	return spine.points[i].x + cos(spine.angles[i] + angle_offset) * (link_size + length_offset)


func get_pos_y(i: int, angle_offset: float, length_offset: float) -> float:
	return spine.points[i].y + sin(spine.angles[i] + angle_offset) * (link_size + length_offset)
