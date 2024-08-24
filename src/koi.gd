@tool
extends Node2D
class_name Koi


var segments: Array[Vector2] = []
const START_NUM_SEGMENTS := 5
const RADIUS := 20
const DIST_SEGMENTS := RADIUS
var head_origin: Vector2
var dragging_head := false


func _ready() -> void:
	var curr := Vector2.ZERO
	var reduction := 0
	for i in START_NUM_SEGMENTS:
		segments.append(curr)
		curr.x += DIST_SEGMENTS
	head_origin = segments[0]


func _process(delta: float) -> void:
	var mouse_pos := get_local_mouse_position()
	var is_in_area := ((mouse_pos.x > head_origin.x - RADIUS) && (mouse_pos.x < head_origin.x + RADIUS)) && ((mouse_pos.y > head_origin.y - RADIUS) && (mouse_pos.y < head_origin.y + RADIUS))
	if is_in_area && Input.is_action_pressed("lmb_press"):
		segments[0] = mouse_pos
		head_origin = segments[0]
		update_segments()


func _draw() -> void:
	for origin in segments:
		draw_arc(origin, RADIUS, 0, 360, 100, Color.WHITE, 1, true)


# Assumes the only changed segment was the head
func update_segments() -> void:
	for i in range(1, segments.size()):
		segments[i] = constrain_distance(
			segments[i], segments[i-1], DIST_SEGMENTS
		);
	queue_redraw()


func constrain_distance(point: Vector2, anchor: Vector2, distance: float) -> Vector2:
	return ((point - anchor).normalized() * distance) + anchor
