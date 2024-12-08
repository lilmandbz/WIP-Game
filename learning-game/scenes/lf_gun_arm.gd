extends Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var turn_check = get_parent()
	var lf_arm = %"LF-GunArm"
	if turn_check.flip_h == false:
		lf_arm.visible = true
		
	else:
		lf_arm.visible = false
		
	lf_arm.looks_at(get_global_mouse_position())
	
