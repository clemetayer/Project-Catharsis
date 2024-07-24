extends CharacterBody3D
# general player code

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
const SPEED = 5.0

#---- EXPORTS -----
# export(int) var EXPORT_NAME # Optionnal comment

#---- STANDARD -----
#==== PUBLIC ====
var _stance := PlayerCommon.stances.FAST

#==== PRIVATE ====
var _gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity") # Get the gravity from the project settings to be synced with RigidBody nodes.
var _mouse_sensitivity : float = Settings.mouse_sensitivity
var _direction := Vector2.ZERO # direction from the w/a/s/d keys, "flattened" to the floor. Actually in 3D : Vector2(z,x)

#==== ONREADY ====
@onready var onready_paths := {
	"rotation_helper": $"RotationHelper",
	"camera": $"RotationHelper/Camera3D",
	"weapon": $"RotationHelper/PlayerWeapon"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	_handle_inputs()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotation around the y axis
		rotate_y(deg_to_rad(-event.relative.x * _mouse_sensitivity))
		# Rotation around the x axis
		onready_paths.rotation_helper.rotate_x(-deg_to_rad(event.relative.y * _mouse_sensitivity))
		var camera_rot = onready_paths.rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90) # 90° +- camera angle
		onready_paths.rotation_helper.rotation_degrees = camera_rot

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= _gravity * delta
	else:
		velocity.y = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var wished_dir = _get_wished_direction()
	var horizontal_wished_dir = Vector3(wished_dir.x, 0, wished_dir.z).normalized()
	if wished_dir:
		velocity.x = horizontal_wished_dir.x * SPEED
		velocity.z = horizontal_wished_dir.z * SPEED
	else:
		velocity.x = move_toward(horizontal_wished_dir.x, 0, SPEED)
		velocity.z = move_toward(horizontal_wished_dir.z, 0, SPEED)

	move_and_slide()

##### PUBLIC METHODS #####
# Methods that are intended to be "visible" to other nodes or scripts
# func public_method(arg : int) -> void:
#     pass

##### PROTECTED METHODS #####
func _handle_inputs() -> void:
	_handle_remove_mouse_mode_capture()
	_handle_direction_inputs()
	_handle_stance_inputs()
	_handle_attack_inputs()
	
func _handle_direction_inputs() -> void:
	_direction = Vector2.ZERO # reset the direction
	if Input.is_action_pressed("Front"):
		_direction.x -= 1 
	if Input.is_action_pressed("Back"):
		_direction.x += 1
	if Input.is_action_pressed("Left"):
		_direction.y -= 1
	if Input.is_action_pressed("Right"):
		_direction.y += 1
	_direction = _direction.normalized()

func _handle_stance_inputs() -> void:
	if Input.is_action_just_pressed("stance_fast"):
		_switch_stance(PlayerCommon.stances.FAST)
	elif Input.is_action_just_pressed("stance_defense"):
		_switch_stance(PlayerCommon.stances.DEFENSE)
	elif Input.is_action_just_pressed("stance_strong"):
		_switch_stance(PlayerCommon.stances.STRONG)

func _switch_stance(stance : PlayerCommon.stances) -> void:
	onready_paths.weapon.change_stance(stance)
	_stance = stance

func _handle_attack_inputs() -> void:
	if Input.is_action_just_pressed("attack"):
		onready_paths.weapon.attack(_stance)

# Temporary, to free the mouse by pressing escape
func _handle_remove_mouse_mode_capture() -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE

func _get_wished_direction() -> Vector3:
	var dir = Vector3()
	var cam_xform = onready_paths.camera.get_global_transform()
	dir += -cam_xform.basis.z * -_direction.x
	dir += cam_xform.basis.x * _direction.y
	return dir

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received
