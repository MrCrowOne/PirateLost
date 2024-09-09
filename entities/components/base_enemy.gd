extends CharacterBody2D
class_name BaseEnemy

enum _types {
	STATIC = 0, 
	CHASE = 1, 
	WANDER = 2
}

var _player_in_range: BaseCharacter = null
var _direction: Vector2 = Vector2.ZERO

var _can_play_dead_ground_animation: bool = true
var _on_knockback: bool = false
var _is_alive: bool = true
var _on_floor: bool = false
var _gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_category("Objects")
@export var _enemy_texture: EnemyTexture
@export var _floor_detection_ray: RayCast2D
@export var _knockback_timer: Timer

@export_category("Variables")
@export var _pink_star_enemy: bool = false
@export var _enemy_type: _types
@export var _move_speed: float = 128.0
@export var _knockback_speed: float = 256.0
@export var _enemy_health: int = 10
@export var _hit_knockback_timer: float = 0.4
@export var _dead_knockback_timer: float = 0.4

func _ready() -> void:
	_direction = [Vector2(-1, 0), Vector2(1, 0)].pick_random()
	_update_direction()

func _process(_delta: float) -> void:
	if _on_knockback:
		move_and_slide()

func _physics_process(_delta: float) -> void:
	_vertical_movement(_delta)
	if _is_alive == false:
		move_and_slide()
		return
	
	if is_instance_valid(_player_in_range):
		_attack()
		return
	
	match _enemy_type:
		_types.STATIC:
			pass
			
		_types.CHASE:
			pass
			
		_types.WANDER:
			_wandering()
			
	move_and_slide()
	
	_enemy_texture.animate(velocity)

func _vertical_movement(_delta: float) -> void:
	if is_on_floor():
		if _is_alive == false:
			if _can_play_dead_ground_animation:
				_enemy_texture.action_animate("dead_ground")
				_can_play_dead_ground_animation = false
			velocity.x = 0
			return
		
		if _on_floor == false:
			_enemy_texture.action_animate("land")
			_on_floor = true
			
	if not is_on_floor():
		_on_floor = false
		velocity.y += _gravity * _delta

func _wandering() -> void:
	if _floor_detection_ray.is_colliding():
		if _floor_detection_ray.get_collider() is TileMap:
			velocity.x = _direction.x * _move_speed
			return
	if is_on_floor():
		_update_direction()
		velocity.x = 0

func _update_direction() -> void:
	_direction.x = -_direction.x
	if _pink_star_enemy:
		if _direction.x > 0:
			_enemy_texture.flip_h = true
		
		if _direction.x < 0:
			_enemy_texture.flip_h = false
	if _direction.x > 0:
		_floor_detection_ray.position.x = 12
	if _direction.x < 0:
		_floor_detection_ray.position.x = -12
	
func _attack() -> void:
	pass

func update_health(_damage: int, _entity) -> void:
	if _is_alive == false:
		return
		
	_knockback(_entity)
	_enemy_health -= _damage
	if _enemy_health <= 0:
		_knockback_timer.start(_dead_knockback_timer)
		_kill()
		return
		
	_knockback_timer.start(_hit_knockback_timer)
	_enemy_texture.action_animate("hit")
	print("Inimigo perder " + str(_damage) + str(_enemy_health))

func _knockback(_entity: BaseCharacter) -> void:
	var _knockback_direction: Vector2 = _entity.global_position.direction_to(global_position)
	velocity.x = _knockback_direction.x * _knockback_speed
	velocity.y = -1 * _knockback_speed
	_on_knockback = true
	

func _kill() -> void:
	_enemy_texture.action_animate("dead_hit")
	_is_alive = false

func _on_detection_area_body_entered(_body) -> void:
	if _body is BaseCharacter:
		_player_in_range = _body


func _on_detection_area_body_exited(_body) -> void:
	if _body is BaseCharacter:
		_player_in_range = null


func _on_knockback_timer_timeout() -> void:
	_on_knockback = false
