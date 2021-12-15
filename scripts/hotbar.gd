extends Control

var item = preload("res://scenes/ITEM.tscn")

func _ready():
	pass

func _process(delta):

	if Input.is_action_just_pressed("SLOT_1"):
		Globals.inventory_slot_used = 0
		Globals.item_held = Globals.invetory[Globals.inventory_slot_used].id
	
	if Input.is_action_just_pressed("SLOT_2"):
		Globals.inventory_slot_used = 1
		Globals.item_held = Globals.invetory[Globals.inventory_slot_used].id
	
	if Input.is_action_just_pressed("SLOT_3"):
		Globals.inventory_slot_used = 2
		Globals.item_held = Globals.invetory[Globals.inventory_slot_used].id
	
	if Input.is_action_just_pressed("SLOT_4"):
		Globals.inventory_slot_used = 3
		Globals.item_held = Globals.invetory[Globals.inventory_slot_used].id
	
	if Input.is_action_just_pressed("SLOT_5"):
		Globals.inventory_slot_used = 4
		Globals.item_held = Globals.invetory[Globals.inventory_slot_used].id

	for i in $HBoxContainer.get_children():
		i.queue_free()
		
	for i in Globals.invetory:
		var new_item = item.instance()
		new_item.get_node("name").text = Globals.item_lookup[Globals.invetory[i].id].name
		new_item.get_node("count").text = str(Globals.invetory[i].count)
		if Globals.inventory_slot_used == i:
			new_item.get_node("overlay").show()
		$HBoxContainer.add_child(new_item)
