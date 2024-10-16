extends Control


@onready var lizard := %Lizard
@onready var preset_options := %PresetOptions
@onready var save_button := %SaveButton
@onready var save_line_edit := %SaveLineEdit

var preset_names: Array[StringName] = []

const PATH_PREFIX := "res://data/"


func _ready() -> void:
	init_lizards()
	load_all_preset_names()


func init_lizards() -> void:
	for node: ParamEditor in get_tree().get_nodes_in_group("param_editor"):
		node.init(lizard)


func load_all_preset_names_from_disk() -> Array[StringName]:
	var presets: Array[StringName] = []
	var dir = DirAccess.open("res://data")
	dir.list_dir_begin()
	if dir != null:
		var file_name := dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				presets.append(file_name.replace(".tres", ""))
			file_name = dir.get_next()
	return presets


func load_all_preset_names() -> void:
	preset_options.clear()
	preset_names = load_all_preset_names_from_disk()
	var count := 0
	var to_select := 0
	for p in preset_names:
		preset_options.add_item(p)
		if p == 'default_preset':
			to_select = count
		count += 1
	preset_options.selected = to_select

func does_preset_name_collide(other_name: String) -> bool:
	for p in preset_names:
		if p == other_name:
			return true
	return false


func build_preset_path(p_name: StringName) -> StringName:
	return PATH_PREFIX + p_name + ".tres"


func _on_save_button_button_up() -> void:
	var new_preset_name: String = save_line_edit.text
	if not does_preset_name_collide(new_preset_name):
		var full_path := build_preset_path(new_preset_name)
		ResourceSaver.save(lizard.preset, full_path)
		preset_names.append(new_preset_name)
		preset_options.add_item(new_preset_name)
		preset_options.selected = preset_names.size()-1
		save_line_edit.clear()


func _on_preset_options_item_selected(index: int) -> void:
	lizard.preset = ResourceLoader.load(build_preset_path(preset_names[index]))
	for node: ParamEditor in get_tree().get_nodes_in_group("param_editor"):
		node.init(lizard)
