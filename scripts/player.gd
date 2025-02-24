extends CharacterBody3D

@onready var camera_mount: Node3D = $camera_mount
@onready var visuals: Node3D = $visuals

const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.3
const WALKING_SPEED = 3.0
const RUNNING_SPEED = 5.0

@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x*SENSITIVITY))
		visuals.rotate_y(deg_to_rad(event.relative.x*SENSITIVITY))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y*SENSITIVITY))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x,deg_to_rad(-40),deg_to_rad(60))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if Input.is_action_pressed("run"):
			if animation_player.current_animation != "running":
				animation_player.play("running")
			velocity.x = direction.x * RUNNING_SPEED
			velocity.z = direction.z * RUNNING_SPEED
		else:
			if animation_player.current_animation != "walking":
				animation_player.play("walking")	
			velocity.x = direction.x * WALKING_SPEED
			velocity.z = direction.z * WALKING_SPEED
		
		visuals.look_at(position + direction)
	else:
		if animation_player.current_animation != "idle":
			animation_player.play("idle")
		velocity.x = move_toward(velocity.x, 0, WALKING_SPEED)
		velocity.z = move_toward(velocity.z, 0, WALKING_SPEED)

	move_and_slide()
