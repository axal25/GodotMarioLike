extends Label

@onready var playerNode = get_node("../../PlayerNode/Player")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Gold: 0"
	if playerNode != null:
		text = "Gold: " + str(Game.state.player.gold) + ("" if Game.state.highScore.gold < 1 else " (highscore: " + str(Game.state.highScore.gold) + ")")
