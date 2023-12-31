extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animSprite = get_node("AnimatedSprite2D")
@onready var animPlayer = get_node("AnimationPlayer")

var isHurting = false

func _physics_process(delta):
	if Game.state.player.health < 1:
		return
	if not is_on_floor():
		velocity.y += Game.gravity * delta
		if !isHurting:
			if velocity.y < 0:
				animPlayer.play("Jump")
			if velocity.y > 0:
				animPlayer.play("Fall")

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		animSprite.flip_h = true
	elif direction == 1:
		animSprite.flip_h = false
	if direction != 0:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			if !isHurting:
				animPlayer.play("Run")
	else:
		if !isHurting:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			if !isHurting:
				animPlayer.play("Idle")

	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY
	move_and_slide()

func hit(damagerSourceNode: Node):
	if isHurting:
		return
		
	isHurting = true
	Game.addHealth(-damagerSourceNode.DAMAGE)
	
	if Game.state.player.health < 1:
		animPlayer.play("Death")
		await animPlayer.animation_finished
		queue_free()
	else:
		var distance: Vector2 = damagerSourceNode.position - self.position
		var direction = Vector2(
			-1 if distance.x < 0 else 1,
			-1 if distance.y < 0 else 1)
		var xToWholeRatio = direction.x * distance.x / ((direction.x * distance.x) + (direction.y * distance.y))
		var yToWholeRatio = direction.y * distance.y / ((direction.x * distance.x) + (direction.y * distance.y))
		var newVelocity = Vector2(
			direction.x * xToWholeRatio * JUMP_VELOCITY,
			direction.y * yToWholeRatio * JUMP_VELOCITY)
		velocity.x = newVelocity.x
		velocity.y = newVelocity.y
		move_and_slide()
		print("distance: ", distance, ", direction: ", direction, ", xToWholeRatio: ", xToWholeRatio, ", yToWholeRatio: ", yToWholeRatio, ", newVelocity: ", newVelocity)
		
		animPlayer.play("Hurt")
		await animPlayer.animation_finished
	
	isHurting = false

func collect(collected: Node):
	Game.addGold(collected.GOLD)
