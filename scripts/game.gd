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

"""

ITEMS:
sticks
rocks
logs
seeds

FOOD:
berries
meat

WEAPONS:
pickaxe (made of iron)
nife (made of iron)
spear (stone head)
club (wooden with teeth as spikes)

"""

var item_lookup = {
	"null":{
		"name":"", 
		"is_tile": false,
		"loot_table":{
			
		}
	},
	
	"fire_pit":{
		"name":"fire pit",
		"is_tile": true, 
		"tile_id":FIRE_PIT_LIT,
		"layer": 2, 
		"allowed_tiles":[VOID, GRASS, LONG_GRASS], 
		"clear_layer":[],
		"loot_table":{
			"fire_pit":1
		}
	},
	
	"fence":{
		"name":"fence", 
		"is_tile": true, 
		"tile_id":FENCE, 
		"layer": 2, 
		"allowed_tiles":[VOID, GRASS, LONG_GRASS], 
		"clear_layer":[],
		"loot_table":{
			"fence":1
		}
	},
	
	"sign":{
		"name":"sign", 
		"is_tile": true, 
		"tile_id":SIGN, 
		"layer": 2, 
		"allowed_tiles":[VOID, GRASS, LONG_GRASS], 
		"clear_layer":[],
		"loot_table":{
			"sign":1
		}
	},
	
	"pine_tree":{
		"name":"pine tree", 
		"is_tile": true, 
		"tile_id":PINE, 
		"layer": 2, 
		"allowed_tiles":[VOID, GRASS, LONG_GRASS], 
		"clear_layer":[],
		"loot_table":{
			"log":2,
			"stick":3,
			"saplings":1
		}
	},
	
	"tree":{
		"name":"tree", 
		"is_tile": true, 
		"tile_id":TREE, 
		"layer": 2, 
		"allowed_tiles":[VOID, GRASS, LONG_GRASS], 
		"clear_layer":[],
		"loot_table":{
			"log":2,
			"stick":3,
			"saplings":1
		}
	},
	
	"stick":{
		"name":"stick", 
		"is_tile": false
	},
	
	"rock":{
		"name":"rock", 
		"is_tile": false
	},
	
	"log":{
		"name":"log", 
		"is_tile": false
	},
	
	"saplings":{
		"name":"saplings", 
		"is_tile": false
	}
}

var tile_to_id = {
	FIRE_PIT_LIT:"fire_pit",
	FENCE:"fence",
	SIGN:"sign",
	PINE:"pine_tree",
	TREE:"tree"
}

var playerpos = Vector2(0, 0)
var item_held = 0

var inventory = {
	0:{"id":"fire_pit", "count":128},
	1:{"id":"fence", "count":128},
	2:{"id":"sign", "count":128},
	3:{"id":"null", "count":0},
	4:{"id":"null", "count":0},
	5:{"id":"null", "count":0},
	6:{"id":"null", "count":0},
	7:{"id":"null", "count":0},
	8:{"id":"null", "count":0},
}

var player_state = "WATER"

var debug = ""

func _process(delta):
	debug = game_id+"\nPosition (x, y): "+str(playerpos)+"\nFPS: "+str(Engine.get_frames_per_second())

func getItem(id):
	return item_lookup[id]

func convertItemToId(tile):
	return tile_to_id[tile]

func itemHeld():
	return getItem(inventory[item_held].id)

func itemHeldInventory():
	return inventory[item_held]
