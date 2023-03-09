extends Control

onready var highscore: Label = get_node("Highscore")
onready var master_slide: HSlider = get_node("Menu/Audio/MasterVolSlider")
onready var bg_check: CheckBox = get_node("Menu/BgScroll/BgCheck")
onready var audio: AudioStreamPlayer = get_node("AudioStreamPlayer")
onready var bganim: AnimationPlayer = get_node("BgMovement")

export(String, FILE) var level_path: = "res://Source/Level.tscn"

func _ready():
	highscore.set_text("Highscore: %s" % Warudo.best_score)
	AudioServer.set_bus_volume_db(0, master_slide.value)
	AmbientSound.play()
	bg_check.set_pressed(not Warudo.bg_stop)

func _on_Play_button_up():
	audio.play()

func start_game():
	var err
	err = get_tree().change_scene(level_path)
	if err != OK:
		print("Error change_scene Menu > Level")

func _on_MasterVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)
	#master_value.text = str(Save.game_data.master_vol)

func _on_BgCheck_toggled(button_pressed):
	if button_pressed:
		bganim.play()
		Warudo.bg_stop = false
	else:
		bganim.stop()
		Warudo.bg_stop = true
