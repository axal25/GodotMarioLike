extends CanvasLayer

@onready var mobsNode: Node = get_node("../Mobs")
@onready var collectableNode: Node = get_node("../Collectables")

func _ready():
	visible = false

func _process(delta):
	if (mobsNode == null or mobsNode.get_child_count() == 1) and (collectableNode == null or collectableNode.get_child_count() == 1):
		visible = true


func _on_restart_level_pressed():
	Game.playerReachedEndOfMap = false
	get_tree().change_scene_to_file("res://world.tscn")


func _on_return_to_main_menu_pressed():
	Game.playerReachedEndOfMap = false
	get_tree().change_scene_to_file("res://main.tscn")
