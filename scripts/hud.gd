extends Control

var debug = false

func _input(ev):
	if Input.is_action_pressed("DEBUG"):
		debug = !debug
		
func _process(delta):
	if debug:
		$debug.text = Game.debug
	else:
		$debug.text = Game.game_id+" (press [f1] to open debug)"
