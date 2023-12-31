extends CanvasLayer

@onready var playerNode: Node = get_node("../PlayerNode/Player")

func _ready():
	visible = false

func _process(delta):
	if playerNode == null:
		visible = true

func _on_return_to_main_menu_pressed():
	Game.state.player.resurrectIfNeeded()
	Game.playerReachedEndOfMap = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_restart_level_pressed():
	Game.state.player.resurrectIfNeeded()
	Game.playerReachedEndOfMap = false
	get_tree().change_scene_to_file("res://world.tscn")
