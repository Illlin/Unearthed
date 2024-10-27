extends CharacterBody3D

enum GameState {
	DEFAULT,
	FOUND_COIN1,
	FOUND_RING,
	FOUND_PENDANT,
	FOUND_HAND
}


var current_state: GameState = GameState.DEFAULT

var direction := Vector3(0, 0, 0) # Used for animation
var will_jump := false

const JUMP := 4
const PLAYER_MOVE_SPEED := 8

@onready var dialogue_label = $"../UI/dialogue"
@onready var Camera = $Camera3D
@onready var GRAVITY = ProjectSettings.get("physics/3d/default_gravity") / 1000
@onready var animations = $character/AnimationPlayer


func update_dialogue(new_state):
	match new_state:
		GameState.FOUND_COIN1:
			dialogue_label.text = "A coin! Maybe it's worth something..."
		GameState.FOUND_RING:
			dialogue_label.text = "What… is this? I should probably leave it alone…"
		GameState.FOUND_PENDANT:
			dialogue_label.text = "No… no, that can’t be real!"


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

	var amount: float = 4

	if not is_on_floor() or will_jump:
		amount = 0.2

	if Input.is_action_pressed("ui_up"):
		self.direction.z -= amount

	elif Input.is_action_pressed("ui_down"):
		self.direction.z += amount

	if Input.is_action_pressed("ui_left"):
		self.direction.x -= amount

	elif Input.is_action_pressed("ui_right"):
		self.direction.x += amount

	self.direction = self.direction.clamp(Vector3(-1, -1, -1), Vector3(1, 1, 1))


func _physics_process(delta: float) -> void:
	# Apply friction
	if self.is_on_floor():
		self.direction *= Vector3.ONE - Vector3(0.9, 1.0, 0.9) * (10 * delta)

	# Preserve the Y velocity from the previous frame
	self.velocity = Vector3(0, self.velocity.y, 0)

	# Always add velocity even when we're in the air
	self.velocity += get_transform().basis.x * direction.x * PLAYER_MOVE_SPEED
	self.velocity += get_transform().basis.z * direction.z * PLAYER_MOVE_SPEED

	# Apply less gravity if we were on the floor last frame
	# This helps our KinematicBody to avoid physics jitter
	if self.is_on_floor():
		self.velocity -= Vector3(0, GRAVITY / 100, 0)
	else:
		self.velocity -= Vector3(0, GRAVITY, 0)

	self.move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if not collider is RigidBody3D:
			continue

		collider.apply_central_impulse(-collision.get_normal() * 0.8)
		collider.apply_impulse(-collision.get_normal() * 0.01, collision.get_position())
