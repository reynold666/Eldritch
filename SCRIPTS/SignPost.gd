extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var counter=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	ActivateSignPost()
	

func makeVisible():
	$".".visible = true

func ActivateSignPost():
	var distanceToPlayer= global_position.distance_to($"../Player".global_position)
	
	if distanceToPlayer < 400:
		if Input.is_physical_key_pressed(82):
			$"../Player".InteractingWithPanel=true
			start_dialog()
		if Input.is_physical_key_pressed(16777217):
			$"../Player".InteractingWithPanel=false
		


func start_dialog():
	if counter==0:
		var dialog = Dialogic.start("SignPost")
		dialog.connect("dialogic_signal", self, "dialog_listener")
		add_child(dialog)
		dialog.connect("timeline_end",self,"dialog_end")
		counter=1

func dialog_listener(string):
	match string:
		"WaitForFlashLight":
			get_tree().call_group("SignPostPortrait","enableCounter")
			
func dialog_end(timeline_name):
	$"../Player".InteractingWithPanel=false
	counter=0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
