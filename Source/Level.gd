extends Node2D

onready var anim_bgmove: AnimationPlayer = get_node("BgMovement")
onready var score: Label = get_node("CanvasLayer/HUD/Score")
onready var bganim: AnimationPlayer = get_node("BgMovement")

onready var atrd_path = preload("res://Source/Enemies/Asteroid.tscn")
onready var big_atrd_path = preload("res://Source/Enemies/BigAsteroid.tscn")
onready var stfgt_path = preload("res://Source/Enemies/Starfighter.tscn")
onready var ststr_path = preload("res://Source/Enemies/Starshooter.tscn")

#atrd = asteroid
#stfgt = starfighter
#ststr = starshooter

var asteroids_spawned

var spawn_atrd_time = 0.0
var spawn_stfgt_time = 0.0
var spawn_ststr_time = 0.0

var spawn_atrd_cooldown = 1.0
var spawn_stfgt_cooldown = 4.0
var spawn_ststr_cooldown = 7.5

func _ready():
	randomize()
	Warudo.reset_score()
	asteroids_spawned = 0
	spawn_atrd_time = 0.0
	spawn_stfgt_time = 0.0
	spawn_ststr_time = 0.0
	
	if Warudo.bg_stop:
		bganim.stop()
	
	var err
	err = Warudo.connect("score_changed", self, "_on_score_changed")
	if err != OK:
		print("Error score changed")

func _physics_process(delta: float) -> void:
	if not Warudo.time_stoped:
		spawn_atrd_time += delta
		if spawn_atrd_time >= spawn_atrd_cooldown:
			spawn_atrd_time = 0
			spawn_atrd()
		
		spawn_stfgt_time += delta
		if spawn_stfgt_time >= spawn_stfgt_cooldown:
			spawn_stfgt_time = 0
			spawn_stfgt()
		
		spawn_ststr_time += delta
		if spawn_ststr_time >= spawn_ststr_cooldown:
			spawn_ststr_time = 0
			spawn_ststr()

func spawn_atrd():
	asteroids_spawned += 1
	var chance = max(1, (100 - asteroids_spawned))
	
	if (randi() % chance) == 0: #1% ~ 100%
		var big_asteroid = big_atrd_path.instance()
		add_child(big_asteroid)
		big_asteroid.initialize()
	else:
		var asteroid = atrd_path.instance()
		add_child(asteroid)
		asteroid.initialize()

func spawn_stfgt():
	var starfighter = stfgt_path.instance()
	add_child(starfighter)

func spawn_ststr():
	var starshooter = ststr_path.instance()
	add_child(starshooter)

func _on_score_changed(value):
	score.set_text(str("Score: %s" % value))
