extends Control

func _ready():
	refresh()
	visible = false

func _process(delta):
	if Input.is_action_just_pressed("INVENTORY"):
		visible = !visible
		refresh()

func refresh():
	for i in $Panel/VBoxContainer.get_children():
		$Panel/VBoxContainer.remove_child(i)
	
	for i in Game.crafting_table:
		var craftitem = preload("res://scenes/craft.tscn").instance()
		craftitem.name = i
		craftitem.text = i + ". requires: " + str(Game.crafting_table[i])
		craftitem.connect("pressed", self, "selected", [i])
		$Panel/VBoxContainer.add_child(craftitem)

func selected(item):
	Game.craftItem(item)
