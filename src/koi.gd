extends Line2D
class_name Koi


@export var num_segments := 5
@export var radius := 20

var dist_segments := radius / 2
var dragging_head := false

var head: Vector2


func _ready() -> void:
	init_segments()
	width = radius


func _process(_delta: float) -> void:
	var mouse_pos := get_local_mouse_position()
	var is_in_area := ((mouse_pos.x > head.x - radius) && (mouse_pos.x < head.x + radius)) && ((mouse_pos.y > head.y - radius) && (mouse_pos.y < head.y + radius))
	if not Engine.is_editor_hint():
		if is_in_area:
			dragging_head = Input.is_action_pressed("lmb_press")
		else:
			dragging_head = dragging_head && Input.is_action_pressed("lmb_press")
	
	if dragging_head:
		points[0] = Vector2(mouse_pos)
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
