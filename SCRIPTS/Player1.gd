extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const FRICTION = 0.1
const MOVEMENT_ACCELERATION = 100

export var MaximumSanity=100
export var MaximumSpiritualEnergy=100
export var PhaseShiftDuration=2
export var PhaseShiftCooldown=6
export var PowerWalkDuration=3.5
export var PowerWalkCooldown=4
export var TeleportCooldown=6
export var TeleportDistance=10
export var NormalSpeed=500
export var PowerWalkSpeed=1200

var currentSpeed = NormalSpeed
var motion = Vector2()
var Sanity=MaximumSanity
var SpiritualEnergy=MaximumSpiritualEnergy

export var InteractingWithPanel=false
onready var playerUi = $PlayerUI
var teleportActive = true
var phaseShiftActive = true
var powerWalkActive = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$TimerPhaseShift.wait_time=PhaseShiftDuration
	$CooldownPhaseShift.wait_time=PhaseShiftCooldown
	
	$TimerPowerWalk.wait_time=PowerWalkDuration
	$CooldownPowerWalk.wait_time=PowerWalkCooldown
	
	$TimerTeleport.wait_time=TeleportCooldown

	#call these to make sure the UI is up to date
	setSanity(MaximumSanity)
	setSpiritual(MaximumSpiritualEnergy) 
	setTeleportUsable(true)
	setPhaseShiftUsbable(true)
	setPowerWalkUsable(true)
	
	pass # Replace with function body.

func _physics_process(delta):
	updateReloadUI()
	#updateCoolDowns()
	if not InteractingWithPanel:
		spectralVision()
		if Input.is_action_just_released("PhaseShift") and phaseShiftActive:
			PhaseShift()
		if Input.is_action_just_released("PowerWalk") and powerWalkActive:
			PowerWalk()
		update_movement()
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and teleportActive:
			teleport()
		move_and_slide(motion)
	
func update_movement():
	if Input.is_action_pressed("Down") and not Input.is_action_pressed("Top"):
		motion.y = clamp(motion.y + MOVEMENT_ACCELERATION, 0, currentSpeed)
	elif Input.is_action_pressed("Top") and not Input.is_action_pressed("Down"):
		motion.y = clamp(motion.y - MOVEMENT_ACCELERATION, -currentSpeed, 0)
	else:
		motion.y = lerp(motion.y,0,FRICTION)
		
	if Input.is_action_pressed("Right") and not Input.is_action_pressed("Left"):
		motion.x = clamp(motion.x + MOVEMENT_ACCELERATION, 0, currentSpeed)
	elif Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		motion.x = clamp(motion.x - MOVEMENT_ACCELERATION, -currentSpeed, 0)
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
	changeSanity(-damage)

	
func teleport():
		var mousePosition = get_global_mouse_position()
#		print(mousePosition)
		$".".global_position=mousePosition
		setTeleportUsable(false)
		playerUi.set_teleport_active(false)
		$TimerTeleport.start()
		
func PhaseShift():
	z_index=1
	$PlayerSprite.modulate=Color(1,1,1,0.25)
	setPhaseShiftUsbable(false)
	set_collision_mask_bit(1, false)
	playerUi.set_phase_shift_active(false)
	$TimerPhaseShift.start()

func PowerWalk():
	currentSpeed = PowerWalkSpeed
#	ghostWalkSpeed(SPEED_BOOSTER)
	setPowerWalkUsable(false)
	playerUi.set_speed_active(false)
	$TimerPowerWalk.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Timer_timeout():
	setTeleportUsable(true)

func _on_TimerPhaseShift_timeout():
	z_index=0
	$PlayerSprite.modulate=Color(1,1,1,1)
#	phaseShiftActive= !phaseShiftActive
	$CooldownPhaseShift.start()
	set_collision_mask_bit(1, true)

func _on_TimerPowerWalk_timeout():
	currentSpeed = NormalSpeed
	$CooldownPowerWalk.start()
#	powerWalkActive= !powerWalkActive


func _on_CooldownPhaseShift_timeout():
	setPhaseShiftUsbable(true)


func _on_CooldownPowerWalk_timeout():
	setPowerWalkUsable(true)
	
func updateReloadUI():
	if $CooldownPhaseShift.time_left>0:
		playerUi.set_phase_shift_reload(1-$CooldownPhaseShift.time_left/PhaseShiftCooldown)
	
	if $CooldownPowerWalk.time_left>0:
		playerUi.set_speed_reload(1-$CooldownPowerWalk.time_left/PowerWalkCooldown)
	
	if $TimerTeleport.time_left>0:
		playerUi.set_teleport_reload(1-$TimerTeleport.time_left/TeleportCooldown)


#func updateCoolDowns():
	#if $TimerPhaseShift.is_stopped():
	#	PhaseShiftDuration=$TimerPhaseShift.wait_time
	#else:
	#	PhaseShiftDuration=$TimerPhaseShift.time_left
	
	#if $TimerPowerWalk.is_stopped():
	#	PowerWalkDuration=$TimerPowerWalk.wait_time
	#else:
	#	PowerWalkDuration=$TimerPowerWalk.time_left
		
	#if $CooldownPhaseShift.is_stopped():
	#	PhaseShiftCooldown=$CooldownPhaseShift.wait_time
	#else:
	#	PhaseShiftCooldown=$CooldownPhaseShift.time_left
	
	#if $CooldownPowerWalk.is_stopped():
	#	PowerWalkCooldown=$CooldownPowerWalk.wait_time
	#else:
	#	PowerWalkCooldown=$CooldownPowerWalk.time_left

func setTeleportUsable(teleportUsable):
	teleportActive = teleportUsable
	playerUi.set_teleport_active(teleportActive)

func setPhaseShiftUsbable(phaseShiftUsable):
	phaseShiftActive = phaseShiftUsable
	playerUi.set_phase_shift_active(phaseShiftActive)
	
func setPowerWalkUsable(powerWalkUsable):
	powerWalkActive = powerWalkUsable
	playerUi.set_speed_active(powerWalkActive)


func interactingWithPanel():
	InteractingWithPanel= !InteractingWithPanel
	
# common interface for changing sanity. e.g. to deal 50 damage, call changeSanity(-50). Also updates the UI
func changeSanity(sanityChange):
	setSanity(Sanity+sanityChange)
	
# common interface for setting the sanity directly. will be clamped between 0 and the maximum. Updates the UI accordingly.
# also calls onZeroSanity() if the sanity goes to zero
func setSanity(newSanity):
	if(newSanity <= 0):
		onZeroSanity()
	Sanity = clamp(newSanity, 0, MaximumSanity)
	playerUi.set_sanity_relative(float(Sanity)/MaximumSanity)
	
func changeSpiritual(spiritualChange):
	setSanity(SpiritualEnergy+spiritualChange)
	
func setSpiritual(newSpiritual):
	SpiritualEnergy = clamp(newSpiritual, 0, MaximumSpiritualEnergy)
	playerUi.set_spiritual_relative(float(SpiritualEnergy)/MaximumSpiritualEnergy)

func onZeroSanity():
	# TODO: what happens here? game over screen?
	pass
	
	
