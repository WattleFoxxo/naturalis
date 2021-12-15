extends Node

var game_id = "naturalis pre-alpha v0.0.1"

var world_width = 512#128#256
var world_height = 512#128#256

var world_seed = 621

var VOID = -1
var WATER = 37
var GRASS = 38
var BUSH_0 = 51
var BUSH_1 = 52
var PINE = 54
var TREE = 55
var LONG_GRASS = 59
var FIRE_PIT = 50
var FIRE_PIT_LIT = 36
var FENCE = 58
var SIGN = 53



var item_lookup = {
	-1:{"name":"", "id":-1, "tile_id":null, "layer": null, "tile": false, "allowed_tiles":null, "clear_layer":null},
	0:{"name":"fire", "id":0, "tile_id":FIRE_PIT_LIT, "layer": 2, "tile": true, "allowed_tiles":[VOID, GRASS, LONG_GRASS], "clear_layer":[]},
	1:{"name":"fence", "id":1, "tile_id":FENCE, "layer": 2, "tile": true, "allowed_tiles":[VOID, GRASS, LONG_GRASS], "clear_layer":[]},
	2:{"name":"sign", "id":2, "tile_id":SIGN, "layer": 2, "tile": true, "allowed_tiles":[VOID, GRASS, LONG_GRASS], "clear_layer":[]}
}

var tile_to_id = {
	FIRE_PIT_LIT:0,
	FENCE:1,
	SIGN:2
}

var playerpos = Vector2(0, 0)
var item_held = 0
var inventory_slot_used = 0

var invetory = {
	0:{"id":0, "count":1},
	1:{"id":1, "count":16},
	2:{"id":2, "count":2},
	3:{"id":-1, "count":0},
	4:{"id":-1, "count":0}
}

var player_state = "WATER"

var debug = ""

func _process(delta):
	debug = game_id+"\nPosition (x, y): "+str(playerpos)+"\nFPS: "+str(Engine.get_frames_per_second())
