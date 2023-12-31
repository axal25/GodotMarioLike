extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const DAMAGE = 1
const GOLD = 5

@onready var playerNode = get_node("../../PlayerNode/Player")
@onready var animSprite = get_node("AnimatedSprite2D")
@onready var lastJumpTimer = get_tree().create_timer(0.5)

var isChasing = false
var isDead = false
	
func _physics_process(delta):
	if isDead:
		return
	if not is_on_floor():
		velocity.y += Game.gravity * delta
	
	if is_on_floor():
		if isChasing and (lastJumpTimer == null or !(lastJumpTimer.get_time_left() > 0)):
			lastJumpTimer = get_tree().create_timer(0.5)
			await lastJumpTimer.timeout
			jump()
			lastJumpTimer = null
		else:
			velocity.x = move_toward(velocity.x, 0, 0.25 * SPEED)
			animSprite.play("Idle")
			
	move_and_slide()

func jump():
	var playerDistance = Vector2(0, 0);
	if playerNode != null:
		playerDistance = playerNode.position - self.position
		playerDistance = playerDistance.normalized()

	var speed = SPEED
	var directionX = playerDistance.x;

	if playerDistance.x == 0:
		directionX = 1
		speed = 0.5 * SPEED

	if directionX < 0:
		animSprite.flip_h = false
	elif directionX > 0:
		animSprite.flip_h = true
	animSprite.play("Jump")
	velocity.x = directionX * speed
	velocity.y = JUMP_VELOCITY

func _on_player_threat_body_entered(body):
	if body.name == "Player":
		isChasing = true

func _on_player_threat_body_exited(body):
	if body.name == "Player":
		isChasing = false

func _on_player_hit_frog_body_entered(body):
	if body.name == "Player":
		playerNode.jump()
		Game.addGold(GOLD)
		isDead = true
		animSprite.play("Death")
		await animSprite.animation_finished
		queue_free()


func _on_frog_hit_player_body_entered(body):
	if body.name == "Player":
		playerNode.hit(self)   
