extends Node2D
class_name Creature


@onready var spine: Chain = $Spine
@onready var left_eye: Node2D = $LeftEye
@onready var right_eye: Node2D = $RightEye

@export_category("Chain")
@export var joint_count := 48
@export var link_size := 64
@export var angle_constraint := PI/8

@export_category("Behaviour and Appearance")
@export var eye_size := 4
@export var eye_color := Color.WHITE
@export var move_speed := 200

const CLOSE_ENOUGH_TO_MOUSE_RADIUS := 10
var velocity: Vector2


func update_velocity(delta: float, head_pos: Vector2) -> void:
	var mouse_position: Vector2 = get_global_mouse_position()
	var current_position: Vector2 = to_global(head_pos)
	var direction: Vector2 = (mouse_position - current_position).normalized()
	velocity = direction * move_speed * delta


func compute_new_pos(head_pos: Vector2) -> Vector2:
	return head_pos + velocity
	

func should_stop(head_pos: Vector2) -> bool:
	return abs(get_global_mouse_position().distance_to(to_global(head_pos))) <= CLOSE_ENOUGH_TO_MOUSE_RADIUS


func update_eye_positions(head_pos: Vector2) -> void:
	var angle := velocity.angle()
	var offset := Vector2(link_size-2, 0).rotated(angle)

	# Position the eyes relative to the head position
	left_eye.position = head_pos + offset.rotated(deg_to_rad(90))
	right_eye.position = head_pos + offset.rotated(deg_to_rad(-90))
