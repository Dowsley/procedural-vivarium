extends Node2D

@export var num_kois := 3
@export var koi_scene: PackedScene

var textures: Array[NoiseTexture2D] = []

func _ready() -> void:
	textures = load_koi_textures()
	
	randomize()
	var screen_size := get_viewport_rect().size
	for i in num_kois:
		var koi: Koi = koi_scene.instantiate()
		koi.load_texture(textures.pick_random())
		koi.position = Vector2(randi_range(0+koi.radius, screen_size.x-koi.radius), randi_range(0+koi.radius, screen_size.y-koi.radius))
		add_child(koi)


func load_koi_textures() -> Array[NoiseTexture2D]:
	var textures: Array[NoiseTexture2D] = []
	var dir = DirAccess.open("res://data/koi_types")
	dir.list_dir_begin()
	if dir != null:
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var resource_path := "res://data/koi_types/" + file_name
				var texture: NoiseTexture2D = ResourceLoader.load(resource_path)
				if texture != null:
					textures.append(texture)
			file_name = dir.get_next()
	return textures
