extends Node2D

onready var layer_ground = $ground
onready var layer_tree = $YSort/tree

onready var player = $YSort/PlayerController

var river_noise = OpenSimplexNoise.new()
var terrain_noise = OpenSimplexNoise.new()
var tree_noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

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
			var tile = 1
			var val = terrain_noise.get_noise_2d(x*6, y*6) + 1
			
			if val > 1.33:
				tile = rng.randi_range(31, 33)
			
			val = terrain_noise.get_noise_2d(x, y) + 1
			
			if val > 1.3:
				tile = 29
			
			if val > 1.35:
				tile = 30
			
			if tile:
				layer_ground.set_cell(x, y, tile)
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
			
			if val > 0.95 and val < 1.15:
				tile = 28
			
			if val > 1 and val < 1.1:
				tile = 2
			
			if tile:
				layer_ground.set_cell(x, y, tile)
	layer_ground.update_bitmask_region()

func gen_objects():
	tree_noise.seed = Globals.world_seed
	tree_noise.octaves = 7
	tree_noise.period = 128
	tree_noise.lacunarity = 2
	tree_noise.persistence = 0.7

	for x in Globals.world_width:
		for y in Globals.world_height:
			var tile
			var val = tree_noise.get_noise_2d(x*7, y*7) + 1
			
			if val > 1.15:
				if layer_ground.get_cell(x, y) == 1:
					tile = rng.randi_range(23, 26)
			
			val = tree_noise.get_noise_2d(x*32, y*32) + 1
			
			if val > 1.36:
				if layer_ground.get_cell(x, y) == 28:
					tile = 27
			
			val = tree_noise.get_noise_2d(x*32, y*32) + 1
			
			if val > 1.42:
				if layer_ground.get_cell(x, y) != 2:
					tile = rng.randi_range(19, 20)
			
			if tile:
				layer_tree.set_cell(x, y, tile)
			
	layer_tree.update_bitmask_region()
	
