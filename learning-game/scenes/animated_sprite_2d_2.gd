extends AnimatedSprite2D

func _physics_process(delta):
	var mouse_pos = get_local_mouse_position()
	var direction = mouse_pos - global_position
	var angle = direction.angle_to(Vector2.ZERO)
	
	%GunArmNode.rotation = angle
