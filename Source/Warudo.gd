extends Node

signal time_stoped(value)
signal score_changed(value)

signal bullet_speed_up()
signal player_speed_up()
signal firing_speed_up()
signal time_stop_up()

var time_stoped = false
var score = 0
var best_score = 0
var bg_stop = false

func stop_time(value):
	time_stoped = value
	emit_signal("time_stoped", value)

func reset_score():
	score = 0
	emit_signal("score_changed", score)

func add_score(value):
	score += value
	emit_signal("score_changed", score)

func set_bullet_speed():
	emit_signal("bullet_speed_up")

func set_player_speed():
	emit_signal("player_speed_up")

func set_firing_speed():
	emit_signal("firing_speed_up")

func set_time_stop():
	emit_signal("time_stop_up")
