extends Node2D

@onready var flame: Sprite2D = $Flame

func _ready() -> void:
	# This parameter of the shader material gives each flame a slightly different look and randomized animation.
	flame.material.set("shader_parameter/offset", global_position * 0.1)

func set_flame_on_and_off () -> void:
	if flame.visible:
		flame.visible = false
	else:
		flame.visible = true
	
func _input_event(viewport: Node, event: InputEvent, shape_index: int):
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
		)
	
	if event_is_mouse_click:
		set_flame_on_and_off()
