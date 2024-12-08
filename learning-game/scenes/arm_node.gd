extends Sprite2D

func _physics_process(_delta: float) -> void:
	
	var arm_sprite = %ArmNode
	var turn_check = get_parent()
		
	if turn_check.flip_h == false:
		arm_sprite.visible = true
		arm_sprite.offset.x = 3
		arm_sprite.offset.y = -1
		arm_sprite.position.x = -4
		arm_sprite.look_at(get_global_mouse_position())
	
	else:
		arm_sprite.visible = false
