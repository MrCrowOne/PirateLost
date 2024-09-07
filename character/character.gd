extends CharacterBody2D
class_name BaseCharacter

var _has_sword: bool = false
var dashing = false
var _jump_count: int = 0
var _dash_count: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var _gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var _on_floor: bool = true

@export_category("Variables")
@export var _speed: float = 200.0
@export var _jump_velocity: float = -250.0
@export var _dash_speed: float = 900.0

@export_category("Objects")
@export var _character_texture: AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	_vertical_movement(_delta)
	_horizontal_movement()
	move_and_slide()
	_character_texture.animate(velocity)

func _vertical_movement(_delta:float) -> void:
	# Add the gravity.
	if is_on_floor():
		if _on_floor == false:
			_character_texture.action_animation("land")
			#set_physics_process(false) para parar quando cair
			_on_floor = true
		_jump_count = 0
		_dash_count = 0
	
	if not is_on_floor():
		_on_floor = false
		velocity.y += _gravity * _delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and _jump_count < 2:
		_jump_count += 1
		velocity.y = _jump_velocity
	
	if Input.is_action_just_pressed("dash") and _dash_count < 1:
		_dash_count += 1
		dashing = true
		$Dash_timer.start()

func _horizontal_movement() -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var _direction := Input.get_axis("move_left", "move_right")
	if _direction:
		velocity.x = _direction * _speed
		if dashing:
			velocity.x = _direction * _dash_speed
		return
	velocity.x = move_toward(velocity.x, 0, _speed)

func _on_dash_timer_timeout() -> void:
	dashing = false

func update_sword_state(_state: bool) -> void:
	_has_sword = _state
	_character_texture.update_suffix(_has_sword)
