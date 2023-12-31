extends Node2D

var cherryResource: Resource = preload("res://cherry.tscn")

func _on_timer_timeout():
	Game.spawn(self, cherryResource)
