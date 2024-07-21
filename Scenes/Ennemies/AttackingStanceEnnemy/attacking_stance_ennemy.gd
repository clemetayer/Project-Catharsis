extends CharacterBody3D
# Basic ennemy script

##### SIGNALS #####
# Node signals

##### ENUMS #####
# enumerations

##### VARIABLES #####
#---- CONSTANTS -----
# const constant = 10 # Optionnal comment

#---- EXPORTS -----
@export var SPEED := 2.5 
@export var BASE_HEALTH := 10
@export var STANCE := EntityCommon.stances.MIDDLE

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _current_health := BASE_HEALTH
var _player = null # reference of the player node

#==== ONREADY ====
@onready var onready_paths := {
	"health_label": $"HealthLabel",
	"weapon_animation": $"WeaponAnimation",
	"attack_cooldown_timer": $"AttackCooldown"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	onready_paths.health_label.text = "%s" % BASE_HEALTH
	onready_paths.weapon_animation.play_stance_idle(STANCE)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

func _physics_process(_delta):
	if _player != null and _player.is_in_group("player"):
		look_at(_player.global_position, Vector3.UP)
		var move_toward_direction = (_player.global_position - self.global_position).normalized()
		velocity = move_toward_direction * SPEED 
		move_and_slide()

##### PUBLIC METHODS #####
func hurt(amount: int, _stance : EntityCommon.stances) -> void:
	_current_health -= amount
	onready_paths.health_label.text = "%d" % _current_health
	if _current_health <= 0 :
		queue_free()

##### PROTECTED METHODS #####
func _attack() -> void:
	onready_paths.weapon_animation.play_stance_attack(STANCE)

##### SIGNAL MANAGEMENT #####
func _on_detect_player_area_body_entered(body):
	if body.is_in_group("player"):
		_player = body

func _on_detect_player_area_body_exited(body):
	if body.is_in_group("player"):
		_player = null

func _on_attack_player_area_body_entered(body):
	if body.is_in_group("player"):
		_attack()
		onready_paths.attack_cooldown_timer.start()

func _on_attack_player_area_body_exited(body):
	if body.is_in_group("player"):
		onready_paths.attack_cooldown_timer.stop()

func _on_attack_cooldown_timeout():
	_attack()
	onready_paths.attack_cooldown_timer.start()
