extends Node2D

var width := 4
var color := Color.WHITE


func initialize(width: int, color: Color) -> void:
	self.width = width
	self.color = color


func _draw() -> void:
	draw_circle(Vector2.ZERO, width, color)
