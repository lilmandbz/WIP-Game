extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const LASSO_THROW_SPEED = 400.0
const LASSO_RETURN_SPEED = 400.0
const LASSO_PULL_SPEED = 300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var lasso_line: Line2D = $LassoLine
@onready var lasso_tip: Sprite2D = $LassoTip

var is_throwing_lasso = false
var lasso_velocity = Vector2.ZERO
var lasso_origin = Vector2.ZERO
var lasso_catch_point: Vector2 = Vector2.ZERO
var lasso_return = false
var lasso_pull = false
var lasso_airborn = false

func _physics_process(delta: float) -> void:
	
	# Gravity.
	if not is_on_floor() and not move_to_lasso_point(delta):
		velocity += get_gravity() * delta
	
	# Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Movement
	var direction := Input.get_axis("move_left", "move_right")
	
	# Flips the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("walking")
	else:
		animated_sprite.play("jump")
	
	
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if lasso_pull:
		move_to_lasso_point(delta)
	
	move_and_slide()

	# Lasso logic
	if is_throwing_lasso:
		update_lasso(delta)
		lasso_tip.visible = true
		
	else:
		lasso_tip.visible = false
		
func _input(event):
	if event.is_action_pressed("lasso") and not is_throwing_lasso:
		throw_lasso()
		
func throw_lasso():
	is_throwing_lasso = true
	lasso_origin = lasso_tip.global_position
	lasso_velocity = (get_global_mouse_position() - lasso_origin).normalized() *LASSO_THROW_SPEED
	lasso_line.clear_points()
	lasso_line.add_point(lasso_origin)
	lasso_line.add_point(lasso_tip.global_position)
	
func update_lasso(delta):
	if lasso_return:
		return_lasso(delta)
		return
	
	lasso_tip.global_position += lasso_velocity * delta
	lasso_line.set_point_position(0, lasso_tip.global_position)
	
	# Check collision with catch points.
	for point in get_tree().get_nodes_in_group("lasso_point"):
		if point.global_position.distance_to(lasso_tip.global_position) < 10:
			lasso_catch_point = point.global_position
			lasso_pull = true
			lasso_airborn = not is_on_floor()
			is_throwing_lasso = false
			break
			
	# If the lasso exceeds a max range, start returning
	if lasso_tip.global_position.distance_to(lasso_origin) > 200:
		lasso_return = true
		
func return_lasso(delta):
	if lasso_tip.global_position.distance_to(lasso_origin) > 1:
		lasso_tip.global_position = lasso_tip.global_position.move_toward(lasso_origin, LASSO_RETURN_SPEED * delta)
		lasso_line.set_point_position(0, lasso_tip.global_position)
	else:
		reset_lasso()

func reset_lasso():
	is_throwing_lasso = false
	lasso_return = false
	lasso_catch_point = Vector2.ZERO
	lasso_pull = false
	lasso_airborn = false
	lasso_line.clear_points()
	lasso_line.add_point(lasso_origin)
	lasso_line.add_point(lasso_origin)
	
func move_to_lasso_point(_delta):
	if not lasso_pull:
		return false
	
	var direction_to_lasso_point = lasso_catch_point - global_position
	velocity = direction_to_lasso_point.normalized() * LASSO_PULL_SPEED

	if global_position.distance_to(lasso_catch_point) <= 10:
		reset_lasso()
		return false
		
	return true
