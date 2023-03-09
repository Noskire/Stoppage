extends Control

onready var trait1_levels: HBoxContainer = get_node("Grid/HBox1/Levels")
onready var trait2_levels: HBoxContainer = get_node("Grid/HBox2/Levels")
onready var trait3_levels: HBoxContainer = get_node("Grid/HBox3/Levels")
onready var trait4_levels: HBoxContainer = get_node("Grid/HBox4/Levels")

onready var trait1_button: Button = get_node("Grid/HBox1/Levels/LevelUp")
onready var trait2_button: Button = get_node("Grid/HBox2/Levels/LevelUp")
onready var trait3_button: Button = get_node("Grid/HBox3/Levels/LevelUp")
onready var trait4_button: Button = get_node("Grid/HBox4/Levels/LevelUp")

onready var audio: AudioStreamPlayer = get_node("AudioStreamPlayer")

onready var upgrade_path = "res://Assets/upgradeon.png"
onready var ok_sound = "res://Assets/SFX/power-up1.wav"
onready var not_sound = "res://Assets/SFX/warning1.wav"

export(String, FILE) var menu_path: = "res://Source/MenuUI/Menu.tscn"

var paused = false
var gameover = false

# Traits
var bullet_speed = 0
var player_speed = 0
var firing_speed = 0
var time_stop = 0
var max_ups = 5
var costs = [100, 200, 500, 1000, 2500]

func _ready():
	trait1_button.set_text(str(costs[0]))
	trait2_button.set_text(str(costs[0]))
	trait3_button.set_text(str(costs[0]))
	trait4_button.set_text(str(costs[0] * 5))

func _input(event):
	if event.is_action_pressed("menu") and not gameover:
		paused = not paused
		get_tree().set_pause(paused)
		set_visible(paused)

func _on_Trait1_button_up():
	if Warudo.score >= costs[bullet_speed]:
		play_sound_ok()
		Warudo.add_score(-costs[bullet_speed])
		update_rect(trait1_levels, bullet_speed)
		bullet_speed += 1
		Warudo.set_bullet_speed()
		if bullet_speed == 5:
			trait1_button.set_disabled(true)
			trait1_button.set_text("MAX")
		else:
			trait1_button.set_text(str(costs[bullet_speed]))
	else:
		play_sound_not()

func _on_Trait2_button_up():
	if Warudo.score >= costs[player_speed]:
		play_sound_ok()
		Warudo.add_score(-costs[player_speed])
		update_rect(trait2_levels, player_speed)
		player_speed += 1
		Warudo.set_player_speed()
		if player_speed == 5:
			trait2_button.set_disabled(true)
			trait2_button.set_text("MAX")
		else:
			trait2_button.set_text(str(costs[player_speed]))
	else:
		play_sound_not()

func _on_Trait3_button_up():
	if Warudo.score >= costs[firing_speed]:
		play_sound_ok()
		Warudo.add_score(-costs[firing_speed])
		update_rect(trait3_levels, firing_speed)
		firing_speed += 1
		Warudo.set_firing_speed()
		if firing_speed == 5:
			trait3_button.set_disabled(true)
			trait3_button.set_text("MAX")
		else:
			trait3_button.set_text(str(costs[firing_speed]))
	else:
		play_sound_not()

func _on_Trait4_button_up():
	#TIME STOP COST MORE
	if Warudo.score >= (costs[time_stop] * 5):
		play_sound_ok()
		Warudo.add_score(-costs[time_stop] * 5)
		update_rect(trait4_levels, time_stop)
		time_stop += 1
		Warudo.set_time_stop()
		if time_stop == 5:
			trait4_button.set_disabled(true)
			trait4_button.set_text("MAX")
		else:
			trait4_button.set_text(str(costs[time_stop] * 5))
	else:
		play_sound_not()

func update_rect(hbox, idx):
	match idx:
		0:
			hbox.get_node("Rect1").set_texture(load(upgrade_path))
		1:
			hbox.get_node("Rect2").set_texture(load(upgrade_path))
		2:
			hbox.get_node("Rect3").set_texture(load(upgrade_path))
		3:
			hbox.get_node("Rect4").set_texture(load(upgrade_path))
		4:
			hbox.get_node("Rect5").set_texture(load(upgrade_path))

func _on_Unpause_button_up():
	paused = false
	get_tree().set_pause(false)
	set_visible(false)

func _on_Menu_button_up():
	get_tree().paused = false
	var err
	err = get_tree().change_scene(menu_path)
	if err != OK:
		print("Error change_scene Pause > Menu")

func play_sound_ok():
	var sfx = load(ok_sound)
	audio.set_stream(sfx)
	audio.play()

func play_sound_not():
	var sfx = load(not_sound)
	audio.set_stream(sfx)
	audio.play()
