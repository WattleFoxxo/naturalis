extends Control

var debug = false

func _input(ev):
	if Input.is_action_pressed("DEBUG"):
		debug = !debug
		
func _process(delta):
	if debug:
		$debug.text = Globals.debug
	else:
		$debug.text = Globals.game_id+" (press [f1] to open debug)"
