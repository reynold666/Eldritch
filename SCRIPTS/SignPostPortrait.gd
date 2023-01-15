extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enabled=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	if Input.is_action_just_released("Vision") and enabled:
		UseFlashlightAndChangeTexture()
		Dialogic.set_variable("TextVisible",1)

func enableCounter():
	enabled=true

func UseFlashlightAndChangeTexture():
		$Light2D.visible=!$Light2D.visible
		$CPUParticles2D.visible=true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
