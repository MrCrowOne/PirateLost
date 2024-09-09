extends Area2D

class_name  EnemyAttackArea

@export_category("Variables")
@export var _attack_damage: int = 1

func _on_body_entered(_body) -> void:
	if _body is BaseCharacter:
		#_body.update_health()
		print("Causou dano ao personagem")
		pass
