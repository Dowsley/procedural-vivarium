extends Line2D
class_name Koi

@onready var left_eye: Node2D = $LeftEye
@onready var right_eye: Node2D = $RightEye

@export var num_segments := 5
@export var radius := 20
@export var move_speed := 100

const CLOSE_ENOUGH_TO_MOUSE_RADIUS := 10

var dist_segments := radius / 2
var random_turn_angle := 0.0

var head: Vector2
var velocity: Vector2


func _ready() -> void:
	init_segments()
	width = radius


func _process(delta: float) -> void:
	if not should_stop():
		update_velocity(delta)
		update_head_pos()
	
	update_segments()
	update_eye_positions()


# Assumes the only changed segment was the head
func update_segments() -> void:
	for i in range(1, points.size()):
		points[i] = constrain_distance(
			points[i], points[i-1], dist_segments
		);
	queue_redraw()


func update_velocity(delta: float) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var current_position: Vector2 = to_global(head)
	var direction: Vector2 = (mouse_position - current_position).normalized()
	velocity = direction * move_speed * delta


func update_head_pos() -> void:
	var new_pos: Vector2 = head + velocity
	points[0] = Vector2(new_pos)
	head = points[0]


func init_segments() -> void:
	points.clear()
	var curr := Vector2.ZERO
	for i in range(num_segments):
		add_point(curr)
		curr.x += dist_segments
	head = points[0]


func should_stop() -> bool:
	return abs(get_global_mouse_position().distance_to(to_global(head))) <= CLOSE_ENOUGH_TO_MOUSE_RADIUS


func constrain_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor


func update_eye_positions() -> void:
	var angle := velocity.angle()
	var offset := Vector2(radius/3, 0).rotated(angle)

	# Position the eyes relative to the head position
	left_eye.position = head + offset.rotated(deg_to_rad(90))
	right_eye.position = head + offset.rotated(deg_to_rad(-90))


#func load_texture(tex: Texture2D) -> void:
	#texture = tex.duplicate()
	#texture.noise = texture.noise.duplicate()
	#texture.noise.seed = randi()
