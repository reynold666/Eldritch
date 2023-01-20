extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var timeTilActivation = 2 #in seconds
export var spikeHoldTime = 2 #in seconds
export var spikesActive = false
export var damage = 5
onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var animSprite: AnimatedSprite = $AnimatedSprite
onready var area2d: Area2D = $TriggerArea
onready var activationTimer: Timer = $SpikeActivationTimer
onready var holdTimer: Timer = $SpikeHoldTimer
func _physics_process(delta):
	
	if spikesActive:
		for body in area2d.get_overlapping_bodies():
			if body.name.match("Player"):
				var player := body as Player
				player.reactToHit(damage)

func toggleSpikeHitbox():
	spikesActive = !spikesActive
	if animSprite.frame == 0:
		animSprite.frame = 1
	else:
		animSprite.frame = 0


func _on_Area2D_body_entered(body):
	if !animationPlayer.is_playing() and !spikesActive:
		animationPlayer.play("spike_activation")
		activationTimer.start(timeTilActivation)


func _on_Timer_timeout():
	#print("Timer done!")
	animationPlayer.stop()
	toggleSpikeHitbox()
	holdTimer.start()

func _on_SpikeHoldTimer_timeout():
	toggleSpikeHitbox()
