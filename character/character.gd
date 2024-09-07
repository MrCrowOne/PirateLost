extends CharacterBody2D
class_name BaseCharacter

const _THROWABLE_SWORD: PackedScene = preload("res://throwables/character_sword/character_sword.tscn")

var _has_sword: bool = false
var dashing = false

var _jump_count: int = 0
var _dash_count: int = 0
var _attack_index: int = 1
var _air_attack_count: int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var _gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var _on_floor: bool = true

@export_category("Variables")
@export var _speed: float = 200.0
@export var _jump_velocity: float = -250.0
@export var _dash_speed: float = 900.0

@export_category("Objects")
@export var _character_texture: AnimatedSprite2D
@export var _attack_combo: Timer

func _physics_process(_delta: float) -> void:
	_vertical_movement(_delta)
	_horizontal_movement()
	_attack_handler()
	move_and_slide()
	
	_character_texture.animate(velocity)
	

func _vertical_movement(_delta:float) -> void:
	# Add the gravity.
	if is_on_floor():
		if _on_floor == false:
			_air_attack_count = 0
			global.spawn_effects(
				"res://visual_effects/dust_particles/fall/fall_effect.tscn", 
				Vector2(0, 2),global_position, false
			)
			_character_texture.action_animation("land")
			#set_physics_process(false) para parar quando cair
			_on_floor = true
			
		_jump_count = 0
		_dash_count = 0 #contador do dash que volta a 0 ao ficar no chão
	
	if not is_on_floor():
		if _on_floor:
			_attack_index = 1
			
		_on_floor = false
		velocity.y += _gravity * _delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and _jump_count < 2:
		_jump_count += 1
		_attack_index = 1
		velocity.y = _jump_velocity
		global.spawn_effects(
			"res://visual_effects/dust_particles/jump/jump_effect.tscn", 
			Vector2(0, 2),global_position, _character_texture.flip_h
		)
	
	#input do dash
	if Input.is_action_just_pressed("dash") and _dash_count < 1:
		_dash_count += 1 #contador de quantas vezes o dash foi chamado
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
			global.spawn_effects(
				"res://visual_effects/dust_particles/run/run_effect.tscn", 
				Vector2(0, -8),global_position, false
			)
		return
	velocity.x = move_toward(velocity.x, 0, _speed)

func _attack_handler() -> void:
	if not _has_sword:
		return
	if Input.is_action_just_pressed("throw"):
		_character_texture.action_animation("throw_sword")
		_has_sword = false
		set_physics_process(false)
		update_sword_state(false)
		return
		
	if Input.is_action_just_pressed("attack") and is_on_floor():
		_attack_animation_handler("attack_", 4)
		
	if (
		Input.is_action_just_pressed("attack") and 
		not is_on_floor() and 
		_air_attack_count < 2
	):
		_attack_animation_handler("air_attack_", 3, true)
		set_physics_process(false)
		
		

func _attack_animation_handler(_prefix: String, _index_limit: int, _on_air: bool = false) -> void:
	global.spawn_effects(
		"res://visual_effects/sword/" + 
		_prefix + str(_attack_index) + "/" +
		_prefix + str(_attack_index) + ".tscn", 
		Vector2(24, 0), global_position, _character_texture.flip_h
	)
	
	_character_texture.action_animation(_prefix + str(_attack_index))
	
	_attack_index += 1
	
	if _attack_index == _index_limit:
		_attack_index = 1
	if _on_air:
		_air_attack_count += 1
	_attack_combo.start()

func throw_sword(_is_flipped: bool) -> void:
	var _sword: CharacterSword = _THROWABLE_SWORD.instantiate()
	get_tree().root.call_deferred("add_child", _sword)
	_sword.global_position = global_position
	
	if _is_flipped:
		_sword.direction = Vector2(-1, 0)
		return
		
	_sword.direction = Vector2(1, 0)
#temporizador do dash
func _on_dash_timer_timeout() -> void:
	dashing = false

func update_sword_state(_state: bool) -> void:
	_has_sword = _state
	_character_texture.update_suffix(_has_sword)


func _on_attack_combo_timeout() -> void:
	_attack_index = 1
