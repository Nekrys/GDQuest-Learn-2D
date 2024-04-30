extends Area2D

#@onready tells Godot to run the code after the '=' sign when the nodes are ready
#"var canvas_group: CanvasGroup" defines a variable with the type CanvasGroup node
#= $CanvasGroup gets the references from CanvasGroup node and assigns it to a variable
@onready var canvas_group: CanvasGroup = $CanvasGroup
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#@export tells Godot to allow edition of the property in the inspector tab on the right
#var possible_items defines the variable
#Array[PackedScene] = [] The variable stores an array of packed scenes. a list that accepts .tscn files
@export var possible_items: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connects the signals mouse_entered and mouse_exited to the functions in the code
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	canvas_group.material.set_shader_parameter("line_thickness", 3.0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

#select variable associated to canvasgroup node
#.material accesses the material property of the canvasgroup node
#.set_shader_parameter("line_thickness", new_thickness) calls function that allows to set a shader parameter
func set_outline_thickness (new_thickness: float) -> void:
	canvas_group.material.set_shader_parameter("line_thickness", new_thickness)
	
#mouse_entered and mouse exited will change the thickness of the shader on the CanvasGroup node
#each frame, the tween will call the set_outline_thickness() function with a value between 3.0 and 6.0
#The duration of the animation is 0.08
func _on_mouse_entered() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 3.0, 6.0, 0.08)
func _on_mouse_exited() -> void:
	var tween := create_tween()
	tween.tween_method(set_outline_thickness, 6.0, 3.0, 0.08)


func _input_event(viewport: Node, event: InputEvent, shape_index: int):
	#the code checks each condition, combines the result, and produces a value of true or false
	#that we assign to the event_is_mouse_click variable
	var event_is_mouse_click: bool = (
		event is InputEventMouseButton and 
		event.button_index == MOUSE_BUTTON_LEFT and 
		event.is_pressed()
		)
	
	if event_is_mouse_click:
		open()

#open chest function
func open() -> void:
	#plays the animation "open" from the var animation_player that contains the AnimationPlayer node
	animation_player.play("open")
	#Node2D property that tells the engine if the node should detect input events
	input_pickable = false
	#checks if the array possible_items is empty. if so we return from the function and the chest doesnt drop items
	#this checks allows to avoid errors
	if possible_items.is_empty():
		return
	#randi_range(1, 3) generates a number between 1 and 3 included
	#range(GeneratedNumber) will return an array of numbers ie range(2) returns two elements [0, 1]
	#this makes the loop run 2 times
	for current_index in range(randi_range(1, 3)):
	#_spawn_random_item() function will be called X times = to the number of the array
	#it will add a new child to the Chest scene for each time it runs
		_spawn_random_item()

func _spawn_random_item() -> void:
	#= possible_items.pick_random()  picks and returns a random value from the array
	#.instantiate() its a function from the PackedScene resource that creates a new instance based on the scene template file
	#var loot_item: Area2D declares a new variable and assigns the results of the function
	var loot_item: Area2D = possible_items.pick_random().instantiate()
	#adds loot_item scene as a child of the Chest.tscn
	add_child(loot_item)
	#generates a random angle and saves it to a variable
	#will grab the random angle and multiply by the value of magnitude on Vector2, this will generate a random_direction with the same length
	var random_angle := randf_range(0.0, 2.0 * PI)
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
	#randomizes a maximum and minimum distance
	#the position of the loot.item will be based on the randomized direction and distance
	var random_distance := randf_range(60.0, 120.0)
	#REMOVED - loot_item.position = random_direction * random_distance
	#create a variable to hold the landing position. the variable will be used to animate with the tween functions
	var land_position := random_direction * random_distance
	#sets the constants for how much time the loot item will be flying and how much time till he reaches the maximun hight
	const FLIGHT_TIME := 0.4
	const HALF_FLIGHT_TIME := FLIGHT_TIME / 2.0
	
	#Animation code 1- change item scale 2- make horizontal movement 3 - make vertical movement (up/down)
	#tween creation
	var tween := create_tween()
	tween.set_parallel()
	
	#loot_item scale configuration
	#animates the scale of them loot_item from 25% to 100% of its size over half the flight time. This will make the loot_item grow as it moves up
	loot_item.scale = Vector2(0.25, 0.25)
	tween.tween_property(loot_item, "scale", Vector2(1.0, 1.0), HALF_FLIGHT_TIME)
	
	#horizontal Movement configuration
	tween.tween_property(loot_item, "position:x", land_position.x, FLIGHT_TIME)
	
	#Vertical Movement Configuration
	tween = create_tween()
	# sets the interpolation function for the entire tween
	tween.set_trans(Tween.TRANS_QUAD)
	#controls how the animation speeds up and slows down - EASE_OUT starts fast and slows down
	tween.set_ease(Tween.EASE_OUT)
	#randomize the jump_height
	var jump_height := randf_range (30.0, 80.0)
	#Tween the y position of the item to move it up to the peak position over half of the flight time
	tween.tween_property(loot_item, "position:y", land_position.y - jump_height, HALF_FLIGHT_TIME)
	#controls how the animation speeds up and slows down - EASE_IN starts slow and speeds up
	tween.set_ease(Tween.EASE_IN)
	#Tween the y position of the item to move it back down to the land position over the other half of the flight time
	tween.tween_property(loot_item, "position:y", land_position.y, HALF_FLIGHT_TIME)





