extends Control

export(String, FILE) var menu_path: = "res://Source/MenuUI/Menu.tscn"

func start():
	var err
	err = get_tree().change_scene(menu_path)
	if err != OK:
		print("Error change_scene Splash > Menu")
