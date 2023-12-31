extends Label

@onready var playerNode = get_node("../../PlayerNode/Player")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "HP: 0"
	if playerNode != null:
		text = "HP: " + str(Game.state.player.health) + ("" if Game.state.highScore.health < 1 else " (highscore: " + str(Game.state.highScore.health) + ")")
