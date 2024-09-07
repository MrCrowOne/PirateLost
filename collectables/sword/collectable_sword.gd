extends CollectableComponent

class_name CollectableSword

func _consume(_body: BaseCharacter) -> void:
	_body.update_sword_state(true)
