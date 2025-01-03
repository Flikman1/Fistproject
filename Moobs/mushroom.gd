extends CharacterBody2D

enum {
	IDLE,
	ATTACK,
	CHACE,
}



var state: int = 0:
	set(value):
		state = value
		match state:
			IDLE:
				idle_state()
			ATTACK:
				attack_state()
			CHACE:
				pass


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var direction
@onready var sprite = $AnimatedSprite2D
func _ready() -> void:
	Signol.connect("player_pos_update", Callable(self, "on_player_position_update"))

@onready var animPlayer = $AnimationPlayer
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if state == CHACE:
		chase_state()
	
	move_and_slide()

func on_player_position_update(player_pos):
	player = player_pos


func _on_attack_range_body_entered(body: Node2D) -> void:
	state = ATTACK
	
func idle_state():
	animPlayer.play("Idle")
	await get_tree().create_timer(1).timeout
	$attack_direction/AttackRange/CollisionShape2D.disabled = false
	state = CHACE
func attack_state():
	animPlayer.play("Attack")
	await animPlayer.animation_finished
	$attack_direction/AttackRange/CollisionShape2D.disabled = true
	
	state = IDLE
func chase_state():
	direction = (player - self.position).normalized()
	if direction.x < 0:
		sprite.flip_h = true
		$attack_direction.rotation_degrees = 180
	elif direction.x > 0:
		sprite.flip_h = false
		$attack_direction.rotation_degrees = 0
	
