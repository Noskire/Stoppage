extends KinematicBody2D

onready var sprite: Sprite = get_node("Sprite")
onready var col1: CollisionShape2D = get_node("Collision")
onready var col2: CollisionShape2D = get_node("Area2D/Collision")
onready var anim: AnimationPlayer = get_node("AnimationPlayer")
onready var audio: AudioStreamPlayer = get_node("AudioStreamPlayer")

onready var atrd_path = preload("res://Source/Enemies/Asteroid.tscn")

export var speed = 100.0

var velocity = Vector2.ZERO
var start_point = Vector2.ZERO
var direction = Vector2.ZERO
var points = 100

func _ready():
	randomize()
	
	var err
	err = Warudo.connect("time_stoped", self, "_on_time_stoped")
	if err != OK:
		print("Error ZA WARUDO!")

func _physics_process(_delta: float) -> void:
	if not Warudo.time_stoped:
		velocity = direction * speed
		velocity = move_and_slide(velocity)

func initialize():
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
	anim.set_speed_scale(2.0)
	anim.play("Destroy")

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()

func _on_animation_finished(anim_name):
	if anim_name == "START":
		anim.play("Rotation")
	elif anim_name == "Destroy":
		var node = Node2D.new()
		var atrd1 = atrd_path.instance()
		var atrd2 = atrd_path.instance()
		var atrd3 = atrd_path.instance()
		
		get_parent().add_child(node)
		node.add_child(atrd1)
		node.add_child(atrd2)
		node.add_child(atrd3)
		node.position = position
		node.rotation = rotation
		
		atrd1.velocity = velocity
		atrd1.position = Vector2(0, 30)
		atrd1.direction = direction + Vector2(0, rand_range(-1, 0))
		atrd1.sprite.set_frame(0)
		
		atrd2.velocity = velocity
		atrd2.position = Vector2(-30, -30)
		atrd2.direction = direction + Vector2(rand_range(0, 1), rand_range(0, 1))
		atrd2.sprite.set_frame(1)
		
		atrd3.velocity = velocity
		atrd3.position = Vector2(30, -30)
		atrd3.direction = direction + Vector2(rand_range(-1, 0), rand_range(0, 1))
		atrd3.sprite.set_frame(2)
		
		queue_free()

func _on_time_stoped(value):
	if value:
		anim.set_speed_scale(0.0)
	else:
		anim.set_speed_scale(1.0)
