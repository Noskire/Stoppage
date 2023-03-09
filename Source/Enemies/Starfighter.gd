extends KinematicBody2D

onready var player = get_parent().get_node("PlayerLayer/Player")
onready var sprite: Sprite = get_node("Sprite")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var audio: AudioStreamPlayer = get_node("AudioStreamPlayer")

onready var shot_sound = "res://Assets/SFX/gauge_recovery2.wav"
onready var die_sound = "res://Assets/SFX/bomb1.wav"

export var speed = 200.0

# States
enum States {IDLE, PREPARE, ATTACK, REST, FLEEING}
var state = States.IDLE

var velocity = Vector2.ZERO
var start_point = Vector2.ZERO
var direction = Vector2.ZERO
var time = 0.0
var points = 250
var destroying = false

func _ready():
	time = 0
	randomize()
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

func _physics_process(delta: float) -> void:
	if not Warudo.time_stoped and not destroying:
		time += delta
		
		if state == States.IDLE:
			if is_instance_valid(player):
				look_at(player.position)
				direction = player.position - get_global_position()
				velocity = direction.normalized() * speed
				velocity = move_and_slide(velocity)
			if abs(direction.x) < 250 and abs(direction.y) < 250:
				state = States.PREPARE
				time = 0
				#anim_player.play("Prepare")
		elif state == States.PREPARE:
			if time >= 0.5:
				time = 0
				state = States.ATTACK
				sprite.set_frame(1)
				audio.play()
		elif state == States.ATTACK:
			if time >= 1.0:
				state = States.IDLE
				sprite.set_frame(0)
			velocity = direction.normalized() * speed * 5
			velocity = move_and_slide(velocity)

func take_damage() -> void:
	Warudo.add_score(points)
	var sfx = load(die_sound)
	audio.set_stream(sfx)
	audio.play()
	destroying = true
	anim.play("Destroy")

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
