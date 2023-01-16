extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var damage = 10
onready var player =get_node("/root").find_node("Player",true,false)
var speed = 300
var wakeUp=false

# Called when the node enters the scene tree for the first time.


func _physics_process(delta):
	move(delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func move(delta):
	if wakeUp == false:
		$Area2D/AnimatedSprite.animation="WakeUp"
		wakeUp=true
	if player:
		global_position = global_position.move_toward(player.global_position,delta*speed)
		$Area2D/AnimatedSprite.animation="Movement"

func _on_Area2D_body_entered(body):
	if body.name == "Player":
#		get_tree().call_group("Player","updateHealth",damage)
		queue_free()
	
