extends Control

var debug = false

func _input(ev):
	if Input.is_action_pressed("DEBUG"):
		debug = !debug
		
func _process(delta):
	if debug:
		$debug.text = Globals.debug
	else:
		$debug.text = "Salvos pre-alpha v0.0.0 (press [f1] to open debug)"
