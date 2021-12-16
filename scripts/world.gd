extends Node2D

onready var layer_ground = $ground
onready var layer_ground_cover = $ground2
onready var layer_tree = $YSort/tree

onready var player = $YSort/PlayerController

var river_noise = OpenSimplexNoise.new()
var terrain_noise = OpenSimplexNoise.new()
var tree_noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()

var world_dir = ""

func _ready():
	pass

func new_game(name, world_seed):
	world_gen(world_seed)
	spawn_player()
	savefile("user://"+name)
	loadfile("user://"+name)
	world_dir = "user://"+name

func load_game(name):
	loadfile(name)
	world_dir = name

func _process(delta):
	Game.playerpos = Vector2(round(player.position.x/8), round(player.position.y/8))

func world_gen(world_seed):
	Game.world_seed = world_seed
	rng.seed = Game.world_seed
	gen_ground()
	gen_river()
	gen_objects()

func gen_ground():
	terrain_noise.seed = Game.world_seed
	terrain_noise.octaves = 7
	terrain_noise.period = 128
	terrain_noise.lacunarity = 2
	terrain_noise.persistence = 0.7

	for x in Game.world_width:
		for y in Game.world_height:
			var tile
			var val = terrain_noise.get_noise_2d(x*6, y*6) + 1
			
			val = terrain_noise.get_noise_2d(x*13, y*13) + 1
			
			if val > 1.1:
				tile = Game.LONG_GRASS
			
			layer_ground.set_cell(x, y, Game.GRASS)
			
			if tile:
				layer_ground_cover.set_cell(x, y,  tile, false, false, false, get_subtile_with_priority(tile, layer_ground_cover))
	
	layer_ground_cover.update_bitmask_region()
	layer_ground.update_bitmask_region()

func gen_river():
	river_noise.seed = Game.world_seed
	river_noise.octaves = 5
	river_noise.period = 128
	river_noise.lacunarity = 2
	river_noise.persistence = 0.5

	for x in Game.world_width:
		for y in Game.world_height:
			var val = river_noise.get_noise_2d(x, y) + 1
			var tile
			
			if val > 0.85:
				tile = Game.WATER
			
			if tile:
				layer_ground.set_cell(x, y, tile)
				layer_ground_cover.set_cell(x, y, -1)
	layer_ground.update_bitmask_region()
	layer_ground_cover.update_bitmask_region()

func gen_objects():
	tree_noise.seed = Game.world_seed
	tree_noise.octaves = 7
	tree_noise.period = 128
	tree_noise.lacunarity = 2
	tree_noise.persistence = 0.7

	for x in Game.world_width:
		for y in Game.world_height:
			var tile
			var val = tree_noise.get_noise_2d(x*15, y*15) + 1
			
			if val > 1.2:
				if layer_ground.get_cell(x, y) == Game.GRASS:
					tile = rng.randi_range(Game.PINE, Game.TREE)
			
			val = tree_noise.get_noise_2d(x*32, y*32) + 1
			
			if val > 1.32:
				if layer_ground.get_cell(x, y) == Game.GRASS:
					tile = Game.BUSH
			
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


func spawn_player():
	while true:
		var x = rng.randi_range(0, Game.world_width)
		var y = rng.randi_range(0, Game.world_height)
		var tile = layer_ground.get_cell(x, y)
		if tile == Game.GRASS:
			player.position = Vector2(x*16, y*16)
			return

func savefile(name):
	var dir = Directory.new()
	dir.open("user://")
	dir.make_dir(name)
	
	var layer1 = PackedScene.new()
	layer1.pack(layer_ground)
	ResourceSaver.save(name+"/one.scn", layer1)
	
	var layer2 = PackedScene.new()
	layer2.pack(layer_ground_cover)
	ResourceSaver.save(name+"/two.scn", layer2)
	
	var layer3 = PackedScene.new()
	layer3.pack(layer_tree)
	ResourceSaver.save(name+"/three.scn", layer3)
	
	var save = {
		"pos":player.position,
		"inventory":Game.inventory,
		"seed":Game.world_seed,
	}
	var file = File.new()
	file.open(name+"/data.save", File.WRITE)
	file.store_var(save, true)
	file.close()

func loadfile(save_name):
	
	remove_child(layer_ground)
	add_child(load(save_name+"/one.scn").instance(), true)
	layer_ground = $ground
	move_child(layer_ground, 0)
	
	remove_child(layer_ground_cover)
	add_child(load(save_name+"/two.scn").instance(), true)
	layer_ground_cover = $ground2
	move_child(layer_ground_cover, 1)
	
	$YSort.remove_child($YSort/tree)
	$YSort.add_child(load(save_name+"/three.scn").instance(), true)
	layer_tree = $YSort/tree
	
	var file = File.new()
	var save
	
	if file.file_exists(save_name+"/data.save"):
		file.open(save_name+"/data.save", File.READ)
		save = file.get_var(true)
		file.close()
	
	player.position = save.pos
	Game.inventory = save.inventory
	Game.world_seed = save.seed

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		savefile(world_dir)
		get_tree().quit()
