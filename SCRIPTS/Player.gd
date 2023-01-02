extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED=1500
var FLOATSPEED=3000
var GRAVITY=150
var MOTION=Vector2(0,0)
var UP=Vector2(0,-1)
const WORLD_LIMIT = 4000
var teleportActive = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	apply_gravity()
	move()
	jump()
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and teleportActive:	
		teleport()
		
	move_and_slide(MOTION,UP)
	
func apply_gravity():
	if position.y > WORLD_LIMIT:
		pass
#		end_game()
#		get_tree().call_group("GameState","end_game")
	elif is_on_floor() and MOTION.y>0:
		MOTION.y = 0
	elif is_on_ceiling():
		MOTION.y = 1
	else:
		MOTION.y += GRAVITY
	
func move():
	if Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		MOTION.x = -SPEED
	elif Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		MOTION.x = SPEED
	else:
		MOTION.x = 0

func jump():
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		MOTION.y -= FLOATSPEED

func teleport():
		var mousePosition = get_global_mouse_position()
		print(mousePosition)
		$".".global_position=mousePosition
		teleportActive= !teleportActive
		$Timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	teleportActive= !teleportActive
