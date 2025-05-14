#Notes on script
#-- this symbol will be used for any function in the script currently unimplemented
#** this symbol will be used for any function in the script that is currently in need of work
class_name Player
extends CharacterBody2D


#used in checkpoint script
var spawn_coord: Vector2= Vector2(0, 0)
const SPEED = 180
const JUMP_VELOCITY = -300

#needs to be reworked so pushback actually works**
const wall_jump_pushback = 300
const wall_slide_gravity = 100

#used in wall_jump/ wall_slide script
var is_wall_sliding = false
#not used currently, double jump not implemented--
var can_double_jump = true
#used in death script, maybe not needed though
var can_control= true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var coyote_timer = $Coyote_timer
@onready var wall_jump_x_disable = $wall_jump_x_disable


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	if Input.is_action_just_pressed("down"):
		position.y += 1

	# Handle jump.
	jump()
	
	#handle wallslide
	wall_slide(delta)

	#get input direction which can be -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	#flip the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	#plays animation
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")
	
	#applies movement
	if(can_control):
		velocity.x = move_toward(velocity.x, direction * SPEED, 72.0)
	
	var was_on_floor = is_on_floor()
	
	move_and_slide()
	
	#see if I was on the floor for coyote time
	if was_on_floor && !is_on_floor():
		coyote_timer.start()
		
	


func jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or !coyote_timer.is_stopped():
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and Input.is_action_pressed("move_right"):
			velocity.y = JUMP_VELOCITY
			velocity.x += -wall_jump_pushback
			wall_jump_x_disable.start()
			can_control = false
			while(not wall_jump_x_disable.timeout):
				pass
			can_control = true
			
		if is_on_wall() and Input.is_action_pressed("move_left"):
			velocity.y = JUMP_VELOCITY
			velocity.x += wall_jump_pushback
			wall_jump_x_disable.start()
			can_control = false
			while(not wall_jump_x_disable.timeout):
				pass
			can_control = true
			
func wall_slide(delta): 
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)
		
# add animation when player dies as well**
func handle_danger() -> void:
	print("player died")
	visible = false
	can_control = false
		
	await get_tree().create_timer(1).timeout
	reset_player()
	

func reset_player() -> void:
	global_position = spawn_coord
	visible = true
	can_control= true
#************************************

#function to set checkpoints
func handle_checkpoint() -> void:
	spawn_coord =  global_position

