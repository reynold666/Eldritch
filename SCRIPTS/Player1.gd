extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SPEED = 50
var MAX_SPEED = 500
const FRICTION = 0.1
var SPEED_BOOSTER=1
var TOTAL_SPEED=0
var motion = Vector2()
export var Sanity=100
export var PhaseShiftDuration=0
export var PowerWalkDuration=0
export var PhaseShiftCooldown=0
export var PowerWalkCooldown=0
export var InteractingWithPanel=false
var teleportActive = true
var phaseShiftActive = true
var powerWalkActive = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	updateCoolDowns()
	if not InteractingWithPanel:
		spectralVision()
		if Input.is_action_just_released("PhaseShift") and phaseShiftActive:
			PhaseShift()
		if Input.is_action_just_released("PowerWalk") and powerWalkActive:
			PowerWalk()
#		print(SPEED_BOOSTER)
#		print(MAX_SPEED)
		ghostWalkSpeed(SPEED_BOOSTER)
		update_movement()
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and teleportActive:
			teleport()
		move_and_slide(motion)
	
func update_movement():
	if Input.is_action_pressed("Down") and not Input.is_action_pressed("Top"):
		motion.y = clamp(motion.y + TOTAL_SPEED, 0, MAX_SPEED)
	elif Input.is_action_pressed("Top") and not Input.is_action_pressed("Down"):
		motion.y = clamp(motion.y - TOTAL_SPEED, -MAX_SPEED, 0)
	else:
		motion.y = lerp(motion.y,0,FRICTION)
		
	if Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		motion.x = clamp(motion.x + TOTAL_SPEED,0,MAX_SPEED)
	elif Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		motion.x = clamp(motion.x - TOTAL_SPEED, -MAX_SPEED , 0)
	else:
		motion.x = lerp(motion.x,0,FRICTION)

func spectralVision():
	if Input.is_action_just_released("Vision"):
		$Spectralvision.visible=!$Spectralvision.visible
#		$Spectralvision2.visible=!$Spectralvision2.visible
	detectHidden()
	$Spectralvision.look_at(get_global_mouse_position())
#	$Spectralvision2.look_at(get_global_mouse_position())
	
func detectHidden():
	if $Spectralvision.visible:
		$RayCast2D.enabled=true
		$RayCast2D.look_at(get_global_mouse_position())
#		print("Inside Raycast Logic")
		if $RayCast2D.is_colliding():
#			print("Inside Raycast Logic")
			var temp=$RayCast2D.get_collider()
			if temp.name=="BonePile":
				get_tree().call_group("BonePile","updateDetected")
			if temp.name=="SignPost":
				get_tree().call_group("SignPost","makeVisible")
				
func updateSanity(damage):
	Sanity=Sanity-damage
	if Sanity==80:
		$Light2D.texture_scale=$Light2D.texture_scale-1
	elif Sanity==60:
		$Light2D.texture_scale=$Light2D.texture_scale-1
	elif Sanity==40:
		$Light2D.texture_scale=$Light2D.texture_scale-1
		
func teleport():
		var mousePosition = get_global_mouse_position()
#		print(mousePosition)
		$".".global_position=mousePosition
		teleportActive= !teleportActive
		$TimerTeleport.start()
		
func PhaseShift():
	z_index=1
	$PlayerSprite.modulate=Color(1,1,1,0.25)
	phaseShiftActive= !phaseShiftActive
	get_tree().call_group("Walls","makePermeable")
	$TimerPhaseShift.start()

func ghostWalkSpeed(a):
	TOTAL_SPEED=SPEED*a
	
func PowerWalk():
	SPEED_BOOSTER=5
	MAX_SPEED=MAX_SPEED*SPEED_BOOSTER
#	ghostWalkSpeed(SPEED_BOOSTER)
	powerWalkActive= !powerWalkActive
	$TimerPowerWalk.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	teleportActive= !teleportActive


func _on_TimerPhaseShift_timeout():
	z_index=0
	$PlayerSprite.modulate=Color(1,1,1,1)
#	phaseShiftActive= !phaseShiftActive
	$CooldownPhaseShift.start()
	get_tree().call_group("Walls","makePermeable")


func _on_TimerPowerWalk_timeout():
	SPEED_BOOSTER=1
	MAX_SPEED=500
	$CooldownPowerWalk.start()
#	powerWalkActive= !powerWalkActive


func _on_CooldownPhaseShift_timeout():
	phaseShiftActive= !phaseShiftActive


func _on_CooldownPowerWalk_timeout():
	powerWalkActive= !powerWalkActive
	
func updateCoolDowns():
	if $TimerPhaseShift.is_stopped():
		PhaseShiftDuration=$TimerPhaseShift.wait_time
	else:
		PhaseShiftDuration=$TimerPhaseShift.time_left
	
	if $TimerPowerWalk.is_stopped():
		PowerWalkDuration=$TimerPowerWalk.wait_time
	else:
		PowerWalkDuration=$TimerPowerWalk.time_left
		
	if $CooldownPhaseShift.is_stopped():
		PhaseShiftCooldown=$CooldownPhaseShift.wait_time
	else:
		PhaseShiftCooldown=$CooldownPhaseShift.time_left
	
	if $CooldownPowerWalk.is_stopped():
		PowerWalkCooldown=$CooldownPowerWalk.wait_time
	else:
		PowerWalkCooldown=$CooldownPowerWalk.time_left


func interactingWithPanel():
	InteractingWithPanel= !InteractingWithPanel
	
