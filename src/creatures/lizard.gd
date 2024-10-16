extends Creature
class_name Lizard

enum ControlMode {
	INFINITE_STROLL,
	KEYBOARD_CONTROL,
	FOLLOW_MOUSE,
}

@export var debug := false
@export var control_mode: ControlMode

@onready var arms: Array[Chain] = [
	$Arm1,
	$Arm2,
	$Arm3,
	$Arm4,
]
var arms_desired: Array[Vector2] = []

var active := true

@export var preset: Preset


func _ready() -> void:
	spine.initialize(joint_count, link_size, angle_constraint)
	left_eye.initialize(eye_size, eye_color)
	right_eye.initialize(eye_size, eye_color)

	initialize_arms()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_space"):
		active = not active

	var head_pos := spine.points[0]
	if active:
		match control_mode:
			ControlMode.KEYBOARD_CONTROL:
				update_velocity_keyboard(delta, head_pos)
			ControlMode.FOLLOW_MOUSE:
				if not should_stop(head_pos):
					update_velocity_follow_mouse(delta, head_pos)
			ControlMode.INFINITE_STROLL:
				update_velocity_infinite_scroll(delta, head_pos)
		spine.resolve(compute_new_pos(head_pos))

	update_eye_positions(head_pos)

	for i in range(arms.size()):
		var side := 1 if i % 2 == 0 else -1
		var body_index: int = get_param("m_body_index1") if i < 2 else get_param("m_body_index2")
		var angle: float = get_param("m_angle1") if i < 2 else get_param("m_angle2")
		var angle_offset := angle * side

		var desired_pos := Vector2(
			get_pos_x(body_index, angle_offset, get_param("m_len_offset_desired")),
			get_pos_y(body_index, angle_offset, get_param("m_len_offset_desired"))
		)

		if desired_pos.distance_to(arms_desired[i]) > get_param("m_distance_thres"):
			arms_desired[i] = desired_pos

		var end_angle_offset := (PI / 2 * side)
		var end_pos := Vector2(
			get_pos_x(body_index, end_angle_offset, get_param("m_len_offset_end")),
			get_pos_y(body_index, end_angle_offset, get_param("m_len_offset_end"))
		)

		arms[i].fabrik_resolve(
			arms[i].points[0].lerp(arms_desired[i], get_param("m_fabrik_lerp_weight")),
			end_pos
		)
	queue_redraw()


func _draw() -> void:
	if not debug:
		return
	for i in range(arms.size()):
		# Debugging: Uncomment the lines below to visualize arm targets
		draw_line(arms[i].points[0], arms_desired[i], Color.GREEN, 2)  # Target position


func initialize_arms() -> void:
	arms_desired.clear()
	arms_desired.resize(4)
	for i in range(4):
		arms_desired[i] = Vector2.ZERO
		var arm_length: int = get_param("m_arm_length1") if i < 2 else get_param("m_arm_length2")
		arms[i].initialize(get_param("m_joint_count"), arm_length)


func set_param(key: String, val) -> bool:
	if not preset.params.has(key):
		return false
	preset.params[key] = val
	return true
	
	
func get_param(key: String):
	assert(preset.params.has(key), "Invalid key: " + String(key))
	return preset.params[key]


func get_pos_x(i: int, angle_offset: float, length_offset: float) -> float:
	return spine.points[i].x + cos(spine.angles[i] + angle_offset) * (link_size + length_offset)


func get_pos_y(i: int, angle_offset: float, length_offset: float) -> float:
	return spine.points[i].y + sin(spine.angles[i] + angle_offset) * (link_size + length_offset)
