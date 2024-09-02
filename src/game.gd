extends Node2D

@export var num_kois := 3
@export var koi_scene: PackedScene

func _ready() -> void:
	var screen_size := get_viewport_rect().size
	for i in num_kois:
		var koi: Koi = koi_scene.instantiate()
		koi.position = Vector2(randi_range(0+koi.radius, screen_size.x-koi.radius), randi_range(0+koi.radius, screen_size.y-koi.radius))
		add_child(koi)
		
