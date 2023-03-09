extends KinematicBody2D

onready var sprite: Sprite = get_node("Sprite")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var audio: AudioStreamPlayer = get_node("AudioStreamPlayer")

export var speed = 150.0

var velocity = Vector2.ZERO
var start_point = Vector2.ZERO
var direction = Vector2.ZERO
var points = 50

var destroying = false

func _ready():
	randomize()
	var err
	err = Warudo.connect("time_stoped", self, "_on_time_stoped")
	if err != OK:
		print("Error ZA WARUDO!")

func _physics_process(_delta: float) -> void:
	if not Warudo.time_stoped and not destroying:
		velocity = direction * speed
		velocity = move_and_slide(velocity)

func initialize():
	sprite.set_frame(int(rand_range(0, 2)))
	
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
	
	direction.x = rand_range(-1, 1)
	direction.y = rand_range(-1, 1)
	direction = direction.normalized()
	
	if start_point.x == 0:
		direction.x = abs(direction.x)
	elif start_point.x == 1920:
		direction.x = -abs(direction.x)
	
	if start_point.y == 0:
		direction.y = abs(direction.y)
	elif start_point.y == 1080:
		direction.y = -abs(direction.y)
	
	look_at(direction)

func take_damage() -> void:
	Warudo.add_score(points)
	audio.play()
	destroying = true
	anim.play("Destroying")

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

func _on_time_stoped(value):
	if value:
		anim.set_speed_scale(0.0)
	else:
		anim.set_speed_scale(1.0)
