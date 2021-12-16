extends Control

func _on_loadgame_pressed():
	$FileDialog.popup()

func _on_playgame_pressed():
	get_tree().change_scene("res://scenes/world.tscn")


func _on_play_new_game_pressed():
	
	$"TabContainer/New Game/GridContainer/play new game".disabled = true
	$"TabContainer/New Game/GridContainer/name".editable = false
	$"TabContainer/New Game/GridContainer/seed".editable = false
	
	var world_seed
	if $"TabContainer/New Game/GridContainer/seed".text == "":
		randomize()
		world_seed = randi()
	else:
		world_seed = int($"TabContainer/New Game/GridContainer/seed".text)
	
	get_tree().get_root().add_child(preload("res://scenes/world.tscn").instance())
	get_tree().get_root().get_node("World").new_game($"TabContainer/New Game/GridContainer/name".text, world_seed)


func _on_select_save_pressed():
	$"TabContainer/Load Game/FileDialog".popup()

func _on_FileDialog_dir_selected(dir):
	get_tree().get_root().add_child(preload("res://scenes/world.tscn").instance())
	get_tree().get_root().get_node("World").load_game(dir)
