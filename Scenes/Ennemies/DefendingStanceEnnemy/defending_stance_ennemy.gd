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
@export var BASE_HEALTH := 10
@export var STANCE := EntityCommon.stances.MIDDLE

#---- STANDARD -----
#==== PUBLIC ====
# var public_var # Optionnal comment

#==== PRIVATE ====
var _current_health := BASE_HEALTH

#==== ONREADY ====
@onready var onready_paths := {
	"health_label": $"HealthLabel",
	"defending_animation": $"DefendingStanceAnimation"
}

##### PROCESSING #####
# Called when the object is initialized.
func _init():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	_play_stance_anim(STANCE)

# Called every frame. 'delta' is the elapsed time since the previous frame. Remove the "_" to use it.
func _process(_delta):
	pass

##### PUBLIC METHODS #####
func hurt(amount: int, stance : EntityCommon.stances) -> void:
	_current_health -= amount * _defending_stance_multiplier(stance)
	onready_paths.health_label.text = "%d" % _current_health
	if _current_health <= 0 :
		queue_free()

##### PROTECTED METHODS #####
func _play_stance_anim(stance : EntityCommon.stances) -> void:
	match stance:
		EntityCommon.stances.HIGH:
			onready_paths.defending_animation.play("defending_high")
		EntityCommon.stances.MIDDLE:
			onready_paths.defending_animation.play("defending_middle")
		EntityCommon.stances.LOW:
			onready_paths.defending_animation.play("defending_low")

# high -> low
# low -> middle
# middle -> high
func _defending_stance_multiplier(stance: EntityCommon.stances) -> int:
	match STANCE:
		EntityCommon.stances.HIGH:
			match stance:
				EntityCommon.stances.HIGH:
					return 0
				EntityCommon.stances.MIDDLE:
					return 2
				EntityCommon.stances.LOW:
					return 1
		EntityCommon.stances.MIDDLE:
			match stance:
				EntityCommon.stances.HIGH:
					return 1
				EntityCommon.stances.MIDDLE:
					return 0
				EntityCommon.stances.LOW:
					return 2
		EntityCommon.stances.LOW:
			match stance:
				EntityCommon.stances.HIGH:
					return 2
				EntityCommon.stances.MIDDLE:
					return 1
				EntityCommon.stances.LOW:
					return 0
	return 1 # default case, should not happen 

##### SIGNAL MANAGEMENT #####
# Functions that should be triggered when a specific signal is received

