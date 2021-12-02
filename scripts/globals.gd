extends Node

var world_width = 512#128#256
var world_height = 512#128#256
var world_seed = 0

var item_lookup = {
	0:{"name":"sign", "id":0, "tile_id":17, "layer": 2, "tile": true, "allowed_tiles":[-1, 1, 28, 29, 30, 31, 32], "clear_layer":[]},
	1:{"name":"fence", "id":1, "tile_id":3, "layer": 2, "tile": true, "allowed_tiles":[-1, 1, 28, 29, 30, 31, 32], "clear_layer":[]},
	2:{"name":"chest", "id":2, "tile_id":18, "layer": 2, "tile": true, "allowed_tiles":[-1, 1, 28, 29, 30, 31, 32], "clear_layer":[]},
	3:{"name":"shovel", "id":3, "tile_id":0, "layer": 1, "tile": true, "allowed_tiles":[-1, 1, 29, 30, 31, 32], "clear_layer":[]},
	4:{"name":"grass_seeds", "id":4, "tile_id":1, "layer": 0, "tile": true, "allowed_tiles":[-1, 1, 0, 28], "clear_layer":[1]}
}

var playerpos = Vector2(0, 0)
var item_held = {}

var debug = ""

func _process(delta):
	debug = "Salvos pre-alpha v0.0.0"+"\nPosition (x, y): "+str(playerpos)+"\nFPS: "+str(Engine.get_frames_per_second())+"\nItem Held ([1] and [2] to change): "+str(item_held)
