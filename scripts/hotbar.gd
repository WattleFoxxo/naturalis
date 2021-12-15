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

	for i in $HBoxContainer.get_children():
		i.queue_free()
		
	for i in Game.inventory:
		var new_item = item.instance()
		new_item.get_node("name").text = Game.getItem(Game.inventory[i].id).name
		new_item.get_node("count").text = str(Game.inventory[i].count)
		if Game.item_held == i:
			new_item.get_node("overlay").show()
		$HBoxContainer.add_child(new_item)
