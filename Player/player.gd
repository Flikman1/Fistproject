extends CharacterBody2D
enum 
{
	ATTACK,
	ATTACK2,
	ATTACK3,
	MOVE,
	BLOCK,
	SLIDE 
}

const SPEED = 150
const JUMP_VELOCITY = -400.0
var HP = 100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gold = 0
var attack_coldown = false
var player_pos 


@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var state = MOVE
var run_speed = 1
var combo = false

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack()
		ATTACK2:
			attack2()
		ATTACK3:
			attack3()
		BLOCK:
			block_state()
		SLIDE:
			slide_state()
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		animPlayer.play("fall")
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	
	
		
	if HP <= 0:
		HP = 0
		animPlayer.play("death")
		await animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://scn/menu.tscn")
	
	move_and_slide()
	
	player_pos = self.position
	Signol.emit_signal("player_pos_update", player_pos)




func move_state():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:
			if run_speed == 1:
				animPlayer.play("walk")
			else:
				animPlayer.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			animPlayer.play("idle")
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false
	if Input.is_action_pressed("run"):
		run_speed = 2
	else:
		run_speed = 1
	if Input.is_action_pressed("block"):
		if velocity.x == 0:
			state = BLOCK
		else:
			state = SLIDE
	if Input.is_action_just_pressed("attack") and attack_coldown == false:
		state = ATTACK

func block_state():
	velocity.x = 0
	animPlayer.play("block")
	if Input.is_action_just_released("block"):
		state = MOVE

func slide_state():
	animPlayer.play("slide")
	await animPlayer.animation_finished
	state = MOVE

func attack():
	velocity.x = 0
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK2
	animPlayer.play("attack")
	await animPlayer.animation_finished
	attack_frez()
	state = MOVE

func attack2():
	velocity.x = 0
	if Input.is_action_just_pressed("attack") and combo == true:
		state = ATTACK3
	animPlayer.play("attack2")
	await animPlayer.animation_finished
	state = MOVE

func attack3():
	velocity.x = 0
	animPlayer.play("attack3")
	await animPlayer.animation_finished
	state = MOVE
func combo1():
	combo = true
	await animPlayer.animation_finished
	combo = false
func attack_frez():
	attack_coldown = true
	await get_tree().create_timer(0.5).timeout
	attack_coldown = false
