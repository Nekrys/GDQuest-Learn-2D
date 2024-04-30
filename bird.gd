extends Node2D

@onready var sparrow: Sprite2D = $Sparrow
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	temporizador()
	get_node("Timer").timeout.connect(bird_jump)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func bird_jump() -> void:
	
	var random_angle := randf_range(0.0, 2.0 * PI)
	var random_direction := Vector2(1.0, 0.0).rotated(random_angle)
	#randomizes a maximum and minimum distance
	#the position of the loot.item will be based on the randomized direction and distance
	var random_distance := randf_range(30.0, 60.0)
	#REMOVED - loot_item.position = random_direction * random_distance
	#create a variable to hold the landing position. the variable will be used to animate with the tween functions
	var land_position := random_direction * random_distance
	#sets the constants for how much time the loot item will be flying and how much time till he reaches the maximun hight
	const FLIGHT_TIME := 0.2
	const HALF_FLIGHT_TIME := FLIGHT_TIME / 2.0
	
	#Animation code 1- change item scale 2- make horizontal movement 3 - make vertical movement (up/down)
	#tween creation
	var tween := create_tween()
	tween.set_parallel()
	
	#horizontal Movement configuration
	tween.tween_property(sparrow, "position:x", land_position.x, FLIGHT_TIME)
	
	#Vertical Movement Configuration
	tween = create_tween()
	# sets the interpolation function for the entire tween
	tween.set_trans(Tween.TRANS_QUAD)
	#controls how the animation speeds up and slows down - EASE_OUT starts fast and slows down
	tween.set_ease(Tween.EASE_OUT)
	
	var jump_height := randf_range (10.0, 30.0)
	#Tween the y position of the item to move it up to the peak position over half of the flight time
	tween.tween_property(sparrow, "position:y", land_position.y - jump_height, HALF_FLIGHT_TIME)
	#controls how the animation speeds up and slows down - EASE_IN starts slow and speeds up
	tween.set_ease(Tween.EASE_IN)
	#Tween the y position of the item to move it back down to the land position over the other half of the flight time
	tween.tween_property(sparrow, "position:y", land_position.y, HALF_FLIGHT_TIME)
	
	temporizador()
	
func temporizador() -> void:
	timer.set_wait_time(randf_range(1.0, 3.0))
	#get_node("Timer").timeout.connect(bird_jump)
