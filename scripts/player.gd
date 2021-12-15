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
		Game.player_state = "WATER"
		speed = 10
	else:
		Game.player_state = ""
		speed = 30
	#4096
	$AnimatedSprite2.hide()
	if Game.player_state == "WATER":
		$AnimatedSprite2.show()
	
	anim.play("IDLE")
	$AnimatedSprite.speed_scale = 1/1.5
	$AnimatedSprite2.speed_scale = 1/1.5
	velocity = Vector2()
	
	if Input.is_action_just_pressed("RMB"):
		if Game.itemHeld().is_tile:
			var pos = Vector2(world.get_node(layer_lookup[Game.itemHeld().layer]).world_to_map(get_global_mouse_position()).x, world.get_node(layer_lookup[Game.itemHeld().layer]).world_to_map(get_global_mouse_position()).y)
			
			if world.get_node(layer_lookup[0]).get_cell(pos.x, pos.y) in Game.itemHeld().allowed_tiles and world.get_node(layer_lookup[1]).get_cell(pos.x, pos.y) in Game.itemHeld().allowed_tiles and world.get_node(layer_lookup[2]).get_cell(pos.x, pos.y) in Game.itemHeld().allowed_tiles:
				if Game.itemHeldInventory().count != 0:
					
					var layer = world.get_node(layer_lookup[Game.itemHeld().layer])
					layer.set_cell(pos.x, pos.y, Game.itemHeld().tile_id)
					layer.update_bitmask_area(pos)
					
					for i in Game.itemHeld().clear_layer:
						world.get_node(layer_lookup[i]).set_cell(pos.x, pos.y, -1)
						world.get_node(layer_lookup[i]).update_bitmask_area(pos)
				
				Game.inventory[Game.item_held].count -= 1
				if Game.inventory[Game.item_held].count <= 0:
					Game.inventory[Game.item_held].id = "null"
					Game.inventory[Game.item_held].count = 0
	
	if Input.is_action_just_pressed("LMB"):
		var pos = Vector2(world.get_node("YSort/tree").world_to_map(get_global_mouse_position()).x, world.get_node("YSort/tree").world_to_map(get_global_mouse_position()).y)
		if world.get_node("YSort/tree").get_cell(pos.x, pos.y) != -1:
			var tile = world.get_node("YSort/tree").get_cell(pos.x, pos.y)
			for j in Game.getItem(Game.tile_to_id[tile]).loot_table:
				var count = Game.getItem(Game.tile_to_id[tile]).loot_table[j]
				var done = false
				for i in Game.inventory:
					if Game.inventory[i].id == j and !done:
						Game.inventory[i].count += count
						done = true
				
				if !done:
					for i in Game.inventory:
						if Game.inventory[i].id == "null" and !done:
							Game.inventory[i].id = j
							Game.inventory[i].count = count
							done = true
			
			world.get_node("YSort/tree").set_cell(pos.x, pos.y, -1)
			world.get_node("YSort/tree").update_bitmask_area(pos)

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
