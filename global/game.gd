extends Node

var state: State = State.new(State.Player.new(-1, -1), State.HighScore.new(-1, -1))
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var playerReachedEndOfMap: bool = false

@onready var playerNode: Node = null
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func addGold(goldDelta: int):
	state.player.gold += goldDelta
	state.update()
	Utils.saveGame()

func addHealth(healthDelta: int):
	state.player.health += healthDelta
	state.update()
	Utils.saveGame()

func spawn(parent: Node, resource: Resource):
	if playerReachedEndOfMap:
		return
	
	var minimalDistance = 250
	var endOfMap = 2300
	var playerPositionX = endOfMap
	lazyLoadPlayerNode()
	if playerNode != null:
		playerPositionX = playerNode.position.x
	playerReachedEndOfMap = playerReachedEndOfMap or playerPositionX + minimalDistance > endOfMap
	if playerReachedEndOfMap:
		return
	var node: Node = resource.instantiate()
	node.position.x = rng.randi_range(playerPositionX + minimalDistance, endOfMap)
	parent.add_child(node)

func lazyLoadPlayerNode():
	if playerNode == null:
		playerNode = get_node("../World/PlayerNode/Player")

class State:
	class Player:
		const HEALTH_START: int = 10
		const GOLD_START: int = 0
		
		var health: int = HEALTH_START
		var gold: int = GOLD_START
		
		func _init(health: int, gold: int):
			self.health = health
			self.gold = gold
		
		func resurrectIfNeeded():
			if health < 1:
				self.health = HEALTH_START
				self.gold = GOLD_START
		
	class HighScore:
		var health: int = 0
		var gold: int = 0
		
		func _init(health: int, gold: int):
			self.health = health
			self.gold = gold
	
	var player: Player
	var highScore: HighScore
	
	func _init(player: Player, highScore: HighScore):
		self.player = player
		self.highScore = highScore
	
	func update():
		if player.health > 0:
			if highScore.gold < player.gold:
				updateHighScore()
			if highScore.gold == player.gold and highScore.health < player.health:
				updateHighScore()
	
	func updateHighScore():
		highScore.health = player.health
		highScore.gold = player.gold
		
	func getDictionary():
		return {
			"player": {
				"health": Game.state.player.health,
				"gold": Game.state.player.gold,
			},
			"highScore": { 
				"health": Game.state.highScore.health,
				"gold": Game.state.highScore.gold
			}
		}
	
	static func parseDictionary(data: Dictionary):
		if not data:
			return null
		
		var player: Player = Player.new(-1, -1)
		if data.has("player") and data["player"] is Dictionary:
			if data["player"].has_all(["health", "gold"]) and data["player"]["health"] is float and data["player"]["gold"] is float:
				player.health = int(data["player"]["health"])
				player.gold = int(data["player"]["gold"])
		player.resurrectIfNeeded()
			
		var highScore: HighScore = HighScore.new(-1, -1)
		if data.has("highScore") and data["highScore"] is Dictionary:
			if data["highScore"].has_all(["health", "gold"]) and data["highScore"]["health"] is float and data["highScore"]["gold"] is float:
				highScore.health = int(data["highScore"]["health"])
				highScore.gold = int(data["highScore"]["gold"])
			
		return Game.State.new(player, highScore)
