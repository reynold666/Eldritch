extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const min_distance_from_player= 4000

var player
var duece = preload("res://Enemy/Duece.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root").find_node("Player",true,false)
	
func _physics_process(delta):
		if player.global_position.x < global_position.x:
			$Sprite.flip_h=true

func Player_in_LOS():
	var space  = get_world_2d().direct_space_state
	var LOS_obstacle = space.intersect_ray(global_position,player.global_position,[self],collision_mask)
#	print(LOS_obstacle)
	if not LOS_obstacle:
		return false
	
	var distance_to_player = player.global_position.distance_to(global_position)
#	print(distance_to_player)
	var player_in_range = distance_to_player < min_distance_from_player
#	print(player_in_range)
	
	if LOS_obstacle.collider == player and player_in_range:
		return true
	else:
		return false	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
#		print(Player_in_LOS())
		if Player_in_LOS():
#		print("Inside Pig player detection logic")
		
			var enemy = duece.instance()
			enemy.position=global_position
			enemy.scale= Vector2(0.3,0.3)
#			print(get_parent())
			get_parent().add_child(enemy)
