extends Sprite2D

func _physics_process(_delta):
	
	var arm = %RFGunArm
	var aim = get_global_mouse_position()
	var parent_flip = get_parent().flip_h
	
	if parent_flip == false:
		arm.visible = true
		arm.looks_at(aim)
	else:
		arm.visible = false
