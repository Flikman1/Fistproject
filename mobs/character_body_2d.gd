extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chase = false

var SPEED = 100

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var player = $Player/player
	var direction = (player.position - self.position).normalized()
	
	if chase == true:
		velocity.x = direction.x * SPEED
	
	move_and_slide()

func _on_detector_body_entered(body):
	if body.name == "Player":
		chase = true
