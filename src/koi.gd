@tool
extends Node2D
class_name Koi


@export var num_segments := 5:
	set(value):
		num_segments = value
		init_segments()
		queue_redraw()
@export var radius := 20:
	set(value):
		radius = value
		dist_segments = radius / 2
		queue_redraw()
@export var size_curve: Curve = Curve.new()

var dist_segments := radius / 2
var segments: Array[Segment] = []
var head_origin: Vector2
var dragging_head := false


func _ready() -> void:
	init_segments()


func _process(_delta: float) -> void:
	var mouse_pos := get_local_mouse_position()
	var is_in_area := ((mouse_pos.x > head_origin.x - radius) && (mouse_pos.x < head_origin.x + radius)) && ((mouse_pos.y > head_origin.y - radius) && (mouse_pos.y < head_origin.y + radius))
	if not Engine.is_editor_hint():
		if is_in_area:
			dragging_head = Input.is_action_pressed("lmb_press")
		else:
			dragging_head = dragging_head && Input.is_action_pressed("lmb_press")
	
	if dragging_head:
		segments[0].origin = mouse_pos
		head_origin = segments[0].origin
		update_segments()


func _draw() -> void:
	for s in segments:
		draw_arc(s.origin, radius, 0, 360, 100, Color.WHITE, 1, true)


# Assumes the only changed segment was the head
func update_segments() -> void:
	for i in range(1, segments.size()):
		segments[i].origin = constrain_distance(
			segments[i].origin, segments[i-1].origin, dist_segments
		);
	queue_redraw()


func init_segments() -> void:
	segments.clear()
	var curr := Vector2.ZERO
	var seg: Segment = null
	for i in num_segments:
		seg = Segment.new(curr, radius)
		segments.append(seg)
		curr.x += dist_segments
	head_origin = segments[0].origin


func constrain_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor
