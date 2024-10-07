extends Creature
class_name Snake


func _ready() -> void:
	spine.initialize(joint_count, link_size, angle_constraint);
	left_eye.initialize(eye_size, eye_color)
	right_eye.initialize(eye_size, eye_color)


func _process(delta: float) -> void:
	var head_pos := spine.points[0]
	if not should_stop(head_pos):
		update_velocity(delta, head_pos)
		spine.resolve(compute_new_pos(head_pos))
		update_eye_positions(head_pos)
	queue_redraw()
