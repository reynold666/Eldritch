extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var BoxTextureRest=preload("res://GFX/Treasure Chest closed 254x254.png")
onready var BoxTextureOpen=preload("res://GFX/Treasure Chest open 254x254.png")
export var Mimic=false
export var EnableTreasureBox=false
var temp
var TreasureBoxActive=false
var TreasureBoxSelected=false
onready var TreasureBoxPlatformPostion = global_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if TreasureBoxSelected:
		openChest()
	MagicCircleAnimation()
#	if Input.is_physical_key_pressed(65):
#		PlatforMove(65)
#	if Input.is_physical_key_pressed(68):
#		PlatforMove(68)
		
func changeShadowTexture():
	if Mimic:
		$TreasureBoxShadow.texture=BoxTextureOpen
	else:
		$TreasureBoxShadow.texture=BoxTextureRest
		
func openChest():
	if Input.is_physical_key_pressed(82):
		print("Pressed")
		$TreasureBox.texture=BoxTextureOpen

func MagicCircleAnimation():
	$AnimationPlayer.play("MagicCircleAnimation1")
#	$MagicCircle.rotation+=0.1
	
func ActivateTreasureBox():
	$CollisionShape2D.visible= !$CollisionShape2D.visible
	
func ActivateTreasureBoxShadow():
	$TreasureBoxShadow.visible= !$TreasureBoxShadow.visible

func PlatforMove(a):
	var moveLimitLeft= TreasureBoxPlatformPostion.x-900
	var moveLimitRight= TreasureBoxPlatformPostion.x+900
	if a==65:
		temp=global_position
		var step=300
		temp.x=temp.x-step
#		temp.y=temp.y+step
		if temp.x == moveLimitLeft:
			var tween = get_node("Tween")
			tween.interpolate_property($".", "position",
				global_position, temp, 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		if temp.x ==0:
			var tween = get_node("Tween")
			tween.interpolate_property($".", "position",
				global_position, temp, 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
	if a==68:
		temp=global_position
		var step=300
		temp.x=temp.x+step
#		temp.y=temp.y+step
		if temp.x == moveLimitRight:
			var tween = get_node("Tween")
			tween.interpolate_property($".", "position",
				global_position, temp, 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
		if temp.x ==0:
			var tween = get_node("Tween")
			tween.interpolate_property($".", "position",
				global_position, temp, 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()
#	temp=$MagicCircle.modulate
#	var step=0.01
#	print(temp)
#
#	if temp.r < 0.94:
##		temp=Color(1,1,1,1)
#		temp.r=1
#
#	else:
##		temp=Color(temp.r-step,temp.g-step,temp.b-step)
#		temp.r=temp.r-step
#		print(temp)
#	$MagicCircle.modulate=temp
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
