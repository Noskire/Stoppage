extends Control

onready var text: RichTextLabel = get_node("ColorRect/RichTextLabel")

export(String, FILE) var menu_path: = "res://Source/MenuUI/Menu.tscn"

var score = 0
var best_score = 0

func play_fadeout():
	$AnimationPlayer.play("FadeOut")

func update_score():
	if Warudo.score > Warudo.best_score:
		Warudo.best_score = Warudo.score
		text.set_bbcode("[center]Game Over!\n\nScore: %s\n\nHighScore: %s\n(New HighScore)[/center]" % [Warudo.score, Warudo.best_score])
	else:
		text.set_bbcode("[center]Game Over!\n\nScore: %s\n\nHighScore: %s[/center]" % [Warudo.score, Warudo.best_score])

func _on_Retry_button_up():
	get_tree().paused = false
	var err
	err = get_tree().reload_current_scene()
	if err != OK:
		print("Error reload_scene End > Retry")

func _on_Menu_button_up():
	get_tree().paused = false
	var err
	err = get_tree().change_scene(menu_path)
	if err != OK:
		print("Error change_scene End > Menu")
