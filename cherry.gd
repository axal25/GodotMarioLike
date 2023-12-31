extends Area2D

@onready var animSprite = get_node("AnimatedSprite2D")
@onready var playerNode: Node = get_node("../../PlayerNode/Player")

const GOLD = 5

var collected = false
var collided = false

func _ready():
	position.y = 0
	modulate.a = 0
	animSprite.play("Idle")

func _physics_process(delta):
	if not collided:
		position.y += Game.gravity * delta

func _on_body_entered(body):
	if body != playerNode:
		if not collided:
			appear()
		return
		
	playerNode.collect(self)
	collected = true
	
	var duration = 1
	
	var tween = get_tree().create_tween()
	var newPosition: Vector2 = position - Vector2(0, 50)
	if newPosition.y < 0:
		newPosition.y = 0
	tween.tween_property(self, "position", newPosition, duration)
	
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, duration)
	
	tween.tween_callback(queue_free)

func appear():
	collided = true
	
	var duration = 0.25

	var tween = get_tree().create_tween()
	var newPosition: Vector2 = position - Vector2(0, 50)
	if newPosition.y < 0:
		newPosition.y = 0
	tween.tween_property(self, "position", newPosition, duration)

	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, duration)
