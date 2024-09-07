extends Area2D

class_name ThrowableComponent

var direction: Vector2

@export_category("Variables")
@export var _move_speed: float = 128.0

func _on_body_entered(_body) -> void:
	pass


func _physics_process(_delta: float) -> void:
	translate(direction * _delta * _move_speed)
