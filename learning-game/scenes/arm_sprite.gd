
onready var arm_sprite = %ArmSprite

func _physics_process(delta):
	arm_sprite.look_at(get_global_mouse_position())
