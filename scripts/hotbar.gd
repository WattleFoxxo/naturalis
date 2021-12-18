extends Control

var item = preload("res://scenes/ITEM.tscn")

func _ready():
	pass

func _process(delta):

	if Input.is_action_just_pressed("SLOT_1"):
		Game.item_held = 0
	
	if Input.is_action_just_pressed("SLOT_2"):
		Game.item_held = 1
	
	if Input.is_action_just_pressed("SLOT_3"):
		Game.item_held = 2
	
	if Input.is_action_just_pressed("SLOT_4"):
		Game.item_held = 3
	
	if Input.is_action_just_pressed("SLOT_5"):
		Game.item_held = 4
	
	if Input.is_action_just_pressed("SLOT_6"):
		Game.item_held = 5
	
	if Input.is_action_just_pressed("SLOT_7"):
		Game.item_held = 6
	
	if Input.is_action_just_pressed("SLOT_8"):
		Game.item_held = 7
	
	if Input.is_action_just_pressed("SLOT_9"):
		Game.item_held = 8

	for i in $HBoxContainer.get_children():
		i.queue_free()
		
	for i in Game.inventory:
		var new_item = item.instance()
		new_item.get_node("name").text = Game.getItem(Game.inventory[i].id).name
		if Game.inventory[i].count > 0:
			new_item.get_node("count").text = str(Game.inventory[i].count)
		
		if Game.item_held == i:
			new_item.get_node("overlay").show()
		$HBoxContainer.add_child(new_item)
