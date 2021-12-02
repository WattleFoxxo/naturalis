extends Node

var world_width = 512#128#256
var world_height = 512#128#256
var world_seed = 0

var item_lookup = {
	0:{"name":"sing", "id":0, "tile_id":17}
}

var playerpos = Vector2(0, 0)
var item_held = {"name":"null", "id":0, "tile_id":0}

var debug = ""

func _process(delta):
	debug = "Salvos pre-alpha v0.0.0"+"\nPosition (x, y): "+str(playerpos)+"\nFPS: "+str(Engine.get_frames_per_second())+"\nItem Held: "+str(item_held)
