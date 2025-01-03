extends CharacterBody2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D
var chase = false
var SPEED = 100
var alive = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $"../../Player/player"
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true:
			velocity.x = direction.x * SPEED
			anim.play("Run")
		else:
			velocity.x = 0
			anim.play("idle ")
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	
	
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == "player":
		chase = true


func _on_detector_body_exited(body):
	if body.name == "player":
		chase = false


func _on_death_body_entered(body):
	if body.name == "player":
		death()
func _on_death_2_body_entered(body):
	if body.name == "player":
		if alive:
			body.HP -= 40
		death()



func death():
	alive = false
	anim.play('Death')
	await anim.animation_finished
	queue_free()
