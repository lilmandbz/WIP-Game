extends Sprite2D

func _physics_process(_delta: float) -> void:
	
	var arm_sprite2 = %ArmNode2
	var turn_check = get_parent()
		
	if turn_check.flip_h == true:
		arm_sprite2.visible = true
		arm_sprite2.offset.x = 2
		arm_sprite2.position.x = 4
		arm_sprite2.look_at(get_global_mouse_position())
	
	else:
		arm_sprite2.visible = false
