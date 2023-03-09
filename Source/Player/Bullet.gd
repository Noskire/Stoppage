extends KinematicBody2D

var velocity = Vector2.ZERO
var speed = Vector2(300.0, 300.0)

func _physics_process(delta):
	if not Warudo.time_stoped:
		var _col = move_and_collide(velocity.normalized() * delta * speed)

func _on_Area2D_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage()
	queue_free()
