extends Line2D
class_name Koi


@export var num_segments := 5
@export var radius := 20
@export var turn_speed := 0.01
@export var random_turn_frequency := 0.5  # The higher the value, the more frequent the random turns
@export var max_turn_angle := 0.1 
@export var velocity := Vector2(3, 3)

var dist_segments := radius / 2
var random_turn_angle := 0.0

var head: Vector2


func _ready() -> void:
	init_segments()
	width = radius
	texture = texture.duplicate()
	texture.noise = texture.noise.duplicate()
	texture.noise.seed = randi()


func _process(delta: float) -> void:
	random_turn()
	ensure_within_screen_bounds()

	var new_pos := points[0] + velocity
	velocity = velocity.rotated(deg_to_rad(random_turn_angle))
	points[0] = Vector2(new_pos)
	head = points[0]
	update_segments()


# Assumes the only changed segment was the head
func update_segments() -> void:
	for i in range(1, points.size()):
		points[i] = constrain_distance(
			points[i], points[i-1], dist_segments
		);
	queue_redraw()


func init_segments() -> void:
	points.clear()
	var curr := Vector2.ZERO
	for i in range(num_segments):
		add_point(curr)
		curr.x += dist_segments
	head = points[0]


func constrain_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor


func ensure_within_screen_bounds() -> void:
	var screen_size := get_viewport_rect().size
	var global_head_pos := to_global(head)
	if global_head_pos.x < 0 or global_head_pos.x > screen_size.x:
		velocity.x *= -1
	if global_head_pos.y < 0 or global_head_pos.y > screen_size.y:
		velocity.y *= -1


func random_turn() -> void:
	if randf() < random_turn_frequency:
		random_turn_angle += randf_range(-max_turn_angle, max_turn_angle) * turn_speed
	else:
		random_turn_angle = lerp(random_turn_angle, 0.0, 0.1)
