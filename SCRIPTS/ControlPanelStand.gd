extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var ControlPanelActive=false
onready var LeverTextureUp= preload("res://GFX/LeverTop.png")
onready var LeverTextureBottom= preload("res://GFX/LeverBottom.png")
onready var LeverTextureRest= preload("res://GFX/LeverRest.png")
onready var ButtonNormal= preload("res://GFX/UnpressedButton.png")
onready var ButtonPressed= preload("res://GFX/PressedButton.png")
export var LightActive=false

var state=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	ActivateControlPanelStand()
	if $"../PanelBox".visible:
		updatePanelBox()
		ActivateLightAndDetectMimic()
#func enablePanelBox():
#	$"../PanelBox".visible=!$"../PanelBox".visible
	
func ActivateControlPanelStand():
#	print($"../Player".global_position)
#	print(global_position)
	var distanceToPlayer= global_position.distance_to($"../Player".global_position)
#	print(distanceToPlayer)
	if distanceToPlayer < 400:
		if Input.is_physical_key_pressed(82):
			$Label.visible=false
			$Label2.visible=true
			ControlPanelActive=true
			$"../Player".global_position=$Position2D.global_position
			$"../Player".InteractingWithPanel=true
			$"../PanelBox".visible=true
			get_tree().call_group("TreasureBox","ActivateTreasureBox")
		if Input.is_physical_key_pressed(16777217):
			$"../Player".InteractingWithPanel=false
			$Label2.visible=false
			$"../PanelBox".visible=false
			get_tree().call_group("TreasureBox","ActivateTreasureBox")
	else:
		$Label.visible=true
		$Label2.visible=false
		
func ActivateLightAndDetectMimic():
	if Input.is_action_just_released("Vision"):
		$Light2D.visible=!$Light2D.visible
		LightActive= !LightActive
		$RayCast2D.enabled=true
#		print(LightActive)
	if LightActive:
		print($RayCast2D.is_colliding())
		if $RayCast2D.is_colliding():
			var temp=$RayCast2D.get_collider()
#			print(temp)
			if temp.has_method("InFrontOfControlPanelStand"):
				temp.call("InFrontOfControlPanelStand")
	
func updatePanelBox():
	if Input.is_action_just_released("Top") and state == 0 :
		state=1
		yield(get_tree().create_timer(0.2), "timeout")
		$"../PanelBox/Lever".texture=LeverTextureUp
		print("From 0 to 1-Key W")
	if Input.is_action_just_released("Down") and state == 0:
		state=-1
		yield(get_tree().create_timer(0.2), "timeout")
		$"../PanelBox/Lever".texture=LeverTextureBottom
		print("From 0 to -1-Key S")
	if Input.is_action_just_released("Down") and state == 1:
		state=0
		yield(get_tree().create_timer(0.2), "timeout")
		$"../PanelBox/Lever".texture=LeverTextureRest
		print("From 1 to 0-Key S")
	if Input.is_action_just_released("Top") and state == -1:
		state=0
		yield(get_tree().create_timer(0.2), "timeout")
		$"../PanelBox/Lever".texture=LeverTextureRest
		print("From -1 to 0-Key W")
		
	if Input.is_action_just_pressed("Left"):
		$"../PanelBox/ButtonLeft".texture=ButtonPressed
		get_tree().call_group("TreasureBox","PlatforMove",65)
		yield(get_tree().create_timer(0.2), "timeout")
		$"../PanelBox/ButtonLeft".texture=ButtonNormal
	if Input.is_action_just_pressed("Right"):
		$"../PanelBox/ButtonRight".texture=ButtonPressed
		get_tree().call_group("TreasureBox","PlatforMove",68)
		yield(get_tree().create_timer(0.2), "timeout")
		$"../PanelBox/ButtonRight".texture=ButtonNormal
		

		
		
#	if Input.is_physical_key_pressed(87):
#		if state == 0:
#			state=1
#			yield(get_tree().create_timer(0.5), "timeout")
#			$"../PanelBox/Lever".texture=LeverTextureUp
#			print("From 0 to 1-Key W")
#		if state == -1:
#			state=0
#			yield(get_tree().create_timer(0.5), "timeout")
#			$"../PanelBox/Lever".texture=LeverTextureRest
#			print("From -1 to 0-Key W")
#	if Input.is_physical_key_pressed(83):
#		if state == 1:
#			state=0
#			yield(get_tree().create_timer(0.5), "timeout")
#			$"../PanelBox/Lever".texture=LeverTextureRest
#			print("From 1 to 0-Key S")
#		if state == 0:
#			state=-1
#			yield(get_tree().create_timer(0.5), "timeout")
#			$"../PanelBox/Lever".texture=LeverTextureBottom
#			print("From 0 to -1-Key S")
			
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
