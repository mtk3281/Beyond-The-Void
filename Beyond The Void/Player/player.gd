extends CharacterBody2D

@export var MAX_SPEED = 100
@export var ACCELERATION = 500
@export var FRICTION = 500

@onready var axis = Vector2.ZERO
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

var state = MOVE
enum{
	MOVE,
	ROLL,
	ATTACK
}


func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			pass
		ATTACK:
			attack_state(delta)

func move_state(delta):
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	axis.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	axis = axis.normalized()
	
	if axis == Vector2.ZERO:
		animationState.travel("Idle")
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
	else:
		animationState.travel("Run")
		animationTree.set("parameters/Idle/blend_position",axis)
		animationTree.set("parameters/Run/blend_position",axis)
		animationTree.set("parameters/Attack/blend_position",axis)
		
		velocity += (axis * ACCELERATION * delta)
		velocity = velocity.limit_length(MAX_SPEED)
	move_and_slide()
	
	if Input.is_action_pressed("Attack"):
		state = ATTACK

func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func AttackAnimationFinished():
	state = MOVE

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



