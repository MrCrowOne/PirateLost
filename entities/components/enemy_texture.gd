extends AnimatedSprite2D

class_name EnemyTexture

var _on_action: bool = false

@export_category("Objects")
@export var _enemy: BaseEnemy

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
	_on_action = false
	_enemy.set_physics_process(true)
