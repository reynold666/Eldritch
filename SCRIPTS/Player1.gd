extends KinematicBody2D

class_name Player
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const FRICTION = 0.1
const MOVEMENT_ACCELERATION = 100

export var MaximumSanity=100
export var MaximumSpiritualEnergy=100
export var SpiritRefillPerSecond=5
export var SpectralVisionSpiritCostPerSecond=12
export var NormalSpeed=500
export var PowerWalkSpeed=1200
export var PowerWalkDuration=3.5
export var PowerWalkCooldown=4
export var PowerWalkSpiritCost=20
export var PhaseShiftDuration=2
export var PhaseShiftCooldown=6
export var PhaseShiftSpiritCost=35
export var TeleportCooldown=6
export var TeleportDistance=1000
export var TeleportSpiritCost=25
export var InvulnTime = 3

var SpectralVisionMinSpiritThresh = SpectralVisionSpiritCostPerSecond
var SpectralVisionAutoShutdownThresh = SpectralVisionSpiritCostPerSecond*0.5

var currentSpeed = NormalSpeed
var motion = Vector2()
var Sanity=MaximumSanity
var SpiritualEnergy : float=MaximumSpiritualEnergy

export var InteractingWithPanel=false
onready var playerUi = $PlayerUI
var teleportUsable = true
var phaseShiftUsable = true
var powerWalkUsable = true
var spectralVisionActive = false
var isInvuln = false
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
	changeSpiritual(delta*SpiritRefillPerSecond)
	if spectralVisionActive:
		changeSpiritual(-delta*SpectralVisionSpiritCostPerSecond)
		if(SpiritualEnergy < SpectralVisionAutoShutdownThresh):
			setSpectralVisionActive(false)

	#updateCoolDowns()
	if not InteractingWithPanel:
		if Input.is_action_just_released("Vision") and (spectralVisionActive or SpiritualEnergy >= SpectralVisionMinSpiritThresh):
			toggleSpectralVision()
		if Input.is_action_just_released("PhaseShift") and phaseShiftUsable and SpiritualEnergy >= PhaseShiftSpiritCost:
			PhaseShift()
		if Input.is_action_just_released("PowerWalk") and powerWalkUsable and SpiritualEnergy >= PowerWalkSpiritCost:
			PowerWalk()
		update_movement()
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and teleportUsable and SpiritualEnergy >= TeleportSpiritCost:
			teleport()
		move_and_slide(motion)
	checkSpectralVision()
	
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

func toggleSpectralVision():
	setSpectralVisionActive(!spectralVisionActive)

#	$Spectralvision2.look_at(get_global_mouse_position())

func setSpectralVisionActive(spectralVisionActiveNew):
	spectralVisionActive = spectralVisionActiveNew
	$Spectralvision.visible=spectralVisionActive
	setSpectralVisionUsable(!spectralVisionActive)
	
func checkSpectralVision():
	if !spectralVisionActive:
		return
	$Spectralvision.look_at(get_global_mouse_position())
	$RayCast2D.enabled=true
	$RayCast2D.look_at(get_global_mouse_position())
#	print("Inside Raycast Logic")
	if $RayCast2D.is_colliding():
#		print("Inside Raycast Logic")
		var temp=$RayCast2D.get_collider()
		if temp.name=="BonePile":
			get_tree().call_group("BonePile","updateDetected")
		if temp.name=="SignPost":
			get_tree().call_group("SignPost","makeVisible")
		
func updateSanity(damage):
	changeSanity(-damage)
	
func reactToHit(damage):
	if !isInvuln:
		updateSanity(damage)
		$InvulnTimer.start(InvulnTime)
		$AnimationPlayer.play("Invulnerability")
		isInvuln = true
	
	
func teleport():
		changeSpiritual(-TeleportSpiritCost)
		var mousePosition = get_global_mouse_position()
#		print(mousePosition)
		var target_vector = (mousePosition-global_position).normalized() * TeleportDistance
		global_position = global_position + target_vector
		setTeleportUsable(false)
		playerUi.set_teleport_active(false)
		$TimerTeleport.start()
		
func PhaseShift():
	changeSpiritual(-PhaseShiftSpiritCost)
	z_index=1
	$PlayerSprite.modulate=Color(1,1,1,0.25)
	setPhaseShiftUsbable(false)
	set_collision_mask_bit(1, false)
	playerUi.set_phase_shift_active(false)
	$TimerPhaseShift.start()

func PowerWalk():
	changeSpiritual(-PowerWalkSpiritCost)
	currentSpeed = PowerWalkSpeed
#	ghostWalkSpeed(SPEED_BOOSTER)
	setPowerWalkUsable(false)
	playerUi.set_power_walk_active(false)
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
		playerUi.set_power_walk_reload(1-$CooldownPowerWalk.time_left/PowerWalkCooldown)
	
	if $TimerTeleport.time_left>0:
		playerUi.set_teleport_reload(1-$TimerTeleport.time_left/TeleportCooldown)

	playerUi.set_power_walk_spirit_tint(SpiritualEnergy >= PowerWalkSpiritCost)
	playerUi.set_phase_shift_spirit_tint(SpiritualEnergy >= PhaseShiftSpiritCost)
	playerUi.set_teleport_spirit_tint(SpiritualEnergy >= TeleportSpiritCost)
	playerUi.set_spectral_vision_spirit_tint(SpiritualEnergy >= SpectralVisionMinSpiritThresh)

func setTeleportUsable(teleportUsableNew):
	teleportUsable = teleportUsableNew
	playerUi.set_teleport_active(teleportUsable)

func setPhaseShiftUsbable(phaseShiftUsableNew):
	phaseShiftUsable = phaseShiftUsableNew
	playerUi.set_phase_shift_active(phaseShiftUsable)
	
func setPowerWalkUsable(powerWalkUsableNew):
	powerWalkUsable = powerWalkUsableNew
	playerUi.set_power_walk_active(powerWalkUsable)

func setSpectralVisionUsable(spectralVisionUsable):
	playerUi.set_spectral_vision_active(spectralVisionUsable)

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
	setSpiritual(SpiritualEnergy+spiritualChange)
	
func setSpiritual(newSpiritual):
	SpiritualEnergy = clamp(newSpiritual, 0, MaximumSpiritualEnergy)
	playerUi.set_spiritual_relative(float(SpiritualEnergy)/MaximumSpiritualEnergy)

func onZeroSanity():
	get_tree().change_scene("res://Menus/GameOver.tscn")
	pass
	
	


func _on_InvulnTimer_timeout():
	$AnimationPlayer.stop()
	isInvuln = false
