extends KinematicBody2D

onready var sprite: Sprite = get_node("Sprite")
onready var spawn_point: Position2D = get_node("BulletSpawnPoint")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var audio: AudioStreamPlayer = get_node("AudioStreamPlayer")

onready var camera: Camera2D = get_parent().get_parent().get_node("Camera2D")
onready var filter: CanvasModulate = get_parent().get_parent().get_node("Camera2D/Filter")
onready var spacekey: TextureRect = get_parent().get_parent().get_node("CanvasLayer/HUD/SpaceKey")
onready var spaceanim: AnimationPlayer = get_parent().get_parent().get_node("CanvasLayer/HUD/SpaceAnim")
onready var pause: Control = get_parent().get_parent().get_node("CanvasLayer/Pause")
onready var game_over: Control = get_parent().get_parent().get_node("CanvasLayer/GameOver")

onready var bullet_path = preload("res://Source/Player/Bullet.tscn")
onready var spaceon_path = "res://Assets/spaceon.png"
onready var spaceoff_path = "res://Assets/spaceoff.png"
onready var shot_sound = "res://Assets/SFX/shot1.wav"
onready var die_sound = "res://Assets/SFX/bomb4.wav"

const FLOOR_NORMAL = Vector2.ZERO

var bullet_speed = 300.0
var player_speed = 200.0
var bullet_damage
var firing_speed = 1.0
var time_stop = 1.0
var time_stop_cooldown = 3.0

var direction = Vector2.ZERO
var velocity = Vector2.ZERO
# rfu = Ready for Use
var ZA_WARUDO_rfu = false
var can_shoot = true

func _ready():
	var err
	err = Warudo.connect("bullet_speed_up", self, "_on_bullet_speed_up")
	if err != OK:
		print("Error bullet speed up")
	err = Warudo.connect("player_speed_up", self, "_on_player_speed_up")
	if err != OK:
		print("Error player speed up")
	err = Warudo.connect("firing_speed_up", self, "_on_firing_speed_up")
	if err != OK:
		print("Error bullet damage up")
	err = Warudo.connect("time_stop_up", self, "_on_time_stop_up")
	if err != OK:
		print("Error time stop up")
	
	var sfx = load(shot_sound)
	audio.set_stream(sfx)

func _physics_process(_delta: float) -> void:
	# Get player input
	get_input()
	
	# Calculate velocity x axis
	velocity = direction * player_speed
	
	# Move
	velocity = move_and_slide(velocity)

func get_input():
	# Get player input
	direction = get_global_mouse_position() - position
	look_at(get_global_mouse_position())
	
	var some = 10
	if abs(direction.x) < some and abs(direction.y) < some:
		direction = Vector2.ZERO
		sprite.set_frame(0)
	else:
		direction = direction.normalized()
		sprite.set_frame(1)
	
	if Input.is_action_just_pressed("special") and not ZA_WARUDO_rfu:
		ZA_WARUDO()
	
	# Attack
	if Input.is_action_pressed("action") and can_shoot:
		shoot()
		can_shoot = false
		yield(get_tree().create_timer(firing_speed), "timeout")
		can_shoot = true

func _on_AttackArea_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

func shoot():
	var bullet = bullet_path.instance()
	get_parent().get_parent().add_child(bullet)
	bullet.position = spawn_point.global_position
	bullet.velocity = (bullet.position - position).normalized()
	bullet.speed = bullet_speed
	audio.play()

func take_damage():
	if not Warudo.time_stoped:
		var sfx = load(die_sound)
		audio.set_stream(sfx)
		audio.play()
		pause.gameover = true
		game_over.play_fadeout()
		get_tree().set_pause(true)

func ZA_WARUDO():
	anim.play("ZaWarudo")
	ZA_WARUDO_rfu = true
	spacekey.set_texture(load(spaceoff_path))
	Warudo.stop_time(true)
	filter.color = "#F8C54B"
	
	yield(get_tree().create_timer(time_stop), "timeout")
	Warudo.stop_time(false)
	filter.color = "#FFFFFF"
	
	# Cooldown of ZA_WARUDO
	yield(get_tree().create_timer(time_stop_cooldown), "timeout")
	ZA_WARUDO_rfu = false
	spacekey.set_texture(load(spaceon_path))
	spaceanim.play("Shake")

func _on_bullet_speed_up():
	bullet_speed += 100.0

func _on_player_speed_up():
	player_speed += 50.0

func _on_firing_speed_up():
	firing_speed -= 0.15

func _on_time_stop_up():
	time_stop += 0.5
