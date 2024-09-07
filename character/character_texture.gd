extends AnimatedSprite2D

class_name CharacterTexture

var _is_on_action: bool = false

@export_category("Objects")
@export var _character: BaseCharacter

func animate(_velocity: Vector2) -> void:
	_verify_direction(_velocity.x)
	
	if _is_on_action:
		return
	
	if not _velocity:
		play("idle")
		return
	
	if _velocity.y > 0:
		play("fall")
		return
	
	if _velocity.y < 0:
		play("jump")
		return
	
	if _velocity.x:
		play("run")
		return
	
func _verify_direction(_direction: float) -> void:
	if _direction > 0:
		flip_h = false
	
	if _direction < 0:
		flip_h = true

func action_animation(_action_name: String) -> void:
	_is_on_action = true
	play(_action_name)


func _on_animation_finished() -> void:
	_character.set_physics_process(true)
	_is_on_action = false
