extends Control

var item = preload("res://scenes/ITEM.tscn")

func _ready():
	pass

func _process(delta):

	if Input.is_action_just_pressed("SLOT_1"):
		Globals.item_held = 0
	
	if Input.is_action_just_pressed("SLOT_2"):
		Globals.item_held = 1
	
	if Input.is_action_just_pressed("SLOT_3"):
		Globals.item_held = 2
	
	if Input.is_action_just_pressed("SLOT_4"):
		Globals.item_held = 3
	
	if Input.is_action_just_pressed("SLOT_5"):
		Globals.item_held = 4

	for i in $HBoxContainer.get_children():
		i.queue_free()
		
	for i in Globals.invetory:
		var new_item = item.instance()
		new_item.get_node("Label").text = Globals.item_lookup[Globals.invetory[i].id].name
		if Globals.item_held == Globals.invetory[i].id:
			new_item.get_node("overlay").show()
		$HBoxContainer.add_child(new_item)
