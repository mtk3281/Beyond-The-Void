extends CharacterBody2D

@export var MAX_SPEED = 100
@export var ACCELERATION = 500
@export var FRICTION = 500

@onready var axis = Vector2.ZERO
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	move(delta)

func get_input_axis():
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return axis.normalized()

func move(delta):
	axis = get_input_axis()

	if axis == Vector2.ZERO:
		animationState.travel("Idle")
		apply_friction(FRICTION * delta)
	else:
		animationState.travel("Run")
		animationTree.set("parameters/Idle/blend_position",axis)
		animationTree.set("parameters/Run/blend_position",axis)
		
		apply_movement(axis * ACCELERATION * delta)
	move_and_slide()

func apply_friction(amount):
	if velocity.length() > amount:
		velocity -= velocity.normalized() * amount
	else:
		velocity = Vector2.ZERO

func apply_movement(accel):
	velocity += accel
	velocity = velocity.limit_length(MAX_SPEED)

#const ACC = 500
#const MAX_SPEED = 100
#const FRICTION = 500
#
#func _physics_process(delta):
#	var input_vector = Vector2.ZERO
#
#	input_vector.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
#	input_vector.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
#
#	input_vector = input_vector.normalized()
#
#	if input_vector != Vector2.ZERO:
#		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACC * delta)
#	else:
#		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#
#	move_and_slide()

#var input_movement = Vector2.ZERO
#@export var SPEED = 80
#
#func _physics_process(delta):
#	move()
#
#func move():
#	input_movement = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
#
#	if input_movement != Vector2.ZERO:
#		velocity = input_movement * SPEED
#
#	if input_movement == Vector2.ZERO:
#		velocity = Vector2.ZERO
#
#	move_and_slide()

#@export var speed = 100
#@export var accel = 10
#
#func _physics_process(delta):
#	var direction = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
#
#	velocity.x = move_toward(velocity.x , speed * direction.x , accel)
#	velocity.y = move_toward(velocity.y , speed * direction.y , accel)
#
#	move_and_slide()



