extends AnimatedSprite2D

class_name EnemyTexture

var _on_action: bool = false

@export_category("Objects")
@export var _enemy: BaseEnemy
@export var _attack_area_collision: CollisionShape2D

@export_category("Variables")
@export var _last_attack_frame: int
func animate(_velocity: Vector2) -> void:
	if _on_action:
		return
	if _velocity.y:
		if _velocity.y < 0:
			play("jump")
		if _velocity.y > 0:
			play("fall")
		return
		
	if _velocity.x:
		play("run")
		return
	
	play("idle")
	
func action_animate(_action: String) -> void:
	_enemy.set_physics_process(false)
	_on_action = true
	play(_action)
	
	
func _on_animation_finished() -> void:
	if animation == "attack_anticipation":
		action_animate("attack")
		return
	_on_action = false
	_enemy.set_physics_process(true)

func _on_frame_changed() -> void:
	if animation == "attack":
		if frame == 0 or frame == 1:
			_attack_area_collision.disabled = false
		if frame == _last_attack_frame:
			_attack_area_collision.disabled = true
