extends Sprite2D

func _physics_process(_delta):
	
	var mouse_pos = get_global_mouse_position()
	var direction = mouse_pos
	var arm_sprite = %ArmNode
	
	arm_sprite.look_at(direction)
	
	var arm_direction := Input.get_axis("move_left", "move_right")
	
	if arm_direction > 0:
		arm_sprite.flip_h = false
	elif arm_direction < 0:
		arm_sprite.flip_h = true
