extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var ScenePath: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	
	if ScenePath:
		print("going to: " + ScenePath.resource_path)
		SceneManager.goto_scene(ScenePath.resource_path)
#	get_tree().call_group("GameState","win_game")
