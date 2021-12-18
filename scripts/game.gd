extends Node

var game_id = "naturalis pre-alpha v0.0.1"

var world_width = 512#128#256
var world_height = 512#128#256

var world_seed = 69420

const VOID = -1
const WATER = 37
const GRASS = 38
const BUSH = 51
const PINE = 54
const TREE = 55
const LONG_GRASS = 59
const FIRE_PIT = 50
const FIRE_PIT_LIT = 36
const FENCE = 58
const SIGN = 53

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
	
	"bush":{
		"name":"bush", 
		"is_tile": true, 
		"tile_id":BUSH, 
		"layer": 2, 
		"allowed_tiles":[VOID, GRASS, LONG_GRASS], 
		"clear_layer":[],
		"loot_table":{
			"stick":2,
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
	TREE:"tree",
	BUSH:"bush",
}

var crafting_table = {
	"fire_pit":{
		"log":2,
		"stick":3
	},
	"fence":{
		"stick":3
	},
	"sign":{
		"log":1,
		"stick":1
	}
} 

var playerpos = Vector2(0, 0)
var item_held = 0

var inventory = {
	0:{"id":"null", "count":0},
	1:{"id":"null", "count":0},
	2:{"id":"null", "count":0},
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
	debug = game_id+"\nPosition (x, y): "+str(playerpos)+"\nFPS: "+str(Engine.get_frames_per_second())+"\nWorld Seed: "+str(world_seed)

func getItem(id):
	return item_lookup[id]

func convertItemToId(tile):
	return tile_to_id[tile]

func itemHeld():
	return getItem(inventory[item_held].id)

func itemHeldInventory():
	return inventory[item_held]

func addInventoryItem(id, count):
	var done = false
	for i in Game.inventory:
		if Game.inventory[i].id == id and !done:
			Game.inventory[i].count += count
			done = true

	if !done:
		for i in Game.inventory:
			if Game.inventory[i].id == "null" and !done:
				Game.inventory[i].id = id
				Game.inventory[i].count = count
				done = true

func removeInventoryItem(id, count):
	var error
	for i in Game.inventory:
		if Game.inventory[i].id == id:
			if Game.inventory[i].count >= count:
				Game.inventory[i].count -= count
				if Game.inventory[i].count == 0:
					Game.inventory[i].id = "null"
				return 0
			else:
				error = 2
		else:
			error = 1
	return error

func craftItem(item):
	var escrow = {}
	for i in crafting_table[item]:
		var error = removeInventoryItem(i, crafting_table[item][i])
		if error != 0:
			for j in escrow:
				addInventoryItem(j, escrow[j])
			return 1
		escrow[i] = crafting_table[item][i]
	addInventoryItem(item, 1)
	return 0
