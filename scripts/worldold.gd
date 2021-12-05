extends Node2D

onready var layer_ground = $ground
onready var layer_ground_cover = $ground2
onready var layer_tree = $YSort/tree

onready var player = $YSort/PlayerController

var river_noise = OpenSimplexNoise.new()
var terrain_noise = OpenSimplexNoise.new()
var tree_noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

var tile_lookup = {
	"WATER":37,
	"GRASS":38,
	"BUSH_0":51,
	"BUSH_1":52,
	"PINE":54,
	"TREE":55,
	"LONG_GRASS":59,
}

func _ready():
	world_gen()

func _process(delta):
	Globals.playerpos = Vector2(round(player.position.x/8), round(player.position.y/8))

func world_gen():
	rng.seed = Globals.world_seed
	gen_ground()
	gen_river()
	gen_objects()

func gen_ground():
	terrain_noise.seed = Globals.world_seed
	terrain_noise.octaves = 7
	terrain_noise.period = 128
	terrain_noise.lacunarity = 2
	terrain_noise.persistence = 0.7

	for x in Globals.world_width:
		for y in Globals.world_height:
			var tile
			var val = terrain_noise.get_noise_2d(x*6, y*6) + 1
			
			if val > 1.33:
				pass#tile = rng.randi_range(31, 33)
			
			val = terrain_noise.get_noise_2d(x*23, y*23) + 1
			
			if val > 1.2:
				tile = tile_lookup["LONG_GRASS"]
			
			layer_ground.set_cell(x, y, tile_lookup["GRASS"])
			
			if tile:
				layer_ground_cover.set_cell(x, y, tile, false, false, false, get_subtile_with_priority(tile, layer_ground_cover))
	
	layer_ground_cover.update_bitmask_region()
	layer_ground.update_bitmask_region()

func gen_river():
	river_noise.seed = Globals.world_seed
	river_noise.octaves = 5
	river_noise.period = 128
	river_noise.lacunarity = 2
	river_noise.persistence = 0.5

	for x in Globals.world_width:
		for y in Globals.world_height:
			var val = river_noise.get_noise_2d(x, y) + 1
			var tile
			
			"""if val > 0.95 and val < 1.15:
				tile = 28"""
			
			if val > 1 and val < 1.1:
				tile = tile_lookup["WATER"]
			
			if tile:
				layer_ground.set_cell(x, y, tile)
				layer_ground_cover.set_cell(x, y, -1)
	layer_ground.update_bitmask_region()
	layer_ground_cover.update_bitmask_region()

func gen_objects():
	tree_noise.seed = Globals.world_seed
	tree_noise.octaves = 7
	tree_noise.period = 128
	tree_noise.lacunarity = 2
	tree_noise.persistence = 0.7

	for x in Globals.world_width:
		for y in Globals.world_height:
			var tile
			var val = tree_noise.get_noise_2d(x*15, y*15) + 1
			
			if val > 1.2:
				if layer_ground.get_cell(x, y) == tile_lookup["GRASS"]:
					tile = rng.randi_range(tile_lookup["PINE"], tile_lookup["TREE"])
			
			val = tree_noise.get_noise_2d(x*32, y*32) + 1
			
			if val > 1.32:
				if layer_ground.get_cell(x, y) == tile_lookup["GRASS"]:
					tile = rng.randi_range(tile_lookup["BUSH_0"], tile_lookup["BUSH_1"])
			
			if tile:
				layer_tree.set_cell(x, y, tile)
	layer_tree.update_bitmask_region()
	
func get_subtile_with_priority(id, tilemap: TileMap):
	var tiles = tilemap.tile_set
	var rect = tilemap.tile_set.tile_get_region(id)
	var size_x = rect.size.x / tiles.autotile_get_size(id).x
	var size_y = rect.size.y / tiles.autotile_get_size(id).y
	var tile_array = []
	for x in range(size_x):
		for y in range(size_y):
			var priority = tiles.autotile_get_subtile_priority(id, Vector2(x ,y))
			for p in priority:
				tile_array.append(Vector2(x,y))

	return tile_array[randi() % tile_array.size()]
