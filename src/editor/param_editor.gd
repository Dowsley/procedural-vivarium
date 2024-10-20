extends VBoxContainer
class_name ParamEditor


@onready var name_label := %NameLabel
@onready var value_label := %ValueLabel
@onready var slider := $Slider

@export var param_name: String
@export var min := 0.0
@export var max := 100.0
@export var step := 1.0
@export var should_trigger_arm_compute := false

var default_val: float
var lizard: Lizard


func _ready() -> void:
	name_label.text = param_name + ':'
	slider.min_value = min
	slider.max_value = max
	slider.step = step


func init(lizard: Lizard) -> void:
	self.lizard = lizard
	var val: float = lizard.get_param(param_name)
	set_val(val)
	default_val = val
	slider.value = val


func set_val(val: float) -> void:
	value_label.text = String("%.2f" % val) 
	if lizard:
		lizard.set_param(param_name, val)


func _on_slider_value_changed(value: float) -> void:
	set_val(value)
	if should_trigger_arm_compute and lizard:
		lizard.initialize_arms()


func _on_button_button_up() -> void:
	set_val(default_val)
	slider.value = default_val
