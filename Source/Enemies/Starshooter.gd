extends KinematicBody2D

onready var player = get_parent().get_node("PlayerLayer/Player")
onready var sprite: Sprite = get_node("Sprite")
onready var spawn_point: Position2D = get_node("BulletSpawnPoint")
onready var timer: Timer = get_node("Timer")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var audio: AudioStreamPlayer = get_node("AudioStreamPlayer")

onready var bullet_path = preload("res://Source/Enemies/EnemyBullet.tscn")
onready var shot_sound = "res://Assets/SFX/handgun-firing1.wav"
onready var die_sound = "res://Assets/SFX/bomb2.wav"

export var speed = 150.0

var velocity = Vector2.ZERO
var start_point = Vector2.ZERO
var direction = Vector2.ZERO
var firing_speed = 2.0
var bullet_speed = 300.0
var points = 400
var destroying = false

func _ready():
	randomize()
	
	var err
	err = Warudo.connect("time_stoped", self, "_on_time_stoped")
	if err != OK:
		print("Error ZA WARUDO!")
	
	timer.set_wait_time(firing_speed)
	timer.start()
	
	var side = int(rand_range(0, 4))
	# Up, Left, Down, Right
	match side:
		0:
			start_point.x = rand_range(0, 1920)
			start_point.y = 0
		1:
			start_point.x = 0
			start_point.y = rand_range(0, 1080)
		2:
			start_point.x = rand_range(0, 1920)
			start_point.y = 1080
		_:
			start_point.x = 1920
			start_point.y = rand_range(0, 1080)
	position = start_point
	
	var sfx = load(shot_sound)
	audio.set_stream(sfx)

func _physics_process(_delta: float) -> void:
	if not Warudo.time_stoped and not destroying:
		if is_instance_valid(player):
			look_at(player.position)
			direction = player.position - get_global_position()
			if abs(direction.x) > 500 or abs(direction.y) > 500:
				sprite.set_frame(0)
				velocity = direction.normalized() * speed
				velocity = move_and_slide(velocity)
			else:
				sprite.set_frame(1)

func shoot():
	var bullet = bullet_path.instance()
	get_parent().get_parent().add_child(bullet)
	bullet.position = spawn_point.global_position
	bullet.velocity = (bullet.position - position).normalized()
	bullet.speed = bullet_speed

func take_damage() -> void:
	Warudo.add_score(points)
	var sfx = load(die_sound)
	audio.set_stream(sfx)
	audio.play()
	destroying = true
	timer.stop()
	anim.play("Destroy")

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

func _on_Timer_timeout():
	shoot()
	audio.play()
	timer.start()

func _on_time_stoped(value):
	if value:
		timer.stop()
	else:
		timer.start()
