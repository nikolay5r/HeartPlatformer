extends CharacterBody2D

@export var movement_data: MovementResource

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_jump_timer = $CoyoteJumpTimer
@onready var wall_coyote_jump_timer = $WallCoyoteJumpTimer
@onready var camera_2d = $Camera2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var was_on_floor = true
var was_on_wall = false
var can_double_jump = true
var starting_position = global_position
var past_wall_normal = Vector2.ZERO

func _physics_process(delta):
	_add_gravity(delta)
	_handle_jump()
	var direction = Input.get_axis("go_left", "go_right")	
	_handle_animation(direction)
	_handle_movement(direction, delta)
	was_on_floor = is_on_floor()
	was_on_wall = is_on_wall_only()
	if was_on_wall:
		past_wall_normal = get_wall_normal()
	move_and_slide()
	_handle_coyote_jump()
	_handle_wall_coyote_jump()


func _add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * movement_data.gravity_scale * delta


func _handle_animation(direction):
	if direction == 0:
		animated_sprite_2d.play("idle")
	else:
		animated_sprite_2d.play("run")
		animated_sprite_2d.flip_h = direction < 0
	
	if not is_on_floor():
		animated_sprite_2d.play("jump")


func _handle_coyote_jump():
	if was_on_floor and not is_on_floor() and velocity.y >= 0:
		coyote_jump_timer.start()


func _handle_jump():
	if is_on_floor() or coyote_jump_timer.time_left > 0.0: 
		if Input.is_action_just_pressed("jump"):
			Sounds.player_jump.playing = Globals.can_play_sounds
			velocity.y = movement_data.jump_velocity
			can_double_jump = true
	elif not is_on_floor(): 
		if Input.is_action_just_released("jump") and velocity.y < movement_data.jump_velocity / 2:
			velocity.y = movement_data.jump_velocity / 2
			
		if Input.is_action_just_pressed("jump"):
			_handle_double_jump()
			_handle_wall_jump()


func _handle_movement(direction, delta):
	if direction:
		_apply_acceleration(direction, delta)
		_apply_air_acceleration(direction, delta)
	else:
		_apply_friction(delta)
		_apply_air_resistance(delta)


func _apply_friction(delta):
	if not is_on_floor():
		return
	
	velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)


func _apply_acceleration(direction, delta):
	if not is_on_floor():
		return
	
	velocity.x = move_toward(
		velocity.x,
		direction * movement_data.speed, 
		movement_data.acceleration * delta
	)


func _apply_air_acceleration(direction, delta):
	if is_on_floor(): 
		return
	
	velocity.x = move_toward(
		velocity.x,
		direction * movement_data.speed,
		movement_data.air_acceleration * delta
	)


func _apply_air_resistance(delta):
	if is_on_floor():
		return
	
	velocity.x = move_toward(velocity.x, 0, movement_data.air_resistance * delta)


func _handle_double_jump():
	if can_double_jump and not is_on_wall():
		Sounds.player_jump.playing = Globals.can_play_sounds
		can_double_jump = false
		velocity.y = movement_data.jump_velocity * movement_data.double_jump_velocity_scale


func _handle_wall_jump():
	if is_on_wall_only() or wall_coyote_jump_timer.time_left > 0.0:
		Sounds.player_jump.playing = Globals.can_play_sounds
		var wall_normal = get_wall_normal()
		if wall_coyote_jump_timer.time_left > 0.0:
			wall_normal = past_wall_normal
		velocity.x = wall_normal.x * movement_data.speed
		velocity.y = movement_data.jump_velocity * movement_data.double_jump_velocity_scale


func _handle_wall_coyote_jump():
	if not is_on_wall() and was_on_wall:
		wall_coyote_jump_timer.start()


func _on_hazard_detector_area_entered(_area):
	Sounds.player_death.playing = Globals.can_play_sounds
	global_position = starting_position
