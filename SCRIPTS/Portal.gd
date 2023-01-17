extends Node2D



export var OtherPortalPath: NodePath
export var TELEPORT_DISTANCE = 200
export var TELEPORT_DIRECTION = Vector2.RIGHT
onready var OtherPortal = get_node(OtherPortalPath)
var teleportTween: SceneTreeTween
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func teleportPlayer(player):
	teleportTween = create_tween()
	player.position = position
	teleportTween.tween_property(player, "position", position + TELEPORT_DIRECTION * TELEPORT_DISTANCE, 1)
	#yield(tween, "finished")

func _on_Area2D_body_entered(body):
	#print(body.name)
	if teleportTween and teleportTween.is_running():
		return
	if OtherPortal and body.name.match('Player'):
		#print("going to: " + OtherPortal.name)
		OtherPortal.teleportPlayer(body)
#	get_tree().call_group("GameState","win_game")
