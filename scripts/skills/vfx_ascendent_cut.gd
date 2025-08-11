extends Node

@export var playback_pos: Timer

func _ready() -> void:
	$sword.play(0.0)
	playback_pos.start()


func _on_time_timeout() -> void:
	$impact.play(0.0)
