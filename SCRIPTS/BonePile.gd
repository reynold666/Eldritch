extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MAX_DETECTION_RANGE = 500
const damage=5
var Player
var detected=false

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = get_node("/root").find_node("Player",true,false)
	
#func _physics_process(delta):
#	if not detected:
##		print("Inside Detection Loop")
#		detectPlayerAndDamage()


func detectPlayerAndDamage():
	var distance_to_player = Player.global_position.distance_to(global_position)
	var Player_in_range = distance_to_player < MAX_DETECTION_RANGE
	if Player_in_range:
		get_tree().call_group("Player","updateSanity",damage)

func updateDetected():
	detected=true
	modulate= Color(1,1,1,1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if not detected:
#		print("Inside Detection Loop")
		detectPlayerAndDamage()
