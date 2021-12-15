extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var world = get_tree().get_root().get_node("World")

var speed = 40
var velocity = Vector2()

var selected_item = 0;

var lookingforspawn = true

var layer_lookup = {
	0:"ground",
	1:"ground2",
	2:"YSort/tree"
}

func _ready():
	pass

func _physics_process(delta):
	var playerpos = world.get_node(layer_lookup[0]).world_to_map(Vector2(position.x+4, position.y+8))
	if world.get_node(layer_lookup[0]).get_cell(playerpos.x, playerpos.y) == 2 and world.get_node(layer_lookup[0]).get_cell_autotile_coord(playerpos.x, playerpos.y) == Vector2(6, 2) :
		Globals.player_state = "WATER"
		speed = 10
	else:
		Globals.player_state = ""
		speed = 30
	#4096
	$AnimatedSprite2.hide()
	if Globals.player_state == "WATER":
		$AnimatedSprite2.show()
	
	anim.play("IDLE")
	$AnimatedSprite.speed_scale = 1/1.5
	$AnimatedSprite2.speed_scale = 1/1.5
	velocity = Vector2()
	
	if Input.is_action_just_pressed("RMB"):
		if Globals.item_lookup[Globals.item_held].tile:
			var pos = Vector2(world.get_node(layer_lookup[Globals.item_lookup[Globals.item_held].layer]).world_to_map(get_global_mouse_position()).x, world.get_node(layer_lookup[Globals.item_lookup[Globals.item_held].layer]).world_to_map(get_global_mouse_position()).y)
			if world.get_node(layer_lookup[0]).get_cell(pos.x, pos.y) in Globals.item_lookup[Globals.item_held].allowed_tiles and world.get_node(layer_lookup[1]).get_cell(pos.x, pos.y) in Globals.item_lookup[Globals.item_held].allowed_tiles and world.get_node(layer_lookup[2]).get_cell(pos.x, pos.y) in Globals.item_lookup[Globals.item_held].allowed_tiles:
				if Globals.invetory[Globals.inventory_slot_used].count != 0:
					world.get_node(layer_lookup[Globals.item_lookup[Globals.item_held].layer]).set_cell(pos.x, pos.y, Globals.item_lookup[Globals.item_held].tile_id)
					world.get_node(layer_lookup[Globals.item_lookup[Globals.item_held].layer]).update_bitmask_area(pos)
					for i in Globals.item_lookup[Globals.item_held].clear_layer:
						world.get_node(layer_lookup[i]).set_cell(pos.x, pos.y, -1)
						world.get_node(layer_lookup[i]).update_bitmask_area(pos)
				Globals.invetory[Globals.inventory_slot_used].count -= 1
				if Globals.invetory[Globals.inventory_slot_used].count <= 0:
					Globals.invetory[Globals.inventory_slot_used].id = -1
					Globals.invetory[Globals.inventory_slot_used].count = 0
	
	if Input.is_action_just_pressed("LMB"):
		var pos = Vector2(world.get_node("YSort/tree").world_to_map(get_global_mouse_position()).x, world.get_node("YSort/tree").world_to_map(get_global_mouse_position()).y)
		if world.get_node("YSort/tree").get_cell(pos.x, pos.y) != -1:
			var item = world.get_node("YSort/tree").get_cell(pos.x, pos.y)
			world.get_node("YSort/tree").set_cell(pos.x, pos.y, -1)
			world.get_node("YSort/tree").update_bitmask_area(pos)
			
			for i in Globals.invetory:
				if Globals.invetory[i].id == Globals.tile_to_id[item]:
					Globals.invetory[i].count += 1
					return
			
			for i in Globals.invetory:
				if Globals.invetory[i].id == -1:
					Globals.invetory[i].id = Globals.tile_to_id[item]
					Globals.invetory[i].count = 1
					return
	
	if Input.is_action_pressed("MOVE_UP"):
		anim.play("MOVE")
		velocity.y -= 1
	
	if Input.is_action_pressed("MOVE_DOWN"):
		anim.play("MOVE")
		velocity.y += 1
	
	if Input.is_action_pressed("MOVE_LEFT") and Input.is_action_pressed("MOVE_RIGHT"):
		pass
	else:
		if Input.is_action_pressed("MOVE_LEFT"):
			anim.play("MOVE_LEFT")
			velocity.x -= 1
		
		if Input.is_action_pressed("MOVE_RIGHT"):
			anim.play("MOVE_RIGHT")
			velocity.x += 1
	
	velocity = velocity.normalized() * speed

func _process(delta):
	move_and_collide(velocity * delta)
