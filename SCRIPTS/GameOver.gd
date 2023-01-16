extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_TextureButton_pressed():
	$BGM.stream_paused = !$BGM.stream_paused



func _on_NEWGAME_mouse_entered():
	$"STARTMENU/NEW GAME".visible=true


func _on_NEWGAME_mouse_exited():
	$"STARTMENU/NEW GAME".visible=false


func _on_QUIT_mouse_entered():
	$STARTMENU/QUIT2.visible=true


func _on_QUIT_mouse_exited():
	$STARTMENU/QUIT2.visible=false


func _on_NEWGAME_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene("res://Levels/level1topdown.tscn")


func _on_QUIT_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			get_tree().quit()
