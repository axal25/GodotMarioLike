extends Node2D

var frogResource: Resource = preload("res://frog.tscn")

func _on_timer_timeout():
	Game.spawn(self, frogResource)
