extends Control


@onready var lizard := %Lizard


func _ready() -> void:
	for node in get_tree().get_nodes_in_group("param_editor"):
		node.init(lizard)
