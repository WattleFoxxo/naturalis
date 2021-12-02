extends KinematicBody2D

onready var anim = $AnimationPlayer
onready var world = get_tree().get_root().get_node("World")

var speed = 30
var velocity = Vector2()

var selected_item = 0;

var layer_lookup = {
	0:"ground",
	1:"ground2",
	2:"YSort/tree"
}

func _ready():
	pass

func _physics_process(delta):
	
	anim.play("IDLE")
	$AnimatedSprite.speed_scale = 0.08+speed/25
	velocity = Vector2()
	
	if Input.is_action_just_pressed("SCROLL_UP"):
		if selected_item < len(Globals.item_lookup)-1:
			selected_item += 1
	
	if Input.is_action_just_pressed("SCROLL_DOWN"):
		if selected_item > 0:
			selected_item -= 1
	
	Globals.item_held = Globals.item_lookup[selected_item]
	
	if Input.is_action_pressed("MBL"):
		if Globals.item_held.tile:
			var pos = Vector2(world.get_node(layer_lookup[Globals.item_held.layer]).world_to_map(get_global_mouse_position()).x, world.get_node(layer_lookup[Globals.item_held.layer]).world_to_map(get_global_mouse_position()).y)
			if world.get_node(layer_lookup[0]).get_cell(pos.x, pos.y) in Globals.item_held.allowed_tiles and world.get_node(layer_lookup[1]).get_cell(pos.x, pos.y) in Globals.item_held.allowed_tiles and world.get_node(layer_lookup[2]).get_cell(pos.x, pos.y) in Globals.item_held.allowed_tiles:
				world.get_node(layer_lookup[Globals.item_held.layer]).set_cell(pos.x, pos.y, Globals.item_held.tile_id)
				world.get_node(layer_lookup[Globals.item_held.layer]).update_bitmask_area(pos)
				for i in Globals.item_held.clear_layer:
					print(i)
					world.get_node(layer_lookup[i]).set_cell(pos.x, pos.y, -1)
					world.get_node(layer_lookup[i]).update_bitmask_area(pos)
	
	if Input.is_action_pressed("MBR"):
		var pos = Vector2(world.get_node("YSort/tree").world_to_map(get_global_mouse_position()).x, world.get_node("YSort/tree").world_to_map(get_global_mouse_position()).y)
		if world.get_node("YSort/tree").get_cell(pos.x, pos.y) != -1:
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
